/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
/* Do not edit directly, auto-generated from: */
/*	Documentation/netlink/specs/ovs_datapath.yaml */
/* YNL-GEN user header */

#ifndef _LINUX_OVS_DATAPATH_GEN_H
#define _LINUX_OVS_DATAPATH_GEN_H

#include <stdlib.h>
#include <string.h>
#include <linux/types.h>
#include <linux/openvswitch.h>

struct ynl_sock;

extern const struct ynl_family ynl_ovs_datapath_family;

/* Enums */
const char *ovs_datapath_op_str(int op);
const char *ovs_datapath_user_features_str(int value);

/* Common nested types */
/* ============== OVS_DP_CMD_GET ============== */
/* OVS_DP_CMD_GET - do */
struct ovs_datapath_get_req {
	struct ovs_header _hdr;

	struct {
		__u32 name_len;
	} _present;

	char *name;
};

static inline struct ovs_datapath_get_req *ovs_datapath_get_req_alloc(void)
{
	return calloc(1, sizeof(struct ovs_datapath_get_req));
}
void ovs_datapath_get_req_free(struct ovs_datapath_get_req *req);

static inline void
ovs_datapath_get_req_set_name(struct ovs_datapath_get_req *req,
			      const char *name)
{
	free(req->name);
	req->_present.name_len = strlen(name);
	req->name = malloc(req->_present.name_len + 1);
	memcpy(req->name, name, req->_present.name_len);
	req->name[req->_present.name_len] = 0;
}

struct ovs_datapath_get_rsp {
	struct ovs_header _hdr;

	struct {
		__u32 name_len;
		__u32 upcall_pid:1;
		__u32 stats_len;
		__u32 megaflow_stats_len;
		__u32 user_features:1;
		__u32 masks_cache_size:1;
		__u32 per_cpu_pids_len;
	} _present;

	char *name;
	__u32 upcall_pid;
	void *stats;
	void *megaflow_stats;
	__u32 user_features;
	__u32 masks_cache_size;
	void *per_cpu_pids;
};

void ovs_datapath_get_rsp_free(struct ovs_datapath_get_rsp *rsp);

/*
 * Get / dump OVS data path configuration and state
 */
struct ovs_datapath_get_rsp *
ovs_datapath_get(struct ynl_sock *ys, struct ovs_datapath_get_req *req);

/* OVS_DP_CMD_GET - dump */
struct ovs_datapath_get_req_dump {
	struct ovs_header _hdr;

	struct {
		__u32 name_len;
	} _present;

	char *name;
};

static inline struct ovs_datapath_get_req_dump *
ovs_datapath_get_req_dump_alloc(void)
{
	return calloc(1, sizeof(struct ovs_datapath_get_req_dump));
}
void ovs_datapath_get_req_dump_free(struct ovs_datapath_get_req_dump *req);

static inline void
ovs_datapath_get_req_dump_set_name(struct ovs_datapath_get_req_dump *req,
				   const char *name)
{
	free(req->name);
	req->_present.name_len = strlen(name);
	req->name = malloc(req->_present.name_len + 1);
	memcpy(req->name, name, req->_present.name_len);
	req->name[req->_present.name_len] = 0;
}

struct ovs_datapath_get_list {
	struct ovs_datapath_get_list *next;
	struct ovs_datapath_get_rsp obj __attribute__((aligned(8)));
};

void ovs_datapath_get_list_free(struct ovs_datapath_get_list *rsp);

struct ovs_datapath_get_list *
ovs_datapath_get_dump(struct ynl_sock *ys,
		      struct ovs_datapath_get_req_dump *req);

/* ============== OVS_DP_CMD_NEW ============== */
/* OVS_DP_CMD_NEW - do */
struct ovs_datapath_new_req {
	struct ovs_header _hdr;

	struct {
		__u32 name_len;
		__u32 upcall_pid:1;
		__u32 user_features:1;
	} _present;

	char *name;
	__u32 upcall_pid;
	__u32 user_features;
};

static inline struct ovs_datapath_new_req *ovs_datapath_new_req_alloc(void)
{
	return calloc(1, sizeof(struct ovs_datapath_new_req));
}
void ovs_datapath_new_req_free(struct ovs_datapath_new_req *req);

static inline void
ovs_datapath_new_req_set_name(struct ovs_datapath_new_req *req,
			      const char *name)
{
	free(req->name);
	req->_present.name_len = strlen(name);
	req->name = malloc(req->_present.name_len + 1);
	memcpy(req->name, name, req->_present.name_len);
	req->name[req->_present.name_len] = 0;
}
static inline void
ovs_datapath_new_req_set_upcall_pid(struct ovs_datapath_new_req *req,
				    __u32 upcall_pid)
{
	req->_present.upcall_pid = 1;
	req->upcall_pid = upcall_pid;
}
static inline void
ovs_datapath_new_req_set_user_features(struct ovs_datapath_new_req *req,
				       __u32 user_features)
{
	req->_present.user_features = 1;
	req->user_features = user_features;
}

/*
 * Create new OVS data path
 */
int ovs_datapath_new(struct ynl_sock *ys, struct ovs_datapath_new_req *req);

/* ============== OVS_DP_CMD_DEL ============== */
/* OVS_DP_CMD_DEL - do */
struct ovs_datapath_del_req {
	struct ovs_header _hdr;

	struct {
		__u32 name_len;
	} _present;

	char *name;
};

static inline struct ovs_datapath_del_req *ovs_datapath_del_req_alloc(void)
{
	return calloc(1, sizeof(struct ovs_datapath_del_req));
}
void ovs_datapath_del_req_free(struct ovs_datapath_del_req *req);

static inline void
ovs_datapath_del_req_set_name(struct ovs_datapath_del_req *req,
			      const char *name)
{
	free(req->name);
	req->_present.name_len = strlen(name);
	req->name = malloc(req->_present.name_len + 1);
	memcpy(req->name, name, req->_present.name_len);
	req->name[req->_present.name_len] = 0;
}

/*
 * Delete existing OVS data path
 */
int ovs_datapath_del(struct ynl_sock *ys, struct ovs_datapath_del_req *req);

#endif /* _LINUX_OVS_DATAPATH_GEN_H */
