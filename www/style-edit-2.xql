<?xml version="1.0"?>
<queryset>

<fullquery name="update_style">      
      <querytext>
      
	update wp_styles set name = :name, css = :css, text_color = :text_color, 
	background_color = :background_color, background_image = :background_image, 
	link_color = :link_color, alink_color = :alink_color, 
	vlink_color = :vlink_color, public_p = :public_p 
	where style_id = :style_id 

      </querytext>
</fullquery>

 
<fullquery name="insert_style">      
      <querytext>
      
	insert into wp_styles 
	(style_id, name, css, text_color, background_color, background_image, 
	link_color, alink_color, vlink_color, public_p, owner) 
	values (:style_id, :name, :css, :text_color, :background_color, :background_image, 
	:link_color, :alink_color, :vlink_color, :public_p, :user_id) 

      </querytext>
</fullquery>

<fullquery name="pres_update">      
      <querytext>
      
	update cr_wp_presentations set style = :style_id where presentation_id = :presentation_id

      </querytext>
</fullquery>
 
</queryset>
