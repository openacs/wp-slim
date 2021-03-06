# /packages/wp/www/presentation-acl-add-group-3.tcl

ad_page_contract {

    This file grants a group of users certain permission.

    @author Haolan Qin (hqin@arsdigita.com)
    @creation-date 01/22/2001
    @cvs-id $Id$
} {
    pres_item_id:naturalnum,notnull
    role:notnull
    group_id:naturalnum,notnull
}

permission::require_permission -object_id $pres_item_id -privilege wp_admin_presentation

# adds a group of users
db_foreach group_grant { *SQL } {
    if {$role eq "write"} {
	set permission "wp_edit_presentation"
    } elseif {$role eq "admin"} {
	set permission "wp_admin_presentation"
    } else {
	set permission "wp_view_presentation"
    }
    db_exec_plsql permission_grant { *SQL }
}

ad_returnredirect [export_vars -base presentation-acl {pres_item_id}]
