# /packages/wp/www/delete-slide.tcl

ad_page_contract {
     
    Confirm page for deleting a slide.

    @author Haolan Qin (hqin@arsdigita.com)
    @creation-date 01/22/2001
    @cvs-id $Id$
} {
    slide_item_id:naturalnum,notnull
    pres_item_id:naturalnum,notnull
}

ad_require_permission $slide_item_id wp_delete_presentation

set nav_bar [ad_context_bar "Delete a Slide"]

ad_return_template