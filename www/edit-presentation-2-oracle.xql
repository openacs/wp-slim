<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

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
          acs_permission.grant_permission(:pres_item_id,acs.magic_object_id('the_public'),'wp_view_presentation');
        end;
    
      </querytext>
</fullquery>

 
<fullquery name="grant_public_read">      
      <querytext>
      
        begin
          acs_permission.grant_permission(:pres_item_id,acs.magic_object_id('the_public'),'wp_view_presentation');
        end;
    
      </querytext>
</fullquery>

 
</queryset>
