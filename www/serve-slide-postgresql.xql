<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="get_slide_info">      
      <querytext>

    select s.slide_title,
    s.sort_key,
    to_char(ao.creation_date, 'HH24:MI, Mon DD, YYYY') as modified_date
    from cr_wp_slides s, cr_items i, acs_objects ao
    where i.item_id = :slide_item_id
    and   i.live_revision = s.slide_id
    and   ao.object_id = s.slide_id

</querytext>
</fullquery>

<fullquery name="get_pre_info">  
      <querytext>

  select content as preamble
  from cr_revisions, cr_items
  where cr_items.content_type = 'cr_wp_slide_preamble'
  and cr_items.parent_id = :slide_item_id
  and cr_revisions.revision_id = cr_items.live_revision

      </querytext>
</fullquery>


<fullquery name="get_pos_info">  
      <querytext>

select content as postamble
  from cr_revisions, cr_items
  where cr_items.content_type = 'cr_wp_slide_postamble'   
  and cr_items.parent_id = :slide_item_id
  and cr_revisions.revision_id = cr_items.live_revision

      </querytext>
</fullquery>


<fullquery name="get_bul_info">  
      <querytext>

select content as bullet_items   
  from cr_revisions, cr_items
  where cr_items.content_type = 'cr_wp_slide_bullet_items'  
  and cr_items.parent_id = :slide_item_id
  and cr_revisions.revision_id = cr_items.live_revision;
 
      </querytext>
</fullquery>

 
</queryset>
