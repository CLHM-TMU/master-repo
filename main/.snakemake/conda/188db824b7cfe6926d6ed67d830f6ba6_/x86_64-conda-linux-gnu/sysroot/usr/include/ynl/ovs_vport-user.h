/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
/* Do not edit directly, auto-generated from: */
/*	Documentation/netlink/specs/ovs_vport.yaml */
/* YNL-GEN user header */

#ifndef _LINUX_OVS_VPORT_GEN_H
#define _LINUX_OVS_VPORT_GEN_H

#include <stdlib.h>
#include <string.h>
#include <linux/types.h>
#include <linux/openvswitch.h>

struct ynl_sock;

extern const struct ynl_family ynl_ovs_vport_family;

/* Enums */
const char *ovs_vport_op_str(int op);
const char *ovs_vport_vport_type_str(enum ovs_vport_type value);

/* Common nested types */
struct ovs_vport_vport_options {
	struct {
		__u32 dst_port:1;
		__u32 extension:1;
	} _present;

	__u32 dst_port;
	__u32 extension;
};

struct ovs_vport_upcall_stats {
	struct {
		__u32 success:1;
		__u32 fail:1;
	} _present;

	__u64 success;
	__u64 fail;
};

/* ============== OVS_VPORT_CMD_NEW ============== */
/* OVS_VPORT_CMD_NEW - do */
struct ovs_vport_new_req {
	struct ovs_header _hdr;

	struct {
		__u32 name_len;
		__u32 type:1;
		__u32 upcall_pid_len;
		__u32 ifindex:1;
		__u32 options:1;
	} _present;

	char *name;
	enum ovs_vport_type type;
	void *upcall_pid;
	__u32 ifindex;
	struct ovs_vport_vport_options options;
};

static inline struct ovs_vport_new_req *ovs_vport_new_req_alloc(void)
{
	return calloc(1, sizeof(struct ovs_vport_new_req));
}
void ovs_vport_new_req_free(struct ovs_vport_new_req *req);

static inline void
ovs_vport_new_req_set_name(struct ovs_vport_new_req *req, const char *name)
{
	free(req->name);
	req->_present.name_len = strlen(name);
	req->name = malloc(req->_present.name_len + 1);
	memcpy(req->name, name, req->_present.name_len);
	req->name[req->_present.name_len] = 0;
}
static inline void
ovs_vport_new_req_set_type(struct ovs_vport_new_req *req,
			   enum ovs_vport_type type)
{
	req->_present.type = 1;
	req->type = type;
}
static inline void
ovs_vport_new_req_set_upcall_pid(struct ovs_vport_new_req *req,
				 const void *upcall_pid, size_t len)
{
	free(req->upcall_pid);
	req->_present.upcall_pid_len = len;
	req->upcall_pid = malloc(req->_present.upcall_pid_len);
	memcpy(req->upcall_pid, upcall_pid, req->_present.upcall_pid_len);
}
static inline void
ovs_vport_new_req_set_ifindex(struct ovs_vport_new_req *req, __u32 ifindex)
{
	req->_present.ifindex = 1;
	req->ifindex = ifindex;
}
static inline void
ovs_vport_new_req_set_options_dst_port(struct ovs_vport_new_req *req,
				       __u32 dst_port)
{
	req->_present.options = 1;
	req->options._present.dst_port = 1;
	req->options.dst_port = dst_port;
}
static inline void
ovs_vport_new_req_set_options_extension(struct ovs_vport_new_req *req,
					__u32 extension)
{
	req->_present.options = 1;
	req->options._present.extension = 1;
	req->options.extension = extension;
}

/*
 * Create a new OVS vport
 */
int ovs_vport_new(struct ynl_sock *ys, struct ovs_vport_new_req *req);

/* ============== OVS_VPORT_CMD_DEL ============== */
/* OVS_VPORT_CMD_DEL - do */
struct ovs_vport_del_req {
	struct ovs_header _hdr;

	struct {
		__u32 port_no:1;
		__u32 type:1;
		__u32 name_len;
	} _present;

	__u32 port_no;
	enum ovs_vport_type type;
	char *name;
};

static inline struct ovs_vport_del_req *ovs_vport_del_req_alloc(void)
{
	return calloc(1, sizeof(struct ovs_vport_del_req));
}
void ovs_vport_del_req_free(struct ovs_vport_del_req *req);

static inline void
ovs_vport_del_req_set_port_no(struct ovs_vport_del_req *req, __u32 port_no)
{
	req->_present.port_no = 1;
	req->port_no = port_no;
}
static inline void
ovs_vport_del_req_set_type(struct ovs_vport_del_req *req,
			   enum ovs_vport_type type)
{
	req->_present.type = 1;
	req->type = type;
}
static inline void
ovs_vport_del_req_set_name(struct ovs_vport_del_req *req, const char *name)
{
	free(req->name);
	req->_present.name_len = strlen(name);
	req->name = malloc(req->_present.name_len + 1);
	memcpy(req->name, name, req->_present.name_len);
	req->name[req->_present.name_len] = 0;
}

/*
 * Delete existing OVS vport from a data path
 */
int ovs_vport_del(struct ynl_sock *ys, struct ovs_vport_del_req *req);

/* ============== OVS_VPORT_CMD_GET ============== */
/* OVS_VPORT_CMD_GET - do */
struct ovs_vport_get_req {
	struct ovs_header _hdr;

	struct {
		__u32 name_len;
	} _present;

	char *name;
};

static inline struct ovs_vport_get_req *ovs_vport_get_req_alloc(void)
{
	return calloc(1, sizeof(struct ovs_vport_get_req));
}
void ovs_vport_get_req_free(struct ovs_vport_get_req *req);

static inline void
ovs_vport_get_req_set_name(struct ovs_vport_get_req *req, const char *name)
{
	free(req->name);
	req->_present.name_len = strlen(name);
	req->name = malloc(req->_present.name_len + 1);
	memcpy(req->name, name, req->_present.name_len);
	req->name[req->_present.name_len] = 0;
}

struct ovs_vport_get_rsp {
	struct ovs_header _hdr;

	struct {
		__u32 port_no:1;
		__u32 type:1;
		__u32 name_len;
		__u32 upcall_pid_len;
		__u32 stats_len;
		__u32 ifindex:1;
		__u32 netnsid:1;
		__u32 upcall_stats:1;
	} _present;

	__u32 port_no;
	enum ovs_vport_type type;
	char *name;
	void *upcall_pid;
	void *stats;
	__u32 ifindex;
	__u32 netnsid;
	struct ovs_vport_upcall_stats upcall_stats;
};

void ovs_vport_get_rsp_free(struct ovs_vport_get_rsp *rsp);

/*
 * Get / dump OVS vport configuration and state
 */
struct ovs_vport_get_rsp *
ovs_vport_get(struct ynl_sock *ys, struct ovs_vport_get_req *req);

/* OVS_VPORT_CMD_GET - dump */
struct ovs_vport_get_req_dump {
	struct ovs_header _hdr;

	struct {
		__u32 name_len;
	} _present;

	char *name;
};

static inline struct ovs_vport_get_req_dump *ovs_vport_get_req_dump_alloc(void)
{
	return calloc(1, sizeof(struct ovs_vport_get_req_dump));
}
void ovs_vport_get_req_dump_free(struct ovs_vport_get_req_dump *req);

static inline void
ovs_vport_get_req_dump_set_name(struct ovs_vport_get_req_dump *req,
				const char *name)
{
	free(req->name);
	req->_present.name_len = strlen(name);
	req->name = malloc(req->_present.name_len + 1);
	memcpy(req->name, name, req->_present.name_len);
	req->name[req->_present.name_len] = 0;
}

struct ovs_vport_get_list {
	struct ovs_vport_get_list *next;
	struct ovs_vport_get_rsp obj __attribute__((aligned(8)));
};

void ovs_vport_get_list_free(struct ovs_vport_get_list *rsp);

struct ovs_vport_get_list *
ovs_vport_get_dump(struct ynl_sock *ys, struct ovs_vport_get_req_dump *req);

#endif /* _LINUX_OVS_VPORT_GEN_H */
