<?xml version="1.0"?>

<queryset>

<fullquery name="image_data">
   <querytext>
      insert into cr_wp_image_attachments
        (attach_id, display)
      values
        (:revision_id, :display)
   </querytext>
</fullquery>

<fullquery name="file_data">
   <querytext>
      insert into cr_wp_file_attachments
        (attach_id)
      values
        (:revision_id)
   </querytext>
</fullquery>

</queryset>
