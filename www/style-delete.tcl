# /wp-slim/www/style-delete.tcl

ad_page_contract {
    Description: Confirms that the user wants to delete the style.
    
    @param style_id

    @creation-date  28 Nov 1999
    @author Jon Salz (jsalz@mit.edu)
    @author Rocael HR (roc@viaro.net) Ported & modified
} {
    style_id:naturalnum,notnull
}


set user_id [ad_verify_and_get_user_id]

wp_check_style_authorization $style_id $user_id

# Get the style information to display a confirmation message.
set name [db_string wp_style_name_select { *SQL* }]
set context [list "[list "style-list.tcl" "[_ wp-slim.Your_Styles]"]" "[_ wp-slim.Delete_name]"]

set num_images [db_string wp_image_count_select { *SQL* }]
if { $num_images == 0 } {
    set images_str ""
} elseif { $num_images == 1 } {
    set images_str "[_ wp-slim.lt_and_the_associated_im]"
} else {
    set images_str ", [_ wp-slim.lt_including_num_images_]"
}


set form_vars [export_form_vars style_id]

ad_return_template
