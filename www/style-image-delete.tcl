# /wp-slim/www/style-image-delete.tcl

ad_page_contract {
    Deletes an image from a style.

    @param style_id the id of the style from which to delete the image
    @param file_name file name of the image to delete

    @creation-date  28 Nov 1999
    @author Jon Salz <jsalz@mit.edu>
    @cvs-id style-image-delete.tcl,v 3.2.2.5 2000/08/16 21:49:45 mbryzek Exp
} {
    style_id:naturalnum,notnull
    revision_id:naturalnum,notnull
}

set user_id [ad_conn user_id]

#??
#wp_check_style_authorization $style_id $user_id

db_exec_plsql revisions_and_item_delete { *SQL* }

db_release_unused_handles

ad_returnredirect "style-view.tcl?style_id=$style_id"
