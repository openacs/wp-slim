# /packages/wp/www/delete-presentation-2.tcl

ad_page_contract {
     
    This file deletes a presentation.

    @author Haolan Qin (hqin@arsdigita.com)
    @creation-date 01/22/2001
    @cvs-id $Id$
} {
    pres_item_id:naturalnum,notnull
    password:notnull
}

ad_require_permission $pres_item_id wp_delete_presentation

set user_id [ad_conn user_id]

if { [ad_check_password $user_id $password] } {
    db_exec_plsql delete_presentation {
 	begin
  	  wp_presentation.del(:pres_item_id);
	end;
    }
} else {
    ad_return_error "[_ wp-slim.Bad_Password]" "[_ wp-slim.Wrong_password]"
    ad_script_abort
}

ad_returnredirect ""
