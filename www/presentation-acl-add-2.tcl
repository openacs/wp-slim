# /packages/wp/www/presentation-acl-add-2.tcl

ad_page_contract {

    This page confirms or cancels an adding action.

    @author Haolan Qin (hqin@arsdigita.com)
    @creation-date 01/22/2001
    @cvs-id $Id$
} {
    pres_item_id:naturalnum,notnull
    role:notnull
    title:notnull
    user_id_from_search:naturalnum,notnull
    first_names_from_search
    last_name_from_search
    email_from_search:notnull
} -properties {
    context
    pres_item_id
    role
}

ad_require_permission $pres_item_id wp_admin_presentation

set context [list [list "presentation-top?[export_url_vars pres_item_id]" "$title"] [list "presentation-acl?[export_url_vars pres_item_id]" "[_ wp-slim.Authorization]"] "[_ wp-slim.Confirm_Add_User]"]


set privilege [ad_decode $role "read" "wp_view_presentation" "write" "wp_edit_presentation" "admin" "wp_admin_presentation" ""]

if [db_0or1row privilege_check {
    select 1
    from acs_permissions
    where object_id = :pres_item_id
    and   grantee_id = :user_id_from_search
    and   privilege = :privilege
}] {
    set vars [export_url_vars pres_item_id]
    ad_return_error "[_ wp-slim.lt_User_Already_Had_That]" "[_ wp-slim.lt_That_user_can_already]"
    db_release_unused_handles
    return
}

db_release_unused_handles

ad_return_template
