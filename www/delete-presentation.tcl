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

ad_require_permission $pres_item_id wp_delete_presentation

set context [list [list "presentation-top?[export_url_vars pres_item_id]" "$title"] "Delete Presentation"]

ad_return_template