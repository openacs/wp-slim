# /packages/wp-slim/www/serve-slide-revision.tcl

ad_page_contract {
     
     This file gets data on a specific slide revision and serves that revision.

     @author Haolan Qin (hqin@arsdigita.com)
     @creation-date 01/19/2001
     @cvs-id $Id$
} {
} -properties {
    show_modified_p
    modified_date
    slide_title
    preamble
    bullet_items
    postamble
    pres_item_id
    sort_key
    page_signature
    href_back_forward
    attach_list:multirow
    context:onevalue
    subsite_name
}

set url [ad_conn url]

if {![regexp {slide_revision/([0-9]+)/([0-9]+)/([0-9]+)\.wimpy} $url match pres_item_id slide_item_id slide_revision_id]} {
    ns_log notice "Could not get a pres_item_id, slide_item_id and slide_revision_id out of url=$url"
    ad_return_error "Wimpy Point" "Could not get a pres_item_id, slide_item_id and slide_revision_id out of url=$url"
}

#added permission checking  roc@
set user_id [ad_verify_and_get_user_id]
permission::require_permission -party_id $user_id -object_id $pres_item_id -privilege wp_view_presentation

set subsite_name [ad_conn package_url]
regexp {^(.+)/$} $subsite_name match subsite_name

# Serve a specific slide revision
db_1row get_slide_info {
    select s.slide_title,
    s.sort_key,
    wp_slide.get_preamble_revision(:slide_revision_id) as preamble,
    wp_slide.get_postamble_revision(:slide_revision_id) as postamble,
    wp_slide.get_bullet_items_revision(:slide_revision_id) as bullet_items,
    to_char(ao.creation_date, 'HH24:MI, Mon DD, YYYY') as modified_date
    from cr_wp_slides s,
         cr_items i,
         acs_objects ao
    where i.item_id    = :slide_item_id
    and   s.slide_id   = :slide_revision_id
    and   ao.object_id = s.slide_id
}

set context [list [list "$subsite_name/display/$pres_item_id" "one presentation"] "one slide"]

db_1row get_presentation_page_signature {
    select p.page_signature,
    p.show_modified_p
    from cr_wp_presentations p, cr_items i
    where i.item_id = :pres_item_id
    and   i.live_revision = p.presentation_id
}

# x view does not contain cr_items.parent_id. That sucks!
db_multirow attach_list get_attachments {
    select x.attach_id as attach_id, x.display, i.name as file_name
    from cr_wp_attachments x, cr_items i
    where i.parent_id = :slide_item_id
    and   i.live_revision = x.attach_id
}
