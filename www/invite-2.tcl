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
    nav_bar
    pres_item_id
    role
}

ad_require_permission $pres_item_id wp_admin_presentation

set nav_bar [ad_context_bar [list "presentation-top?[export_url_vars pres_item_id]" "$title"] [list "presentation-acl?[export_url_vars pres_item_id]" "Authorization"] [list "invite?[export_url_vars pres_item_id role title]" "Invite User"] "Email Sent"]

set user_id [ad_verify_and_get_user_id]

db_1row user_info_get {
    select persons.first_names || ' ' || persons.last_name as user_name,
           parties.email as user_email
    from persons, parties
    where persons.person_id = :user_id
    and   parties.party_id = :user_id
}

set email_content [ad_convert_to_html -html_p t "
From: $user_name $user_email
To: $name $email

Hello! I have invited you to work on the WimpyPoint presentation named

  $title

on [ad_conn server]. To do so, you'll need to register for an account on
[ad_conn server]. Please visit [ad_conn location] and follow the instructions.

$message
"]

ns_sendmail $email $user_email "WimpyPoint Invitation" "$email_content"

ad_return_template