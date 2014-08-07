
# /wp-slim/www/style-edit-2.tcl
ad_page_contract {
    Create or apply changes to a style.
    @creation-date  28 Nov 1999
    @author Jon Salz <jsalz@mit.edu>
    @author Rocael HR <roc@viaro.net>
    @param name is the name of the style
    @param style_id is the ID of the style (if editing)
    @param presentation_id is the ID of the presentation to which the style is applied
    @param text_color.* are rgb values of text_color
    @param background_color.* are rgb values of background_color
    @param link_color.* are  rgb values of link_color
    @param css is the text of a cascading style sheet (file)
} {
    name:optional,notnull
    style_id:naturalnum,optional
    presentation_id:naturalnum,optional
    text_color.c1:naturalnum,optional
    text_color.c2:naturalnum,optional
    text_color.c3:naturalnum,optional
    background_color.c1:naturalnum,optional
    background_color.c2:naturalnum,optional
    background_color.c3:naturalnum,optional
    {background_image:integer "0"} 
    link_color.c1:naturalnum,optional
    link_color.c2:naturalnum,optional
    link_color.c3:naturalnum,optional
    alink_color.c1:naturalnum,optional
    alink_color.c2:naturalnum,optional
    alink_color.c3:naturalnum,optional
    vlink_color.c1:naturalnum,optional
    vlink_color.c2:naturalnum,optional
    vlink_color.c3:naturalnum,optional
    public_p:notnull
    css:optional
}

# check for naughty html
if { [info exists name] && ![empty_string_p [ad_html_security_check $name]] } {
    ad_return_complaint 1 "[ad_html_security_check $name]\n"
    return
}
if { [info exists css] && ![empty_string_p [ad_html_security_check $css]] } {
    ad_return_complaint 1 "[ad_html_security_check $css]\n"
    return
}

set user_id [ad_conn user_id]


# We're OK to insert or update.

if { [info exists style_id] } {
    set condition "style_id = $style_id"
    set query "update_style"
    # If editing, make sure we can write to the style.
    wp_check_style_authorization $style_id $user_id
} else {
    set condition ""
    set style_id [db_nextval "wp_style_seq"]
    set query "insert_style"
}

ad_process_color_widgets text_color background_color link_color alink_color vlink_color


db_transaction {
    db_dml $query { *SQL* }

    if { [info exists presentation_id] } {
	# We reached here through the "I'll upload my own" menu item in presentation-edit.tcl.
	# Set the presentation's style, now that we've created it.
	permission::require_permission -party_id $user_id -object_id $presentation_id -privilege wp_admin_presentation 
	
	db_dml pres_update { *SQL* }
    }
} on_error {
    db_release_unused_handles
    ad_return_error "[_ wp-slim.Error]" "[_ wp-slim.lt_Couldnt_update_your_s]"
}

db_release_unused_handles

ad_returnredirect "style-view?[export_vars -url {style_id presentation_id}]"
