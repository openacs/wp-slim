<?xml version="1.0"?>
<queryset>

<fullquery name="get_presentation_page_signature">      
      <querytext>
      
    select p.page_signature,
    p.show_modified_p
    from cr_wp_presentations p, cr_items i
    where i.item_id = :pres_item_id
    and   i.live_revision = p.presentation_id

      </querytext>
</fullquery>

 
<fullquery name="get_previous_slide_item_id">      
      <querytext>
      
	select i.item_id
	from cr_wp_slides s, cr_items i
	where i.parent_id = :pres_item_id
        and   i.live_revision = s.slide_id
	and   s.sort_key = (:sort_key - 1)
    
      </querytext>
</fullquery>

 
<fullquery name="get_next_slide">      
      <querytext>
      
    select i.item_id as next_slide_item_id 
    from cr_wp_slides s, cr_items i 
    where i.parent_id = :pres_item_id
    and   i.live_revision = s.slide_id
    and   s.sort_key = :next_sort_key

      </querytext>
</fullquery>

 
<fullquery name="get_attachments">      
      <querytext>
      
    select x.attach_id as attach_id, x.display, i.name as file_name
    from cr_wp_attachments x, cr_items i
    where i.parent_id = :slide_item_id
    and   i.live_revision = x.attach_id

      </querytext>
</fullquery>

 
</queryset>