<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="delete_slide">      
      <querytext>
	select wp_slide__delete(:slide_item_id);
 

    </querytext>
</fullquery>

 
</queryset>
