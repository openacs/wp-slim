<?xml version="1.0"?>

<queryset>

<fullquery name="wp_style_img_insert">      
      <querytext>

    insert into wp_style_images(style_id, file_size, file_name, wp_style_images_id)
    values(:style_id, :n_bytes, :client_filename, :revision_id)

      </querytext>
</fullquery>

<fullquery name="get_bg_image_id">      
      <querytext>

	select background_image from wp_styles where style_id = :style_id

      </querytext>
</fullquery>

<fullquery name="update_bg_image">      
      <querytext>

	update wp_styles set background_image = :revision_id where style_id = :style_id

      </querytext>
</fullquery>

 
</queryset>
