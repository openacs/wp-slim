# /packages/wp/www/attach-list.tcl

ad_page_contract {

    # This file displays details about an attachment

     @author Haolan Qin (hqin@arsdigita.com)
     @creation-date Fri Dec 8 13:17:49 2000
     @cvs-id $Id$
} {
    slide_item_id:naturalnum
    attach_item_id:naturalnum,notnull
    file_name:notnull
} -properties {
    context
    slide_item_id
    attach_item_id
    revisions:multirow
    revision_id
    display
    file_name
    attachment_type
}


set pres_item_id [db_string pres_item_id_get {
    select parent_id
    from cr_items
    where content_type = 'cr_wp_slide'
    and   item_id = :slide_item_id
}]

#added permission checking  roc@
set user_id [ad_verify_and_get_user_id]
permission::require_permission -party_id $user_id -object_id $pres_item_id -privilege wp_edit_presentation


set context [list [list "edit-slide?[export_url_vars slide_item_id pres_item_id]" "[_ wp-slim.Edit_Slide]"] "[_ wp-slim.Details]"]

db_multirow revisions revisions_get {
    select r.revision_id,
           ao.creation_date as creation_date,
           ao.creation_ip
    from cr_revisions r,
         acs_objects ao
    where r.item_id = :attach_item_id
    and   ao.object_id = r.revision_id
} {
    set creation_date [lc_time_fmt $creation_date "%X %Q"]
}


set _selected ""
set top_selected ""
set preamble_selected ""
set after_preamble_selected ""
set bullets_selected ""
set after_bullets_selected ""
set postamble_selected ""
set bottom_selected ""

db_1row info_get ""

set attachment_type [cr_registered_type_for_mime_type $mime_type]

set ${display}_selected "selected"

set return_url [ns_urlencode "attach-detail?[export_url_vars slide_item_id attach_item_id file_name]"]

ad_return_template
