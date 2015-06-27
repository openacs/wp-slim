# /packages/wp/www/presentation-acl-add.tcl

ad_page_contract {

    This page displays a searching interface to add a person.

    @author Haolan Qin (hqin@arsdigita.com)
    @creation-date 01/21/2001
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

set context [list [list [export_vars -base presentation-top {pres_item_id}] "$title"] [list [export_vars -base presentation-acl {pres_item_id}] "[_ wp-slim.Authorization]"] "[_ wp-slim.Add_User]"]

set encoded_title [ns_urlencode $title]

set target "[ad_conn package_url]/presentation-acl-add-2"
set passthrough [list pres_item_id role title]
set params [export_vars -form {pres_item_id role title target passthrough}]

ad_return_template
