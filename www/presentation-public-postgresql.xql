<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="grant_public_read">      
      <querytext>
	select
acs_permission__grant_permission(:pres_item_id,acs__magic_object_id('the_public'),'wp_view_presentation');
  
      </querytext>
</fullquery>

 
<fullquery name="revoke_public_read">      
      <querytext>
  
	select
acs_permission__revoke_permission(:pres_item_id,acs__magic_object_id('the_public'),'wp_view_presentation');
  
      </querytext>
</fullquery>

 
</queryset>
