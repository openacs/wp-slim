<?xml version="1.0"?>
<queryset>

<fullquery name="get_presentaiton">      
      <querytext>
      
select p.pres_title as title,
       p.public_p,
       ao.creation_user
from cr_wp_presentations p,
     cr_items i,
     acs_objects ao
where i.item_id = :pres_item_id
and   i.live_revision = p.presentation_id
and   ao.object_id = i.item_id

      </querytext>
</fullquery>

 
<fullquery name="read_users_get">      
      <querytext>
      
    select p.person_id,
           p.first_names,
           p.last_name
    from persons p,
         acs_permissions perm
    where perm.object_id = :pres_item_id
    and   perm.grantee_id = p.person_id
    and   perm.privilege = 'wp_view_presentation'

      </querytext>
</fullquery>

 
<fullquery name="write_users_get">      
      <querytext>
      
    select p.person_id,
           p.first_names,
           p.last_name
    from persons p,
         acs_permissions perm
    where perm.object_id = :pres_item_id
    and   perm.grantee_id = p.person_id
    and   perm.privilege = 'wp_edit_presentation'

      </querytext>
</fullquery>

 
<fullquery name="admin_users_get">      
      <querytext>
      
    select p.person_id,
           p.first_names,
           p.last_name
    from persons p,
         acs_permissions perm
    where perm.object_id = :pres_item_id
    and   perm.grantee_id = p.person_id
    and   perm.privilege = 'wp_admin_presentation'

      </querytext>
</fullquery>

 
</queryset>
