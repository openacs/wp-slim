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
    context
    slide_title
    preamble
    postamble    
    bullet_items
    bullet_num
    sort_key
    original_slide_id
}


#added permission checking  roc@
set user_id [ad_verify_and_get_user_id]
permission::require_permission -party_id $user_id -object_id $pres_item_id -privilege wp_edit_presentation

set context [list "presentation-top?[export_url_vars pres_item_id] {presentation}" {Edit Slide}]

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
#
#db_1row get_pre_info {
#  select content as preamble
#  from cr_revisions, cr_items
#  where cr_items.content_type = 'cr_wp_slide_preamble'
#  and cr_items.parent_id = :slide_item_id
#  and cr_revisions.revision_id = cr_items.live_revision
#}
#
#db_1row get_pos_info {
#  select content as postamble
#  from cr_revisions, cr_items
#  where cr_items.content_type = 'cr_wp_slide_postamble' 
#  and cr_items.parent_id = :slide_item_id
#  and cr_revisions.revision_id = cr_items.live_revision
#}
#
#db_1row get_bul_info {
#select content as bullet_items
#  from cr_revisions, cr_items
#  where cr_items.content_type = 'cr_wp_slide_bullet_items'
#  and cr_items.parent_id = :slide_item_id
#  and cr_revisions.revision_id = cr_items.live_revision;
#}
#
#

set bullet_num 0
multirow create bullets item widget rows prev
# up to 3 bullets now! roc@
lappend bullet_items {} {}
foreach item $bullet_items { 
    if {[string length $item] < 60} { 
        set rows 1 
        set widget text
    } else { 
        set rows [max 3 [min 8 [expr {[string length $item]/45}]]]
        set widget textarea
    }
    multirow append bullets $item $widget $rows $bullet_num
    incr bullet_num
}
incr bullet_num 
set bullet_max [expr $bullet_num + 1]

# quote html tags contained in bullet items
set bullet_items [ad_quotehtml $bullet_items]

ad_return_template
