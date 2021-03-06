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

permission::require_permission -object_id $pres_item_id -privilege wp_admin_presentation

if {$email ne ""} {
    set user_id [ad_conn user_id]
    db_1row email_get {
	select email as sender_email
	from parties
	where party_id = :user_id
    }
    acs_mail_lite::send \
	-to_addr $email_from_search \
	-from_addr $sender_email \
	-subject [_ wp-slim.lt_WimpyPoint_Authorizat] \
	-body $message
}

set privilege_list "wp_view_presentation"
if {$role eq "write"} {
    lappend privilege_list "wp_edit_presentation"
}
if {$role eq "write"} {
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

ad_returnredirect [export_vars -base presentation-acl { pres_item_id }]
