ad_library {

   Wimpy procs
}

ad_proc wp_header {style_id} { Build the proper style for an specific page. } {

    db_1row get_style_data { *SQL* }
    set out ""
    if { $background_image != "" } {
       append out " background=\"[ad_conn package_url]/view-image?revision_id=$background_image\""
    }
    foreach property {
	{ text text_color }
	{ bgcolor background_color }
	{ link link_color }
	{ vlink vlink_color }
	{ alink alink_color }
    } {
       set value [set [lindex $property 1]]
	if { $value != "" } {
           append out " [lindex $property 0]=[ad_color_to_hex $value]"
	}
    }
    return $out
}


proc_doc wp_check_style_authorization { style_id user_id } { Verifies that the user owns this style. } {
    set owner [db_string wp_style_owner_select { *SQL* } -default "not_found"]
    if { $owner == "not_found" } {
	set err "Error"
	set errmsg "Style $style_id was not found in the database."
    } else { 
	set err "Authorization Failed"
	set errmsg "You do not have the proper authorization to access this feature."
    }
    if { $owner != $user_id } {
	ad_return_error $err $errmsg
	ad_script_abort
    }
}

