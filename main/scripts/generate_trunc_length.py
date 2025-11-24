#!/usr/bin/env python3
import sys
import re
import ast
import pandas as pd

# Usage: python generate_trunc_length.py input_js output_csv [q_threshold]

input_js = sys.argv[1]
output_csv = sys.argv[2]
q_threshold = int(sys.argv[3]) if len(sys.argv) > 3 else 20

print("Generating truncation lengths based on quality scores...")
print(f"Default Q-score cutoff: {q_threshold}")

# Step 1: Read the JS file
with open(input_js) as f:
    text = f.read()

# Step 2: Extract content inside app.init(...)
start = text.find("app.init(")
if start == -1:
    raise ValueError("Could not find 'app.init(' in JS file")

start = text.find("(", start) + 1
end = text.rfind(")")
inner_text = text[start:end].strip().rstrip(";")

# Step 3: Split first comma at top level to skip metadata
brace_level = 0
split_idx = None
for i, char in enumerate(inner_text):
    if char == "{":
        brace_level += 1
    elif char == "}":
        brace_level -= 1
    elif char == "," and brace_level == 0:
        split_idx = i
        break

if split_idx is None:
    raise ValueError("Could not split metadata and per-base-quality objects")

per_base_text = inner_text[split_idx + 1:].strip()

# Step 4: Clean JS to Python-friendly format
# Quote numeric keys
per_base_text = re.sub(r'(\b\d+\b)\s*:', r'"\1":', per_base_text)
# Remove trailing commas
per_base_text = re.sub(r',\s*([}\]])', r'\1', per_base_text)

# Step 5: Convert to Python dict
data = ast.literal_eval(per_base_text)

# If data is a tuple/list, take the second element (per-base quality)
if isinstance(data, (tuple, list)) and len(data) >= 2:
    data = data[1]
elif isinstance(data, dict):
    pass  # already fine
else:
    raise ValueError("Unexpected format in per-base quality JS export")

# Step 6: Convert to DataFrame
df = pd.DataFrame.from_dict(data, orient='index')
df = df.sort_index(key=lambda x: x.astype(int))

# Step 7: Detect repeated indices (forward/reverse)
index_vals = df.index.astype(int)
repeat_idx = index_vals.duplicated(keep='first').argmax() if index_vals.duplicated().any() else len(df)

df_f = df.iloc[:repeat_idx]
df_r = df.iloc[repeat_idx:]

# Step 8: Compute truncation lengths
trunc_len_f = (df_f['50%'] >= q_threshold).sum()
trunc_len_r = (df_r['50%'] >= q_threshold).sum()

trunc_len_f = max(trunc_len_f, 0)
trunc_len_r = max(trunc_len_r, 0)

# Step 9: Write output CSV
with open(output_csv, 'w') as f:
    f.write(f"trunc_len_f,trunc_len_r\n{trunc_len_f},{trunc_len_r}\n")

print(f"Truncation lengths determined: forward={trunc_len_f}, reverse={trunc_len_r}")
