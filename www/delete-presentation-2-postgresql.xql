<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="delete_presentation">      
      <querytext>
  
	select wp_presentation__delete(:pres_item_id);
        
      </querytext>
</fullquery>

 
</queryset>
