# /packages/wp/www/delete-slide.tcl

ad_page_contract {
     
    Confirm page for deleting a slide.

    @author Haolan Qin (hqin@arsdigita.com)
    @creation-date 01/22/2001
    @cvs-id $Id$
} {
    slide_item_id:naturalnum,notnull
    pres_item_id:naturalnum,notnull
    slide_title
}


#added permission checking  roc@
set user_id [ad_conn user_id]
permission::require_permission -party_id $user_id -object_id $pres_item_id -privilege wp_delete_presentation

set context [list "[_ wp-slim.Delete_a_Slide]"]

ad_return_template
