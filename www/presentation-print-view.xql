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

<fullquery name="get_owner_name">      
  <querytext>
    select first_names || ' ' || last_name as owner_name, person_id as owner_id
    from persons, acs_objects
    where persons.person_id = acs_objects.creation_user
    and acs_objects.object_id = :pres_item_id
  </querytext>
</fullquery>

<fullquery name="get_presentation_data">      
  <querytext>
    select p.pres_title, p.page_signature, p.style, p.copyright_notice, p.public_p, p.show_modified_p 
    from cr_wp_presentations p, cr_items i
    where i.item_id = :pres_item_id
    and   i.live_revision = p.presentation_id
  </querytext>
</fullquery>

<fullquery name="get_aud_data">      
  <querytext>
    select name as audience
    from cr_revisions, cr_items
    where cr_items.content_type = 'cr_wp_presentation_aud'
    and cr_items.parent_id = :pres_item_id
    and cr_revisions.revision_id = cr_items.live_revision
  </querytext>
</fullquery>

<fullquery name="get_back_data">      
  <querytext>
    select name as background
    from cr_revisions r, cr_items i
    where i.content_type = 'cr_wp_presentation_back'
    and i.parent_id = :pres_item_id
    and r.revision_id = i.live_revision
  </querytext>
</fullquery>

<fullquery name="get_slide_info">      
  <querytext>
    select s.slide_title as title ,
     	i.item_id as slide_id ,
	s.sort_key,wp_slide__get_preamble(i.item_id) as preamble,
    	wp_slide__get_postamble(i.item_id) as postamble,
    	wp_slide__get_bullet_items(i.item_id) as bullet_list
    from cr_wp_slides s, cr_items i
    where i.parent_id = :pres_item_id
   	and   i.live_revision = s.slide_id
    order by s.sort_key
  </querytext>
</fullquery>

</queryset>
