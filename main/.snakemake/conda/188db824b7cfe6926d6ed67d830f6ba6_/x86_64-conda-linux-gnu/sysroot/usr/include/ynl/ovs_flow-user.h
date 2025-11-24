/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
/* Do not edit directly, auto-generated from: */
/*	Documentation/netlink/specs/ovs_flow.yaml */
/* YNL-GEN user header */

#ifndef _LINUX_OVS_FLOW_GEN_H
#define _LINUX_OVS_FLOW_GEN_H

#include <stdlib.h>
#include <string.h>
#include <linux/types.h>
#include <linux/openvswitch.h>

struct ynl_sock;

extern const struct ynl_family ynl_ovs_flow_family;

/* Enums */
const char *ovs_flow_op_str(int op);
const char *ovs_flow_ovs_frag_type_str(enum ovs_frag_type value);
const char *ovs_flow_ovs_ufid_flags_str(int value);
const char *ovs_flow_ovs_hash_alg_str(enum ovs_hash_alg value);
const char *ovs_flow_ct_state_flags_str(int value);

/* Common nested types */
struct ovs_flow_ovs_nsh_key_attrs {
	struct {
		__u32 base_len;
		__u32 md1_len;
		__u32 md2_len;
	} _present;

	void *base;
	void *md1;
	void *md2;
};

struct ovs_flow_userspace_attrs {
	struct {
		__u32 pid:1;
		__u32 userdata_len;
		__u32 egress_tun_port:1;
		__u32 actions:1;
	} _present;

	__u32 pid;
	void *userdata;
	__u32 egress_tun_port;
};

struct ovs_flow_psample_attrs {
	struct {
		__u32 group:1;
		__u32 cookie_len;
	} _present;

	__u32 group;
	void *cookie;
};

struct ovs_flow_vxlan_ext_attrs {
	struct {
		__u32 gbp:1;
	} _present;

	__u32 gbp;
};

struct ovs_flow_nat_attrs {
	struct {
		__u32 src:1;
		__u32 dst:1;
		__u32 ip_min_len;
		__u32 ip_max_len;
		__u32 proto_min:1;
		__u32 proto_max:1;
		__u32 persistent:1;
		__u32 proto_hash:1;
		__u32 proto_random:1;
	} _present;

	void *ip_min;
	void *ip_max;
	__u16 proto_min;
	__u16 proto_max;
};

struct ovs_flow_tunnel_key_attrs {
	struct {
		__u32 id:1;
		__u32 ipv4_src:1;
		__u32 ipv4_dst:1;
		__u32 tos:1;
		__u32 ttl:1;
		__u32 dont_fragment:1;
		__u32 csum:1;
		__u32 oam:1;
		__u32 geneve_opts_len;
		__u32 tp_src:1;
		__u32 tp_dst:1;
		__u32 vxlan_opts:1;
		__u32 ipv6_src_len;
		__u32 ipv6_dst_len;
		__u32 pad_len;
		__u32 erspan_opts_len;
		__u32 ipv4_info_bridge:1;
	} _present;

	__u64 id /* big-endian */;
	__u32 ipv4_src /* big-endian */;
	__u32 ipv4_dst /* big-endian */;
	__u8 tos;
	__u8 ttl;
	void *geneve_opts;
	__u16 tp_src /* big-endian */;
	__u16 tp_dst /* big-endian */;
	struct ovs_flow_vxlan_ext_attrs vxlan_opts;
	void *ipv6_src;
	void *ipv6_dst;
	void *pad;
	void *erspan_opts;
};

struct ovs_flow_ct_attrs {
	struct {
		__u32 commit:1;
		__u32 zone:1;
		__u32 mark_len;
		__u32 labels_len;
		__u32 helper_len;
		__u32 nat:1;
		__u32 force_commit:1;
		__u32 eventmask:1;
		__u32 timeout_len;
	} _present;

	__u16 zone;
	void *mark;
	void *labels;
	char *helper;
	struct ovs_flow_nat_attrs nat;
	__u32 eventmask;
	char *timeout;
};

struct ovs_flow_key_attrs {
	struct {
		__u32 encap:1;
		__u32 priority:1;
		__u32 in_port:1;
		__u32 ethernet_len;
		__u32 vlan:1;
		__u32 ethertype:1;
		__u32 ipv4_len;
		__u32 ipv6_len;
		__u32 tcp_len;
		__u32 udp_len;
		__u32 icmp_len;
		__u32 icmpv6_len;
		__u32 arp_len;
		__u32 nd_len;
		__u32 skb_mark:1;
		__u32 tunnel:1;
		__u32 sctp_len;
		__u32 tcp_flags:1;
		__u32 dp_hash:1;
		__u32 recirc_id:1;
		__u32 mpls_len;
		__u32 ct_state:1;
		__u32 ct_zone:1;
		__u32 ct_mark:1;
		__u32 ct_labels_len;
		__u32 ct_orig_tuple_ipv4_len;
		__u32 ct_orig_tuple_ipv6_len;
		__u32 nsh:1;
		__u32 packet_type:1;
		__u32 nd_extensions_len;
		__u32 tunnel_info_len;
		__u32 ipv6_exthdrs_len;
	} _present;

	struct ovs_flow_key_attrs *encap;
	__u32 priority;
	__u32 in_port;
	void *ethernet;
	__u16 vlan /* big-endian */;
	__u16 ethertype /* big-endian */;
	void *ipv4;
	void *ipv6;
	void *tcp;
	void *udp;
	void *icmp;
	void *icmpv6;
	void *arp;
	void *nd;
	__u32 skb_mark;
	struct ovs_flow_tunnel_key_attrs tunnel;
	void *sctp;
	__u16 tcp_flags /* big-endian */;
	__u32 dp_hash;
	__u32 recirc_id;
	void *mpls;
	__u32 ct_state;
	__u16 ct_zone;
	__u32 ct_mark;
	void *ct_labels;
	void *ct_orig_tuple_ipv4;
	void *ct_orig_tuple_ipv6;
	struct ovs_flow_ovs_nsh_key_attrs nsh;
	__u32 packet_type /* big-endian */;
	void *nd_extensions;
	void *tunnel_info;
	void *ipv6_exthdrs;
};

struct ovs_flow_sample_attrs {
	struct {
		__u32 probability:1;
		__u32 actions:1;
	} _present;

	__u32 probability;
	struct ovs_flow_action_attrs *actions;
};

struct ovs_flow_check_pkt_len_attrs {
	struct {
		__u32 pkt_len:1;
		__u32 actions_if_greater:1;
		__u32 actions_if_less_equal:1;
	} _present;

	__u16 pkt_len;
	struct ovs_flow_action_attrs *actions_if_greater;
	struct ovs_flow_action_attrs *actions_if_less_equal;
};

struct ovs_flow_dec_ttl_attrs {
	struct {
		__u32 action:1;
	} _present;

	struct ovs_flow_action_attrs *action;
};

struct ovs_flow_action_attrs {
	struct {
		__u32 output:1;
		__u32 userspace:1;
		__u32 set:1;
		__u32 push_vlan_len;
		__u32 pop_vlan:1;
		__u32 sample:1;
		__u32 recirc:1;
		__u32 hash_len;
		__u32 push_mpls_len;
		__u32 pop_mpls:1;
		__u32 set_masked:1;
		__u32 ct:1;
		__u32 trunc:1;
		__u32 push_eth_len;
		__u32 pop_eth:1;
		__u32 ct_clear:1;
		__u32 push_nsh:1;
		__u32 pop_nsh:1;
		__u32 meter:1;
		__u32 clone:1;
		__u32 check_pkt_len:1;
		__u32 add_mpls_len;
		__u32 dec_ttl:1;
		__u32 psample:1;
	} _present;

	__u32 output;
	struct ovs_flow_userspace_attrs userspace;
	struct ovs_flow_key_attrs *set;
	void *push_vlan;
	struct ovs_flow_sample_attrs sample;
	__u32 recirc;
	void *hash;
	void *push_mpls;
	__u16 pop_mpls /* big-endian */;
	struct ovs_flow_key_attrs *set_masked;
	struct ovs_flow_ct_attrs ct;
	__u32 trunc;
	void *push_eth;
	struct ovs_flow_ovs_nsh_key_attrs push_nsh;
	__u32 meter;
	struct ovs_flow_action_attrs *clone;
	struct ovs_flow_check_pkt_len_attrs check_pkt_len;
	void *add_mpls;
	struct ovs_flow_dec_ttl_attrs dec_ttl;
	struct ovs_flow_psample_attrs psample;
};

/* ============== OVS_FLOW_CMD_GET ============== */
/* OVS_FLOW_CMD_GET - do */
struct ovs_flow_get_req {
	struct ovs_header _hdr;

	struct {
		__u32 key:1;
		__u32 ufid_len;
		__u32 ufid_flags:1;
	} _present;

	struct ovs_flow_key_attrs key;
	void *ufid;
	__u32 ufid_flags;
};

static inline struct ovs_flow_get_req *ovs_flow_get_req_alloc(void)
{
	return calloc(1, sizeof(struct ovs_flow_get_req));
}
void ovs_flow_get_req_free(struct ovs_flow_get_req *req);

static inline void
ovs_flow_get_req_set_key_priority(struct ovs_flow_get_req *req, __u32 priority)
{
	req->_present.key = 1;
	req->key._present.priority = 1;
	req->key.priority = priority;
}
static inline void
ovs_flow_get_req_set_key_in_port(struct ovs_flow_get_req *req, __u32 in_port)
{
	req->_present.key = 1;
	req->key._present.in_port = 1;
	req->key.in_port = in_port;
}
static inline void
ovs_flow_get_req_set_key_ethernet(struct ovs_flow_get_req *req,
				  const void *ethernet, size_t len)
{
	req->_present.key = 1;
	free(req->key.ethernet);
	req->key._present.ethernet_len = len;
	req->key.ethernet = malloc(req->key._present.ethernet_len);
	memcpy(req->key.ethernet, ethernet, req->key._present.ethernet_len);
}
static inline void
ovs_flow_get_req_set_key_vlan(struct ovs_flow_get_req *req,
			      __u16 vlan /* big-endian */)
{
	req->_present.key = 1;
	req->key._present.vlan = 1;
	req->key.vlan = vlan;
}
static inline void
ovs_flow_get_req_set_key_ethertype(struct ovs_flow_get_req *req,
				   __u16 ethertype /* big-endian */)
{
	req->_present.key = 1;
	req->key._present.ethertype = 1;
	req->key.ethertype = ethertype;
}
static inline void
ovs_flow_get_req_set_key_ipv4(struct ovs_flow_get_req *req, const void *ipv4,
			      size_t len)
{
	req->_present.key = 1;
	free(req->key.ipv4);
	req->key._present.ipv4_len = len;
	req->key.ipv4 = malloc(req->key._present.ipv4_len);
	memcpy(req->key.ipv4, ipv4, req->key._present.ipv4_len);
}
static inline void
ovs_flow_get_req_set_key_ipv6(struct ovs_flow_get_req *req, const void *ipv6,
			      size_t len)
{
	req->_present.key = 1;
	free(req->key.ipv6);
	req->key._present.ipv6_len = len;
	req->key.ipv6 = malloc(req->key._present.ipv6_len);
	memcpy(req->key.ipv6, ipv6, req->key._present.ipv6_len);
}
static inline void
ovs_flow_get_req_set_key_tcp(struct ovs_flow_get_req *req, const void *tcp,
			     size_t len)
{
	req->_present.key = 1;
	free(req->key.tcp);
	req->key._present.tcp_len = len;
	req->key.tcp = malloc(req->key._present.tcp_len);
	memcpy(req->key.tcp, tcp, req->key._present.tcp_len);
}
static inline void
ovs_flow_get_req_set_key_udp(struct ovs_flow_get_req *req, const void *udp,
			     size_t len)
{
	req->_present.key = 1;
	free(req->key.udp);
	req->key._present.udp_len = len;
	req->key.udp = malloc(req->key._present.udp_len);
	memcpy(req->key.udp, udp, req->key._present.udp_len);
}
static inline void
ovs_flow_get_req_set_key_icmp(struct ovs_flow_get_req *req, const void *icmp,
			      size_t len)
{
	req->_present.key = 1;
	free(req->key.icmp);
	req->key._present.icmp_len = len;
	req->key.icmp = malloc(req->key._present.icmp_len);
	memcpy(req->key.icmp, icmp, req->key._present.icmp_len);
}
static inline void
ovs_flow_get_req_set_key_icmpv6(struct ovs_flow_get_req *req,
				const void *icmpv6, size_t len)
{
	req->_present.key = 1;
	free(req->key.icmpv6);
	req->key._present.icmpv6_len = len;
	req->key.icmpv6 = malloc(req->key._present.icmpv6_len);
	memcpy(req->key.icmpv6, icmpv6, req->key._present.icmpv6_len);
}
static inline void
ovs_flow_get_req_set_key_arp(struct ovs_flow_get_req *req, const void *arp,
			     size_t len)
{
	req->_present.key = 1;
	free(req->key.arp);
	req->key._present.arp_len = len;
	req->key.arp = malloc(req->key._present.arp_len);
	memcpy(req->key.arp, arp, req->key._present.arp_len);
}
static inline void
ovs_flow_get_req_set_key_nd(struct ovs_flow_get_req *req, const void *nd,
			    size_t len)
{
	req->_present.key = 1;
	free(req->key.nd);
	req->key._present.nd_len = len;
	req->key.nd = malloc(req->key._present.nd_len);
	memcpy(req->key.nd, nd, req->key._present.nd_len);
}
static inline void
ovs_flow_get_req_set_key_skb_mark(struct ovs_flow_get_req *req, __u32 skb_mark)
{
	req->_present.key = 1;
	req->key._present.skb_mark = 1;
	req->key.skb_mark = skb_mark;
}
static inline void
ovs_flow_get_req_set_key_tunnel_id(struct ovs_flow_get_req *req,
				   __u64 id /* big-endian */)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	req->key.tunnel._present.id = 1;
	req->key.tunnel.id = id;
}
static inline void
ovs_flow_get_req_set_key_tunnel_ipv4_src(struct ovs_flow_get_req *req,
					 __u32 ipv4_src /* big-endian */)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	req->key.tunnel._present.ipv4_src = 1;
	req->key.tunnel.ipv4_src = ipv4_src;
}
static inline void
ovs_flow_get_req_set_key_tunnel_ipv4_dst(struct ovs_flow_get_req *req,
					 __u32 ipv4_dst /* big-endian */)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	req->key.tunnel._present.ipv4_dst = 1;
	req->key.tunnel.ipv4_dst = ipv4_dst;
}
static inline void
ovs_flow_get_req_set_key_tunnel_tos(struct ovs_flow_get_req *req, __u8 tos)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	req->key.tunnel._present.tos = 1;
	req->key.tunnel.tos = tos;
}
static inline void
ovs_flow_get_req_set_key_tunnel_ttl(struct ovs_flow_get_req *req, __u8 ttl)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	req->key.tunnel._present.ttl = 1;
	req->key.tunnel.ttl = ttl;
}
static inline void
ovs_flow_get_req_set_key_tunnel_dont_fragment(struct ovs_flow_get_req *req)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	req->key.tunnel._present.dont_fragment = 1;
}
static inline void
ovs_flow_get_req_set_key_tunnel_csum(struct ovs_flow_get_req *req)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	req->key.tunnel._present.csum = 1;
}
static inline void
ovs_flow_get_req_set_key_tunnel_oam(struct ovs_flow_get_req *req)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	req->key.tunnel._present.oam = 1;
}
static inline void
ovs_flow_get_req_set_key_tunnel_geneve_opts(struct ovs_flow_get_req *req,
					    const void *geneve_opts,
					    size_t len)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	free(req->key.tunnel.geneve_opts);
	req->key.tunnel._present.geneve_opts_len = len;
	req->key.tunnel.geneve_opts = malloc(req->key.tunnel._present.geneve_opts_len);
	memcpy(req->key.tunnel.geneve_opts, geneve_opts, req->key.tunnel._present.geneve_opts_len);
}
static inline void
ovs_flow_get_req_set_key_tunnel_tp_src(struct ovs_flow_get_req *req,
				       __u16 tp_src /* big-endian */)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	req->key.tunnel._present.tp_src = 1;
	req->key.tunnel.tp_src = tp_src;
}
static inline void
ovs_flow_get_req_set_key_tunnel_tp_dst(struct ovs_flow_get_req *req,
				       __u16 tp_dst /* big-endian */)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	req->key.tunnel._present.tp_dst = 1;
	req->key.tunnel.tp_dst = tp_dst;
}
static inline void
ovs_flow_get_req_set_key_tunnel_vxlan_opts_gbp(struct ovs_flow_get_req *req,
					       __u32 gbp)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	req->key.tunnel._present.vxlan_opts = 1;
	req->key.tunnel.vxlan_opts._present.gbp = 1;
	req->key.tunnel.vxlan_opts.gbp = gbp;
}
static inline void
ovs_flow_get_req_set_key_tunnel_ipv6_src(struct ovs_flow_get_req *req,
					 const void *ipv6_src, size_t len)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	free(req->key.tunnel.ipv6_src);
	req->key.tunnel._present.ipv6_src_len = len;
	req->key.tunnel.ipv6_src = malloc(req->key.tunnel._present.ipv6_src_len);
	memcpy(req->key.tunnel.ipv6_src, ipv6_src, req->key.tunnel._present.ipv6_src_len);
}
static inline void
ovs_flow_get_req_set_key_tunnel_ipv6_dst(struct ovs_flow_get_req *req,
					 const void *ipv6_dst, size_t len)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	free(req->key.tunnel.ipv6_dst);
	req->key.tunnel._present.ipv6_dst_len = len;
	req->key.tunnel.ipv6_dst = malloc(req->key.tunnel._present.ipv6_dst_len);
	memcpy(req->key.tunnel.ipv6_dst, ipv6_dst, req->key.tunnel._present.ipv6_dst_len);
}
static inline void
ovs_flow_get_req_set_key_tunnel_pad(struct ovs_flow_get_req *req,
				    const void *pad, size_t len)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	free(req->key.tunnel.pad);
	req->key.tunnel._present.pad_len = len;
	req->key.tunnel.pad = malloc(req->key.tunnel._present.pad_len);
	memcpy(req->key.tunnel.pad, pad, req->key.tunnel._present.pad_len);
}
static inline void
ovs_flow_get_req_set_key_tunnel_erspan_opts(struct ovs_flow_get_req *req,
					    const void *erspan_opts,
					    size_t len)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	free(req->key.tunnel.erspan_opts);
	req->key.tunnel._present.erspan_opts_len = len;
	req->key.tunnel.erspan_opts = malloc(req->key.tunnel._present.erspan_opts_len);
	memcpy(req->key.tunnel.erspan_opts, erspan_opts, req->key.tunnel._present.erspan_opts_len);
}
static inline void
ovs_flow_get_req_set_key_tunnel_ipv4_info_bridge(struct ovs_flow_get_req *req)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	req->key.tunnel._present.ipv4_info_bridge = 1;
}
static inline void
ovs_flow_get_req_set_key_sctp(struct ovs_flow_get_req *req, const void *sctp,
			      size_t len)
{
	req->_present.key = 1;
	free(req->key.sctp);
	req->key._present.sctp_len = len;
	req->key.sctp = malloc(req->key._present.sctp_len);
	memcpy(req->key.sctp, sctp, req->key._present.sctp_len);
}
static inline void
ovs_flow_get_req_set_key_tcp_flags(struct ovs_flow_get_req *req,
				   __u16 tcp_flags /* big-endian */)
{
	req->_present.key = 1;
	req->key._present.tcp_flags = 1;
	req->key.tcp_flags = tcp_flags;
}
static inline void
ovs_flow_get_req_set_key_dp_hash(struct ovs_flow_get_req *req, __u32 dp_hash)
{
	req->_present.key = 1;
	req->key._present.dp_hash = 1;
	req->key.dp_hash = dp_hash;
}
static inline void
ovs_flow_get_req_set_key_recirc_id(struct ovs_flow_get_req *req,
				   __u32 recirc_id)
{
	req->_present.key = 1;
	req->key._present.recirc_id = 1;
	req->key.recirc_id = recirc_id;
}
static inline void
ovs_flow_get_req_set_key_mpls(struct ovs_flow_get_req *req, const void *mpls,
			      size_t len)
{
	req->_present.key = 1;
	free(req->key.mpls);
	req->key._present.mpls_len = len;
	req->key.mpls = malloc(req->key._present.mpls_len);
	memcpy(req->key.mpls, mpls, req->key._present.mpls_len);
}
static inline void
ovs_flow_get_req_set_key_ct_state(struct ovs_flow_get_req *req, __u32 ct_state)
{
	req->_present.key = 1;
	req->key._present.ct_state = 1;
	req->key.ct_state = ct_state;
}
static inline void
ovs_flow_get_req_set_key_ct_zone(struct ovs_flow_get_req *req, __u16 ct_zone)
{
	req->_present.key = 1;
	req->key._present.ct_zone = 1;
	req->key.ct_zone = ct_zone;
}
static inline void
ovs_flow_get_req_set_key_ct_mark(struct ovs_flow_get_req *req, __u32 ct_mark)
{
	req->_present.key = 1;
	req->key._present.ct_mark = 1;
	req->key.ct_mark = ct_mark;
}
static inline void
ovs_flow_get_req_set_key_ct_labels(struct ovs_flow_get_req *req,
				   const void *ct_labels, size_t len)
{
	req->_present.key = 1;
	free(req->key.ct_labels);
	req->key._present.ct_labels_len = len;
	req->key.ct_labels = malloc(req->key._present.ct_labels_len);
	memcpy(req->key.ct_labels, ct_labels, req->key._present.ct_labels_len);
}
static inline void
ovs_flow_get_req_set_key_ct_orig_tuple_ipv4(struct ovs_flow_get_req *req,
					    const void *ct_orig_tuple_ipv4,
					    size_t len)
{
	req->_present.key = 1;
	free(req->key.ct_orig_tuple_ipv4);
	req->key._present.ct_orig_tuple_ipv4_len = len;
	req->key.ct_orig_tuple_ipv4 = malloc(req->key._present.ct_orig_tuple_ipv4_len);
	memcpy(req->key.ct_orig_tuple_ipv4, ct_orig_tuple_ipv4, req->key._present.ct_orig_tuple_ipv4_len);
}
static inline void
ovs_flow_get_req_set_key_ct_orig_tuple_ipv6(struct ovs_flow_get_req *req,
					    const void *ct_orig_tuple_ipv6,
					    size_t len)
{
	req->_present.key = 1;
	free(req->key.ct_orig_tuple_ipv6);
	req->key._present.ct_orig_tuple_ipv6_len = len;
	req->key.ct_orig_tuple_ipv6 = malloc(req->key._present.ct_orig_tuple_ipv6_len);
	memcpy(req->key.ct_orig_tuple_ipv6, ct_orig_tuple_ipv6, req->key._present.ct_orig_tuple_ipv6_len);
}
static inline void
ovs_flow_get_req_set_key_nsh_base(struct ovs_flow_get_req *req,
				  const void *base, size_t len)
{
	req->_present.key = 1;
	req->key._present.nsh = 1;
	free(req->key.nsh.base);
	req->key.nsh._present.base_len = len;
	req->key.nsh.base = malloc(req->key.nsh._present.base_len);
	memcpy(req->key.nsh.base, base, req->key.nsh._present.base_len);
}
static inline void
ovs_flow_get_req_set_key_nsh_md1(struct ovs_flow_get_req *req, const void *md1,
				 size_t len)
{
	req->_present.key = 1;
	req->key._present.nsh = 1;
	free(req->key.nsh.md1);
	req->key.nsh._present.md1_len = len;
	req->key.nsh.md1 = malloc(req->key.nsh._present.md1_len);
	memcpy(req->key.nsh.md1, md1, req->key.nsh._present.md1_len);
}
static inline void
ovs_flow_get_req_set_key_nsh_md2(struct ovs_flow_get_req *req, const void *md2,
				 size_t len)
{
	req->_present.key = 1;
	req->key._present.nsh = 1;
	free(req->key.nsh.md2);
	req->key.nsh._present.md2_len = len;
	req->key.nsh.md2 = malloc(req->key.nsh._present.md2_len);
	memcpy(req->key.nsh.md2, md2, req->key.nsh._present.md2_len);
}
static inline void
ovs_flow_get_req_set_key_packet_type(struct ovs_flow_get_req *req,
				     __u32 packet_type /* big-endian */)
{
	req->_present.key = 1;
	req->key._present.packet_type = 1;
	req->key.packet_type = packet_type;
}
static inline void
ovs_flow_get_req_set_key_nd_extensions(struct ovs_flow_get_req *req,
				       const void *nd_extensions, size_t len)
{
	req->_present.key = 1;
	free(req->key.nd_extensions);
	req->key._present.nd_extensions_len = len;
	req->key.nd_extensions = malloc(req->key._present.nd_extensions_len);
	memcpy(req->key.nd_extensions, nd_extensions, req->key._present.nd_extensions_len);
}
static inline void
ovs_flow_get_req_set_key_tunnel_info(struct ovs_flow_get_req *req,
				     const void *tunnel_info, size_t len)
{
	req->_present.key = 1;
	free(req->key.tunnel_info);
	req->key._present.tunnel_info_len = len;
	req->key.tunnel_info = malloc(req->key._present.tunnel_info_len);
	memcpy(req->key.tunnel_info, tunnel_info, req->key._present.tunnel_info_len);
}
static inline void
ovs_flow_get_req_set_key_ipv6_exthdrs(struct ovs_flow_get_req *req,
				      const void *ipv6_exthdrs, size_t len)
{
	req->_present.key = 1;
	free(req->key.ipv6_exthdrs);
	req->key._present.ipv6_exthdrs_len = len;
	req->key.ipv6_exthdrs = malloc(req->key._present.ipv6_exthdrs_len);
	memcpy(req->key.ipv6_exthdrs, ipv6_exthdrs, req->key._present.ipv6_exthdrs_len);
}
static inline void
ovs_flow_get_req_set_ufid(struct ovs_flow_get_req *req, const void *ufid,
			  size_t len)
{
	free(req->ufid);
	req->_present.ufid_len = len;
	req->ufid = malloc(req->_present.ufid_len);
	memcpy(req->ufid, ufid, req->_present.ufid_len);
}
static inline void
ovs_flow_get_req_set_ufid_flags(struct ovs_flow_get_req *req, __u32 ufid_flags)
{
	req->_present.ufid_flags = 1;
	req->ufid_flags = ufid_flags;
}

struct ovs_flow_get_rsp {
	struct ovs_header _hdr;

	struct {
		__u32 key:1;
		__u32 ufid_len;
		__u32 mask:1;
		__u32 stats_len;
		__u32 actions:1;
	} _present;

	struct ovs_flow_key_attrs key;
	void *ufid;
	struct ovs_flow_key_attrs mask;
	void *stats;
	struct ovs_flow_action_attrs actions;
};

void ovs_flow_get_rsp_free(struct ovs_flow_get_rsp *rsp);

/*
 * Get / dump OVS flow configuration and state
 */
struct ovs_flow_get_rsp *
ovs_flow_get(struct ynl_sock *ys, struct ovs_flow_get_req *req);

/* OVS_FLOW_CMD_GET - dump */
struct ovs_flow_get_req_dump {
	struct ovs_header _hdr;

	struct {
		__u32 key:1;
		__u32 ufid_len;
		__u32 ufid_flags:1;
	} _present;

	struct ovs_flow_key_attrs key;
	void *ufid;
	__u32 ufid_flags;
};

static inline struct ovs_flow_get_req_dump *ovs_flow_get_req_dump_alloc(void)
{
	return calloc(1, sizeof(struct ovs_flow_get_req_dump));
}
void ovs_flow_get_req_dump_free(struct ovs_flow_get_req_dump *req);

static inline void
ovs_flow_get_req_dump_set_key_priority(struct ovs_flow_get_req_dump *req,
				       __u32 priority)
{
	req->_present.key = 1;
	req->key._present.priority = 1;
	req->key.priority = priority;
}
static inline void
ovs_flow_get_req_dump_set_key_in_port(struct ovs_flow_get_req_dump *req,
				      __u32 in_port)
{
	req->_present.key = 1;
	req->key._present.in_port = 1;
	req->key.in_port = in_port;
}
static inline void
ovs_flow_get_req_dump_set_key_ethernet(struct ovs_flow_get_req_dump *req,
				       const void *ethernet, size_t len)
{
	req->_present.key = 1;
	free(req->key.ethernet);
	req->key._present.ethernet_len = len;
	req->key.ethernet = malloc(req->key._present.ethernet_len);
	memcpy(req->key.ethernet, ethernet, req->key._present.ethernet_len);
}
static inline void
ovs_flow_get_req_dump_set_key_vlan(struct ovs_flow_get_req_dump *req,
				   __u16 vlan /* big-endian */)
{
	req->_present.key = 1;
	req->key._present.vlan = 1;
	req->key.vlan = vlan;
}
static inline void
ovs_flow_get_req_dump_set_key_ethertype(struct ovs_flow_get_req_dump *req,
					__u16 ethertype /* big-endian */)
{
	req->_present.key = 1;
	req->key._present.ethertype = 1;
	req->key.ethertype = ethertype;
}
static inline void
ovs_flow_get_req_dump_set_key_ipv4(struct ovs_flow_get_req_dump *req,
				   const void *ipv4, size_t len)
{
	req->_present.key = 1;
	free(req->key.ipv4);
	req->key._present.ipv4_len = len;
	req->key.ipv4 = malloc(req->key._present.ipv4_len);
	memcpy(req->key.ipv4, ipv4, req->key._present.ipv4_len);
}
static inline void
ovs_flow_get_req_dump_set_key_ipv6(struct ovs_flow_get_req_dump *req,
				   const void *ipv6, size_t len)
{
	req->_present.key = 1;
	free(req->key.ipv6);
	req->key._present.ipv6_len = len;
	req->key.ipv6 = malloc(req->key._present.ipv6_len);
	memcpy(req->key.ipv6, ipv6, req->key._present.ipv6_len);
}
static inline void
ovs_flow_get_req_dump_set_key_tcp(struct ovs_flow_get_req_dump *req,
				  const void *tcp, size_t len)
{
	req->_present.key = 1;
	free(req->key.tcp);
	req->key._present.tcp_len = len;
	req->key.tcp = malloc(req->key._present.tcp_len);
	memcpy(req->key.tcp, tcp, req->key._present.tcp_len);
}
static inline void
ovs_flow_get_req_dump_set_key_udp(struct ovs_flow_get_req_dump *req,
				  const void *udp, size_t len)
{
	req->_present.key = 1;
	free(req->key.udp);
	req->key._present.udp_len = len;
	req->key.udp = malloc(req->key._present.udp_len);
	memcpy(req->key.udp, udp, req->key._present.udp_len);
}
static inline void
ovs_flow_get_req_dump_set_key_icmp(struct ovs_flow_get_req_dump *req,
				   const void *icmp, size_t len)
{
	req->_present.key = 1;
	free(req->key.icmp);
	req->key._present.icmp_len = len;
	req->key.icmp = malloc(req->key._present.icmp_len);
	memcpy(req->key.icmp, icmp, req->key._present.icmp_len);
}
static inline void
ovs_flow_get_req_dump_set_key_icmpv6(struct ovs_flow_get_req_dump *req,
				     const void *icmpv6, size_t len)
{
	req->_present.key = 1;
	free(req->key.icmpv6);
	req->key._present.icmpv6_len = len;
	req->key.icmpv6 = malloc(req->key._present.icmpv6_len);
	memcpy(req->key.icmpv6, icmpv6, req->key._present.icmpv6_len);
}
static inline void
ovs_flow_get_req_dump_set_key_arp(struct ovs_flow_get_req_dump *req,
				  const void *arp, size_t len)
{
	req->_present.key = 1;
	free(req->key.arp);
	req->key._present.arp_len = len;
	req->key.arp = malloc(req->key._present.arp_len);
	memcpy(req->key.arp, arp, req->key._present.arp_len);
}
static inline void
ovs_flow_get_req_dump_set_key_nd(struct ovs_flow_get_req_dump *req,
				 const void *nd, size_t len)
{
	req->_present.key = 1;
	free(req->key.nd);
	req->key._present.nd_len = len;
	req->key.nd = malloc(req->key._present.nd_len);
	memcpy(req->key.nd, nd, req->key._present.nd_len);
}
static inline void
ovs_flow_get_req_dump_set_key_skb_mark(struct ovs_flow_get_req_dump *req,
				       __u32 skb_mark)
{
	req->_present.key = 1;
	req->key._present.skb_mark = 1;
	req->key.skb_mark = skb_mark;
}
static inline void
ovs_flow_get_req_dump_set_key_tunnel_id(struct ovs_flow_get_req_dump *req,
					__u64 id /* big-endian */)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	req->key.tunnel._present.id = 1;
	req->key.tunnel.id = id;
}
static inline void
ovs_flow_get_req_dump_set_key_tunnel_ipv4_src(struct ovs_flow_get_req_dump *req,
					      __u32 ipv4_src /* big-endian */)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	req->key.tunnel._present.ipv4_src = 1;
	req->key.tunnel.ipv4_src = ipv4_src;
}
static inline void
ovs_flow_get_req_dump_set_key_tunnel_ipv4_dst(struct ovs_flow_get_req_dump *req,
					      __u32 ipv4_dst /* big-endian */)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	req->key.tunnel._present.ipv4_dst = 1;
	req->key.tunnel.ipv4_dst = ipv4_dst;
}
static inline void
ovs_flow_get_req_dump_set_key_tunnel_tos(struct ovs_flow_get_req_dump *req,
					 __u8 tos)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	req->key.tunnel._present.tos = 1;
	req->key.tunnel.tos = tos;
}
static inline void
ovs_flow_get_req_dump_set_key_tunnel_ttl(struct ovs_flow_get_req_dump *req,
					 __u8 ttl)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	req->key.tunnel._present.ttl = 1;
	req->key.tunnel.ttl = ttl;
}
static inline void
ovs_flow_get_req_dump_set_key_tunnel_dont_fragment(struct ovs_flow_get_req_dump *req)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	req->key.tunnel._present.dont_fragment = 1;
}
static inline void
ovs_flow_get_req_dump_set_key_tunnel_csum(struct ovs_flow_get_req_dump *req)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	req->key.tunnel._present.csum = 1;
}
static inline void
ovs_flow_get_req_dump_set_key_tunnel_oam(struct ovs_flow_get_req_dump *req)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	req->key.tunnel._present.oam = 1;
}
static inline void
ovs_flow_get_req_dump_set_key_tunnel_geneve_opts(struct ovs_flow_get_req_dump *req,
						 const void *geneve_opts,
						 size_t len)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	free(req->key.tunnel.geneve_opts);
	req->key.tunnel._present.geneve_opts_len = len;
	req->key.tunnel.geneve_opts = malloc(req->key.tunnel._present.geneve_opts_len);
	memcpy(req->key.tunnel.geneve_opts, geneve_opts, req->key.tunnel._present.geneve_opts_len);
}
static inline void
ovs_flow_get_req_dump_set_key_tunnel_tp_src(struct ovs_flow_get_req_dump *req,
					    __u16 tp_src /* big-endian */)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	req->key.tunnel._present.tp_src = 1;
	req->key.tunnel.tp_src = tp_src;
}
static inline void
ovs_flow_get_req_dump_set_key_tunnel_tp_dst(struct ovs_flow_get_req_dump *req,
					    __u16 tp_dst /* big-endian */)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	req->key.tunnel._present.tp_dst = 1;
	req->key.tunnel.tp_dst = tp_dst;
}
static inline void
ovs_flow_get_req_dump_set_key_tunnel_vxlan_opts_gbp(struct ovs_flow_get_req_dump *req,
						    __u32 gbp)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	req->key.tunnel._present.vxlan_opts = 1;
	req->key.tunnel.vxlan_opts._present.gbp = 1;
	req->key.tunnel.vxlan_opts.gbp = gbp;
}
static inline void
ovs_flow_get_req_dump_set_key_tunnel_ipv6_src(struct ovs_flow_get_req_dump *req,
					      const void *ipv6_src, size_t len)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	free(req->key.tunnel.ipv6_src);
	req->key.tunnel._present.ipv6_src_len = len;
	req->key.tunnel.ipv6_src = malloc(req->key.tunnel._present.ipv6_src_len);
	memcpy(req->key.tunnel.ipv6_src, ipv6_src, req->key.tunnel._present.ipv6_src_len);
}
static inline void
ovs_flow_get_req_dump_set_key_tunnel_ipv6_dst(struct ovs_flow_get_req_dump *req,
					      const void *ipv6_dst, size_t len)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	free(req->key.tunnel.ipv6_dst);
	req->key.tunnel._present.ipv6_dst_len = len;
	req->key.tunnel.ipv6_dst = malloc(req->key.tunnel._present.ipv6_dst_len);
	memcpy(req->key.tunnel.ipv6_dst, ipv6_dst, req->key.tunnel._present.ipv6_dst_len);
}
static inline void
ovs_flow_get_req_dump_set_key_tunnel_pad(struct ovs_flow_get_req_dump *req,
					 const void *pad, size_t len)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	free(req->key.tunnel.pad);
	req->key.tunnel._present.pad_len = len;
	req->key.tunnel.pad = malloc(req->key.tunnel._present.pad_len);
	memcpy(req->key.tunnel.pad, pad, req->key.tunnel._present.pad_len);
}
static inline void
ovs_flow_get_req_dump_set_key_tunnel_erspan_opts(struct ovs_flow_get_req_dump *req,
						 const void *erspan_opts,
						 size_t len)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	free(req->key.tunnel.erspan_opts);
	req->key.tunnel._present.erspan_opts_len = len;
	req->key.tunnel.erspan_opts = malloc(req->key.tunnel._present.erspan_opts_len);
	memcpy(req->key.tunnel.erspan_opts, erspan_opts, req->key.tunnel._present.erspan_opts_len);
}
static inline void
ovs_flow_get_req_dump_set_key_tunnel_ipv4_info_bridge(struct ovs_flow_get_req_dump *req)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	req->key.tunnel._present.ipv4_info_bridge = 1;
}
static inline void
ovs_flow_get_req_dump_set_key_sctp(struct ovs_flow_get_req_dump *req,
				   const void *sctp, size_t len)
{
	req->_present.key = 1;
	free(req->key.sctp);
	req->key._present.sctp_len = len;
	req->key.sctp = malloc(req->key._present.sctp_len);
	memcpy(req->key.sctp, sctp, req->key._present.sctp_len);
}
static inline void
ovs_flow_get_req_dump_set_key_tcp_flags(struct ovs_flow_get_req_dump *req,
					__u16 tcp_flags /* big-endian */)
{
	req->_present.key = 1;
	req->key._present.tcp_flags = 1;
	req->key.tcp_flags = tcp_flags;
}
static inline void
ovs_flow_get_req_dump_set_key_dp_hash(struct ovs_flow_get_req_dump *req,
				      __u32 dp_hash)
{
	req->_present.key = 1;
	req->key._present.dp_hash = 1;
	req->key.dp_hash = dp_hash;
}
static inline void
ovs_flow_get_req_dump_set_key_recirc_id(struct ovs_flow_get_req_dump *req,
					__u32 recirc_id)
{
	req->_present.key = 1;
	req->key._present.recirc_id = 1;
	req->key.recirc_id = recirc_id;
}
static inline void
ovs_flow_get_req_dump_set_key_mpls(struct ovs_flow_get_req_dump *req,
				   const void *mpls, size_t len)
{
	req->_present.key = 1;
	free(req->key.mpls);
	req->key._present.mpls_len = len;
	req->key.mpls = malloc(req->key._present.mpls_len);
	memcpy(req->key.mpls, mpls, req->key._present.mpls_len);
}
static inline void
ovs_flow_get_req_dump_set_key_ct_state(struct ovs_flow_get_req_dump *req,
				       __u32 ct_state)
{
	req->_present.key = 1;
	req->key._present.ct_state = 1;
	req->key.ct_state = ct_state;
}
static inline void
ovs_flow_get_req_dump_set_key_ct_zone(struct ovs_flow_get_req_dump *req,
				      __u16 ct_zone)
{
	req->_present.key = 1;
	req->key._present.ct_zone = 1;
	req->key.ct_zone = ct_zone;
}
static inline void
ovs_flow_get_req_dump_set_key_ct_mark(struct ovs_flow_get_req_dump *req,
				      __u32 ct_mark)
{
	req->_present.key = 1;
	req->key._present.ct_mark = 1;
	req->key.ct_mark = ct_mark;
}
static inline void
ovs_flow_get_req_dump_set_key_ct_labels(struct ovs_flow_get_req_dump *req,
					const void *ct_labels, size_t len)
{
	req->_present.key = 1;
	free(req->key.ct_labels);
	req->key._present.ct_labels_len = len;
	req->key.ct_labels = malloc(req->key._present.ct_labels_len);
	memcpy(req->key.ct_labels, ct_labels, req->key._present.ct_labels_len);
}
static inline void
ovs_flow_get_req_dump_set_key_ct_orig_tuple_ipv4(struct ovs_flow_get_req_dump *req,
						 const void *ct_orig_tuple_ipv4,
						 size_t len)
{
	req->_present.key = 1;
	free(req->key.ct_orig_tuple_ipv4);
	req->key._present.ct_orig_tuple_ipv4_len = len;
	req->key.ct_orig_tuple_ipv4 = malloc(req->key._present.ct_orig_tuple_ipv4_len);
	memcpy(req->key.ct_orig_tuple_ipv4, ct_orig_tuple_ipv4, req->key._present.ct_orig_tuple_ipv4_len);
}
static inline void
ovs_flow_get_req_dump_set_key_ct_orig_tuple_ipv6(struct ovs_flow_get_req_dump *req,
						 const void *ct_orig_tuple_ipv6,
						 size_t len)
{
	req->_present.key = 1;
	free(req->key.ct_orig_tuple_ipv6);
	req->key._present.ct_orig_tuple_ipv6_len = len;
	req->key.ct_orig_tuple_ipv6 = malloc(req->key._present.ct_orig_tuple_ipv6_len);
	memcpy(req->key.ct_orig_tuple_ipv6, ct_orig_tuple_ipv6, req->key._present.ct_orig_tuple_ipv6_len);
}
static inline void
ovs_flow_get_req_dump_set_key_nsh_base(struct ovs_flow_get_req_dump *req,
				       const void *base, size_t len)
{
	req->_present.key = 1;
	req->key._present.nsh = 1;
	free(req->key.nsh.base);
	req->key.nsh._present.base_len = len;
	req->key.nsh.base = malloc(req->key.nsh._present.base_len);
	memcpy(req->key.nsh.base, base, req->key.nsh._present.base_len);
}
static inline void
ovs_flow_get_req_dump_set_key_nsh_md1(struct ovs_flow_get_req_dump *req,
				      const void *md1, size_t len)
{
	req->_present.key = 1;
	req->key._present.nsh = 1;
	free(req->key.nsh.md1);
	req->key.nsh._present.md1_len = len;
	req->key.nsh.md1 = malloc(req->key.nsh._present.md1_len);
	memcpy(req->key.nsh.md1, md1, req->key.nsh._present.md1_len);
}
static inline void
ovs_flow_get_req_dump_set_key_nsh_md2(struct ovs_flow_get_req_dump *req,
				      const void *md2, size_t len)
{
	req->_present.key = 1;
	req->key._present.nsh = 1;
	free(req->key.nsh.md2);
	req->key.nsh._present.md2_len = len;
	req->key.nsh.md2 = malloc(req->key.nsh._present.md2_len);
	memcpy(req->key.nsh.md2, md2, req->key.nsh._present.md2_len);
}
static inline void
ovs_flow_get_req_dump_set_key_packet_type(struct ovs_flow_get_req_dump *req,
					  __u32 packet_type /* big-endian */)
{
	req->_present.key = 1;
	req->key._present.packet_type = 1;
	req->key.packet_type = packet_type;
}
static inline void
ovs_flow_get_req_dump_set_key_nd_extensions(struct ovs_flow_get_req_dump *req,
					    const void *nd_extensions,
					    size_t len)
{
	req->_present.key = 1;
	free(req->key.nd_extensions);
	req->key._present.nd_extensions_len = len;
	req->key.nd_extensions = malloc(req->key._present.nd_extensions_len);
	memcpy(req->key.nd_extensions, nd_extensions, req->key._present.nd_extensions_len);
}
static inline void
ovs_flow_get_req_dump_set_key_tunnel_info(struct ovs_flow_get_req_dump *req,
					  const void *tunnel_info, size_t len)
{
	req->_present.key = 1;
	free(req->key.tunnel_info);
	req->key._present.tunnel_info_len = len;
	req->key.tunnel_info = malloc(req->key._present.tunnel_info_len);
	memcpy(req->key.tunnel_info, tunnel_info, req->key._present.tunnel_info_len);
}
static inline void
ovs_flow_get_req_dump_set_key_ipv6_exthdrs(struct ovs_flow_get_req_dump *req,
					   const void *ipv6_exthdrs,
					   size_t len)
{
	req->_present.key = 1;
	free(req->key.ipv6_exthdrs);
	req->key._present.ipv6_exthdrs_len = len;
	req->key.ipv6_exthdrs = malloc(req->key._present.ipv6_exthdrs_len);
	memcpy(req->key.ipv6_exthdrs, ipv6_exthdrs, req->key._present.ipv6_exthdrs_len);
}
static inline void
ovs_flow_get_req_dump_set_ufid(struct ovs_flow_get_req_dump *req,
			       const void *ufid, size_t len)
{
	free(req->ufid);
	req->_present.ufid_len = len;
	req->ufid = malloc(req->_present.ufid_len);
	memcpy(req->ufid, ufid, req->_present.ufid_len);
}
static inline void
ovs_flow_get_req_dump_set_ufid_flags(struct ovs_flow_get_req_dump *req,
				     __u32 ufid_flags)
{
	req->_present.ufid_flags = 1;
	req->ufid_flags = ufid_flags;
}

struct ovs_flow_get_list {
	struct ovs_flow_get_list *next;
	struct ovs_flow_get_rsp obj __attribute__((aligned(8)));
};

void ovs_flow_get_list_free(struct ovs_flow_get_list *rsp);

struct ovs_flow_get_list *
ovs_flow_get_dump(struct ynl_sock *ys, struct ovs_flow_get_req_dump *req);

/* ============== OVS_FLOW_CMD_NEW ============== */
/* OVS_FLOW_CMD_NEW - do */
struct ovs_flow_new_req {
	struct ovs_header _hdr;

	struct {
		__u32 key:1;
		__u32 ufid_len;
		__u32 mask:1;
		__u32 actions:1;
	} _present;

	struct ovs_flow_key_attrs key;
	void *ufid;
	struct ovs_flow_key_attrs mask;
	struct ovs_flow_action_attrs actions;
};

static inline struct ovs_flow_new_req *ovs_flow_new_req_alloc(void)
{
	return calloc(1, sizeof(struct ovs_flow_new_req));
}
void ovs_flow_new_req_free(struct ovs_flow_new_req *req);

static inline void
ovs_flow_new_req_set_key_priority(struct ovs_flow_new_req *req, __u32 priority)
{
	req->_present.key = 1;
	req->key._present.priority = 1;
	req->key.priority = priority;
}
static inline void
ovs_flow_new_req_set_key_in_port(struct ovs_flow_new_req *req, __u32 in_port)
{
	req->_present.key = 1;
	req->key._present.in_port = 1;
	req->key.in_port = in_port;
}
static inline void
ovs_flow_new_req_set_key_ethernet(struct ovs_flow_new_req *req,
				  const void *ethernet, size_t len)
{
	req->_present.key = 1;
	free(req->key.ethernet);
	req->key._present.ethernet_len = len;
	req->key.ethernet = malloc(req->key._present.ethernet_len);
	memcpy(req->key.ethernet, ethernet, req->key._present.ethernet_len);
}
static inline void
ovs_flow_new_req_set_key_vlan(struct ovs_flow_new_req *req,
			      __u16 vlan /* big-endian */)
{
	req->_present.key = 1;
	req->key._present.vlan = 1;
	req->key.vlan = vlan;
}
static inline void
ovs_flow_new_req_set_key_ethertype(struct ovs_flow_new_req *req,
				   __u16 ethertype /* big-endian */)
{
	req->_present.key = 1;
	req->key._present.ethertype = 1;
	req->key.ethertype = ethertype;
}
static inline void
ovs_flow_new_req_set_key_ipv4(struct ovs_flow_new_req *req, const void *ipv4,
			      size_t len)
{
	req->_present.key = 1;
	free(req->key.ipv4);
	req->key._present.ipv4_len = len;
	req->key.ipv4 = malloc(req->key._present.ipv4_len);
	memcpy(req->key.ipv4, ipv4, req->key._present.ipv4_len);
}
static inline void
ovs_flow_new_req_set_key_ipv6(struct ovs_flow_new_req *req, const void *ipv6,
			      size_t len)
{
	req->_present.key = 1;
	free(req->key.ipv6);
	req->key._present.ipv6_len = len;
	req->key.ipv6 = malloc(req->key._present.ipv6_len);
	memcpy(req->key.ipv6, ipv6, req->key._present.ipv6_len);
}
static inline void
ovs_flow_new_req_set_key_tcp(struct ovs_flow_new_req *req, const void *tcp,
			     size_t len)
{
	req->_present.key = 1;
	free(req->key.tcp);
	req->key._present.tcp_len = len;
	req->key.tcp = malloc(req->key._present.tcp_len);
	memcpy(req->key.tcp, tcp, req->key._present.tcp_len);
}
static inline void
ovs_flow_new_req_set_key_udp(struct ovs_flow_new_req *req, const void *udp,
			     size_t len)
{
	req->_present.key = 1;
	free(req->key.udp);
	req->key._present.udp_len = len;
	req->key.udp = malloc(req->key._present.udp_len);
	memcpy(req->key.udp, udp, req->key._present.udp_len);
}
static inline void
ovs_flow_new_req_set_key_icmp(struct ovs_flow_new_req *req, const void *icmp,
			      size_t len)
{
	req->_present.key = 1;
	free(req->key.icmp);
	req->key._present.icmp_len = len;
	req->key.icmp = malloc(req->key._present.icmp_len);
	memcpy(req->key.icmp, icmp, req->key._present.icmp_len);
}
static inline void
ovs_flow_new_req_set_key_icmpv6(struct ovs_flow_new_req *req,
				const void *icmpv6, size_t len)
{
	req->_present.key = 1;
	free(req->key.icmpv6);
	req->key._present.icmpv6_len = len;
	req->key.icmpv6 = malloc(req->key._present.icmpv6_len);
	memcpy(req->key.icmpv6, icmpv6, req->key._present.icmpv6_len);
}
static inline void
ovs_flow_new_req_set_key_arp(struct ovs_flow_new_req *req, const void *arp,
			     size_t len)
{
	req->_present.key = 1;
	free(req->key.arp);
	req->key._present.arp_len = len;
	req->key.arp = malloc(req->key._present.arp_len);
	memcpy(req->key.arp, arp, req->key._present.arp_len);
}
static inline void
ovs_flow_new_req_set_key_nd(struct ovs_flow_new_req *req, const void *nd,
			    size_t len)
{
	req->_present.key = 1;
	free(req->key.nd);
	req->key._present.nd_len = len;
	req->key.nd = malloc(req->key._present.nd_len);
	memcpy(req->key.nd, nd, req->key._present.nd_len);
}
static inline void
ovs_flow_new_req_set_key_skb_mark(struct ovs_flow_new_req *req, __u32 skb_mark)
{
	req->_present.key = 1;
	req->key._present.skb_mark = 1;
	req->key.skb_mark = skb_mark;
}
static inline void
ovs_flow_new_req_set_key_tunnel_id(struct ovs_flow_new_req *req,
				   __u64 id /* big-endian */)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	req->key.tunnel._present.id = 1;
	req->key.tunnel.id = id;
}
static inline void
ovs_flow_new_req_set_key_tunnel_ipv4_src(struct ovs_flow_new_req *req,
					 __u32 ipv4_src /* big-endian */)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	req->key.tunnel._present.ipv4_src = 1;
	req->key.tunnel.ipv4_src = ipv4_src;
}
static inline void
ovs_flow_new_req_set_key_tunnel_ipv4_dst(struct ovs_flow_new_req *req,
					 __u32 ipv4_dst /* big-endian */)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	req->key.tunnel._present.ipv4_dst = 1;
	req->key.tunnel.ipv4_dst = ipv4_dst;
}
static inline void
ovs_flow_new_req_set_key_tunnel_tos(struct ovs_flow_new_req *req, __u8 tos)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	req->key.tunnel._present.tos = 1;
	req->key.tunnel.tos = tos;
}
static inline void
ovs_flow_new_req_set_key_tunnel_ttl(struct ovs_flow_new_req *req, __u8 ttl)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	req->key.tunnel._present.ttl = 1;
	req->key.tunnel.ttl = ttl;
}
static inline void
ovs_flow_new_req_set_key_tunnel_dont_fragment(struct ovs_flow_new_req *req)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	req->key.tunnel._present.dont_fragment = 1;
}
static inline void
ovs_flow_new_req_set_key_tunnel_csum(struct ovs_flow_new_req *req)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	req->key.tunnel._present.csum = 1;
}
static inline void
ovs_flow_new_req_set_key_tunnel_oam(struct ovs_flow_new_req *req)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	req->key.tunnel._present.oam = 1;
}
static inline void
ovs_flow_new_req_set_key_tunnel_geneve_opts(struct ovs_flow_new_req *req,
					    const void *geneve_opts,
					    size_t len)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	free(req->key.tunnel.geneve_opts);
	req->key.tunnel._present.geneve_opts_len = len;
	req->key.tunnel.geneve_opts = malloc(req->key.tunnel._present.geneve_opts_len);
	memcpy(req->key.tunnel.geneve_opts, geneve_opts, req->key.tunnel._present.geneve_opts_len);
}
static inline void
ovs_flow_new_req_set_key_tunnel_tp_src(struct ovs_flow_new_req *req,
				       __u16 tp_src /* big-endian */)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	req->key.tunnel._present.tp_src = 1;
	req->key.tunnel.tp_src = tp_src;
}
static inline void
ovs_flow_new_req_set_key_tunnel_tp_dst(struct ovs_flow_new_req *req,
				       __u16 tp_dst /* big-endian */)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	req->key.tunnel._present.tp_dst = 1;
	req->key.tunnel.tp_dst = tp_dst;
}
static inline void
ovs_flow_new_req_set_key_tunnel_vxlan_opts_gbp(struct ovs_flow_new_req *req,
					       __u32 gbp)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	req->key.tunnel._present.vxlan_opts = 1;
	req->key.tunnel.vxlan_opts._present.gbp = 1;
	req->key.tunnel.vxlan_opts.gbp = gbp;
}
static inline void
ovs_flow_new_req_set_key_tunnel_ipv6_src(struct ovs_flow_new_req *req,
					 const void *ipv6_src, size_t len)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	free(req->key.tunnel.ipv6_src);
	req->key.tunnel._present.ipv6_src_len = len;
	req->key.tunnel.ipv6_src = malloc(req->key.tunnel._present.ipv6_src_len);
	memcpy(req->key.tunnel.ipv6_src, ipv6_src, req->key.tunnel._present.ipv6_src_len);
}
static inline void
ovs_flow_new_req_set_key_tunnel_ipv6_dst(struct ovs_flow_new_req *req,
					 const void *ipv6_dst, size_t len)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	free(req->key.tunnel.ipv6_dst);
	req->key.tunnel._present.ipv6_dst_len = len;
	req->key.tunnel.ipv6_dst = malloc(req->key.tunnel._present.ipv6_dst_len);
	memcpy(req->key.tunnel.ipv6_dst, ipv6_dst, req->key.tunnel._present.ipv6_dst_len);
}
static inline void
ovs_flow_new_req_set_key_tunnel_pad(struct ovs_flow_new_req *req,
				    const void *pad, size_t len)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	free(req->key.tunnel.pad);
	req->key.tunnel._present.pad_len = len;
	req->key.tunnel.pad = malloc(req->key.tunnel._present.pad_len);
	memcpy(req->key.tunnel.pad, pad, req->key.tunnel._present.pad_len);
}
static inline void
ovs_flow_new_req_set_key_tunnel_erspan_opts(struct ovs_flow_new_req *req,
					    const void *erspan_opts,
					    size_t len)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	free(req->key.tunnel.erspan_opts);
	req->key.tunnel._present.erspan_opts_len = len;
	req->key.tunnel.erspan_opts = malloc(req->key.tunnel._present.erspan_opts_len);
	memcpy(req->key.tunnel.erspan_opts, erspan_opts, req->key.tunnel._present.erspan_opts_len);
}
static inline void
ovs_flow_new_req_set_key_tunnel_ipv4_info_bridge(struct ovs_flow_new_req *req)
{
	req->_present.key = 1;
	req->key._present.tunnel = 1;
	req->key.tunnel._present.ipv4_info_bridge = 1;
}
static inline void
ovs_flow_new_req_set_key_sctp(struct ovs_flow_new_req *req, const void *sctp,
			      size_t len)
{
	req->_present.key = 1;
	free(req->key.sctp);
	req->key._present.sctp_len = len;
	req->key.sctp = malloc(req->key._present.sctp_len);
	memcpy(req->key.sctp, sctp, req->key._present.sctp_len);
}
static inline void
ovs_flow_new_req_set_key_tcp_flags(struct ovs_flow_new_req *req,
				   __u16 tcp_flags /* big-endian */)
{
	req->_present.key = 1;
	req->key._present.tcp_flags = 1;
	req->key.tcp_flags = tcp_flags;
}
static inline void
ovs_flow_new_req_set_key_dp_hash(struct ovs_flow_new_req *req, __u32 dp_hash)
{
	req->_present.key = 1;
	req->key._present.dp_hash = 1;
	req->key.dp_hash = dp_hash;
}
static inline void
ovs_flow_new_req_set_key_recirc_id(struct ovs_flow_new_req *req,
				   __u32 recirc_id)
{
	req->_present.key = 1;
	req->key._present.recirc_id = 1;
	req->key.recirc_id = recirc_id;
}
static inline void
ovs_flow_new_req_set_key_mpls(struct ovs_flow_new_req *req, const void *mpls,
			      size_t len)
{
	req->_present.key = 1;
	free(req->key.mpls);
	req->key._present.mpls_len = len;
	req->key.mpls = malloc(req->key._present.mpls_len);
	memcpy(req->key.mpls, mpls, req->key._present.mpls_len);
}
static inline void
ovs_flow_new_req_set_key_ct_state(struct ovs_flow_new_req *req, __u32 ct_state)
{
	req->_present.key = 1;
	req->key._present.ct_state = 1;
	req->key.ct_state = ct_state;
}
static inline void
ovs_flow_new_req_set_key_ct_zone(struct ovs_flow_new_req *req, __u16 ct_zone)
{
	req->_present.key = 1;
	req->key._present.ct_zone = 1;
	req->key.ct_zone = ct_zone;
}
static inline void
ovs_flow_new_req_set_key_ct_mark(struct ovs_flow_new_req *req, __u32 ct_mark)
{
	req->_present.key = 1;
	req->key._present.ct_mark = 1;
	req->key.ct_mark = ct_mark;
}
static inline void
ovs_flow_new_req_set_key_ct_labels(struct ovs_flow_new_req *req,
				   const void *ct_labels, size_t len)
{
	req->_present.key = 1;
	free(req->key.ct_labels);
	req->key._present.ct_labels_len = len;
	req->key.ct_labels = malloc(req->key._present.ct_labels_len);
	memcpy(req->key.ct_labels, ct_labels, req->key._present.ct_labels_len);
}
static inline void
ovs_flow_new_req_set_key_ct_orig_tuple_ipv4(struct ovs_flow_new_req *req,
					    const void *ct_orig_tuple_ipv4,
					    size_t len)
{
	req->_present.key = 1;
	free(req->key.ct_orig_tuple_ipv4);
	req->key._present.ct_orig_tuple_ipv4_len = len;
	req->key.ct_orig_tuple_ipv4 = malloc(req->key._present.ct_orig_tuple_ipv4_len);
	memcpy(req->key.ct_orig_tuple_ipv4, ct_orig_tuple_ipv4, req->key._present.ct_orig_tuple_ipv4_len);
}
static inline void
ovs_flow_new_req_set_key_ct_orig_tuple_ipv6(struct ovs_flow_new_req *req,
					    const void *ct_orig_tuple_ipv6,
					    size_t len)
{
	req->_present.key = 1;
	free(req->key.ct_orig_tuple_ipv6);
	req->key._present.ct_orig_tuple_ipv6_len = len;
	req->key.ct_orig_tuple_ipv6 = malloc(req->key._present.ct_orig_tuple_ipv6_len);
	memcpy(req->key.ct_orig_tuple_ipv6, ct_orig_tuple_ipv6, req->key._present.ct_orig_tuple_ipv6_len);
}
static inline void
ovs_flow_new_req_set_key_nsh_base(struct ovs_flow_new_req *req,
				  const void *base, size_t len)
{
	req->_present.key = 1;
	req->key._present.nsh = 1;
	free(req->key.nsh.base);
	req->key.nsh._present.base_len = len;
	req->key.nsh.base = malloc(req->key.nsh._present.base_len);
	memcpy(req->key.nsh.base, base, req->key.nsh._present.base_len);
}
static inline void
ovs_flow_new_req_set_key_nsh_md1(struct ovs_flow_new_req *req, const void *md1,
				 size_t len)
{
	req->_present.key = 1;
	req->key._present.nsh = 1;
	free(req->key.nsh.md1);
	req->key.nsh._present.md1_len = len;
	req->key.nsh.md1 = malloc(req->key.nsh._present.md1_len);
	memcpy(req->key.nsh.md1, md1, req->key.nsh._present.md1_len);
}
static inline void
ovs_flow_new_req_set_key_nsh_md2(struct ovs_flow_new_req *req, const void *md2,
				 size_t len)
{
	req->_present.key = 1;
	req->key._present.nsh = 1;
	free(req->key.nsh.md2);
	req->key.nsh._present.md2_len = len;
	req->key.nsh.md2 = malloc(req->key.nsh._present.md2_len);
	memcpy(req->key.nsh.md2, md2, req->key.nsh._present.md2_len);
}
static inline void
ovs_flow_new_req_set_key_packet_type(struct ovs_flow_new_req *req,
				     __u32 packet_type /* big-endian */)
{
	req->_present.key = 1;
	req->key._present.packet_type = 1;
	req->key.packet_type = packet_type;
}
static inline void
ovs_flow_new_req_set_key_nd_extensions(struct ovs_flow_new_req *req,
				       const void *nd_extensions, size_t len)
{
	req->_present.key = 1;
	free(req->key.nd_extensions);
	req->key._present.nd_extensions_len = len;
	req->key.nd_extensions = malloc(req->key._present.nd_extensions_len);
	memcpy(req->key.nd_extensions, nd_extensions, req->key._present.nd_extensions_len);
}
static inline void
ovs_flow_new_req_set_key_tunnel_info(struct ovs_flow_new_req *req,
				     const void *tunnel_info, size_t len)
{
	req->_present.key = 1;
	free(req->key.tunnel_info);
	req->key._present.tunnel_info_len = len;
	req->key.tunnel_info = malloc(req->key._present.tunnel_info_len);
	memcpy(req->key.tunnel_info, tunnel_info, req->key._present.tunnel_info_len);
}
static inline void
ovs_flow_new_req_set_key_ipv6_exthdrs(struct ovs_flow_new_req *req,
				      const void *ipv6_exthdrs, size_t len)
{
	req->_present.key = 1;
	free(req->key.ipv6_exthdrs);
	req->key._present.ipv6_exthdrs_len = len;
	req->key.ipv6_exthdrs = malloc(req->key._present.ipv6_exthdrs_len);
	memcpy(req->key.ipv6_exthdrs, ipv6_exthdrs, req->key._present.ipv6_exthdrs_len);
}
static inline void
ovs_flow_new_req_set_ufid(struct ovs_flow_new_req *req, const void *ufid,
			  size_t len)
{
	free(req->ufid);
	req->_present.ufid_len = len;
	req->ufid = malloc(req->_present.ufid_len);
	memcpy(req->ufid, ufid, req->_present.ufid_len);
}
static inline void
ovs_flow_new_req_set_mask_priority(struct ovs_flow_new_req *req,
				   __u32 priority)
{
	req->_present.mask = 1;
	req->mask._present.priority = 1;
	req->mask.priority = priority;
}
static inline void
ovs_flow_new_req_set_mask_in_port(struct ovs_flow_new_req *req, __u32 in_port)
{
	req->_present.mask = 1;
	req->mask._present.in_port = 1;
	req->mask.in_port = in_port;
}
static inline void
ovs_flow_new_req_set_mask_ethernet(struct ovs_flow_new_req *req,
				   const void *ethernet, size_t len)
{
	req->_present.mask = 1;
	free(req->mask.ethernet);
	req->mask._present.ethernet_len = len;
	req->mask.ethernet = malloc(req->mask._present.ethernet_len);
	memcpy(req->mask.ethernet, ethernet, req->mask._present.ethernet_len);
}
static inline void
ovs_flow_new_req_set_mask_vlan(struct ovs_flow_new_req *req,
			       __u16 vlan /* big-endian */)
{
	req->_present.mask = 1;
	req->mask._present.vlan = 1;
	req->mask.vlan = vlan;
}
static inline void
ovs_flow_new_req_set_mask_ethertype(struct ovs_flow_new_req *req,
				    __u16 ethertype /* big-endian */)
{
	req->_present.mask = 1;
	req->mask._present.ethertype = 1;
	req->mask.ethertype = ethertype;
}
static inline void
ovs_flow_new_req_set_mask_ipv4(struct ovs_flow_new_req *req, const void *ipv4,
			       size_t len)
{
	req->_present.mask = 1;
	free(req->mask.ipv4);
	req->mask._present.ipv4_len = len;
	req->mask.ipv4 = malloc(req->mask._present.ipv4_len);
	memcpy(req->mask.ipv4, ipv4, req->mask._present.ipv4_len);
}
static inline void
ovs_flow_new_req_set_mask_ipv6(struct ovs_flow_new_req *req, const void *ipv6,
			       size_t len)
{
	req->_present.mask = 1;
	free(req->mask.ipv6);
	req->mask._present.ipv6_len = len;
	req->mask.ipv6 = malloc(req->mask._present.ipv6_len);
	memcpy(req->mask.ipv6, ipv6, req->mask._present.ipv6_len);
}
static inline void
ovs_flow_new_req_set_mask_tcp(struct ovs_flow_new_req *req, const void *tcp,
			      size_t len)
{
	req->_present.mask = 1;
	free(req->mask.tcp);
	req->mask._present.tcp_len = len;
	req->mask.tcp = malloc(req->mask._present.tcp_len);
	memcpy(req->mask.tcp, tcp, req->mask._present.tcp_len);
}
static inline void
ovs_flow_new_req_set_mask_udp(struct ovs_flow_new_req *req, const void *udp,
			      size_t len)
{
	req->_present.mask = 1;
	free(req->mask.udp);
	req->mask._present.udp_len = len;
	req->mask.udp = malloc(req->mask._present.udp_len);
	memcpy(req->mask.udp, udp, req->mask._present.udp_len);
}
static inline void
ovs_flow_new_req_set_mask_icmp(struct ovs_flow_new_req *req, const void *icmp,
			       size_t len)
{
	req->_present.mask = 1;
	free(req->mask.icmp);
	req->mask._present.icmp_len = len;
	req->mask.icmp = malloc(req->mask._present.icmp_len);
	memcpy(req->mask.icmp, icmp, req->mask._present.icmp_len);
}
static inline void
ovs_flow_new_req_set_mask_icmpv6(struct ovs_flow_new_req *req,
				 const void *icmpv6, size_t len)
{
	req->_present.mask = 1;
	free(req->mask.icmpv6);
	req->mask._present.icmpv6_len = len;
	req->mask.icmpv6 = malloc(req->mask._present.icmpv6_len);
	memcpy(req->mask.icmpv6, icmpv6, req->mask._present.icmpv6_len);
}
static inline void
ovs_flow_new_req_set_mask_arp(struct ovs_flow_new_req *req, const void *arp,
			      size_t len)
{
	req->_present.mask = 1;
	free(req->mask.arp);
	req->mask._present.arp_len = len;
	req->mask.arp = malloc(req->mask._present.arp_len);
	memcpy(req->mask.arp, arp, req->mask._present.arp_len);
}
static inline void
ovs_flow_new_req_set_mask_nd(struct ovs_flow_new_req *req, const void *nd,
			     size_t len)
{
	req->_present.mask = 1;
	free(req->mask.nd);
	req->mask._present.nd_len = len;
	req->mask.nd = malloc(req->mask._present.nd_len);
	memcpy(req->mask.nd, nd, req->mask._present.nd_len);
}
static inline void
ovs_flow_new_req_set_mask_skb_mark(struct ovs_flow_new_req *req,
				   __u32 skb_mark)
{
	req->_present.mask = 1;
	req->mask._present.skb_mark = 1;
	req->mask.skb_mark = skb_mark;
}
static inline void
ovs_flow_new_req_set_mask_tunnel_id(struct ovs_flow_new_req *req,
				    __u64 id /* big-endian */)
{
	req->_present.mask = 1;
	req->mask._present.tunnel = 1;
	req->mask.tunnel._present.id = 1;
	req->mask.tunnel.id = id;
}
static inline void
ovs_flow_new_req_set_mask_tunnel_ipv4_src(struct ovs_flow_new_req *req,
					  __u32 ipv4_src /* big-endian */)
{
	req->_present.mask = 1;
	req->mask._present.tunnel = 1;
	req->mask.tunnel._present.ipv4_src = 1;
	req->mask.tunnel.ipv4_src = ipv4_src;
}
static inline void
ovs_flow_new_req_set_mask_tunnel_ipv4_dst(struct ovs_flow_new_req *req,
					  __u32 ipv4_dst /* big-endian */)
{
	req->_present.mask = 1;
	req->mask._present.tunnel = 1;
	req->mask.tunnel._present.ipv4_dst = 1;
	req->mask.tunnel.ipv4_dst = ipv4_dst;
}
static inline void
ovs_flow_new_req_set_mask_tunnel_tos(struct ovs_flow_new_req *req, __u8 tos)
{
	req->_present.mask = 1;
	req->mask._present.tunnel = 1;
	req->mask.tunnel._present.tos = 1;
	req->mask.tunnel.tos = tos;
}
static inline void
ovs_flow_new_req_set_mask_tunnel_ttl(struct ovs_flow_new_req *req, __u8 ttl)
{
	req->_present.mask = 1;
	req->mask._present.tunnel = 1;
	req->mask.tunnel._present.ttl = 1;
	req->mask.tunnel.ttl = ttl;
}
static inline void
ovs_flow_new_req_set_mask_tunnel_dont_fragment(struct ovs_flow_new_req *req)
{
	req->_present.mask = 1;
	req->mask._present.tunnel = 1;
	req->mask.tunnel._present.dont_fragment = 1;
}
static inline void
ovs_flow_new_req_set_mask_tunnel_csum(struct ovs_flow_new_req *req)
{
	req->_present.mask = 1;
	req->mask._present.tunnel = 1;
	req->mask.tunnel._present.csum = 1;
}
static inline void
ovs_flow_new_req_set_mask_tunnel_oam(struct ovs_flow_new_req *req)
{
	req->_present.mask = 1;
	req->mask._present.tunnel = 1;
	req->mask.tunnel._present.oam = 1;
}
static inline void
ovs_flow_new_req_set_mask_tunnel_geneve_opts(struct ovs_flow_new_req *req,
					     const void *geneve_opts,
					     size_t len)
{
	req->_present.mask = 1;
	req->mask._present.tunnel = 1;
	free(req->mask.tunnel.geneve_opts);
	req->mask.tunnel._present.geneve_opts_len = len;
	req->mask.tunnel.geneve_opts = malloc(req->mask.tunnel._present.geneve_opts_len);
	memcpy(req->mask.tunnel.geneve_opts, geneve_opts, req->mask.tunnel._present.geneve_opts_len);
}
static inline void
ovs_flow_new_req_set_mask_tunnel_tp_src(struct ovs_flow_new_req *req,
					__u16 tp_src /* big-endian */)
{
	req->_present.mask = 1;
	req->mask._present.tunnel = 1;
	req->mask.tunnel._present.tp_src = 1;
	req->mask.tunnel.tp_src = tp_src;
}
static inline void
ovs_flow_new_req_set_mask_tunnel_tp_dst(struct ovs_flow_new_req *req,
					__u16 tp_dst /* big-endian */)
{
	req->_present.mask = 1;
	req->mask._present.tunnel = 1;
	req->mask.tunnel._present.tp_dst = 1;
	req->mask.tunnel.tp_dst = tp_dst;
}
static inline void
ovs_flow_new_req_set_mask_tunnel_vxlan_opts_gbp(struct ovs_flow_new_req *req,
						__u32 gbp)
{
	req->_present.mask = 1;
	req->mask._present.tunnel = 1;
	req->mask.tunnel._present.vxlan_opts = 1;
	req->mask.tunnel.vxlan_opts._present.gbp = 1;
	req->mask.tunnel.vxlan_opts.gbp = gbp;
}
static inline void
ovs_flow_new_req_set_mask_tunnel_ipv6_src(struct ovs_flow_new_req *req,
					  const void *ipv6_src, size_t len)
{
	req->_present.mask = 1;
	req->mask._present.tunnel = 1;
	free(req->mask.tunnel.ipv6_src);
	req->mask.tunnel._present.ipv6_src_len = len;
	req->mask.tunnel.ipv6_src = malloc(req->mask.tunnel._present.ipv6_src_len);
	memcpy(req->mask.tunnel.ipv6_src, ipv6_src, req->mask.tunnel._present.ipv6_src_len);
}
static inline void
ovs_flow_new_req_set_mask_tunnel_ipv6_dst(struct ovs_flow_new_req *req,
					  const void *ipv6_dst, size_t len)
{
	req->_present.mask = 1;
	req->mask._present.tunnel = 1;
	free(req->mask.tunnel.ipv6_dst);
	req->mask.tunnel._present.ipv6_dst_len = len;
	req->mask.tunnel.ipv6_dst = malloc(req->mask.tunnel._present.ipv6_dst_len);
	memcpy(req->mask.tunnel.ipv6_dst, ipv6_dst, req->mask.tunnel._present.ipv6_dst_len);
}
static inline void
ovs_flow_new_req_set_mask_tunnel_pad(struct ovs_flow_new_req *req,
				     const void *pad, size_t len)
{
	req->_present.mask = 1;
	req->mask._present.tunnel = 1;
	free(req->mask.tunnel.pad);
	req->mask.tunnel._present.pad_len = len;
	req->mask.tunnel.pad = malloc(req->mask.tunnel._present.pad_len);
	memcpy(req->mask.tunnel.pad, pad, req->mask.tunnel._present.pad_len);
}
static inline void
ovs_flow_new_req_set_mask_tunnel_erspan_opts(struct ovs_flow_new_req *req,
					     const void *erspan_opts,
					     size_t len)
{
	req->_present.mask = 1;
	req->mask._present.tunnel = 1;
	free(req->mask.tunnel.erspan_opts);
	req->mask.tunnel._present.erspan_opts_len = len;
	req->mask.tunnel.erspan_opts = malloc(req->mask.tunnel._present.erspan_opts_len);
	memcpy(req->mask.tunnel.erspan_opts, erspan_opts, req->mask.tunnel._present.erspan_opts_len);
}
static inline void
ovs_flow_new_req_set_mask_tunnel_ipv4_info_bridge(struct ovs_flow_new_req *req)
{
	req->_present.mask = 1;
	req->mask._present.tunnel = 1;
	req->mask.tunnel._present.ipv4_info_bridge = 1;
}
static inline void
ovs_flow_new_req_set_mask_sctp(struct ovs_flow_new_req *req, const void *sctp,
			       size_t len)
{
	req->_present.mask = 1;
	free(req->mask.sctp);
	req->mask._present.sctp_len = len;
	req->mask.sctp = malloc(req->mask._present.sctp_len);
	memcpy(req->mask.sctp, sctp, req->mask._present.sctp_len);
}
static inline void
ovs_flow_new_req_set_mask_tcp_flags(struct ovs_flow_new_req *req,
				    __u16 tcp_flags /* big-endian */)
{
	req->_present.mask = 1;
	req->mask._present.tcp_flags = 1;
	req->mask.tcp_flags = tcp_flags;
}
static inline void
ovs_flow_new_req_set_mask_dp_hash(struct ovs_flow_new_req *req, __u32 dp_hash)
{
	req->_present.mask = 1;
	req->mask._present.dp_hash = 1;
	req->mask.dp_hash = dp_hash;
}
static inline void
ovs_flow_new_req_set_mask_recirc_id(struct ovs_flow_new_req *req,
				    __u32 recirc_id)
{
	req->_present.mask = 1;
	req->mask._present.recirc_id = 1;
	req->mask.recirc_id = recirc_id;
}
static inline void
ovs_flow_new_req_set_mask_mpls(struct ovs_flow_new_req *req, const void *mpls,
			       size_t len)
{
	req->_present.mask = 1;
	free(req->mask.mpls);
	req->mask._present.mpls_len = len;
	req->mask.mpls = malloc(req->mask._present.mpls_len);
	memcpy(req->mask.mpls, mpls, req->mask._present.mpls_len);
}
static inline void
ovs_flow_new_req_set_mask_ct_state(struct ovs_flow_new_req *req,
				   __u32 ct_state)
{
	req->_present.mask = 1;
	req->mask._present.ct_state = 1;
	req->mask.ct_state = ct_state;
}
static inline void
ovs_flow_new_req_set_mask_ct_zone(struct ovs_flow_new_req *req, __u16 ct_zone)
{
	req->_present.mask = 1;
	req->mask._present.ct_zone = 1;
	req->mask.ct_zone = ct_zone;
}
static inline void
ovs_flow_new_req_set_mask_ct_mark(struct ovs_flow_new_req *req, __u32 ct_mark)
{
	req->_present.mask = 1;
	req->mask._present.ct_mark = 1;
	req->mask.ct_mark = ct_mark;
}
static inline void
ovs_flow_new_req_set_mask_ct_labels(struct ovs_flow_new_req *req,
				    const void *ct_labels, size_t len)
{
	req->_present.mask = 1;
	free(req->mask.ct_labels);
	req->mask._present.ct_labels_len = len;
	req->mask.ct_labels = malloc(req->mask._present.ct_labels_len);
	memcpy(req->mask.ct_labels, ct_labels, req->mask._present.ct_labels_len);
}
static inline void
ovs_flow_new_req_set_mask_ct_orig_tuple_ipv4(struct ovs_flow_new_req *req,
					     const void *ct_orig_tuple_ipv4,
					     size_t len)
{
	req->_present.mask = 1;
	free(req->mask.ct_orig_tuple_ipv4);
	req->mask._present.ct_orig_tuple_ipv4_len = len;
	req->mask.ct_orig_tuple_ipv4 = malloc(req->mask._present.ct_orig_tuple_ipv4_len);
	memcpy(req->mask.ct_orig_tuple_ipv4, ct_orig_tuple_ipv4, req->mask._present.ct_orig_tuple_ipv4_len);
}
static inline void
ovs_flow_new_req_set_mask_ct_orig_tuple_ipv6(struct ovs_flow_new_req *req,
					     const void *ct_orig_tuple_ipv6,
					     size_t len)
{
	req->_present.mask = 1;
	free(req->mask.ct_orig_tuple_ipv6);
	req->mask._present.ct_orig_tuple_ipv6_len = len;
	req->mask.ct_orig_tuple_ipv6 = malloc(req->mask._present.ct_orig_tuple_ipv6_len);
	memcpy(req->mask.ct_orig_tuple_ipv6, ct_orig_tuple_ipv6, req->mask._present.ct_orig_tuple_ipv6_len);
}
static inline void
ovs_flow_new_req_set_mask_nsh_base(struct ovs_flow_new_req *req,
				   const void *base, size_t len)
{
	req->_present.mask = 1;
	req->mask._present.nsh = 1;
	free(req->mask.nsh.base);
	req->mask.nsh._present.base_len = len;
	req->mask.nsh.base = malloc(req->mask.nsh._present.base_len);
	memcpy(req->mask.nsh.base, base, req->mask.nsh._present.base_len);
}
static inline void
ovs_flow_new_req_set_mask_nsh_md1(struct ovs_flow_new_req *req,
				  const void *md1, size_t len)
{
	req->_present.mask = 1;
	req->mask._present.nsh = 1;
	free(req->mask.nsh.md1);
	req->mask.nsh._present.md1_len = len;
	req->mask.nsh.md1 = malloc(req->mask.nsh._present.md1_len);
	memcpy(req->mask.nsh.md1, md1, req->mask.nsh._present.md1_len);
}
static inline void
ovs_flow_new_req_set_mask_nsh_md2(struct ovs_flow_new_req *req,
				  const void *md2, size_t len)
{
	req->_present.mask = 1;
	req->mask._present.nsh = 1;
	free(req->mask.nsh.md2);
	req->mask.nsh._present.md2_len = len;
	req->mask.nsh.md2 = malloc(req->mask.nsh._present.md2_len);
	memcpy(req->mask.nsh.md2, md2, req->mask.nsh._present.md2_len);
}
static inline void
ovs_flow_new_req_set_mask_packet_type(struct ovs_flow_new_req *req,
				      __u32 packet_type /* big-endian */)
{
	req->_present.mask = 1;
	req->mask._present.packet_type = 1;
	req->mask.packet_type = packet_type;
}
static inline void
ovs_flow_new_req_set_mask_nd_extensions(struct ovs_flow_new_req *req,
					const void *nd_extensions, size_t len)
{
	req->_present.mask = 1;
	free(req->mask.nd_extensions);
	req->mask._present.nd_extensions_len = len;
	req->mask.nd_extensions = malloc(req->mask._present.nd_extensions_len);
	memcpy(req->mask.nd_extensions, nd_extensions, req->mask._present.nd_extensions_len);
}
static inline void
ovs_flow_new_req_set_mask_tunnel_info(struct ovs_flow_new_req *req,
				      const void *tunnel_info, size_t len)
{
	req->_present.mask = 1;
	free(req->mask.tunnel_info);
	req->mask._present.tunnel_info_len = len;
	req->mask.tunnel_info = malloc(req->mask._present.tunnel_info_len);
	memcpy(req->mask.tunnel_info, tunnel_info, req->mask._present.tunnel_info_len);
}
static inline void
ovs_flow_new_req_set_mask_ipv6_exthdrs(struct ovs_flow_new_req *req,
				       const void *ipv6_exthdrs, size_t len)
{
	req->_present.mask = 1;
	free(req->mask.ipv6_exthdrs);
	req->mask._present.ipv6_exthdrs_len = len;
	req->mask.ipv6_exthdrs = malloc(req->mask._present.ipv6_exthdrs_len);
	memcpy(req->mask.ipv6_exthdrs, ipv6_exthdrs, req->mask._present.ipv6_exthdrs_len);
}
static inline void
ovs_flow_new_req_set_actions_output(struct ovs_flow_new_req *req, __u32 output)
{
	req->_present.actions = 1;
	req->actions._present.output = 1;
	req->actions.output = output;
}
static inline void
ovs_flow_new_req_set_actions_userspace_pid(struct ovs_flow_new_req *req,
					   __u32 pid)
{
	req->_present.actions = 1;
	req->actions._present.userspace = 1;
	req->actions.userspace._present.pid = 1;
	req->actions.userspace.pid = pid;
}
static inline void
ovs_flow_new_req_set_actions_userspace_userdata(struct ovs_flow_new_req *req,
						const void *userdata,
						size_t len)
{
	req->_present.actions = 1;
	req->actions._present.userspace = 1;
	free(req->actions.userspace.userdata);
	req->actions.userspace._present.userdata_len = len;
	req->actions.userspace.userdata = malloc(req->actions.userspace._present.userdata_len);
	memcpy(req->actions.userspace.userdata, userdata, req->actions.userspace._present.userdata_len);
}
static inline void
ovs_flow_new_req_set_actions_userspace_egress_tun_port(struct ovs_flow_new_req *req,
						       __u32 egress_tun_port)
{
	req->_present.actions = 1;
	req->actions._present.userspace = 1;
	req->actions.userspace._present.egress_tun_port = 1;
	req->actions.userspace.egress_tun_port = egress_tun_port;
}
static inline void
ovs_flow_new_req_set_actions_userspace_actions(struct ovs_flow_new_req *req)
{
	req->_present.actions = 1;
	req->actions._present.userspace = 1;
	req->actions.userspace._present.actions = 1;
}
static inline void
ovs_flow_new_req_set_actions_push_vlan(struct ovs_flow_new_req *req,
				       const void *push_vlan, size_t len)
{
	req->_present.actions = 1;
	free(req->actions.push_vlan);
	req->actions._present.push_vlan_len = len;
	req->actions.push_vlan = malloc(req->actions._present.push_vlan_len);
	memcpy(req->actions.push_vlan, push_vlan, req->actions._present.push_vlan_len);
}
static inline void
ovs_flow_new_req_set_actions_pop_vlan(struct ovs_flow_new_req *req)
{
	req->_present.actions = 1;
	req->actions._present.pop_vlan = 1;
}
static inline void
ovs_flow_new_req_set_actions_sample_probability(struct ovs_flow_new_req *req,
						__u32 probability)
{
	req->_present.actions = 1;
	req->actions._present.sample = 1;
	req->actions.sample._present.probability = 1;
	req->actions.sample.probability = probability;
}
static inline void
ovs_flow_new_req_set_actions_recirc(struct ovs_flow_new_req *req, __u32 recirc)
{
	req->_present.actions = 1;
	req->actions._present.recirc = 1;
	req->actions.recirc = recirc;
}
static inline void
ovs_flow_new_req_set_actions_hash(struct ovs_flow_new_req *req,
				  const void *hash, size_t len)
{
	req->_present.actions = 1;
	free(req->actions.hash);
	req->actions._present.hash_len = len;
	req->actions.hash = malloc(req->actions._present.hash_len);
	memcpy(req->actions.hash, hash, req->actions._present.hash_len);
}
static inline void
ovs_flow_new_req_set_actions_push_mpls(struct ovs_flow_new_req *req,
				       const void *push_mpls, size_t len)
{
	req->_present.actions = 1;
	free(req->actions.push_mpls);
	req->actions._present.push_mpls_len = len;
	req->actions.push_mpls = malloc(req->actions._present.push_mpls_len);
	memcpy(req->actions.push_mpls, push_mpls, req->actions._present.push_mpls_len);
}
static inline void
ovs_flow_new_req_set_actions_pop_mpls(struct ovs_flow_new_req *req,
				      __u16 pop_mpls /* big-endian */)
{
	req->_present.actions = 1;
	req->actions._present.pop_mpls = 1;
	req->actions.pop_mpls = pop_mpls;
}
static inline void
ovs_flow_new_req_set_actions_ct_commit(struct ovs_flow_new_req *req)
{
	req->_present.actions = 1;
	req->actions._present.ct = 1;
	req->actions.ct._present.commit = 1;
}
static inline void
ovs_flow_new_req_set_actions_ct_zone(struct ovs_flow_new_req *req, __u16 zone)
{
	req->_present.actions = 1;
	req->actions._present.ct = 1;
	req->actions.ct._present.zone = 1;
	req->actions.ct.zone = zone;
}
static inline void
ovs_flow_new_req_set_actions_ct_mark(struct ovs_flow_new_req *req,
				     const void *mark, size_t len)
{
	req->_present.actions = 1;
	req->actions._present.ct = 1;
	free(req->actions.ct.mark);
	req->actions.ct._present.mark_len = len;
	req->actions.ct.mark = malloc(req->actions.ct._present.mark_len);
	memcpy(req->actions.ct.mark, mark, req->actions.ct._present.mark_len);
}
static inline void
ovs_flow_new_req_set_actions_ct_labels(struct ovs_flow_new_req *req,
				       const void *labels, size_t len)
{
	req->_present.actions = 1;
	req->actions._present.ct = 1;
	free(req->actions.ct.labels);
	req->actions.ct._present.labels_len = len;
	req->actions.ct.labels = malloc(req->actions.ct._present.labels_len);
	memcpy(req->actions.ct.labels, labels, req->actions.ct._present.labels_len);
}
static inline void
ovs_flow_new_req_set_actions_ct_helper(struct ovs_flow_new_req *req,
				       const char *helper)
{
	req->_present.actions = 1;
	req->actions._present.ct = 1;
	free(req->actions.ct.helper);
	req->actions.ct._present.helper_len = strlen(helper);
	req->actions.ct.helper = malloc(req->actions.ct._present.helper_len + 1);
	memcpy(req->actions.ct.helper, helper, req->actions.ct._present.helper_len);
	req->actions.ct.helper[req->actions.ct._present.helper_len] = 0;
}
static inline void
ovs_flow_new_req_set_actions_ct_nat_src(struct ovs_flow_new_req *req)
{
	req->_present.actions = 1;
	req->actions._present.ct = 1;
	req->actions.ct._present.nat = 1;
	req->actions.ct.nat._present.src = 1;
}
static inline void
ovs_flow_new_req_set_actions_ct_nat_dst(struct ovs_flow_new_req *req)
{
	req->_present.actions = 1;
	req->actions._present.ct = 1;
	req->actions.ct._present.nat = 1;
	req->actions.ct.nat._present.dst = 1;
}
static inline void
ovs_flow_new_req_set_actions_ct_nat_ip_min(struct ovs_flow_new_req *req,
					   const void *ip_min, size_t len)
{
	req->_present.actions = 1;
	req->actions._present.ct = 1;
	req->actions.ct._present.nat = 1;
	free(req->actions.ct.nat.ip_min);
	req->actions.ct.nat._present.ip_min_len = len;
	req->actions.ct.nat.ip_min = malloc(req->actions.ct.nat._present.ip_min_len);
	memcpy(req->actions.ct.nat.ip_min, ip_min, req->actions.ct.nat._present.ip_min_len);
}
static inline void
ovs_flow_new_req_set_actions_ct_nat_ip_max(struct ovs_flow_new_req *req,
					   const void *ip_max, size_t len)
{
	req->_present.actions = 1;
	req->actions._present.ct = 1;
	req->actions.ct._present.nat = 1;
	free(req->actions.ct.nat.ip_max);
	req->actions.ct.nat._present.ip_max_len = len;
	req->actions.ct.nat.ip_max = malloc(req->actions.ct.nat._present.ip_max_len);
	memcpy(req->actions.ct.nat.ip_max, ip_max, req->actions.ct.nat._present.ip_max_len);
}
static inline void
ovs_flow_new_req_set_actions_ct_nat_proto_min(struct ovs_flow_new_req *req,
					      __u16 proto_min)
{
	req->_present.actions = 1;
	req->actions._present.ct = 1;
	req->actions.ct._present.nat = 1;
	req->actions.ct.nat._present.proto_min = 1;
	req->actions.ct.nat.proto_min = proto_min;
}
static inline void
ovs_flow_new_req_set_actions_ct_nat_proto_max(struct ovs_flow_new_req *req,
					      __u16 proto_max)
{
	req->_present.actions = 1;
	req->actions._present.ct = 1;
	req->actions.ct._present.nat = 1;
	req->actions.ct.nat._present.proto_max = 1;
	req->actions.ct.nat.proto_max = proto_max;
}
static inline void
ovs_flow_new_req_set_actions_ct_nat_persistent(struct ovs_flow_new_req *req)
{
	req->_present.actions = 1;
	req->actions._present.ct = 1;
	req->actions.ct._present.nat = 1;
	req->actions.ct.nat._present.persistent = 1;
}
static inline void
ovs_flow_new_req_set_actions_ct_nat_proto_hash(struct ovs_flow_new_req *req)
{
	req->_present.actions = 1;
	req->actions._present.ct = 1;
	req->actions.ct._present.nat = 1;
	req->actions.ct.nat._present.proto_hash = 1;
}
static inline void
ovs_flow_new_req_set_actions_ct_nat_proto_random(struct ovs_flow_new_req *req)
{
	req->_present.actions = 1;
	req->actions._present.ct = 1;
	req->actions.ct._present.nat = 1;
	req->actions.ct.nat._present.proto_random = 1;
}
static inline void
ovs_flow_new_req_set_actions_ct_force_commit(struct ovs_flow_new_req *req)
{
	req->_present.actions = 1;
	req->actions._present.ct = 1;
	req->actions.ct._present.force_commit = 1;
}
static inline void
ovs_flow_new_req_set_actions_ct_eventmask(struct ovs_flow_new_req *req,
					  __u32 eventmask)
{
	req->_present.actions = 1;
	req->actions._present.ct = 1;
	req->actions.ct._present.eventmask = 1;
	req->actions.ct.eventmask = eventmask;
}
static inline void
ovs_flow_new_req_set_actions_ct_timeout(struct ovs_flow_new_req *req,
					const char *timeout)
{
	req->_present.actions = 1;
	req->actions._present.ct = 1;
	free(req->actions.ct.timeout);
	req->actions.ct._present.timeout_len = strlen(timeout);
	req->actions.ct.timeout = malloc(req->actions.ct._present.timeout_len + 1);
	memcpy(req->actions.ct.timeout, timeout, req->actions.ct._present.timeout_len);
	req->actions.ct.timeout[req->actions.ct._present.timeout_len] = 0;
}
static inline void
ovs_flow_new_req_set_actions_trunc(struct ovs_flow_new_req *req, __u32 trunc)
{
	req->_present.actions = 1;
	req->actions._present.trunc = 1;
	req->actions.trunc = trunc;
}
static inline void
ovs_flow_new_req_set_actions_push_eth(struct ovs_flow_new_req *req,
				      const void *push_eth, size_t len)
{
	req->_present.actions = 1;
	free(req->actions.push_eth);
	req->actions._present.push_eth_len = len;
	req->actions.push_eth = malloc(req->actions._present.push_eth_len);
	memcpy(req->actions.push_eth, push_eth, req->actions._present.push_eth_len);
}
static inline void
ovs_flow_new_req_set_actions_pop_eth(struct ovs_flow_new_req *req)
{
	req->_present.actions = 1;
	req->actions._present.pop_eth = 1;
}
static inline void
ovs_flow_new_req_set_actions_ct_clear(struct ovs_flow_new_req *req)
{
	req->_present.actions = 1;
	req->actions._present.ct_clear = 1;
}
static inline void
ovs_flow_new_req_set_actions_push_nsh_base(struct ovs_flow_new_req *req,
					   const void *base, size_t len)
{
	req->_present.actions = 1;
	req->actions._present.push_nsh = 1;
	free(req->actions.push_nsh.base);
	req->actions.push_nsh._present.base_len = len;
	req->actions.push_nsh.base = malloc(req->actions.push_nsh._present.base_len);
	memcpy(req->actions.push_nsh.base, base, req->actions.push_nsh._present.base_len);
}
static inline void
ovs_flow_new_req_set_actions_push_nsh_md1(struct ovs_flow_new_req *req,
					  const void *md1, size_t len)
{
	req->_present.actions = 1;
	req->actions._present.push_nsh = 1;
	free(req->actions.push_nsh.md1);
	req->actions.push_nsh._present.md1_len = len;
	req->actions.push_nsh.md1 = malloc(req->actions.push_nsh._present.md1_len);
	memcpy(req->actions.push_nsh.md1, md1, req->actions.push_nsh._present.md1_len);
}
static inline void
ovs_flow_new_req_set_actions_push_nsh_md2(struct ovs_flow_new_req *req,
					  const void *md2, size_t len)
{
	req->_present.actions = 1;
	req->actions._present.push_nsh = 1;
	free(req->actions.push_nsh.md2);
	req->actions.push_nsh._present.md2_len = len;
	req->actions.push_nsh.md2 = malloc(req->actions.push_nsh._present.md2_len);
	memcpy(req->actions.push_nsh.md2, md2, req->actions.push_nsh._present.md2_len);
}
static inline void
ovs_flow_new_req_set_actions_pop_nsh(struct ovs_flow_new_req *req)
{
	req->_present.actions = 1;
	req->actions._present.pop_nsh = 1;
}
static inline void
ovs_flow_new_req_set_actions_meter(struct ovs_flow_new_req *req, __u32 meter)
{
	req->_present.actions = 1;
	req->actions._present.meter = 1;
	req->actions.meter = meter;
}
static inline void
ovs_flow_new_req_set_actions_check_pkt_len_pkt_len(struct ovs_flow_new_req *req,
						   __u16 pkt_len)
{
	req->_present.actions = 1;
	req->actions._present.check_pkt_len = 1;
	req->actions.check_pkt_len._present.pkt_len = 1;
	req->actions.check_pkt_len.pkt_len = pkt_len;
}
static inline void
ovs_flow_new_req_set_actions_add_mpls(struct ovs_flow_new_req *req,
				      const void *add_mpls, size_t len)
{
	req->_present.actions = 1;
	free(req->actions.add_mpls);
	req->actions._present.add_mpls_len = len;
	req->actions.add_mpls = malloc(req->actions._present.add_mpls_len);
	memcpy(req->actions.add_mpls, add_mpls, req->actions._present.add_mpls_len);
}
static inline void
ovs_flow_new_req_set_actions_psample_group(struct ovs_flow_new_req *req,
					   __u32 group)
{
	req->_present.actions = 1;
	req->actions._present.psample = 1;
	req->actions.psample._present.group = 1;
	req->actions.psample.group = group;
}
static inline void
ovs_flow_new_req_set_actions_psample_cookie(struct ovs_flow_new_req *req,
					    const void *cookie, size_t len)
{
	req->_present.actions = 1;
	req->actions._present.psample = 1;
	free(req->actions.psample.cookie);
	req->actions.psample._present.cookie_len = len;
	req->actions.psample.cookie = malloc(req->actions.psample._present.cookie_len);
	memcpy(req->actions.psample.cookie, cookie, req->actions.psample._present.cookie_len);
}

/*
 * Create OVS flow configuration in a data path
 */
int ovs_flow_new(struct ynl_sock *ys, struct ovs_flow_new_req *req);

#endif /* _LINUX_OVS_FLOW_GEN_H */
