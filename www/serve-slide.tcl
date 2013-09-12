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
    ad_return_error "[_ wp-slim.Wimpy_Point]" "[_ wp-slim.lt_Could_not_get_a_pres_]"
}

#added permission checking  roc@
set user_id [ad_conn user_id]
permission::require_permission -party_id $user_id -object_id $pres_item_id -privilege wp_view_presentation

set edit_p 0
if {[permission::permission_p -party_id $user_id -object_id $pres_item_id -privilege wp_edit_presentation]} {
    set edit_p 1
}
set delete_p 0
if {[permission::permission_p -party_id $user_id -object_id $pres_item_id -privilege wp_delete_presentation]} {
    set delete_p 1
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
    ao.creation_date as modified_date
    from cr_wp_slides s, cr_items i, acs_objects ao
    where i.item_id = :slide_item_id
    and   i.live_revision = s.slide_id
    and   ao.object_id = s.slide_id
}

# to support htmlArea
set preamble [lindex $preamble 0]
set postamble [lindex $postamble 0]

set modified_date [lc_time_fmt $modified_date "%Q"]

db_1row get_presentation_page_signature { *SQL* }

set context [list [list "$subsite_name/display/$pres_item_id" [_ wp-slim.One_Presentation]] "[_ wp-slim.One_Slide]"]



# Figure out what the previous slide link should be.
if {$sort_key == 1} {
    set href_back "<a href=\"$subsite_name/display/$pres_item_id/\">[_ wp-slim.top]</a> | "
} else {
    set previous_slide_item_id [db_string get_previous_slide_item_id {
	select i.item_id
	from cr_wp_slides s, cr_items i
	where i.parent_id = :pres_item_id
        and   i.live_revision = s.slide_id
	and   s.sort_key = (:sort_key - 1)
    }
    ]
    set href_back "<a href=\"${previous_slide_item_id}.wimpy\">[_ wp-slim.previous]</a> | "
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
    }
        set href_forward "<a href=\"$subsite_name/display/$pres_item_id\">[_ wp-slim.top]</a>"
} else {
    set href_forward "<a href=\"$subsite_name/display/$pres_item_id/${next_slide_item_id}.wimpy\">[_ wp-slim.next]</a>"
}


# x view does not contain cr_items.parent_id. That sucks!
db_multirow attach_list get_attachments {
    select x.attach_id as attach_id, x.display, i.name as file_name
    from cr_wp_attachments x, cr_items i
    where i.parent_id = :slide_item_id
    and   i.live_revision = x.attach_id
}

set edit_slide 1
set extra ""
if {$edit_p == 1} {
    append extra "<a href=\"$subsite_name/add-edit-slide?[export_vars -url {slide_item_id pres_item_id edit_slide}]\">[_ wp-slim.edit]</a> | "
}
if {$delete_p == 1} {
    append extra "<a href=\"$subsite_name/delete-slide?[export_vars -url {slide_item_id pres_item_id slide_title}]\">[_ wp-slim.delete]</a> |"
}

set href_back_forward "$href_back $extra $href_forward"


#comments capability added roc@
if {$edit_p == 1 || $show_comments_p == "t"} {
    set comment_link [general_comments_create_link $slide_item_id $url]
    set comments [general_comments_get_comments -print_content_p 1 -print_attachments_p 1 \
             $slide_item_id $url]
}

ad_return_template serve-slide
