<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="revisions_and_item_delete">      
      <querytext>
      
    begin
        wp_attachment.delete(:attach_item_id);
    end;

      </querytext>
</fullquery>

 
</queryset>
