<?xml version="1.0"?>
<queryset>

<fullquery name="pres_item_id_get">      
      <querytext>
      
    select parent_id
    from cr_items
    where content_type = 'cr_wp_slide'
    and   item_id = :slide_item_id

      </querytext>
</fullquery>

 
<fullquery name="attachments_get">      
      <querytext>
      
    select name, item_id
    from cr_items
    where content_type = 'cr_wp_attachment'
    and   parent_id = :slide_item_id

      </querytext>
</fullquery>

 
</queryset>
