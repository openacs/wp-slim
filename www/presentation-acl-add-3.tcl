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
    ns_sendmail $email_from_search $sender_email "[_ wp-slim.lt_WimpyPoint_Authorizat]" "$message"
}

set privilege_list "wp_view_presentation"
if { [string equal $role "write"] } {
    lappend privilege_list "wp_edit_presentation"
}
if { [string equal $role "write"] } {
    lappend privilege_list "wp_edit_presentation"
}

switch $role {
    "read" {
        set privilege_list { wp_view_presentation }
    }
    "write" {
        set privilege_list { wp_view_presentation wp_edit_presentation }
    }
    "admin" {
        set privilege_list { wp_view_presentation wp_edit_presentation wp_admin_presentation }
    }
}

db_transaction {
    foreach privilege $privilege_list {
        db_exec_plsql grant_privilege {
            begin
                acs_permission.grant_permission(:pres_item_id, :user_id_from_search, :privilege);
            end;
        }
    }   
}

ad_returnredirect presentation-acl?[export_vars -url { pres_item_id }]
