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

 
<fullquery name="info_get">      
      <querytext>
      
    select i.live_revision, x.display
    from cr_items i, cr_wp_attachments x
    where x.attach_id = i.live_revision
    and   i.item_id = :attach_item_id

      </querytext>
</fullquery>

 
</queryset>
