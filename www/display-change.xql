<?xml version="1.0"?>
<queryset>

<fullquery name="get_mime_type">      
      <querytext>
      
    select mime_type
    from cr_revisions
    where revision_id = :revision_id

      </querytext>
</fullquery>

 
<fullquery name="display_chagne">      
      <querytext>
      
    update cr_wp_attachments
    set display = :display
    where attach_id = :revision_id

      </querytext>
</fullquery>

 
</queryset>
