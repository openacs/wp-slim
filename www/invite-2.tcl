# /packages/wp/www/invite-2.tcl

ad_page_contract {

    This page displays the message just sent out.

    @author Haolan Qin (hqin@arsdigita.com)
    @creation-date 01/22/2001
    @cvs-id $Id$
} {
    pres_item_id:naturalnum,notnull
    role:notnull
    title:notnull
    name
    email
    message
} -properties {
    context
    pres_item_id
    role
}

permission::require_permission -object_id $pres_item_id -privilege wp_admin_presentation

set context [list [list "presentation-top?[export_vars -url {pres_item_id}]" "$title"] [list "presentation-acl?[export_vars -url {pres_item_id}]" "[_ wp-slim.Authorization]"] [list "invite?[export_vars -url {pres_item_id role title}]" "[_ wp-slim.Invite_User]"] "[_ wp-slim.Email_Sent]"]

set user_id [ad_conn user_id]

db_1row user_info_get {
    select persons.first_names || ' ' || persons.last_name as user_name,
           parties.email as user_email
    from persons, parties
    where persons.person_id = :user_id
    and   parties.party_id = :user_id
}

set server [ad_conn server]
set location [ad_conn location]
set email_content [ad_convert_to_html -html_p t "
[_ wp-slim.lt_From_user_name_user_e]
"]

ns_sendmail $email $user_email "[_ wp-slim.lt_WimpyPoint_Invitation]" "$email_content"

ad_return_template
