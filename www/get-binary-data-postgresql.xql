<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="get_image">      
      <querytext>

select content
from cr_revisions
where revision_id = :attach_id

      </querytext>
</fullquery>

 
</queryset>
