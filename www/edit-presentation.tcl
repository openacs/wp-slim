# /packages/wp/www/edit-presentation.tcl
ad_page_contract {
     
    @author Paul Konigsberg (paulk@arsdigita.com)    
    @creation-date Mon Nov 20 20:48:03 2000
    @cvs-id $Id$
} {
    pres_item_id:integer
} -properties {
    nav_bar
    pres_item_id
    pres_title
    page_signature
    audience
    background
    copyright_notice
    public_p
    show_modified_p
}

ad_require_permission $pres_item_id wp_edit_presentation

set header [ad_header "Edit Presentation"]

db_1row get_presentation_data {
    select p.pres_title, p.page_signature, p.copyright_notice, p.public_p, p.show_modified_p, wp_presentation.get_audience(:pres_item_id) as audience, wp_presentation.get_background(:pres_item_id) as background
    from cr_wp_presentations p, cr_items i
    where i.item_id = :pres_item_id
    and   i.live_revision = p.presentation_id
}

#set public_p [db_string get_public_read_p "
#select decode(count(*),1,'t','f')
#from acs_permissions
#where object_id = :pres_item_id
#and upper(privilege)='WP_VIEW_PRESENTATION' 
#and grantee_id = acs.magic_object_id('the_public')
#"]


set nav_bar [ad_context_bar [list "presentation-top?[export_url_vars pres_item_id]"  "$pres_title"] "Edit Presentation"]

ad_return_template