<?xml version="1.0"?>
<queryset>

<fullquery name="get_mime_type">      
      <querytext>
      
select mime_type
from cr_revisions
where revision_id = :attach_id

      </querytext>
</fullquery>

 
</queryset>
