<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="revisions_and_item_delete">      
      <querytext>

      	begin
	 wp_style.image_delete( p_revision_id => :revision_id);
	end;

      </querytext>
</fullquery>
 
</queryset>
