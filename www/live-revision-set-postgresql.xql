<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="live_revision_set">      
      <querytext>

	select content_item__set_live_revision(:revision_id);

      </querytext>
</fullquery>

 
</queryset>
