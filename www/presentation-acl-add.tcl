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

ad_require_permission $pres_item_id wp_admin_presentation

set context [list [list "presentation-top?[export_url_vars pres_item_id]" "$title"] [list "presentation-acl?[export_url_vars pres_item_id]" "[_ wp-slim.Authorization]"] "[_ wp-slim.Add_User]"]

set encoded_title [ns_urlencode $title]

set target "[ad_conn package_url]/presentation-acl-add-2"
set passthrough [list pres_item_id role title]
set params [export_form_vars pres_item_id role title target passthrough]

ad_return_template
