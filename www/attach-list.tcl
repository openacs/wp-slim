# /packages/wp/www/attach-list.tcl

ad_page_contract {

    # This file displays a complete list of attachments (and all
    # of the revisions) that are associated with a slide.

     @author Haolan Qin (hqin@arsdigita.com)
     @creation-date Fri Dec 8 13:17:49 2000
     @cvs-id $Id$
} {
    slide_item_id:naturalnum,notnull
} -properties {
    slide_item_id
    context
    att:multirow
}


set pres_item_id [db_string pres_item_id_get {
    select parent_id
    from cr_items
    where content_type = 'cr_wp_slide'
    and   item_id = :slide_item_id
}]

set context [list [list "edit-slide?[export_url_vars slide_item_id pres_item_id]" "Edit Slide"] "List Attachments"]

db_multirow att attachments_get {
    select name, item_id
    from cr_items
    where content_type = 'cr_wp_attachment'
    and   parent_id = :slide_item_id
}

ad_return_template
