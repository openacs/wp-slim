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

 
</queryset>
