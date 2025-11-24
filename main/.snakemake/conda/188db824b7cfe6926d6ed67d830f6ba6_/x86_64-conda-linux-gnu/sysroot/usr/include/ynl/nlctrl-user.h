/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
/* Do not edit directly, auto-generated from: */
/*	Documentation/netlink/specs/nlctrl.yaml */
/* YNL-GEN user header */

#ifndef _LINUX_NLCTRL_GEN_H
#define _LINUX_NLCTRL_GEN_H

#include <stdlib.h>
#include <string.h>
#include <linux/types.h>
#include <linux/genetlink.h>

struct ynl_sock;

extern const struct ynl_family ynl_nlctrl_family;

/* Enums */
const char *nlctrl_op_str(int op);
const char *nlctrl_op_flags_str(int value);
const char *nlctrl_attr_type_str(enum netlink_attribute_type value);

/* Common nested types */
struct nlctrl_op_attrs {
	struct {
		__u32 id:1;
		__u32 flags:1;
	} _present;

	__u32 idx;
	__u32 id;
	__u32 flags;
};

struct nlctrl_mcast_group_attrs {
	struct {
		__u32 name_len;
		__u32 id:1;
	} _present;

	__u32 idx;
	char *name;
	__u32 id;
};

struct nlctrl_policy_attrs {
	struct {
		__u32 type:1;
		__u32 min_value_s:1;
		__u32 max_value_s:1;
		__u32 min_value_u:1;
		__u32 max_value_u:1;
		__u32 min_length:1;
		__u32 max_length:1;
		__u32 policy_idx:1;
		__u32 policy_maxtype:1;
		__u32 bitfield32_mask:1;
		__u32 mask:1;
	} _present;

	__u32 attr_id;
	__u32 policy_id;
	enum netlink_attribute_type type;
	__s64 min_value_s;
	__s64 max_value_s;
	__u64 min_value_u;
	__u64 max_value_u;
	__u32 min_length;
	__u32 max_length;
	__u32 policy_idx;
	__u32 policy_maxtype;
	__u32 bitfield32_mask;
	__u64 mask;
};

struct nlctrl_op_policy_attrs {
	struct {
		__u32 do_:1;
		__u32 dump:1;
	} _present;

	__u32 op_id;
	__u32 do_;
	__u32 dump;
};

/* ============== CTRL_CMD_GETFAMILY ============== */
/* CTRL_CMD_GETFAMILY - do */
struct nlctrl_getfamily_req {
	struct {
		__u32 family_name_len;
	} _present;

	char *family_name;
};

static inline struct nlctrl_getfamily_req *nlctrl_getfamily_req_alloc(void)
{
	return calloc(1, sizeof(struct nlctrl_getfamily_req));
}
void nlctrl_getfamily_req_free(struct nlctrl_getfamily_req *req);

static inline void
nlctrl_getfamily_req_set_family_name(struct nlctrl_getfamily_req *req,
				     const char *family_name)
{
	free(req->family_name);
	req->_present.family_name_len = strlen(family_name);
	req->family_name = malloc(req->_present.family_name_len + 1);
	memcpy(req->family_name, family_name, req->_present.family_name_len);
	req->family_name[req->_present.family_name_len] = 0;
}

struct nlctrl_getfamily_rsp {
	struct {
		__u32 family_id:1;
		__u32 family_name_len;
		__u32 hdrsize:1;
		__u32 maxattr:1;
		__u32 version:1;
	} _present;

	__u16 family_id;
	char *family_name;
	__u32 hdrsize;
	__u32 maxattr;
	unsigned int n_mcast_groups;
	struct nlctrl_mcast_group_attrs *mcast_groups;
	unsigned int n_ops;
	struct nlctrl_op_attrs *ops;
	__u32 version;
};

void nlctrl_getfamily_rsp_free(struct nlctrl_getfamily_rsp *rsp);

/*
 * Get / dump genetlink families
 */
struct nlctrl_getfamily_rsp *
nlctrl_getfamily(struct ynl_sock *ys, struct nlctrl_getfamily_req *req);

/* CTRL_CMD_GETFAMILY - dump */
struct nlctrl_getfamily_list {
	struct nlctrl_getfamily_list *next;
	struct nlctrl_getfamily_rsp obj __attribute__((aligned(8)));
};

void nlctrl_getfamily_list_free(struct nlctrl_getfamily_list *rsp);

struct nlctrl_getfamily_list *nlctrl_getfamily_dump(struct ynl_sock *ys);

/* ============== CTRL_CMD_GETPOLICY ============== */
/* CTRL_CMD_GETPOLICY - dump */
struct nlctrl_getpolicy_req_dump {
	struct {
		__u32 family_name_len;
		__u32 family_id:1;
		__u32 op:1;
	} _present;

	char *family_name;
	__u16 family_id;
	__u32 op;
};

static inline struct nlctrl_getpolicy_req_dump *
nlctrl_getpolicy_req_dump_alloc(void)
{
	return calloc(1, sizeof(struct nlctrl_getpolicy_req_dump));
}
void nlctrl_getpolicy_req_dump_free(struct nlctrl_getpolicy_req_dump *req);

static inline void
nlctrl_getpolicy_req_dump_set_family_name(struct nlctrl_getpolicy_req_dump *req,
					  const char *family_name)
{
	free(req->family_name);
	req->_present.family_name_len = strlen(family_name);
	req->family_name = malloc(req->_present.family_name_len + 1);
	memcpy(req->family_name, family_name, req->_present.family_name_len);
	req->family_name[req->_present.family_name_len] = 0;
}
static inline void
nlctrl_getpolicy_req_dump_set_family_id(struct nlctrl_getpolicy_req_dump *req,
					__u16 family_id)
{
	req->_present.family_id = 1;
	req->family_id = family_id;
}
static inline void
nlctrl_getpolicy_req_dump_set_op(struct nlctrl_getpolicy_req_dump *req,
				 __u32 op)
{
	req->_present.op = 1;
	req->op = op;
}

struct nlctrl_getpolicy_rsp_dump {
	struct {
		__u32 family_id:1;
		__u32 op_policy:1;
		__u32 policy:1;
	} _present;

	__u16 family_id;
	struct nlctrl_op_policy_attrs op_policy;
	struct nlctrl_policy_attrs policy;
};

struct nlctrl_getpolicy_rsp_list {
	struct nlctrl_getpolicy_rsp_list *next;
	struct nlctrl_getpolicy_rsp_dump obj __attribute__((aligned(8)));
};

void nlctrl_getpolicy_rsp_list_free(struct nlctrl_getpolicy_rsp_list *rsp);

struct nlctrl_getpolicy_rsp_list *
nlctrl_getpolicy_dump(struct ynl_sock *ys,
		      struct nlctrl_getpolicy_req_dump *req);

#endif /* _LINUX_NLCTRL_GEN_H */
