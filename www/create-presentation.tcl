# /packages/wimpy-point/www/presentation-create.tcl
ad_page_contract {
    
    # This file displays the form for creating a new presentation.
     @author Paul Konigsberg (paul@arsdigita.com)
     @creation-date Thu Nov  9 10:04:22 2000
     @cvs-id $Id$
} {
} -properties {
    title:onevalue
    context:onevalue
}

set package_id [ad_conn package_id]
set user_id [ad_verify_and_get_user_id]
permission::require_permission -party_id $user_id -object_id $package_id -privilege wp_create_presentation

set items [db_list_of_lists wp_styles { *SQL* }]

    set names [list]
    set values [list]
    foreach image $items {
	lappend names [lindex $image 1]
	lappend values [lindex $image 0]
    }

    lappend names "none" 
    lappend values -1 

    set available_styles "<select name=style>
    [ad_generic_optionlist $names $values -1]</select>\n"

set title "Create Presentation"
set context [list $title]

