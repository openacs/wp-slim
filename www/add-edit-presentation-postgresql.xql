<?xml version="1.0"?>
<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>
    <fullquery name="wp_styles">      
        <querytext>
            select (case when owner = :user_id then name || ' (yours)' else name end) as name, style_id
            from wp_styles
            where owner = :user_id
            or public_p = 't'
            order by name
        </querytext>
    </fullquery>

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
      	    ) from dual
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

    <fullquery name="revoke_public_read">      
        <querytext>
    	   select
           acs_permission__revoke_permission(:pres_item_id,acs__magic_object_id('the_public'),'wp_view_presentation');  
        </querytext>
    </fullquery>

    <fullquery name="get_presentation_data">      
        <querytext>
            select p.pres_title, p.page_signature, p.copyright_notice, p.public_p, style,
	    p.show_modified_p from cr_wp_presentations p, cr_items i
	    where i.item_id = :pres_item_id
            and i.live_revision = p.presentation_id
        </querytext>
    </fullquery>

    <fullquery name="get_aud_data">
        <querytext>
            select content as audience
            from cr_revisions, cr_items
	    where cr_items.content_type = 'cr_wp_presentation_aud' 
    	    and cr_items.parent_id = :pres_item_id
    	    and cr_revisions.revision_id = cr_items.live_revision
        </querytext>
    </fullquery>

    <fullquery name="get_back_data">
        <querytext>
            select content as background   
    	    from cr_revisions r, cr_items i
	    where i.content_type = 'cr_wp_presentation_back' 
	    and i.parent_id = :pres_item_id
	    and r.revision_id = i.live_revision 
        </querytext>
    </fullquery>

</queryset>
