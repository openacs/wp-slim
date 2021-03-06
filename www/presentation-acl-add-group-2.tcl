# /packages/wp/www/presentation-acl-add-group-2.tcl

ad_page_contract {

    This page displays a list of users in a group. The admin can bulk grant these users
    certain privilege.

    @author Haolan Qin (hqin@arsdigita.com)
    @creation-date 01/22/2001
    @cvs-id $Id$
} {
    pres_item_id:naturalnum,notnull
    role:notnull
    title:notnull
    group_id:naturalnum,notnull
} -properties {
    context
    pres_item_id
    role
    groups:multirow
}

permission::require_permission -object_id $pres_item_id -privilege wp_admin_presentation

set context [list [list [export_vars -base presentation-top {pres_item_id}] "$title"] [list [export_vars -base presentation-acl {pres_item_id}] "[_ wp-slim.Authorization]"] "[_ wp-slim.Confirm_Add_Users]"]

db_multirow group users_get {
    select p.first_names,
           p.last_name
    from persons p,
         group_member_map m
    where m.group_id = :group_id
    and   m.member_id = p.person_id
    order by p.last_name
}

ad_return_template
