# /packages/wp/www/edit-presentation.tcl
ad_page_contract {
     
    @author Paul Konigsberg (paulk@arsdigita.com)    
    @creation-date Mon Nov 20 20:48:03 2000
    @cvs-id $Id$
} {
    pres_item_id:integer
} -properties {
    context
    pres_item_id
    pres_title
    page_signature
    audience
    background
    copyright_notice
    public_p
    show_modified_p
}


#added permission checking  roc@
set user_id [ad_verify_and_get_user_id]
permission::require_permission -party_id $user_id -object_id $pres_item_id -privilege wp_edit_presentation

set header [ad_header "Edit Presentation"]

db_1row get_presentation_data { *SQL* }


db_1row get_aud_data {
    select name as audience
    from cr_revisions, cr_items
    where cr_items.content_type = 'cr_wp_presentation_aud'
    and cr_items.parent_id = :pres_item_id
    and cr_revisions.revision_id = cr_items.live_revision
}


db_1row get_back_data {
    select name as background
    from cr_revisions r, cr_items i
    where i.content_type = 'cr_wp_presentation_back'
    and i.parent_id = :pres_item_id
    and r.revision_id = i.live_revision
}

set context [list [list "presentation-top?[export_url_vars pres_item_id]"  "$pres_title"] "Edit Presentation"]

# quote html tags
set page_signature [ad_quotehtml $page_signature]
set copyright_notice [ad_quotehtml $copyright_notice]
set audience [ad_quotehtml $audience]
set background [ad_quotehtml $background]

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
    [ad_generic_optionlist $names $values $style]</select>\n"


ad_return_template
