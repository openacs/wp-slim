<?xml version="1.0"?>
<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="info_get">      
      <querytext>
         select r.revision_id, a.display, r.mime_type
         from cr_items i, cr_wp_image_attachments a, cr_revisions r
         where i.item_id = :attach_item_id and
             i.live_revision = r.revision_id and
             r.revision_id = a.attach_id(+)
      </querytext>
</fullquery>
 
</queryset>
