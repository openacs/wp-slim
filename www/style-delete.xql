<?xml version="1.0"?>
<queryset>

<fullquery name="wp_style_name_select">      
      <querytext>
      
	select name from wp_styles where style_id = :style_id

      </querytext>
</fullquery>

 
<fullquery name="wp_image_count_select">      
      <querytext>
      
	select count(*) from wp_style_images where style_id = :style_id

      </querytext>
</fullquery>
 
</queryset>
