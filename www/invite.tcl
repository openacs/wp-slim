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
    context
    pres_item_id
    role
    encoded_title
}

permission::require_permission -object_id $pres_item_id -privilege wp_admin_presentation

set context [list [list "presentation-top?[export_vars -url {pres_item_id}]" "$title"] [list "presentation-acl?[export_vars -url {pres_item_id}]" "[_ wp-slim.Authorization]"] "[_ wp-slim.Invite_User]"]

set encoded_title [ad_urlencode $title]
ad_return_template
