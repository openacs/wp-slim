# /packages/wp/www/presentation-top.tcl

ad_page_contract {
    
    This file show s a top level view of a presentation.
    From here the owner should be able to click on edit links fo slides,
    add new slides, and changes the permissions of who can edit/view the presentation.

    @author Paul Konigsberg (paulk@arsdigita.com)
    @creation-date Thu Nov 30 10:38:10 2000
    @cvs-id $Id$
} {
    pres_item_id:naturalnum
} -properties {
    context
    slides:multirow
    viewers:multirow
    public_p
    presentation_title
    pres_item_id
    subsite_name
}


#added permission checking  roc@
set user_id [ad_conn user_id]
permission::require_permission -party_id $user_id -object_id $pres_item_id -privilege wp_edit_presentation


db_1row get_presentation { *SQL* }

set encoded_title [ns_urlencode $presentation_title]
set context [list "$presentation_title"]
set subsite_name [ad_conn package_url]

db_multirow slides get_slides {
select s.sort_key, s.slide_title, i.item_id as slide_item_id
from cr_wp_slides s,
     cr_items i
where i.parent_id = :pres_item_id
and   i.live_revision = s.slide_id
order by s.sort_key
}

#lets not show duplicate users for this
#the oracle select distinct (p.person_id) doesn't work? so lets verify it in the db_multirow, in PG works fine =) roc@
set users_list [list]
db_multirow users get_users {} {
    if {[lsearch $users_list $person_id] != -1} {
	continue
    } 
    lappend users_list $person_id
}


#set public_p [db_string get_permissions {
#select decode(count(1),1,'The Public','')
#from acs_permissions
#where object_id = acs.magic_object_id('default_context')
#and   privilege = 'wp_view_presentation' 
#and   grantee_id = acs.magic_object_id('the_public')
#}]


ad_return_template
