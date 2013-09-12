# /packages/wp/www/attach-list.tcl

ad_page_contract {

    # This file displays details about an attachment

     @author Haolan Qin (hqin@arsdigita.com)
     @creation-date Fri Dec 8 13:17:49 2000
     @cvs-id $Id$
} {
    slide_item_id:naturalnum,notnull
    attach_item_id:naturalnum,notnull
    revision_id:naturalnum,notnull
    display
    file_name:notnull
}

# DRB: This code actually should never be called except for images, since
# the user isn't allowed to change the display attribute for links (rather
# stupid, but that's the way it is).  Rather than allow the user the opportunity
# to try to make such a change, only to deny it with the following code, I've
# changed the calling page to suppress the option except for images...

# check mime type
set mime_type [db_string get_mime_type {
    select mime_type
    from cr_revisions
    where revision_id = :revision_id
}]

if { ![empty_string_p $display] } {
    if { [cr_registered_type_for_mime_type $mime_type] != "image" } {
	ad_return_complaint 1 "<li>[_ wp-slim.lt_The_file_is_neither_a]"
        ad_script_abort
    }
    db_dml display_change ""
}


ad_returnredirect "attach-detail?[export_vars -url {slide_item_id attach_item_id file_name}]"
