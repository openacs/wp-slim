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
    nav_bar
    slide_item_id
    attach_item_id
    revisions:multirow
    live_revision
    display
    file_name
}


set pres_item_id [db_string pres_item_id_get {
    select parent_id
    from cr_items
    where content_type = 'cr_wp_slide'
    and   item_id = :slide_item_id
}]

set nav_bar [ad_context_bar [list "edit-slide?[export_url_vars slide_item_id pres_item_id]" "Edit Slide"] "Details"]

db_multirow revisions revisions_get {
    select r.revision_id,
           to_char(ao.creation_date, 'HH24:MI:SS Mon DD, YYYY') as creation_date,
           ao.creation_ip
    from cr_revisions r,
         acs_objects ao
    where r.item_id = :attach_item_id
    and   ao.object_id = r.revision_id
}


set _selected ""
set top_selected ""
set preamble_selected ""
set after_preamble_selected ""
set bullets_selected ""
set after_bullets_selected ""
set postamble_selected ""
set bottom_selected ""

db_1row info_get {
    select i.live_revision, x.display
    from cr_items i, cr_wp_attachments x
    where x.attach_id = i.live_revision
    and   i.item_id = :attach_item_id
}

set ${display}_selected "selected"

set return_url [ns_urlencode "attach-detail?[export_url_vars slide_item_id attach_item_id file_name]"]

ad_return_template
