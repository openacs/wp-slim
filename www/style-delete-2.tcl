# /wp-slim/www/style-delete-2.tcl

ad_page_contract {
    Description: Deletes the style.

    @param style_id is the ID of the style to delete

    @author Jon Salz (jsalz@mit.edu)
    @author Rocael HR (roc@viaro.net) Ported & modified
} {
    style_id:naturalnum,notnull
}

set user_id [ad_verify_and_get_user_id]

wp_check_style_authorization $style_id $user_id

db_exec_plsql revisions_and_item_delete { *SQL* }

db_release_unused_handles

ad_returnredirect "style-list.tcl"

