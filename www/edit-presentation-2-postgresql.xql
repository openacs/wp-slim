<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="update_wp_presentation">      
      <querytext>

	select wp_presentation__new_revision(
		now(),
		:user_id,
      		:creation_ip,
		:pres_item_id,
      		:pres_title,
		:page_signature,
		:copyright_notice,
		:style,
		:public_p,
		:show_modified_p,
		:audience,
		:background
      	);
    
      </querytext>
</fullquery>

 
<fullquery name="grant_public_read">      
      <querytext>

	select
acs_permission__grant_permission(:pres_item_id,acs__magic_object_id('the_public'),'wp_view_presentation');
    
      </querytext>
</fullquery>

 
<fullquery name="grant_public_read">      
      <querytext>
  
	select
acs_permission__grant_permission(:pres_item_id,acs__magic_object_id('the_public'),'wp_view_presentation');  

      </querytext>
</fullquery>

 
</queryset>
