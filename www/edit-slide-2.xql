<?xml version="1.0"?>
<queryset>

<fullquery name="get_number_of_attachments">      
      <querytext>
      
	select count(1) 
	from cr_items
        where content_type = 'cr_wp_attachment'
	and   parent_id = :slide_item_id
    
      </querytext>
</fullquery>

 
</queryset>
