# /packages/wp-slim/www/serve-presentation.tcl
ad_page_contract {
     
    # This file gets the data for a presentation a serves the the opening page of it.
     @author Paul Konigsberg (paulk@arsdigita.com)
     @creation-date Tue Dec  5 12:12:59 2000
     @cvs-id $Id$
} {
} -properties {
    pres_item_id
    first_slide_item_id
    pres_title
    page_signature
    owner_name
    owner_id
    slides:multirow
}

set url [ad_conn url]

if {![regexp {display/([0-9]+)/?$} $url match pres_item_id]} {
    ns_log notice "Could not get a pres_item_id and slide_item_id out of url=$url"
    ad_return_error "Wimpy Point" "Could not get a pres_item_id and slide_item_id out of url=$url"
}

ad_require_permission $pres_item_id wp_view_presentation

set subsite_name [ad_conn package_url]
regexp {^(.+)/$} $subsite_name match subsite_name

# Serve the top presentation page.
db_0or1row get_first_slide_item_id {
    select item_id as first_slide_item_id
    from cr_items
    where content_type = 'cr_wp_slide'
    and   parent_id    = :pres_item_id
    and   exists (select 1 from cr_wp_slides s where s.slide_id=cr_items.live_revision and s.sort_key=1)
}

db_1row get_presentation_info {
    select p.pres_title, p.page_signature
    from cr_wp_presentations p, cr_items i
    where i.item_id = :pres_item_id
    and   i.live_revision = p.presentation_id
}

db_1row get_owner_name {
    select first_names || ' ' || last_name as owner_name, person_id as owner_id
    from persons, acs_objects
    where persons.person_id = acs_objects.creation_user
    and acs_objects.object_id = :pres_item_id
}

db_multirow slides get_slides "
select s.slide_title, '$subsite_name/display/$pres_item_id/' || i.item_id || '.wimpy' as url
from cr_wp_slides s, cr_items i
where i.parent_id = :pres_item_id
and   i.live_revision = s.slide_id
order by s.sort_key
"

ad_return_template