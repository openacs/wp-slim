# /packages/wp/www/slide-revisions.tcl

ad_page_contract {

    This file displays a list of revisions of a slide.

    @author Haolan Qin (hqin@arsdigita.com)
    @creation-date 01/18/2001
    @cvs-id $Id$
} {
    slide_item_id:naturalnum,notnull
    pres_item_id:naturalnum,notnull
} -properties {
    pres_item_id
    context
    subsite_name
}

#added permission checking  roc@
set user_id [ad_verify_and_get_user_id]
permission::require_permission -party_id $user_id -object_id $pres_item_id -privilege wp_edit_presentation


set subsite_name [ad_conn package_url]

set context [list [list "presentation-top?[export_url_vars pres_item_id]" "[_ wp-slim.Presentation]"] "[_ wp-slim.Slide_Revisions]"]


db_multirow revisions revisions_get {
    select r.revision_id,
           ao.creation_date as creation_date,
           ao.creation_ip,
           i.live_revision,
           p.first_names || ' ' || p.last_name as full_name
    from cr_revisions r,
         cr_items i,
         acs_objects ao,
         persons p
    where r.item_id = :slide_item_id
    and   ao.object_id = r.revision_id
    and   i.item_id = r.item_id
    and   p.person_id = ao.creation_user
    order by creation_date
} {
    set creation_date [lc_time_fmt $creation_date "%X %Q"]
}

set return_url [ns_urlencode "slide-revisions?[export_url_vars slide_item_id pres_item_id]"]

ad_return_template
