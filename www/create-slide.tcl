# /packages/wp/www/create-slide.tcl
ad_page_contract {
     
    # This file presents the form for users to create a slide.
     @author Paul Konigsberg (paul@arsdigita.com)
     @creation-date Mon Nov 20 12:07:24 2000
     @cvs-id $Id$
} {
    pres_item_id:naturalnum,notnull
    {sort_key:naturalnum,optional ""}
} -properties {
    context
    pres_item_id
    sort_key
    pres_title
}

set package_id [ad_conn package_id]


db_1row get_presentaiton {
select pres_title
from cr_wp_presentations p,
     cr_items i
where i.item_id = :pres_item_id
and   i.live_revision = p.presentation_id
}

set context [list [list "presentation-top?[export_url_vars pres_item_id]" "$pres_title"] "$pres_title"]

if {[empty_string_p $sort_key]} {
    set sort_key [db_string get_sort_key {
	select 1+max(sort_key)
        from cr_wp_slides s,
	     cr_items i,
             cr_revisions r
	where i.parent_id = :pres_item_id
	and   s.slide_id = i.live_revision
    }]
}

ad_return_template
