# /packages/wp/www/presentation-revisions.tcl
ad_page_contract {
    
    This page displays a list of revisions of a presentation.

    @author Haolan Qin (hqin@arsdigita.com)    
    @creation-date 01/18/2001
    @cvs-id $Id$
} {
    pres_item_id:integer
} -properties {
    nav_bar
    pres_item_id
    
}


db_multirow revisions revisions_get {
    select r.revision_id,
           to_char(ao.creation_date, 'HH24:MI:SS Mon DD, YYYY') as creation_date,
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
}

set nav_bar [ad_context_bar [list "presentation-top?[export_url_vars pres_item_id]"  "Presentation"] "All Revisions"]

set return_url [ns_urlencode "presentation-revisions?[export_url_vars pres_item_id]"]

ad_return_template
