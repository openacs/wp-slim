<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

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
      parent_id       => :package_id
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

 
</queryset>
