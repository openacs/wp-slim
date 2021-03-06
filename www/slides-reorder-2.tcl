# /packages/wp/www/slides-reorder.tcl

ad_page_contract {
    Saves changes made to slide order.

    @author Haolan Qin (hqin@arsdigita.com)     
    @creation-date Tue Dec 14 10:41:42 2000
    @cvs-id $Id$
} {
    pres_item_id:naturalnum,notnull
    slide_item_id:multiple,naturalnum,notnull
}


#added permission checking  roc@
set user_id [ad_conn user_id]
permission::require_permission -party_id $user_id -object_id $pres_item_id -privilege wp_edit_presentation

# Just iterate over the values for slide_id in order and set their respective
# sort_keys to 1, 2, 3, ...
set counter 0
foreach id $slide_item_id {
    incr counter
    db_dml wp_slide_order_update {
	update cr_wp_slides
        set    sort_key = :counter
        where  exists (select 1 from cr_revisions where cr_wp_slides.slide_id = cr_revisions.revision_id and cr_revisions.item_id = :id)
    }
}

db_release_unused_handles

ad_returnredirect [export_vars -base presentation-top {pres_item_id}]
