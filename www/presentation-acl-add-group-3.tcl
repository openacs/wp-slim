# /packages/wp/www/presentation-acl-add-group-3.tcl

ad_page_contract {

    This file grants a group of users certain permission.

    @author Haolan Qin (hqin@arsdigita.com)
    @creation-date 01/22/2001
    @cvs-id $Id$
} {
    pres_item_id:naturalnum,notnull
    role:notnull
    group_id:integer,notnull
}

ad_require_permission $pres_item_id wp_admin_presentation

# adds a group of users
db_foreach group_grant { *SQL } {
    if {$role == "write"} {
	set permission "wp_edit_presentation"
    } elseif {$role == "admin"} {
	set permission "wp_admin_presentation"
    } else {
	set permission "wp_view_presentation"
    }
    db_exec_plsql permission_grant { *SQL }
}

ad_returnredirect presentation-acl?[export_url_vars pres_item_id]
