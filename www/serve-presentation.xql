<?xml version="1.0"?>
<queryset>

<fullquery name="get_first_slide_item_id">      
      <querytext>
      
    select item_id as first_slide_item_id
    from cr_items
    where content_type = 'cr_wp_slide'
    and   parent_id    = :pres_item_id
    and   exists (select 1 from cr_wp_slides s where s.slide_id=cr_items.live_revision and s.sort_key=1)

      </querytext>
</fullquery>

 
<fullquery name="get_presentation_info">      
      <querytext>
      
    select p.pres_title, p.page_signature, p.style, p.copyright_notice
    from cr_wp_presentations p, cr_items i
    where i.item_id = :pres_item_id
    and   i.live_revision = p.presentation_id

      </querytext>
</fullquery>

 
<fullquery name="get_owner_name">      
      <querytext>
      
    select first_names || ' ' || last_name as owner_name, person_id as owner_id
    from persons, acs_objects
    where persons.person_id = acs_objects.creation_user
    and acs_objects.object_id = :pres_item_id

      </querytext>
</fullquery>

 
<fullquery name="get_slides">      
      <querytext>
      
select s.slide_title, '$subsite_name/display/$pres_item_id/' || i.item_id || '.wimpy' as url
from cr_wp_slides s, cr_items i
where i.parent_id = :pres_item_id
and   i.live_revision = s.slide_id
order by s.sort_key

      </querytext>
</fullquery>


<fullquery name="get_collaborators">      
      <querytext>
      
    select p.person_id,
           p.first_names || ' ' || p.last_name as full_name,
           perm.privilege
    from persons p,
         acs_permissions perm
    where perm.object_id = :pres_item_id
    and   perm.grantee_id <> :owner_id
    and   perm.grantee_id = p.person_id
    and
    ( perm.privilege = 'wp_edit_presentation'
     or perm.privilege = 'wp_admin_presentation'
    ) 
    order by p.person_id, perm.privilege ASC


      </querytext>
</fullquery>
 
</queryset>
