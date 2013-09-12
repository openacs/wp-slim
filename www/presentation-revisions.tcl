# /packages/wp/www/presentation-revisions.tcl
ad_page_contract {
    
    This page displays a list of revisions of a presentation.

    @author Haolan Qin (hqin@arsdigita.com)    
    @creation-date 01/18/2001
    @cvs-id $Id$
} {
    pres_item_id:integer
} -properties {
    context
    pres_item_id
    
}

#added permission checking  roc@
set user_id [ad_conn user_id]
permission::require_permission -party_id $user_id -object_id $pres_item_id -privilege wp_edit_presentation



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
    where r.item_id = :pres_item_id
    and   ao.object_id = r.revision_id
    and   i.item_id = r.item_id
    and   p.person_id = ao.creation_user
    order by creation_date
}  {
    set creation_date [lc_time_fmt $creation_date "%X %Q"]
}
db_1row get_presentation {}
set context [list [list "presentation-top?[export_vars -url {pres_item_id}]"  "$pres_title"] "[_ wp-slim.All_Revisions]"]

set return_url [ns_urlencode "presentation-revisions?[export_vars -url {pres_item_id}]"]

ad_return_template
