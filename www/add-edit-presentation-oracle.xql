<?xml version="1.0"?>
<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>
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
	     begin        
      		:1 := wp_presentation.new(
      		creation_user    => :user_id,
		creation_ip      => :creation_ip,
		creation_date    => sysdate,
      		pres_title       => :pres_title,
      		page_signature   => :page_signature,
      		copyright_notice => :copyright_notice,
      		style            => :style,
      		public_p         => :public_p,
      		show_modified_p  => :show_modified_p,
      		audience         => :audience,
      		background       => :background,
      		parent_id       => :package_id,
		package_id       => :package_id
      	 	);
	    end;
        </querytext>
    </fullquery>

    <fullquery name="grant_owner_access">      
        <querytext>
            begin
                acs_permission.grant_permission(:pres_item_id,:user_id,'wp_admin_presentation');
           	acs_permission.grant_permission(:pres_item_id,:user_id,'wp_view_presentation');
           	acs_permission.grant_permission(:pres_item_id,:user_id,'wp_edit_presentation');
          	acs_permission.grant_permission(:pres_item_id,:user_id,'wp_delete_presentation');
            end;
        </querytext>
    </fullquery>

    <fullquery name="make_wp_presentation_public">      
        <querytext>
            begin
                acs_permission.grant_permission(:pres_item_id,acs.magic_object_id('the_public'),'wp_view_presentation');
            end;
        </querytext>
    </fullquery>

    <fullquery name="update_wp_presentation">      
        <querytext>
	    begin
      		wp_presentation.new_revision(
		creation_user    => :user_id,
      		creation_ip      => :creation_ip,
      		creation_date    => sysdate,
      		pres_item_id     => :pres_item_id,
      		pres_title       => :pres_title,
      		page_signature   => :page_signature,
      		copyright_notice => :copyright_notice,
      		public_p         => :public_p,
      		show_modified_p  => :show_modified_p,
      		style            => :style,
      		audience         => :audience,
      		background       => :background
      		);
    	    end;
        </querytext>
    </fullquery>

    <fullquery name="grant_public_read">      
        <querytext>
  	    begin
                acs_permission.grant_permission(:pres_item_id,acs__magic_object_id('the_public'),'wp_view_presentation');
	    end;
        </querytext>
    </fullquery>

    <fullquery name="revoke_public_read">      
        <querytext>
    	   begin
               acs_permission.revoke_permission(:pres_item_id,acs__magic_object_id('the_public'),'wp_view_presentation');  
           end;
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
