# /packages/wp/www/invite.tcl

ad_page_contract {

    This page displays a form to compose an invitation message.

    @author Haolan Qin (hqin@arsdigita.com)
    @creation-date 01/22/2001
    @cvs-id $Id$
} {
    pres_item_id:naturalnum,notnull
    role:notnull
    title:notnull
} -properties {
    nav_bar
    pres_item_id
    role
    encoded_title
}

ad_require_permission $pres_item_id wp_admin_presentation

set nav_bar [ad_context_bar [list "presentation-top?[export_url_vars pres_item_id]" "$title"] [list "presentation-acl?[export_url_vars pres_item_id]" "Authorization"] "Invite User"]

set encoded_title [ad_urlencode $title]
ad_return_template