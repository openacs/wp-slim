# /packages/wimpy-point/www/index.tcl
ad_page_contract {
     
    This file is meant to display all the presentations you own
    and give you some options...like creating a new presentation or
    editing an old one.
    
    @author Paul Konigsberg (paul@arsdigita.com)
    @creation-date Wed Nov  8 17:33:21 2000
    @cvs-id $Id$
} {
}

set package_id [ad_conn package_id]

set context [list]

set user_id [ad_verify_and_get_user_id]

if {$user_id == 0} {
    db_multirow allpresentations get_all_public_presentations { 
	select i.item_id as pres_item_id,
	pres.pres_title,
	to_char(ao.creation_date, 'Month DD, YYYY') as creation_date,
	ao.creation_user,
	p.first_names || ' ' || p.last_name as full_name
	from cr_items i, cr_wp_presentations pres, persons p, acs_objects ao
	where i.live_revision = pres.presentation_id
	and   ao.object_id = i.item_id
	and   ao.creation_user = p.person_id
	and   pres.public_p = 't'
    }
    
    set return_url [ns_urlencode [ad_conn url]]
    ad_return_template index-unregistered
} else {
    db_multirow presentations get_my_presentations { 
	select i.item_id as pres_item_id,
	p.pres_title,
	to_char(ao.creation_date, 'Month DD, YYYY') as creation_date
	from cr_items i, cr_wp_presentations p, acs_objects ao
	where i.live_revision = p.presentation_id
	and   ao.object_id = i.item_id
	and   ao.creation_user = :user_id
    }

    db_multirow allpresentations get_all_visible_presentations { 
	select i.item_id as pres_item_id,
	pres.pres_title,
	to_char(ao.creation_date, 'Month DD, YYYY') as creation_date,
	ao.creation_user,
	p.first_names || ' ' || p.last_name as full_name,
	acs_permission.permission_p(i.item_id, :user_id, 'wp_edit_presentation') as edit_p
	from cr_items i, cr_wp_presentations pres, persons p, acs_objects ao
	where i.live_revision = pres.presentation_id
	and   ao.object_id = i.item_id
	and   ao.creation_user <> :user_id
	and   ao.creation_user = p.person_id
	and   acs_permission.permission_p(i.item_id, :user_id,
'wp_view_presentation') = 'f'
    }

    ad_return_template index
}
