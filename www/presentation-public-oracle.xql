<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

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
