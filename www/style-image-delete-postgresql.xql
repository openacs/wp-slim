<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="revisions_and_item_delete">      
      <querytext>
      
	select wp_style__image_delete(:revision_id)

      </querytext>
</fullquery>
 
</queryset>
