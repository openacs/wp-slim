# /packages/wp/www/attach-del.tcl

ad_page_contract {

    # This file displays details about an attachment

     @author Haolan Qin (hqin@arsdigita.com)
     @creation-date Fri Dec 8 13:17:49 2000
     @cvs-id $Id$
} {
    slide_item_id:naturalnum,notnull
    attach_item_id:naturalnum,notnull
}



db_exec_plsql revisions_and_item_delete {
    begin
        wp_attachment.delete(:attach_item_id);
    end;
}
    
ad_returnredirect "attach-list?[export_url_vars slide_item_id]"
