<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="wp_presentation_insert">      
      <querytext>

  select wp_presentation__new(
       	now(),  	
    	:user_id,
      	:creation_ip,
      	:pres_title,
     	:page_signature,
	:copyright_notice,
      	:style,
      	:public_p,
      	:show_modified_p,
      	:audience,
      	:background,
	:package_id,
	:package_id
      );

      </querytext>
</fullquery>

<fullquery name="grant_owner_access">      
      <querytext>
         begin
           perform acs_permission__grant_permission(:pres_item_id,:user_id,'wp_admin_presentation');
           perform acs_permission__grant_permission(:pres_item_id,:user_id,'wp_view_presentation');
           perform acs_permission__grant_permission(:pres_item_id,:user_id,'wp_edit_presentation');
           perform acs_permission__grant_permission(:pres_item_id,:user_id,'wp_delete_presentation');
           return 0;
         end;
      </querytext>
</fullquery>

 
<fullquery name="make_wp_presentation_public">      
      <querytext>
         select acs_permission__grant_permission(:pres_item_id,acs__magic_object_id('the_public'),'wp_view_presentation');
      </querytext>
</fullquery>

 
</queryset>
