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
    nav_bar
    pres_item_id
    role
    groups:multirow
}

ad_require_permission $pres_item_id wp_admin_presentation

set nav_bar [ad_context_bar [list "presentation-top?[export_url_vars pres_item_id]" "$title"] [list "presentation-acl?[export_url_vars pres_item_id]" "Authorization"] "Add Group"]

db_multirow groups groups_get {
    select group_id, group_name
    from groups
    order by group_name
}

ad_return_template