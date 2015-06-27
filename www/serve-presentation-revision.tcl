# /packages/wp-slim/www/serve-presentation-revision.tcl

ad_page_contract {
     
    This file displays the properties for a presentation revision.

    @author Haolan Qin (hqin@arsdigita.com)
    @creation-date 01/20/2001
    @cvs-id $Id$
} {
} -properties {
    pres_item_id
    pres_title
    page_signature
    owner_name
    owner_id
    audience
    background
}

set url [ad_conn url]

if {![regexp {presentation_revision/([0-9]+)/([0-9]+)} $url match pres_item_id pres_revision_id]} {
    ns_log notice "Could not get a pres_item_id and a pres_revision_id out of url=$url"
    ad_return_error "[_ wp-slim.Wimpy_Point]" "[_ wp-slim.lt_Could_not_get_a_pres__1]"
}

#added permission checking  roc@
set user_id [ad_conn user_id]
permission::require_permission -party_id $user_id -object_id $pres_item_id -privilege wp_view_presentation

set subsite_name [ad_conn package_url]
regexp {^(.+)/$} $subsite_name match subsite_name

db_1row get_presentation_data {
    select p.pres_title,
           p.page_signature,
           p.copyright_notice,
           p.public_p,
           p.show_modified_p 
    from cr_wp_presentations p, cr_items i
    where i.item_id = :pres_item_id
    and   p.presentation_id = :pres_revision_id
}

db_1row get_audience_data {
    select content as audience
    from cr_revisions r, cr_wp_presentations_aud pa
    where pa.presentation_id = :pres_revision_id
    and r.revision_id = pa.id
}

db_1row get_background_data {
    select content as background
    from cr_revisions r, cr_wp_presentations_back pb
    where pb.presentation_id = :pres_revision_id
    and r.revision_id = pb.id
}   

set context [list [list [export_vars -base $subsite_name/presentation-top {pres_item_id}] "$pres_title"] "[_ wp-slim.One_Revision]"]

ad_return_template
