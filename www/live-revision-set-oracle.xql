<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="live_revision_set">      
      <querytext>
      
    begin
      content_item.set_live_revision(:revision_id);
    end;

      </querytext>
</fullquery>

 
</queryset>
