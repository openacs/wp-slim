<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="delete_slide">      
      <querytext>
      
    begin
      wp_slide.del(:slide_item_id);
    end;

      </querytext>
</fullquery>

 
</queryset>
