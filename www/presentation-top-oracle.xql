<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_presentation">      
      <querytext>
      
select p.public_p,
       p.pres_title as presentation_title,
       acs_permission.permission_p(:pres_item_id, :user_id, 'wp_admin_presentation') as admin_p,
       acs_permission.permission_p(:pres_item_id, :user_id, 'wp_delete_presentation') as delete_p,
       ao.creation_user,
       p.show_comments_p,
       p.presentation_id
from cr_wp_presentations p,
     cr_items i,
     acs_objects ao
where i.item_id = :pres_item_id
and   i.live_revision = p.presentation_id
and   ao.object_id = :pres_item_id

      </querytext>
</fullquery>


<fullquery name="get_users">      
      <querytext>
      
    select distinct (p.person_id),
           p.first_names || ' ' || p.last_name as full_name,
           perm.privilege
    from persons p,
         acs_permissions perm
    where perm.object_id = :pres_item_id
    and   perm.grantee_id = p.person_id
    and
    (perm.privilege = 'wp_view_presentation'
     or perm.privilege = 'wp_edit_presentation'
     or perm.privilege = 'wp_admin_presentation'
    )
    order by p.person_id, perm.privilege ASC

      </querytext>
</fullquery>

 
</queryset>
