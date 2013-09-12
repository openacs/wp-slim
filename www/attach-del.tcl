# /packages/wp/www/attach-del.tcl

ad_page_contract {

    # This file displays details about an attachment

     @author Haolan Qin (hqin@arsdigita.com)
     @creation-date Fri Dec 8 13:17:49 2000
     @cvs-id $Id$
} {
    slide_item_id:naturalnum,notnull
    attach_item_id:naturalnum,notnull
    pres_item_id:naturalnum,notnull
}

#added permission checking  roc@
set user_id [ad_conn user_id]
permission::require_permission -party_id $user_id -object_id $pres_item_id -privilege wp_delete_presentation


db_exec_plsql revisions_and_item_delete {
    begin
        wp_attachment.del(:attach_item_id);
    end;
}
    
ad_returnredirect "attach-list?[export_vars -url {slide_item_id pres_item_id}]"
