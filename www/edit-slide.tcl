# /packages/wp/www/edit-slide.tcl
ad_page_contract {

    # This file displays the form to edit slide info.
    @author Paul Konigsberg (paulk@arsdigita.com)
    @creation-date Tue Nov 21 13:20:42 2000
    @cvs-id $Id$
} {
    slide_item_id:naturalnum,notnull
    pres_item_id:naturalnum,notnull
} -properties {
    pres_item_id
    nav_bar
    slide_title
    preamble
    postamble    
    bullet_items
    bullet_num
    sort_key
    original_slide_id
}

ad_require_permission $slide_item_id wp_edit_presentation

set nav_bar [ad_context_bar "Edit Slide"]

db_1row get_slide_info {
select s.slide_title,
       s.sort_key,
       s.original_slide_id,
       wp_slide.get_preamble(:slide_item_id) as preamble,
       wp_slide.get_postamble(:slide_item_id) as postamble,
       wp_slide.get_bullet_items(:slide_item_id) as bullet_items
from cr_wp_slides s, cr_items i
where i.item_id = :slide_item_id
and   i.live_revision = s.slide_id
}

set bullet_num [llength $bullet_items]

ad_return_template
