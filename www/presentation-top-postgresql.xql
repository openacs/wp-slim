<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="get_presentaiton">      
      <querytext>
      
select p.public_p,
       p.pres_title as presentation_title,
       acs_permission__permission_p(:pres_item_id, :user_id, 'wp_admin_presentation') as admin_p,
       acs_permission__permission_p(:pres_item_id, :user_id, 'wp_delete_presentation') as delete_p,
       ao.creation_user
from cr_wp_presentations p,
     cr_items i,
     acs_objects ao
where i.item_id = :pres_item_id
and   i.live_revision = p.presentation_id
and   ao.object_id = :pres_item_id

      </querytext>
</fullquery>

 
<fullquery name="get_viewers">      
      <querytext>
      
    select first_names || ' ' || last_name as full_name,
           person_id,
           acs_permission__permission_p(:pres_item_id, person_id, 'wp_view_presentation') as view_p,
           acs_permission__permission_p(:pres_item_id, person_id, 'wp_edit_presentation') as edit_p,
           acs_permission__permission_p(:pres_item_id, person_id, 'wp_admin_presentation') as admin_p
    from persons
    where acs_permission__permission_p(:pres_item_id, person_id, 'wp_view_presentation') = 't'
    or    acs_permission__permission_p(:pres_item_id, person_id, 'wp_edit_presentation') = 't'
    or    acs_permission__permission_p(:pres_item_id, person_id, 'wp_admin_presentation') = 't'

      </querytext>
</fullquery>

 
</queryset>
