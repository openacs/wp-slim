# /packages/wp/www/presentation-top.tcl

ad_page_contract {
    
    This file show s a top level view of a presentation.
    From here the owner should be able to click on edit links fo slides,
    add new slides, and changes the permissions of who can edit/view the presentation.

    @author Paul Konigsberg (paulk@arsdigita.com)
    @creation-date Thu Nov 30 10:38:10 2000
    @cvs-id $Id$
} {
    pres_item_id:naturalnum
} -properties {
    nav_bar
    slides:multirow
    viewers:multirow
    public_p
    presentation_title
    pres_item_id
    subsite_name
}

ad_require_permission $pres_item_id wp_edit_presentation

set user_id [ad_verify_and_get_user_id]

db_1row get_presentaiton {
select p.public_p,
       p.pres_title as presentation_title,
       acs_permission.permission_p(:pres_item_id, :user_id, 'wp_admin_presentation') as admin_p,
       acs_permission.permission_p(:pres_item_id, :user_id, 'wp_delete_presentation') as delete_p,
       ao.creation_user
from cr_wp_presentations p,
     cr_items i,
     acs_objects ao
where i.item_id = :pres_item_id
and   i.live_revision = p.presentation_id
and   ao.object_id = :pres_item_id
}

set encoded_title [ns_urlencode $presentation_title]
set nav_bar [ad_context_bar [list "$presentation_title"]]
set subsite_name [ad_conn package_url]

db_multirow slides get_slides {
select s.sort_key, s.slide_title, i.item_id as slide_item_id
from cr_wp_slides s,
     cr_items i
where i.parent_id = :pres_item_id
and   i.live_revision = s.slide_id
order by s.sort_key
}

db_multirow viewers get_viewers {
    select first_names || ' ' || last_name as full_name,
           person_id,
           acs_permission.permission_p(:pres_item_id, person_id, 'wp_view_presentation') as view_p,
           acs_permission.permission_p(:pres_item_id, person_id, 'wp_edit_presentation') as edit_p,
           acs_permission.permission_p(:pres_item_id, person_id, 'wp_admin_presentation') as admin_p
    from persons
    where acs_permission.permission_p(:pres_item_id, person_id, 'wp_view_presentation') = 't'
    or    acs_permission.permission_p(:pres_item_id, person_id, 'wp_edit_presentation') = 't'
    or    acs_permission.permission_p(:pres_item_id, person_id, 'wp_admin_presentation') = 't'
}

#set public_p [db_string get_permissions {
#select decode(count(1),1,'The Public','')
#from acs_permissions
#where object_id = acs.magic_object_id('default_context')
#and   privilege = 'wp_view_presentation' 
#and   grantee_id = acs.magic_object_id('the_public')
#}]


ad_return_template