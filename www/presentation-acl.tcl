# /packages/wp/www/presentation-acl.tcl

ad_page_contract {

    This page displays a UI to change authorization to a presentation

    @author Haolan Qin (hqin@arsdigita.com)
    @creation-date 01/17/2001
    @cvs-id $Id$
} {
    pres_item_id:naturalnum,notnull
} -properties {
    context
    public_p
    presentation_title
    pres_item_id
}

set user_id [ad_conn user_id]
permission::require_permission -party_id $user_id -object_id $pres_item_id -privilege wp_admin_presentation


db_1row get_presentaiton {
select p.pres_title as title,
       p.public_p,
       ao.creation_user
from cr_wp_presentations p,
     cr_items i,
     acs_objects ao
where i.item_id = :pres_item_id
and   i.live_revision = p.presentation_id
and   ao.object_id = i.item_id
}

set encoded_title [ns_urlencode $title]

set context [list [list [export_vars -base presentation-top {pres_item_id}] "$title"] "[_ wp-slim.Authorization]"]



#set page_output "[wp_header_form "name=f" \
#           [list "" "WimpyPoint"] [list "index?show_user=" "Your Presentations"] \
#           [list "presentation-top?pres_item_id=$pres_item_id" "$title"] "Authorization"]
#
#"


db_multirow read_users read_users_get {
    select p.person_id,
           p.first_names,
           p.last_name
    from persons p,
         acs_permissions perm
    where perm.object_id = :pres_item_id
    and   perm.grantee_id = p.person_id
    and   perm.privilege = 'wp_view_presentation'
}

db_multirow write_users write_users_get {
    select p.person_id,
           p.first_names,
           p.last_name
    from persons p,
         acs_permissions perm
    where perm.object_id = :pres_item_id
    and   perm.grantee_id = p.person_id
    and   perm.privilege = 'wp_edit_presentation'
}

db_multirow admin_users admin_users_get {
    select p.person_id,
           p.first_names,
           p.last_name
    from persons p,
         acs_permissions perm
    where perm.object_id = :pres_item_id
    and   perm.grantee_id = p.person_id
    and   perm.privilege = 'wp_admin_presentation'
}

db_release_unused_handles

ad_return_template
