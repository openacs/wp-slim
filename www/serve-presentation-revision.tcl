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
    ad_return_error "Wimpy Point" "Could not get a pres_item_id and a pres_revision_id out of url=$url"
}

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

db_1row get_aud_data {
    select content as audience
    from cr_revisions r, cr_wp_presentations_aud pa
    where pa.presentation_id = :pres_revision_id
    and r.revision_id = pa.id
}

db_1row get_back_data {
    select content as background
    from cr_revisions r, cr_wp_presentations_back pb
    where pb.presentation_id = :pres_revision_id
    and r.revision_id = pb.id
}   

set nav_bar [ad_context_bar [list "$subsite_name/presentation-top?[export_url_vars pres_item_id]" "$pres_title"] "One Revision"]

ad_return_template