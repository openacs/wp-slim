<?xml version="1.0"?>
<queryset>

<fullquery name="get_number_of_attachments">      
      <querytext>
      
	select count(1) 
	from cr_items
        where content_type in ('cr_wp_image_attachment', 'cr_wp_file_attachment')
	and   parent_id = :slide_item_id
    
      </querytext>
</fullquery>

 
<fullquery name="get_presentation">      
      <querytext>
      
select pres_title
from cr_wp_presentations p,
     cr_items i
where i.item_id = :pres_item_id
and   i.live_revision = p.presentation_id

      </querytext>
</fullquery>

</queryset>
