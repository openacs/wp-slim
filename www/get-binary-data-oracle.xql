<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_image">      
      <querytext>
      
select content
from cr_revisions
where revision_id = $attach_id

      </querytext>
</fullquery>

 
</queryset>
