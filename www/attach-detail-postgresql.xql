<?xml version="1.0"?>
<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="info_get">      
      <querytext>
         select revision_id, display, mime_type
         from (select r.revision_id, r.mime_type
               from cr_items i, cr_revisions r
               where i.item_id = :attach_item_id and i.live_revision = r.revision_id) current
              left join cr_wp_image_attachments on (current.revision_id = attach_id)
      </querytext>
</fullquery>
 
</queryset>
