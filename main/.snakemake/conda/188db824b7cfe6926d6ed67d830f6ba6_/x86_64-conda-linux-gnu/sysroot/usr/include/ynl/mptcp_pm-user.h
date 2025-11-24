/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
/* Do not edit directly, auto-generated from: */
/*	Documentation/netlink/specs/mptcp_pm.yaml */
/* YNL-GEN user header */

#ifndef _LINUX_MPTCP_PM_GEN_H
#define _LINUX_MPTCP_PM_GEN_H

#include <stdlib.h>
#include <string.h>
#include <linux/types.h>
#include <linux/mptcp_pm.h>

struct ynl_sock;

extern const struct ynl_family ynl_mptcp_pm_family;

/* Enums */
const char *mptcp_pm_op_str(int op);
const char *mptcp_pm_event_type_str(enum mptcp_event_type value);

/* Common nested types */
struct mptcp_pm_address {
	struct {
		__u32 family:1;
		__u32 id:1;
		__u32 addr4:1;
		__u32 addr6_len;
		__u32 port:1;
		__u32 flags:1;
		__u32 if_idx:1;
	} _present;

	__u16 family;
	__u8 id;
	__u32 addr4 /* big-endian */;
	void *addr6;
	__u16 port;
	__u32 flags;
	__s32 if_idx;
};

/* ============== MPTCP_PM_CMD_ADD_ADDR ============== */
/* MPTCP_PM_CMD_ADD_ADDR - do */
struct mptcp_pm_add_addr_req {
	struct {
		__u32 addr:1;
	} _present;

	struct mptcp_pm_address addr;
};

static inline struct mptcp_pm_add_addr_req *mptcp_pm_add_addr_req_alloc(void)
{
	return calloc(1, sizeof(struct mptcp_pm_add_addr_req));
}
void mptcp_pm_add_addr_req_free(struct mptcp_pm_add_addr_req *req);

static inline void
mptcp_pm_add_addr_req_set_addr_family(struct mptcp_pm_add_addr_req *req,
				      __u16 family)
{
	req->_present.addr = 1;
	req->addr._present.family = 1;
	req->addr.family = family;
}
static inline void
mptcp_pm_add_addr_req_set_addr_id(struct mptcp_pm_add_addr_req *req, __u8 id)
{
	req->_present.addr = 1;
	req->addr._present.id = 1;
	req->addr.id = id;
}
static inline void
mptcp_pm_add_addr_req_set_addr_addr4(struct mptcp_pm_add_addr_req *req,
				     __u32 addr4 /* big-endian */)
{
	req->_present.addr = 1;
	req->addr._present.addr4 = 1;
	req->addr.addr4 = addr4;
}
static inline void
mptcp_pm_add_addr_req_set_addr_addr6(struct mptcp_pm_add_addr_req *req,
				     const void *addr6, size_t len)
{
	req->_present.addr = 1;
	free(req->addr.addr6);
	req->addr._present.addr6_len = len;
	req->addr.addr6 = malloc(req->addr._present.addr6_len);
	memcpy(req->addr.addr6, addr6, req->addr._present.addr6_len);
}
static inline void
mptcp_pm_add_addr_req_set_addr_port(struct mptcp_pm_add_addr_req *req,
				    __u16 port)
{
	req->_present.addr = 1;
	req->addr._present.port = 1;
	req->addr.port = port;
}
static inline void
mptcp_pm_add_addr_req_set_addr_flags(struct mptcp_pm_add_addr_req *req,
				     __u32 flags)
{
	req->_present.addr = 1;
	req->addr._present.flags = 1;
	req->addr.flags = flags;
}
static inline void
mptcp_pm_add_addr_req_set_addr_if_idx(struct mptcp_pm_add_addr_req *req,
				      __s32 if_idx)
{
	req->_present.addr = 1;
	req->addr._present.if_idx = 1;
	req->addr.if_idx = if_idx;
}

/*
 * Add endpoint
 */
int mptcp_pm_add_addr(struct ynl_sock *ys, struct mptcp_pm_add_addr_req *req);

/* ============== MPTCP_PM_CMD_DEL_ADDR ============== */
/* MPTCP_PM_CMD_DEL_ADDR - do */
struct mptcp_pm_del_addr_req {
	struct {
		__u32 addr:1;
	} _present;

	struct mptcp_pm_address addr;
};

static inline struct mptcp_pm_del_addr_req *mptcp_pm_del_addr_req_alloc(void)
{
	return calloc(1, sizeof(struct mptcp_pm_del_addr_req));
}
void mptcp_pm_del_addr_req_free(struct mptcp_pm_del_addr_req *req);

static inline void
mptcp_pm_del_addr_req_set_addr_family(struct mptcp_pm_del_addr_req *req,
				      __u16 family)
{
	req->_present.addr = 1;
	req->addr._present.family = 1;
	req->addr.family = family;
}
static inline void
mptcp_pm_del_addr_req_set_addr_id(struct mptcp_pm_del_addr_req *req, __u8 id)
{
	req->_present.addr = 1;
	req->addr._present.id = 1;
	req->addr.id = id;
}
static inline void
mptcp_pm_del_addr_req_set_addr_addr4(struct mptcp_pm_del_addr_req *req,
				     __u32 addr4 /* big-endian */)
{
	req->_present.addr = 1;
	req->addr._present.addr4 = 1;
	req->addr.addr4 = addr4;
}
static inline void
mptcp_pm_del_addr_req_set_addr_addr6(struct mptcp_pm_del_addr_req *req,
				     const void *addr6, size_t len)
{
	req->_present.addr = 1;
	free(req->addr.addr6);
	req->addr._present.addr6_len = len;
	req->addr.addr6 = malloc(req->addr._present.addr6_len);
	memcpy(req->addr.addr6, addr6, req->addr._present.addr6_len);
}
static inline void
mptcp_pm_del_addr_req_set_addr_port(struct mptcp_pm_del_addr_req *req,
				    __u16 port)
{
	req->_present.addr = 1;
	req->addr._present.port = 1;
	req->addr.port = port;
}
static inline void
mptcp_pm_del_addr_req_set_addr_flags(struct mptcp_pm_del_addr_req *req,
				     __u32 flags)
{
	req->_present.addr = 1;
	req->addr._present.flags = 1;
	req->addr.flags = flags;
}
static inline void
mptcp_pm_del_addr_req_set_addr_if_idx(struct mptcp_pm_del_addr_req *req,
				      __s32 if_idx)
{
	req->_present.addr = 1;
	req->addr._present.if_idx = 1;
	req->addr.if_idx = if_idx;
}

/*
 * Delete endpoint
 */
int mptcp_pm_del_addr(struct ynl_sock *ys, struct mptcp_pm_del_addr_req *req);

/* ============== MPTCP_PM_CMD_GET_ADDR ============== */
/* MPTCP_PM_CMD_GET_ADDR - do */
struct mptcp_pm_get_addr_req {
	struct {
		__u32 addr:1;
		__u32 token:1;
	} _present;

	struct mptcp_pm_address addr;
	__u32 token;
};

static inline struct mptcp_pm_get_addr_req *mptcp_pm_get_addr_req_alloc(void)
{
	return calloc(1, sizeof(struct mptcp_pm_get_addr_req));
}
void mptcp_pm_get_addr_req_free(struct mptcp_pm_get_addr_req *req);

static inline void
mptcp_pm_get_addr_req_set_addr_family(struct mptcp_pm_get_addr_req *req,
				      __u16 family)
{
	req->_present.addr = 1;
	req->addr._present.family = 1;
	req->addr.family = family;
}
static inline void
mptcp_pm_get_addr_req_set_addr_id(struct mptcp_pm_get_addr_req *req, __u8 id)
{
	req->_present.addr = 1;
	req->addr._present.id = 1;
	req->addr.id = id;
}
static inline void
mptcp_pm_get_addr_req_set_addr_addr4(struct mptcp_pm_get_addr_req *req,
				     __u32 addr4 /* big-endian */)
{
	req->_present.addr = 1;
	req->addr._present.addr4 = 1;
	req->addr.addr4 = addr4;
}
static inline void
mptcp_pm_get_addr_req_set_addr_addr6(struct mptcp_pm_get_addr_req *req,
				     const void *addr6, size_t len)
{
	req->_present.addr = 1;
	free(req->addr.addr6);
	req->addr._present.addr6_len = len;
	req->addr.addr6 = malloc(req->addr._present.addr6_len);
	memcpy(req->addr.addr6, addr6, req->addr._present.addr6_len);
}
static inline void
mptcp_pm_get_addr_req_set_addr_port(struct mptcp_pm_get_addr_req *req,
				    __u16 port)
{
	req->_present.addr = 1;
	req->addr._present.port = 1;
	req->addr.port = port;
}
static inline void
mptcp_pm_get_addr_req_set_addr_flags(struct mptcp_pm_get_addr_req *req,
				     __u32 flags)
{
	req->_present.addr = 1;
	req->addr._present.flags = 1;
	req->addr.flags = flags;
}
static inline void
mptcp_pm_get_addr_req_set_addr_if_idx(struct mptcp_pm_get_addr_req *req,
				      __s32 if_idx)
{
	req->_present.addr = 1;
	req->addr._present.if_idx = 1;
	req->addr.if_idx = if_idx;
}
static inline void
mptcp_pm_get_addr_req_set_token(struct mptcp_pm_get_addr_req *req, __u32 token)
{
	req->_present.token = 1;
	req->token = token;
}

struct mptcp_pm_get_addr_rsp {
	struct {
		__u32 addr:1;
	} _present;

	struct mptcp_pm_address addr;
};

void mptcp_pm_get_addr_rsp_free(struct mptcp_pm_get_addr_rsp *rsp);

/*
 * Get endpoint information
 */
struct mptcp_pm_get_addr_rsp *
mptcp_pm_get_addr(struct ynl_sock *ys, struct mptcp_pm_get_addr_req *req);

/* MPTCP_PM_CMD_GET_ADDR - dump */
struct mptcp_pm_get_addr_list {
	struct mptcp_pm_get_addr_list *next;
	struct mptcp_pm_get_addr_rsp obj __attribute__((aligned(8)));
};

void mptcp_pm_get_addr_list_free(struct mptcp_pm_get_addr_list *rsp);

struct mptcp_pm_get_addr_list *mptcp_pm_get_addr_dump(struct ynl_sock *ys);

/* ============== MPTCP_PM_CMD_FLUSH_ADDRS ============== */
/* MPTCP_PM_CMD_FLUSH_ADDRS - do */
struct mptcp_pm_flush_addrs_req {
	struct {
		__u32 addr:1;
	} _present;

	struct mptcp_pm_address addr;
};

static inline struct mptcp_pm_flush_addrs_req *
mptcp_pm_flush_addrs_req_alloc(void)
{
	return calloc(1, sizeof(struct mptcp_pm_flush_addrs_req));
}
void mptcp_pm_flush_addrs_req_free(struct mptcp_pm_flush_addrs_req *req);

static inline void
mptcp_pm_flush_addrs_req_set_addr_family(struct mptcp_pm_flush_addrs_req *req,
					 __u16 family)
{
	req->_present.addr = 1;
	req->addr._present.family = 1;
	req->addr.family = family;
}
static inline void
mptcp_pm_flush_addrs_req_set_addr_id(struct mptcp_pm_flush_addrs_req *req,
				     __u8 id)
{
	req->_present.addr = 1;
	req->addr._present.id = 1;
	req->addr.id = id;
}
static inline void
mptcp_pm_flush_addrs_req_set_addr_addr4(struct mptcp_pm_flush_addrs_req *req,
					__u32 addr4 /* big-endian */)
{
	req->_present.addr = 1;
	req->addr._present.addr4 = 1;
	req->addr.addr4 = addr4;
}
static inline void
mptcp_pm_flush_addrs_req_set_addr_addr6(struct mptcp_pm_flush_addrs_req *req,
					const void *addr6, size_t len)
{
	req->_present.addr = 1;
	free(req->addr.addr6);
	req->addr._present.addr6_len = len;
	req->addr.addr6 = malloc(req->addr._present.addr6_len);
	memcpy(req->addr.addr6, addr6, req->addr._present.addr6_len);
}
static inline void
mptcp_pm_flush_addrs_req_set_addr_port(struct mptcp_pm_flush_addrs_req *req,
				       __u16 port)
{
	req->_present.addr = 1;
	req->addr._present.port = 1;
	req->addr.port = port;
}
static inline void
mptcp_pm_flush_addrs_req_set_addr_flags(struct mptcp_pm_flush_addrs_req *req,
					__u32 flags)
{
	req->_present.addr = 1;
	req->addr._present.flags = 1;
	req->addr.flags = flags;
}
static inline void
mptcp_pm_flush_addrs_req_set_addr_if_idx(struct mptcp_pm_flush_addrs_req *req,
					 __s32 if_idx)
{
	req->_present.addr = 1;
	req->addr._present.if_idx = 1;
	req->addr.if_idx = if_idx;
}

/*
 * flush addresses
 */
int mptcp_pm_flush_addrs(struct ynl_sock *ys,
			 struct mptcp_pm_flush_addrs_req *req);

/* ============== MPTCP_PM_CMD_SET_LIMITS ============== */
/* MPTCP_PM_CMD_SET_LIMITS - do */
struct mptcp_pm_set_limits_req {
	struct {
		__u32 rcv_add_addrs:1;
		__u32 subflows:1;
	} _present;

	__u32 rcv_add_addrs;
	__u32 subflows;
};

static inline struct mptcp_pm_set_limits_req *
mptcp_pm_set_limits_req_alloc(void)
{
	return calloc(1, sizeof(struct mptcp_pm_set_limits_req));
}
void mptcp_pm_set_limits_req_free(struct mptcp_pm_set_limits_req *req);

static inline void
mptcp_pm_set_limits_req_set_rcv_add_addrs(struct mptcp_pm_set_limits_req *req,
					  __u32 rcv_add_addrs)
{
	req->_present.rcv_add_addrs = 1;
	req->rcv_add_addrs = rcv_add_addrs;
}
static inline void
mptcp_pm_set_limits_req_set_subflows(struct mptcp_pm_set_limits_req *req,
				     __u32 subflows)
{
	req->_present.subflows = 1;
	req->subflows = subflows;
}

/*
 * Set protocol limits
 */
int mptcp_pm_set_limits(struct ynl_sock *ys,
			struct mptcp_pm_set_limits_req *req);

/* ============== MPTCP_PM_CMD_GET_LIMITS ============== */
/* MPTCP_PM_CMD_GET_LIMITS - do */
struct mptcp_pm_get_limits_req {
	struct {
		__u32 rcv_add_addrs:1;
		__u32 subflows:1;
	} _present;

	__u32 rcv_add_addrs;
	__u32 subflows;
};

static inline struct mptcp_pm_get_limits_req *
mptcp_pm_get_limits_req_alloc(void)
{
	return calloc(1, sizeof(struct mptcp_pm_get_limits_req));
}
void mptcp_pm_get_limits_req_free(struct mptcp_pm_get_limits_req *req);

static inline void
mptcp_pm_get_limits_req_set_rcv_add_addrs(struct mptcp_pm_get_limits_req *req,
					  __u32 rcv_add_addrs)
{
	req->_present.rcv_add_addrs = 1;
	req->rcv_add_addrs = rcv_add_addrs;
}
static inline void
mptcp_pm_get_limits_req_set_subflows(struct mptcp_pm_get_limits_req *req,
				     __u32 subflows)
{
	req->_present.subflows = 1;
	req->subflows = subflows;
}

struct mptcp_pm_get_limits_rsp {
	struct {
		__u32 rcv_add_addrs:1;
		__u32 subflows:1;
	} _present;

	__u32 rcv_add_addrs;
	__u32 subflows;
};

void mptcp_pm_get_limits_rsp_free(struct mptcp_pm_get_limits_rsp *rsp);

/*
 * Get protocol limits
 */
struct mptcp_pm_get_limits_rsp *
mptcp_pm_get_limits(struct ynl_sock *ys, struct mptcp_pm_get_limits_req *req);

/* ============== MPTCP_PM_CMD_SET_FLAGS ============== */
/* MPTCP_PM_CMD_SET_FLAGS - do */
struct mptcp_pm_set_flags_req {
	struct {
		__u32 addr:1;
		__u32 token:1;
		__u32 addr_remote:1;
	} _present;

	struct mptcp_pm_address addr;
	__u32 token;
	struct mptcp_pm_address addr_remote;
};

static inline struct mptcp_pm_set_flags_req *mptcp_pm_set_flags_req_alloc(void)
{
	return calloc(1, sizeof(struct mptcp_pm_set_flags_req));
}
void mptcp_pm_set_flags_req_free(struct mptcp_pm_set_flags_req *req);

static inline void
mptcp_pm_set_flags_req_set_addr_family(struct mptcp_pm_set_flags_req *req,
				       __u16 family)
{
	req->_present.addr = 1;
	req->addr._present.family = 1;
	req->addr.family = family;
}
static inline void
mptcp_pm_set_flags_req_set_addr_id(struct mptcp_pm_set_flags_req *req, __u8 id)
{
	req->_present.addr = 1;
	req->addr._present.id = 1;
	req->addr.id = id;
}
static inline void
mptcp_pm_set_flags_req_set_addr_addr4(struct mptcp_pm_set_flags_req *req,
				      __u32 addr4 /* big-endian */)
{
	req->_present.addr = 1;
	req->addr._present.addr4 = 1;
	req->addr.addr4 = addr4;
}
static inline void
mptcp_pm_set_flags_req_set_addr_addr6(struct mptcp_pm_set_flags_req *req,
				      const void *addr6, size_t len)
{
	req->_present.addr = 1;
	free(req->addr.addr6);
	req->addr._present.addr6_len = len;
	req->addr.addr6 = malloc(req->addr._present.addr6_len);
	memcpy(req->addr.addr6, addr6, req->addr._present.addr6_len);
}
static inline void
mptcp_pm_set_flags_req_set_addr_port(struct mptcp_pm_set_flags_req *req,
				     __u16 port)
{
	req->_present.addr = 1;
	req->addr._present.port = 1;
	req->addr.port = port;
}
static inline void
mptcp_pm_set_flags_req_set_addr_flags(struct mptcp_pm_set_flags_req *req,
				      __u32 flags)
{
	req->_present.addr = 1;
	req->addr._present.flags = 1;
	req->addr.flags = flags;
}
static inline void
mptcp_pm_set_flags_req_set_addr_if_idx(struct mptcp_pm_set_flags_req *req,
				       __s32 if_idx)
{
	req->_present.addr = 1;
	req->addr._present.if_idx = 1;
	req->addr.if_idx = if_idx;
}
static inline void
mptcp_pm_set_flags_req_set_token(struct mptcp_pm_set_flags_req *req,
				 __u32 token)
{
	req->_present.token = 1;
	req->token = token;
}
static inline void
mptcp_pm_set_flags_req_set_addr_remote_family(struct mptcp_pm_set_flags_req *req,
					      __u16 family)
{
	req->_present.addr_remote = 1;
	req->addr_remote._present.family = 1;
	req->addr_remote.family = family;
}
static inline void
mptcp_pm_set_flags_req_set_addr_remote_id(struct mptcp_pm_set_flags_req *req,
					  __u8 id)
{
	req->_present.addr_remote = 1;
	req->addr_remote._present.id = 1;
	req->addr_remote.id = id;
}
static inline void
mptcp_pm_set_flags_req_set_addr_remote_addr4(struct mptcp_pm_set_flags_req *req,
					     __u32 addr4 /* big-endian */)
{
	req->_present.addr_remote = 1;
	req->addr_remote._present.addr4 = 1;
	req->addr_remote.addr4 = addr4;
}
static inline void
mptcp_pm_set_flags_req_set_addr_remote_addr6(struct mptcp_pm_set_flags_req *req,
					     const void *addr6, size_t len)
{
	req->_present.addr_remote = 1;
	free(req->addr_remote.addr6);
	req->addr_remote._present.addr6_len = len;
	req->addr_remote.addr6 = malloc(req->addr_remote._present.addr6_len);
	memcpy(req->addr_remote.addr6, addr6, req->addr_remote._present.addr6_len);
}
static inline void
mptcp_pm_set_flags_req_set_addr_remote_port(struct mptcp_pm_set_flags_req *req,
					    __u16 port)
{
	req->_present.addr_remote = 1;
	req->addr_remote._present.port = 1;
	req->addr_remote.port = port;
}
static inline void
mptcp_pm_set_flags_req_set_addr_remote_flags(struct mptcp_pm_set_flags_req *req,
					     __u32 flags)
{
	req->_present.addr_remote = 1;
	req->addr_remote._present.flags = 1;
	req->addr_remote.flags = flags;
}
static inline void
mptcp_pm_set_flags_req_set_addr_remote_if_idx(struct mptcp_pm_set_flags_req *req,
					      __s32 if_idx)
{
	req->_present.addr_remote = 1;
	req->addr_remote._present.if_idx = 1;
	req->addr_remote.if_idx = if_idx;
}

/*
 * Change endpoint flags
 */
int mptcp_pm_set_flags(struct ynl_sock *ys, struct mptcp_pm_set_flags_req *req);

/* ============== MPTCP_PM_CMD_ANNOUNCE ============== */
/* MPTCP_PM_CMD_ANNOUNCE - do */
struct mptcp_pm_announce_req {
	struct {
		__u32 addr:1;
		__u32 token:1;
	} _present;

	struct mptcp_pm_address addr;
	__u32 token;
};

static inline struct mptcp_pm_announce_req *mptcp_pm_announce_req_alloc(void)
{
	return calloc(1, sizeof(struct mptcp_pm_announce_req));
}
void mptcp_pm_announce_req_free(struct mptcp_pm_announce_req *req);

static inline void
mptcp_pm_announce_req_set_addr_family(struct mptcp_pm_announce_req *req,
				      __u16 family)
{
	req->_present.addr = 1;
	req->addr._present.family = 1;
	req->addr.family = family;
}
static inline void
mptcp_pm_announce_req_set_addr_id(struct mptcp_pm_announce_req *req, __u8 id)
{
	req->_present.addr = 1;
	req->addr._present.id = 1;
	req->addr.id = id;
}
static inline void
mptcp_pm_announce_req_set_addr_addr4(struct mptcp_pm_announce_req *req,
				     __u32 addr4 /* big-endian */)
{
	req->_present.addr = 1;
	req->addr._present.addr4 = 1;
	req->addr.addr4 = addr4;
}
static inline void
mptcp_pm_announce_req_set_addr_addr6(struct mptcp_pm_announce_req *req,
				     const void *addr6, size_t len)
{
	req->_present.addr = 1;
	free(req->addr.addr6);
	req->addr._present.addr6_len = len;
	req->addr.addr6 = malloc(req->addr._present.addr6_len);
	memcpy(req->addr.addr6, addr6, req->addr._present.addr6_len);
}
static inline void
mptcp_pm_announce_req_set_addr_port(struct mptcp_pm_announce_req *req,
				    __u16 port)
{
	req->_present.addr = 1;
	req->addr._present.port = 1;
	req->addr.port = port;
}
static inline void
mptcp_pm_announce_req_set_addr_flags(struct mptcp_pm_announce_req *req,
				     __u32 flags)
{
	req->_present.addr = 1;
	req->addr._present.flags = 1;
	req->addr.flags = flags;
}
static inline void
mptcp_pm_announce_req_set_addr_if_idx(struct mptcp_pm_announce_req *req,
				      __s32 if_idx)
{
	req->_present.addr = 1;
	req->addr._present.if_idx = 1;
	req->addr.if_idx = if_idx;
}
static inline void
mptcp_pm_announce_req_set_token(struct mptcp_pm_announce_req *req, __u32 token)
{
	req->_present.token = 1;
	req->token = token;
}

/*
 * announce new sf
 */
int mptcp_pm_announce(struct ynl_sock *ys, struct mptcp_pm_announce_req *req);

/* ============== MPTCP_PM_CMD_REMOVE ============== */
/* MPTCP_PM_CMD_REMOVE - do */
struct mptcp_pm_remove_req {
	struct {
		__u32 token:1;
		__u32 loc_id:1;
	} _present;

	__u32 token;
	__u8 loc_id;
};

static inline struct mptcp_pm_remove_req *mptcp_pm_remove_req_alloc(void)
{
	return calloc(1, sizeof(struct mptcp_pm_remove_req));
}
void mptcp_pm_remove_req_free(struct mptcp_pm_remove_req *req);

static inline void
mptcp_pm_remove_req_set_token(struct mptcp_pm_remove_req *req, __u32 token)
{
	req->_present.token = 1;
	req->token = token;
}
static inline void
mptcp_pm_remove_req_set_loc_id(struct mptcp_pm_remove_req *req, __u8 loc_id)
{
	req->_present.loc_id = 1;
	req->loc_id = loc_id;
}

/*
 * announce removal
 */
int mptcp_pm_remove(struct ynl_sock *ys, struct mptcp_pm_remove_req *req);

/* ============== MPTCP_PM_CMD_SUBFLOW_CREATE ============== */
/* MPTCP_PM_CMD_SUBFLOW_CREATE - do */
struct mptcp_pm_subflow_create_req {
	struct {
		__u32 addr:1;
		__u32 token:1;
		__u32 addr_remote:1;
	} _present;

	struct mptcp_pm_address addr;
	__u32 token;
	struct mptcp_pm_address addr_remote;
};

static inline struct mptcp_pm_subflow_create_req *
mptcp_pm_subflow_create_req_alloc(void)
{
	return calloc(1, sizeof(struct mptcp_pm_subflow_create_req));
}
void mptcp_pm_subflow_create_req_free(struct mptcp_pm_subflow_create_req *req);

static inline void
mptcp_pm_subflow_create_req_set_addr_family(struct mptcp_pm_subflow_create_req *req,
					    __u16 family)
{
	req->_present.addr = 1;
	req->addr._present.family = 1;
	req->addr.family = family;
}
static inline void
mptcp_pm_subflow_create_req_set_addr_id(struct mptcp_pm_subflow_create_req *req,
					__u8 id)
{
	req->_present.addr = 1;
	req->addr._present.id = 1;
	req->addr.id = id;
}
static inline void
mptcp_pm_subflow_create_req_set_addr_addr4(struct mptcp_pm_subflow_create_req *req,
					   __u32 addr4 /* big-endian */)
{
	req->_present.addr = 1;
	req->addr._present.addr4 = 1;
	req->addr.addr4 = addr4;
}
static inline void
mptcp_pm_subflow_create_req_set_addr_addr6(struct mptcp_pm_subflow_create_req *req,
					   const void *addr6, size_t len)
{
	req->_present.addr = 1;
	free(req->addr.addr6);
	req->addr._present.addr6_len = len;
	req->addr.addr6 = malloc(req->addr._present.addr6_len);
	memcpy(req->addr.addr6, addr6, req->addr._present.addr6_len);
}
static inline void
mptcp_pm_subflow_create_req_set_addr_port(struct mptcp_pm_subflow_create_req *req,
					  __u16 port)
{
	req->_present.addr = 1;
	req->addr._present.port = 1;
	req->addr.port = port;
}
static inline void
mptcp_pm_subflow_create_req_set_addr_flags(struct mptcp_pm_subflow_create_req *req,
					   __u32 flags)
{
	req->_present.addr = 1;
	req->addr._present.flags = 1;
	req->addr.flags = flags;
}
static inline void
mptcp_pm_subflow_create_req_set_addr_if_idx(struct mptcp_pm_subflow_create_req *req,
					    __s32 if_idx)
{
	req->_present.addr = 1;
	req->addr._present.if_idx = 1;
	req->addr.if_idx = if_idx;
}
static inline void
mptcp_pm_subflow_create_req_set_token(struct mptcp_pm_subflow_create_req *req,
				      __u32 token)
{
	req->_present.token = 1;
	req->token = token;
}
static inline void
mptcp_pm_subflow_create_req_set_addr_remote_family(struct mptcp_pm_subflow_create_req *req,
						   __u16 family)
{
	req->_present.addr_remote = 1;
	req->addr_remote._present.family = 1;
	req->addr_remote.family = family;
}
static inline void
mptcp_pm_subflow_create_req_set_addr_remote_id(struct mptcp_pm_subflow_create_req *req,
					       __u8 id)
{
	req->_present.addr_remote = 1;
	req->addr_remote._present.id = 1;
	req->addr_remote.id = id;
}
static inline void
mptcp_pm_subflow_create_req_set_addr_remote_addr4(struct mptcp_pm_subflow_create_req *req,
						  __u32 addr4 /* big-endian */)
{
	req->_present.addr_remote = 1;
	req->addr_remote._present.addr4 = 1;
	req->addr_remote.addr4 = addr4;
}
static inline void
mptcp_pm_subflow_create_req_set_addr_remote_addr6(struct mptcp_pm_subflow_create_req *req,
						  const void *addr6,
						  size_t len)
{
	req->_present.addr_remote = 1;
	free(req->addr_remote.addr6);
	req->addr_remote._present.addr6_len = len;
	req->addr_remote.addr6 = malloc(req->addr_remote._present.addr6_len);
	memcpy(req->addr_remote.addr6, addr6, req->addr_remote._present.addr6_len);
}
static inline void
mptcp_pm_subflow_create_req_set_addr_remote_port(struct mptcp_pm_subflow_create_req *req,
						 __u16 port)
{
	req->_present.addr_remote = 1;
	req->addr_remote._present.port = 1;
	req->addr_remote.port = port;
}
static inline void
mptcp_pm_subflow_create_req_set_addr_remote_flags(struct mptcp_pm_subflow_create_req *req,
						  __u32 flags)
{
	req->_present.addr_remote = 1;
	req->addr_remote._present.flags = 1;
	req->addr_remote.flags = flags;
}
static inline void
mptcp_pm_subflow_create_req_set_addr_remote_if_idx(struct mptcp_pm_subflow_create_req *req,
						   __s32 if_idx)
{
	req->_present.addr_remote = 1;
	req->addr_remote._present.if_idx = 1;
	req->addr_remote.if_idx = if_idx;
}

/*
 * todo
 */
int mptcp_pm_subflow_create(struct ynl_sock *ys,
			    struct mptcp_pm_subflow_create_req *req);

/* ============== MPTCP_PM_CMD_SUBFLOW_DESTROY ============== */
/* MPTCP_PM_CMD_SUBFLOW_DESTROY - do */
struct mptcp_pm_subflow_destroy_req {
	struct {
		__u32 addr:1;
		__u32 token:1;
		__u32 addr_remote:1;
	} _present;

	struct mptcp_pm_address addr;
	__u32 token;
	struct mptcp_pm_address addr_remote;
};

static inline struct mptcp_pm_subflow_destroy_req *
mptcp_pm_subflow_destroy_req_alloc(void)
{
	return calloc(1, sizeof(struct mptcp_pm_subflow_destroy_req));
}
void
mptcp_pm_subflow_destroy_req_free(struct mptcp_pm_subflow_destroy_req *req);

static inline void
mptcp_pm_subflow_destroy_req_set_addr_family(struct mptcp_pm_subflow_destroy_req *req,
					     __u16 family)
{
	req->_present.addr = 1;
	req->addr._present.family = 1;
	req->addr.family = family;
}
static inline void
mptcp_pm_subflow_destroy_req_set_addr_id(struct mptcp_pm_subflow_destroy_req *req,
					 __u8 id)
{
	req->_present.addr = 1;
	req->addr._present.id = 1;
	req->addr.id = id;
}
static inline void
mptcp_pm_subflow_destroy_req_set_addr_addr4(struct mptcp_pm_subflow_destroy_req *req,
					    __u32 addr4 /* big-endian */)
{
	req->_present.addr = 1;
	req->addr._present.addr4 = 1;
	req->addr.addr4 = addr4;
}
static inline void
mptcp_pm_subflow_destroy_req_set_addr_addr6(struct mptcp_pm_subflow_destroy_req *req,
					    const void *addr6, size_t len)
{
	req->_present.addr = 1;
	free(req->addr.addr6);
	req->addr._present.addr6_len = len;
	req->addr.addr6 = malloc(req->addr._present.addr6_len);
	memcpy(req->addr.addr6, addr6, req->addr._present.addr6_len);
}
static inline void
mptcp_pm_subflow_destroy_req_set_addr_port(struct mptcp_pm_subflow_destroy_req *req,
					   __u16 port)
{
	req->_present.addr = 1;
	req->addr._present.port = 1;
	req->addr.port = port;
}
static inline void
mptcp_pm_subflow_destroy_req_set_addr_flags(struct mptcp_pm_subflow_destroy_req *req,
					    __u32 flags)
{
	req->_present.addr = 1;
	req->addr._present.flags = 1;
	req->addr.flags = flags;
}
static inline void
mptcp_pm_subflow_destroy_req_set_addr_if_idx(struct mptcp_pm_subflow_destroy_req *req,
					     __s32 if_idx)
{
	req->_present.addr = 1;
	req->addr._present.if_idx = 1;
	req->addr.if_idx = if_idx;
}
static inline void
mptcp_pm_subflow_destroy_req_set_token(struct mptcp_pm_subflow_destroy_req *req,
				       __u32 token)
{
	req->_present.token = 1;
	req->token = token;
}
static inline void
mptcp_pm_subflow_destroy_req_set_addr_remote_family(struct mptcp_pm_subflow_destroy_req *req,
						    __u16 family)
{
	req->_present.addr_remote = 1;
	req->addr_remote._present.family = 1;
	req->addr_remote.family = family;
}
static inline void
mptcp_pm_subflow_destroy_req_set_addr_remote_id(struct mptcp_pm_subflow_destroy_req *req,
						__u8 id)
{
	req->_present.addr_remote = 1;
	req->addr_remote._present.id = 1;
	req->addr_remote.id = id;
}
static inline void
mptcp_pm_subflow_destroy_req_set_addr_remote_addr4(struct mptcp_pm_subflow_destroy_req *req,
						   __u32 addr4 /* big-endian */)
{
	req->_present.addr_remote = 1;
	req->addr_remote._present.addr4 = 1;
	req->addr_remote.addr4 = addr4;
}
static inline void
mptcp_pm_subflow_destroy_req_set_addr_remote_addr6(struct mptcp_pm_subflow_destroy_req *req,
						   const void *addr6,
						   size_t len)
{
	req->_present.addr_remote = 1;
	free(req->addr_remote.addr6);
	req->addr_remote._present.addr6_len = len;
	req->addr_remote.addr6 = malloc(req->addr_remote._present.addr6_len);
	memcpy(req->addr_remote.addr6, addr6, req->addr_remote._present.addr6_len);
}
static inline void
mptcp_pm_subflow_destroy_req_set_addr_remote_port(struct mptcp_pm_subflow_destroy_req *req,
						  __u16 port)
{
	req->_present.addr_remote = 1;
	req->addr_remote._present.port = 1;
	req->addr_remote.port = port;
}
static inline void
mptcp_pm_subflow_destroy_req_set_addr_remote_flags(struct mptcp_pm_subflow_destroy_req *req,
						   __u32 flags)
{
	req->_present.addr_remote = 1;
	req->addr_remote._present.flags = 1;
	req->addr_remote.flags = flags;
}
static inline void
mptcp_pm_subflow_destroy_req_set_addr_remote_if_idx(struct mptcp_pm_subflow_destroy_req *req,
						    __s32 if_idx)
{
	req->_present.addr_remote = 1;
	req->addr_remote._present.if_idx = 1;
	req->addr_remote.if_idx = if_idx;
}

/*
 * todo
 */
int mptcp_pm_subflow_destroy(struct ynl_sock *ys,
			     struct mptcp_pm_subflow_destroy_req *req);

#endif /* _LINUX_MPTCP_PM_GEN_H */
