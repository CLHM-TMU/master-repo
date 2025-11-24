/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
/* Do not edit directly, auto-generated from: */
/*	Documentation/netlink/specs/tcp_metrics.yaml */
/* YNL-GEN user header */

#ifndef _LINUX_TCP_METRICS_GEN_H
#define _LINUX_TCP_METRICS_GEN_H

#include <stdlib.h>
#include <string.h>
#include <linux/types.h>
#include <linux/tcp_metrics.h>

struct ynl_sock;

extern const struct ynl_family ynl_tcp_metrics_family;

/* Enums */
const char *tcp_metrics_op_str(int op);

/* Common nested types */
struct tcp_metrics_metrics {
	struct {
		__u32 rtt:1;
		__u32 rttvar:1;
		__u32 ssthresh:1;
		__u32 cwnd:1;
		__u32 reodering:1;
		__u32 rtt_us:1;
		__u32 rttvar_us:1;
	} _present;

	__u32 rtt;
	__u32 rttvar;
	__u32 ssthresh;
	__u32 cwnd;
	__u32 reodering;
	__u32 rtt_us;
	__u32 rttvar_us;
};

/* ============== TCP_METRICS_CMD_GET ============== */
/* TCP_METRICS_CMD_GET - do */
struct tcp_metrics_get_req {
	struct {
		__u32 addr_ipv4:1;
		__u32 addr_ipv6_len;
		__u32 saddr_ipv4:1;
		__u32 saddr_ipv6_len;
	} _present;

	__u32 addr_ipv4 /* big-endian */;
	void *addr_ipv6;
	__u32 saddr_ipv4 /* big-endian */;
	void *saddr_ipv6;
};

static inline struct tcp_metrics_get_req *tcp_metrics_get_req_alloc(void)
{
	return calloc(1, sizeof(struct tcp_metrics_get_req));
}
void tcp_metrics_get_req_free(struct tcp_metrics_get_req *req);

static inline void
tcp_metrics_get_req_set_addr_ipv4(struct tcp_metrics_get_req *req,
				  __u32 addr_ipv4 /* big-endian */)
{
	req->_present.addr_ipv4 = 1;
	req->addr_ipv4 = addr_ipv4;
}
static inline void
tcp_metrics_get_req_set_addr_ipv6(struct tcp_metrics_get_req *req,
				  const void *addr_ipv6, size_t len)
{
	free(req->addr_ipv6);
	req->_present.addr_ipv6_len = len;
	req->addr_ipv6 = malloc(req->_present.addr_ipv6_len);
	memcpy(req->addr_ipv6, addr_ipv6, req->_present.addr_ipv6_len);
}
static inline void
tcp_metrics_get_req_set_saddr_ipv4(struct tcp_metrics_get_req *req,
				   __u32 saddr_ipv4 /* big-endian */)
{
	req->_present.saddr_ipv4 = 1;
	req->saddr_ipv4 = saddr_ipv4;
}
static inline void
tcp_metrics_get_req_set_saddr_ipv6(struct tcp_metrics_get_req *req,
				   const void *saddr_ipv6, size_t len)
{
	free(req->saddr_ipv6);
	req->_present.saddr_ipv6_len = len;
	req->saddr_ipv6 = malloc(req->_present.saddr_ipv6_len);
	memcpy(req->saddr_ipv6, saddr_ipv6, req->_present.saddr_ipv6_len);
}

struct tcp_metrics_get_rsp {
	struct {
		__u32 addr_ipv4:1;
		__u32 addr_ipv6_len;
		__u32 saddr_ipv4:1;
		__u32 saddr_ipv6_len;
		__u32 age:1;
		__u32 vals:1;
		__u32 fopen_mss:1;
		__u32 fopen_syn_drops:1;
		__u32 fopen_syn_drop_ts:1;
		__u32 fopen_cookie_len;
	} _present;

	__u32 addr_ipv4 /* big-endian */;
	void *addr_ipv6;
	__u32 saddr_ipv4 /* big-endian */;
	void *saddr_ipv6;
	__u64 age;
	struct tcp_metrics_metrics vals;
	__u16 fopen_mss;
	__u16 fopen_syn_drops;
	__u64 fopen_syn_drop_ts;
	void *fopen_cookie;
};

void tcp_metrics_get_rsp_free(struct tcp_metrics_get_rsp *rsp);

/*
 * Retrieve metrics.
 */
struct tcp_metrics_get_rsp *
tcp_metrics_get(struct ynl_sock *ys, struct tcp_metrics_get_req *req);

/* TCP_METRICS_CMD_GET - dump */
struct tcp_metrics_get_list {
	struct tcp_metrics_get_list *next;
	struct tcp_metrics_get_rsp obj __attribute__((aligned(8)));
};

void tcp_metrics_get_list_free(struct tcp_metrics_get_list *rsp);

struct tcp_metrics_get_list *tcp_metrics_get_dump(struct ynl_sock *ys);

/* ============== TCP_METRICS_CMD_DEL ============== */
/* TCP_METRICS_CMD_DEL - do */
struct tcp_metrics_del_req {
	struct {
		__u32 addr_ipv4:1;
		__u32 addr_ipv6_len;
		__u32 saddr_ipv4:1;
		__u32 saddr_ipv6_len;
	} _present;

	__u32 addr_ipv4 /* big-endian */;
	void *addr_ipv6;
	__u32 saddr_ipv4 /* big-endian */;
	void *saddr_ipv6;
};

static inline struct tcp_metrics_del_req *tcp_metrics_del_req_alloc(void)
{
	return calloc(1, sizeof(struct tcp_metrics_del_req));
}
void tcp_metrics_del_req_free(struct tcp_metrics_del_req *req);

static inline void
tcp_metrics_del_req_set_addr_ipv4(struct tcp_metrics_del_req *req,
				  __u32 addr_ipv4 /* big-endian */)
{
	req->_present.addr_ipv4 = 1;
	req->addr_ipv4 = addr_ipv4;
}
static inline void
tcp_metrics_del_req_set_addr_ipv6(struct tcp_metrics_del_req *req,
				  const void *addr_ipv6, size_t len)
{
	free(req->addr_ipv6);
	req->_present.addr_ipv6_len = len;
	req->addr_ipv6 = malloc(req->_present.addr_ipv6_len);
	memcpy(req->addr_ipv6, addr_ipv6, req->_present.addr_ipv6_len);
}
static inline void
tcp_metrics_del_req_set_saddr_ipv4(struct tcp_metrics_del_req *req,
				   __u32 saddr_ipv4 /* big-endian */)
{
	req->_present.saddr_ipv4 = 1;
	req->saddr_ipv4 = saddr_ipv4;
}
static inline void
tcp_metrics_del_req_set_saddr_ipv6(struct tcp_metrics_del_req *req,
				   const void *saddr_ipv6, size_t len)
{
	free(req->saddr_ipv6);
	req->_present.saddr_ipv6_len = len;
	req->saddr_ipv6 = malloc(req->_present.saddr_ipv6_len);
	memcpy(req->saddr_ipv6, saddr_ipv6, req->_present.saddr_ipv6_len);
}

/*
 * Delete metrics.
 */
int tcp_metrics_del(struct ynl_sock *ys, struct tcp_metrics_del_req *req);

#endif /* _LINUX_TCP_METRICS_GEN_H */
