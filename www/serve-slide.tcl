# /packages/wp-slim/www/serve-slide.tcl
ad_page_contract {
     
    # This file gets data on a specific slide and serves that slide.
     @author Paul Konigsberg (paulk@arsdigita.com)
     @creation-date Tue Dec  5 13:04:20 2000
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

if {![regexp {display/([0-9]+)/([0-9]+)\.wimpy} $url match pres_item_id slide_item_id]} {
    ns_log notice "Could not get a pres_item_id and slide_item_id out of url=$url"
    ad_return_error "Wimpy Point" "Could not get a pres_item_id and slide_item_id out of url=$url"
}


set subsite_name [ad_conn package_url]
regexp {^(.+)/$} $subsite_name match subsite_name
#set pkg_key [ad_conn package_key]

# Serve a specific slide.
db_1row get_slide_info {
    select s.slide_title,
    s.sort_key,
    wp_slide.get_preamble(:slide_item_id) as preamble,
    wp_slide.get_postamble(:slide_item_id) as postamble,
    wp_slide.get_bullet_items(:slide_item_id) as bullet_items,
    to_char(ao.creation_date, 'HH24:MI, Mon DD, YYYY') as modified_date
    from cr_wp_slides s, cr_items i, acs_objects ao
    where i.item_id = :slide_item_id
    and   i.live_revision = s.slide_id
    and   ao.object_id = s.slide_id
}

db_1row get_presentation_page_signature {
    select p.page_signature,
    p.show_modified_p
    from cr_wp_presentations p, cr_items i
    where i.item_id = :pres_item_id
    and   i.live_revision = p.presentation_id
}

set context [list [list "$subsite_name/display/$pres_item_id" "one presentation"] "one slide"]

# Figure out what the previous slide link should be.
if {$sort_key == 1} {
    set href_back "<a href=\"$subsite_name/display/$pres_item_id/\">top</a> | "
} else {
    set previous_slide_item_id [db_string get_previous_slide_item_id {
	select i.item_id
	from cr_wp_slides s, cr_items i
	where i.parent_id = :pres_item_id
        and   i.live_revision = s.slide_id
	and   s.sort_key = (:sort_key - 1)
    }
    ]
    set href_back "<a href=\"${previous_slide_item_id}.wimpy\">previous</a> | "
}

# Figure out what the next slide link should be.    

set next_sort_key [expr $sort_key + 1]

set found_slide [db_0or1row get_next_slide {
    select i.item_id as next_slide_item_id 
    from cr_wp_slides s, cr_items i 
    where i.parent_id = :pres_item_id
    and   i.live_revision = s.slide_id
    and   s.sort_key = :next_sort_key
}
]

if {!$found_slide} {
    if {$sort_key == 1} {        
	# this is the only slide.
	set href_back ""
	set href_forward "<a href=\"$subsite_name/display/$pres_item_id\">top</a>"
    } else { 
        set href_forward {}
    }
} else {
    set href_forward "<a href=\"$subsite_name/display/$pres_item_id/${next_slide_item_id}.wimpy\">next</a>"
}


# x view does not contain cr_items.parent_id. That sucks!
db_multirow attach_list get_attachments {
    select x.attach_id as attach_id, x.display, i.name as file_name
    from cr_wp_attachments x, cr_items i
    where i.parent_id = :slide_item_id
    and   i.live_revision = x.attach_id
}

set href_back_forward "$href_back $href_forward"
ad_return_template serve-slide
