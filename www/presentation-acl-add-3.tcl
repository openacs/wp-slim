# /packages/wp/www/presentation-acl-add-3.tcl

ad_page_contract {

    This page grants a user certain privilege on a presentation.

    @author Haolan Qin (hqin@arsdigita.com)
    @creation-date 01/22/2001
    @cvs-id $Id$
} {
    pres_item_id:naturalnum,notnull
    role:notnull
    user_id_from_search:naturalnum,notnull
    first_names_from_search
    last_name_from_search
    email_from_search:notnull
    message
    {email ""}
}

ad_require_permission $pres_item_id wp_admin_presentation

if {![empty_string_p $email]} {
    set user_id [ad_verify_and_get_user_id]
    db_1row email_get {
	select email as sender_email
	from parties
	where party_id = :user_id
    }
    ns_sendmail $email_from_search $sender_email "WimpyPoint Authorization" "$message"
}

switch $role {
    "read" {
	db_exec_plsql grant_privilege {
	    begin
	        acs_permission.grant_permission(:pres_item_id, :user_id_from_search, 'wp_view_presentation');
	    end;
	}
    }

    "write" {
	db_exec_plsql grant_privilege {
	    begin
	        acs_permission.grant_permission(:pres_item_id, :user_id_from_search, 'wp_view_presentation');
	        acs_permission.grant_permission(:pres_item_id, :user_id_from_search, 'wp_edit_presentation');
	    end;
	}
    }

    "admin" {
	db_exec_plsql grant_privilege {
	    begin
	        acs_permission.grant_permission(:pres_item_id, :user_id_from_search, 'wp_view_presentation');
	        acs_permission.grant_permission(:pres_item_id, :user_id_from_search, 'wp_edit_presentation');
	        acs_permission.grant_permission(:pres_item_id, :user_id_from_search, 'wp_admin_presentation');
	    end;
	}
    }
}

ad_returnredirect presentation-acl?[export_url_vars pres_item_id]