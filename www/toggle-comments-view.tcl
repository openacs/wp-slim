# /packages/wp/www/presentation-top.tcl

ad_page_contract {
    
    Make comments on slides available or not to users.

    @author Rocael HR (roc@viaro.net)
    @creation-date Thu Mar 31 17:11:10 2003
} {
    pres_item_id
    presentation_id:integer,notnull
    view:notnull
}

#permission checking  roc@
set user_id [ad_conn user_id]
permission::require_permission -party_id $user_id -object_id $pres_item_id -privilege wp_admin_presentation

db_dml toggle_comments { *SQL* }

ad_returnredirect "presentation-top?pres_item_id=$pres_item_id"
