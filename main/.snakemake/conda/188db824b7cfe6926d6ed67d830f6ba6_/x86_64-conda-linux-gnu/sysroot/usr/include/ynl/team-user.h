/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
/* Do not edit directly, auto-generated from: */
/*	Documentation/netlink/specs/team.yaml */
/* YNL-GEN user header */

#ifndef _LINUX_TEAM_GEN_H
#define _LINUX_TEAM_GEN_H

#include <stdlib.h>
#include <string.h>
#include <linux/types.h>
#include <linux/if_team.h>

struct ynl_sock;

extern const struct ynl_family ynl_team_family;

/* Enums */
const char *team_op_str(int op);

/* Common nested types */
struct team_attr_option {
	struct {
		__u32 name_len;
		__u32 changed:1;
		__u32 type:1;
		__u32 data_len;
		__u32 removed:1;
		__u32 port_ifindex:1;
		__u32 array_index:1;
	} _present;

	char *name;
	__u8 type;
	void *data;
	__u32 port_ifindex;
	__u32 array_index;
};

struct team_attr_port {
	struct {
		__u32 ifindex:1;
		__u32 changed:1;
		__u32 linkup:1;
		__u32 speed:1;
		__u32 duplex:1;
		__u32 removed:1;
	} _present;

	__u32 ifindex;
	__u32 speed;
	__u8 duplex;
};

struct team_item_option {
	struct {
		__u32 option:1;
	} _present;

	struct team_attr_option option;
};

struct team_item_port {
	struct {
		__u32 port:1;
	} _present;

	struct team_attr_port port;
};

/* ============== TEAM_CMD_NOOP ============== */
/* TEAM_CMD_NOOP - do */

struct team_noop_rsp {
	struct {
		__u32 team_ifindex:1;
	} _present;

	__u32 team_ifindex;
};

void team_noop_rsp_free(struct team_noop_rsp *rsp);

/*
 * No operation
 */
struct team_noop_rsp *team_noop(struct ynl_sock *ys);

/* ============== TEAM_CMD_OPTIONS_SET ============== */
/* TEAM_CMD_OPTIONS_SET - do */
struct team_options_set_req {
	struct {
		__u32 team_ifindex:1;
		__u32 list_option:1;
	} _present;

	__u32 team_ifindex;
	struct team_item_option list_option;
};

static inline struct team_options_set_req *team_options_set_req_alloc(void)
{
	return calloc(1, sizeof(struct team_options_set_req));
}
void team_options_set_req_free(struct team_options_set_req *req);

static inline void
team_options_set_req_set_team_ifindex(struct team_options_set_req *req,
				      __u32 team_ifindex)
{
	req->_present.team_ifindex = 1;
	req->team_ifindex = team_ifindex;
}
static inline void
team_options_set_req_set_list_option_option_name(struct team_options_set_req *req,
						 const char *name)
{
	req->_present.list_option = 1;
	req->list_option._present.option = 1;
	free(req->list_option.option.name);
	req->list_option.option._present.name_len = strlen(name);
	req->list_option.option.name = malloc(req->list_option.option._present.name_len + 1);
	memcpy(req->list_option.option.name, name, req->list_option.option._present.name_len);
	req->list_option.option.name[req->list_option.option._present.name_len] = 0;
}
static inline void
team_options_set_req_set_list_option_option_changed(struct team_options_set_req *req)
{
	req->_present.list_option = 1;
	req->list_option._present.option = 1;
	req->list_option.option._present.changed = 1;
}
static inline void
team_options_set_req_set_list_option_option_type(struct team_options_set_req *req,
						 __u8 type)
{
	req->_present.list_option = 1;
	req->list_option._present.option = 1;
	req->list_option.option._present.type = 1;
	req->list_option.option.type = type;
}
static inline void
team_options_set_req_set_list_option_option_data(struct team_options_set_req *req,
						 const void *data, size_t len)
{
	req->_present.list_option = 1;
	req->list_option._present.option = 1;
	free(req->list_option.option.data);
	req->list_option.option._present.data_len = len;
	req->list_option.option.data = malloc(req->list_option.option._present.data_len);
	memcpy(req->list_option.option.data, data, req->list_option.option._present.data_len);
}
static inline void
team_options_set_req_set_list_option_option_removed(struct team_options_set_req *req)
{
	req->_present.list_option = 1;
	req->list_option._present.option = 1;
	req->list_option.option._present.removed = 1;
}
static inline void
team_options_set_req_set_list_option_option_port_ifindex(struct team_options_set_req *req,
							 __u32 port_ifindex)
{
	req->_present.list_option = 1;
	req->list_option._present.option = 1;
	req->list_option.option._present.port_ifindex = 1;
	req->list_option.option.port_ifindex = port_ifindex;
}
static inline void
team_options_set_req_set_list_option_option_array_index(struct team_options_set_req *req,
							__u32 array_index)
{
	req->_present.list_option = 1;
	req->list_option._present.option = 1;
	req->list_option.option._present.array_index = 1;
	req->list_option.option.array_index = array_index;
}

struct team_options_set_rsp {
	struct {
		__u32 team_ifindex:1;
		__u32 list_option:1;
	} _present;

	__u32 team_ifindex;
	struct team_item_option list_option;
};

void team_options_set_rsp_free(struct team_options_set_rsp *rsp);

/*
 * Set team options
 */
struct team_options_set_rsp *
team_options_set(struct ynl_sock *ys, struct team_options_set_req *req);

/* ============== TEAM_CMD_OPTIONS_GET ============== */
/* TEAM_CMD_OPTIONS_GET - do */
struct team_options_get_req {
	struct {
		__u32 team_ifindex:1;
	} _present;

	__u32 team_ifindex;
};

static inline struct team_options_get_req *team_options_get_req_alloc(void)
{
	return calloc(1, sizeof(struct team_options_get_req));
}
void team_options_get_req_free(struct team_options_get_req *req);

static inline void
team_options_get_req_set_team_ifindex(struct team_options_get_req *req,
				      __u32 team_ifindex)
{
	req->_present.team_ifindex = 1;
	req->team_ifindex = team_ifindex;
}

struct team_options_get_rsp {
	struct {
		__u32 team_ifindex:1;
		__u32 list_option:1;
	} _present;

	__u32 team_ifindex;
	struct team_item_option list_option;
};

void team_options_get_rsp_free(struct team_options_get_rsp *rsp);

/*
 * Get team options info
 */
struct team_options_get_rsp *
team_options_get(struct ynl_sock *ys, struct team_options_get_req *req);

/* ============== TEAM_CMD_PORT_LIST_GET ============== */
/* TEAM_CMD_PORT_LIST_GET - do */
struct team_port_list_get_req {
	struct {
		__u32 team_ifindex:1;
	} _present;

	__u32 team_ifindex;
};

static inline struct team_port_list_get_req *team_port_list_get_req_alloc(void)
{
	return calloc(1, sizeof(struct team_port_list_get_req));
}
void team_port_list_get_req_free(struct team_port_list_get_req *req);

static inline void
team_port_list_get_req_set_team_ifindex(struct team_port_list_get_req *req,
					__u32 team_ifindex)
{
	req->_present.team_ifindex = 1;
	req->team_ifindex = team_ifindex;
}

struct team_port_list_get_rsp {
	struct {
		__u32 team_ifindex:1;
		__u32 list_port:1;
	} _present;

	__u32 team_ifindex;
	struct team_item_port list_port;
};

void team_port_list_get_rsp_free(struct team_port_list_get_rsp *rsp);

/*
 * Get team ports info
 */
struct team_port_list_get_rsp *
team_port_list_get(struct ynl_sock *ys, struct team_port_list_get_req *req);

#endif /* _LINUX_TEAM_GEN_H */
