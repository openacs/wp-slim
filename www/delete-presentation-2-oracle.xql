<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="delete_presentation">      
      <querytext>
      
	begin
  	  wp_presentation.del(:pres_item_id);
	end;
    
      </querytext>
</fullquery>

 
</queryset>
