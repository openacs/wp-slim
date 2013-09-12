# /packages/wp/www/delete-presentation.tcl

ad_page_contract {
     
    This file prompts for user password to confirm deleting a presentation.

    @author Haolan Qin (hqin@arsdigita.com)
    @creation-date 01/22/2001
    @cvs-id $Id$
} {
    pres_item_id:naturalnum,notnull
    title:notnull
} -properties {
    context
    pres_item_id
}

permission::require_permission -object_id $pres_item_id -privilege wp_delete_presentation

set context [list [list "presentation-top?[export_vars -url {pres_item_id}]" "$title"] "[_ wp-slim.Delete_Presentation]"]

ad_return_template
