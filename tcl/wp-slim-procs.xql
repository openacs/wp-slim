<?xml version="1.0"?>
<queryset>

<fullquery name="wp_header.get_style_data">      
      <querytext>

	select * from wp_styles where style_id = :style_id      

      </querytext>
</fullquery>

 
<fullquery name="wp_check_style_authorization.wp_style_owner_select">      
      <querytext>

	select owner from wp_styles where style_id = :style_id

      </querytext>
</fullquery>

</queryset>
