<?xml version="1.0"?>
<queryset>
  
<fullquery name="get_attachments">      
  <querytext>
    select live_revision as attach_id, display, name as file_name
    from (select live_revision, name
          from cr_items
          where parent_id = :slide_item_id and
                content_type in ('cr_wp_image_attachment', 'cr_wp_file_attachment')
          ) a
    left join cr_wp_image_attachments on (a.live_revision = attach_id)
  </querytext>
</fullquery>
 
</queryset>
