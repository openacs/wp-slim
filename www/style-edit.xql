<?xml version="1.0"?>
<queryset>

<fullquery name="style_select">      
      <querytext>
      
    select  name,
	    css, 
	    text_color, 
	    background_color,
	    background_image,
	    link_color,
	    alink_color,
	    vlink_color,
            public_p
    from wp_styles where style_id = :style_id

      </querytext>
</fullquery>

 
<fullquery name="wp_file_names_select">      
      <querytext>
      
        select wp_style_images_id, file_name
        from wp_style_images
        where style_id = :style_id
        order by file_name

      </querytext>
</fullquery>
 
</queryset>
