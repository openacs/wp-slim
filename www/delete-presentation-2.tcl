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

permission::require_permission -object_id $pres_item_id -privilege wp_delete_presentation

set user_id [ad_conn user_id]
set username [db_string sel_authority_id "select username from cc_users where user_id = :user_id"]
set authority_id [db_string sel_authority_id "select authority_id from cc_users where user_id = :user_id"]

with_catch errmsg {
  array set result [auth::authentication::Authenticate  -username $username  -authority_id $authority_id  -password $password]
  if { [string equal $result(auth_status) "ok"] } {
    #Ok
  } else {
    ad_return_error "[_ wp-slim.Bad_Password]" "[_ wp-slim.Bad_Password]"
    ad_returnredirect ""
  }
} {
  ad_return_error "[_ wp-slim.Bad_Password]" "[_ wp-slim.Bad_Password]"
  ad_returnredirect ""
}

db_exec_plsql delete_presentation {
 	begin
  	  wp_presentation.del(:pres_item_id);
	end;
}
ad_returnredirect ""
