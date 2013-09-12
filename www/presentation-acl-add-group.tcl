# /packages/wp/www/presentation-acl-add-group.tcl

ad_page_contract {

    This page displays a list of groups. The admin can grant certain privilege
    to one group at a time.

    @author Haolan Qin (hqin@arsdigita.com)
    @creation-date 01/22/2001
    @cvs-id $Id$
} {
    pres_item_id:naturalnum,notnull
    role:notnull
    title:notnull
} -properties {
    context
    pres_item_id
    role
    groups:multirow
}

permission::require_permission -object_id $pres_item_id -privilege wp_admin_presentation

set context [list [list "presentation-top?[export_vars -url {pres_item_id}]" "$title"] [list "presentation-acl?[export_vars -url {pres_item_id}]" "[_ wp-slim.Authorization]"] "[_ wp-slim.Add_Group]"]

db_multirow groups groups_get {
    select group_id, group_name
    from groups
    order by group_name
}

ad_return_template
