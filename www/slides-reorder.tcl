# /packages/wp/www/slides-reorder.tcl

ad_page_contract {
    This pages provides an interface to reorder slides.

    @author Haolan Qin (hqin@arsdigita.com)     
    @creation-date Tue Dec 14 10:41:42 2000
    @cvs-id $Id$
} {
    pres_item_id:naturalnum,notnull
} -properties {
    pres_item_id
    out
}


#added permission checking  roc@
set user_id [ad_verify_and_get_user_id]
permission::require_permission -party_id $user_id -object_id $pres_item_id -privilege wp_edit_presentation

set header [ad_header "[_ wp-slim.Reorder_Slides]"]

db_1row get_presentation {}
set context [list [list "presentation-top?[export_url_vars pres_item_id]" "$pres_title"] "[_ wp-slim.Reorder_Slides]"]

set counter 0

set out ""
db_foreach slides_sel {
    select s.sort_key, s.slide_title, i.item_id as slide_item_id
    from cr_wp_slides s, cr_items i
    where i.parent_id = :pres_item_id
    and   i.live_revision = s.slide_id
    order by s.sort_key
} {
    incr counter
    append out "<option value=\"$slide_item_id\">$counter. $slide_title\n"
}

ad_return_template
