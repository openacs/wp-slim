# /wp/style-view.tcl
ad_page_contract {
    Allows the user to view a style.
    @creation-date  28 Nov 1999
    @author Jon Salz <jsalz@mit.edu>
    @author Rocael HR <roc@viaro.net>   
    @param style_id (if editing)
    @param presentation_id (if we were editing a presentation)
} {
    style_id:integer,optional
    presentation_id:naturalnum,optional
}

set user_id [ad_verify_and_get_user_id]

wp_check_style_authorization $style_id $user_id

db_1row style_select { *SQL* }

set url_vars "[export_url_vars style_id presentation_id]"

if { $background_color == "" } {
    set bgcolor_str ""
} else {
    set bgcolor_str "bgcolor=[ad_color_to_hex $background_color]"
}
if { $background_image == "" } {
    set bgimage_str ""
} else {
    # this needs to be modified in order to handle the background images!!
    set bgimage_str "style=\"background-image: url(view-image?revision_id=$background_image)\""
}

foreach property { text_color link_color alink_color vlink_color } {
    if { [set $property] == "" } {
	set "${property}_font" ""
	set "${property}_font_end" ""
    } else {
	set "${property}_font" "<font color=[ad_color_to_hex [set $property]]>"
	set "${property}_font_end" "</font>"
    }
}

# set the return link to the presentation we were editing, if id exists
if { [exists_and_not_null presentation_id] } {
    set last_link " [list "presentation-top?pres_item_id=$presentation_id" "[db_string pres_name_select "select title from cr_wp_presentations where presentation_id = :presentation_id"]"]"
} else {
set last_link [list "style-list?user_id=$user_id" "Your Styles"]
}

set context [list $last_link "One Style"]

set export_form_vars "[export_form_vars style_id presentation_id]"

db_multirow style_images style_image_select { *SQL* } {

    set file_size "[format "%.1f" [expr $file_size / 1024.0]]K"
}

db_release_unused_handles


ad_return_template
