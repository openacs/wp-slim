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
    subsite_name:onevalue
}

set url [ad_conn url]

if {![regexp {display/([0-9]+)/?$} $url match pres_item_id]} {
    ns_log notice "Could not get a pres_item_id and slide_item_id out of url=$url"
    ad_return_error "[_ wp-slim.Wimpy_Point]" "[_ wp-slim.lt_Could_not_get_a_pres__2]"
}

#added permission checking  roc@
set user_id [ad_verify_and_get_user_id]
permission::require_permission -party_id $user_id -object_id $pres_item_id -privilege wp_view_presentation

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

db_1row get_presentation_info { *SQL* }

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

set users_list [list]
db_multirow collaborators get_collaborators { *SQL* } {
    if {[lsearch $users_list $person_id] != -1} {
	continue
    } 
    lappend users_list $person_id
}


ad_return_template
