# /wp-slim/www/style-edit.tcl
ad_page_contract {
    Allows the user to create or edit a style.
    @creation-date  28 Nov 1999
    @author  Jon Salz <jsalz@mit.edu>
    @author Rocael HR <roc@viaro.net>
    @param style_id ID of the style to edit (if editing)
    @param presentation_id ID of the presentation, if we should set a presentation to have this style
} {
    style_id:naturalnum,optional
    presentation_id:naturalnum,optional
}

set user_id [ad_verify_and_get_user_id]

set context {}

if { [info exists style_id] } {
    # Editing an existing style. Make sure we own it, and then retrieve info from the
    # database.
    wp_check_style_authorization $style_id $user_id

    db_1row style_select { *SQL* }


    set header [list "style-view.tcl?style_id=$style_id" $name]

    set role "Edit"
} else {
    # Creating a new style. Set fields to defaults.
    set show_modified_p "f"
    set public_p "t"
    set style -1
    foreach var { name description header text_color background_color background_image link_color alink_color vlink_color css } {
	set $var ""
    }

    set role "Create"
}

set colors { Chartreuse Mauve Teal Oyster Cordova Burgundy Spruce }
set elements { Polka-Dots Hearts {Maple Leaves} Peacocks Bunnies }

if { [info exists style_id] } {
    set items [db_list_of_lists wp_file_names_select { *SQL* } ]
} else {
    set items ""
}


db_release_unused_handles

if { $items == "" } {
    set background_images "<i>There are not yet any uploaded images to use as the background.</i>
<input type=hidden name=background_image value=\"0\">
"
} else {
    set names [list]
    set values [list]
    foreach image $items {
	lappend names [lindex $image 1]
	lappend values [lindex $image 0]
    }

    lappend names "none"
    lappend values 0

    set background_images "<select name=background_image>
[ad_generic_optionlist $names $values $background_image]</select>\n"
}

set public "<select name=public_p>
[ad_generic_optionlist [list Yes No] [list t f] $public_p]</select>\n"


set values [list]

set context "[list [list "style-list.tcl" "Your Styles"] $header "$role Style"]"

set export_form_vars [export_form_vars style_id presentation_id]
set ad_color_widget_js [ad_color_widget_js]
set ramdom_name "[lindex $colors [randomRange [llength $colors]]] on [lindex $colors [randomRange [llength $colors]]] with [lindex $elements [randomRange [llength $elements]]]"


ad_return_template
