#!/usr/bin/env python3
import sys
import re
import ast
import pandas as pd

# Usage: python generate_trunc_length.py input_js output_csv [q_threshold] [min_count_fraction]

input_js = sys.argv[1]
output_csv = sys.argv[2]
q_threshold = int(sys.argv[3]) if len(sys.argv) > 3 else 20
min_count_fraction = float(sys.argv[4]) if len(sys.argv) > 4 else 0.9

print("Generating truncation lengths based on quality scores...")
print(f"Q-score cutoff: {q_threshold}")
print(f"Minimum read fraction: {min_count_fraction}")

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
per_base_text = re.sub(r'(\b\d+\b)\s*:', r'"\1":', per_base_text)
per_base_text = re.sub(r',\s*([}\]])', r'\1', per_base_text)

# Step 5: Convert to Python dict(s) and split forward/reverse
data = ast.literal_eval(per_base_text)

if isinstance(data, (tuple, list)) and len(data) >= 2:
    df_f = pd.DataFrame.from_dict(data[0], orient='index').sort_index(key=lambda x: x.astype(int))
    df_r = pd.DataFrame.from_dict(data[1], orient='index').sort_index(key=lambda x: x.astype(int))
elif isinstance(data, dict):
    df = pd.DataFrame.from_dict(data, orient='index').sort_index(key=lambda x: x.astype(int))
    index_vals = df.index.astype(int)
    repeat_idx = index_vals.duplicated(keep='first').argmax() if index_vals.duplicated().any() else len(df)
    df_f = df.iloc[:repeat_idx]
    df_r = df.iloc[repeat_idx:]
else:
    raise ValueError("Unexpected format in per-base quality JS export")

# Step 6: Compute truncation lengths using both count and quality thresholds
def compute_trunc_len(df, q_threshold, min_count_fraction, label):
    max_count = df['count'].max()
    min_count = max_count * min_count_fraction

    # Last position where enough reads are still present
    count_cutoff = int((df['count'] >= min_count).sum())

    # Last position where median quality is still acceptable
    quality_cutoff = int((df['50%'] >= q_threshold).sum())

    # Take the more conservative of the two
    trunc_len = min(count_cutoff, quality_cutoff)

    print(f"  {label}: count cutoff={count_cutoff}, quality cutoff={quality_cutoff} → using {trunc_len}")
    return trunc_len

print("\nComputing truncation lengths:")
trunc_len_f = compute_trunc_len(df_f, q_threshold, min_count_fraction, "forward")
trunc_len_r = compute_trunc_len(df_r, q_threshold, min_count_fraction, "reverse")

trunc_len_f = max(trunc_len_f, 0)
trunc_len_r = max(trunc_len_r, 0)

# Step 7: Write output CSV
with open(output_csv, 'w') as f:
    f.write(f"trunc_len_f,trunc_len_r\n{trunc_len_f},{trunc_len_r}\n")

print(f"\nTruncation lengths determined: forward={trunc_len_f}, reverse={trunc_len_r}")