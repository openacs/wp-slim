ad_page_contract {

     @author Paul Konigsberg (paul@arsdigita.com)     
     @creation-date Thu Nov  9 20:44:46 2000
     @cvs-id $Id$
} {
    { audience:html "" }
    { background:html "" }
    { page_signature:html "" }
    { copyright_notice:html "" }
    pres_title:notnull
    { style:integer -1 }
    show_modified_p:notnull
    public_p:notnull
}

set package_id [ad_conn package_id]

set user_id [ad_verify_and_get_user_id]
set creation_ip [ad_conn peeraddr]

set pres_item_id [db_exec_plsql wp_presentation_insert ""]

db_exec_plsql grant_owner_access ""

if {$public_p == "t"} {
    db_exec_plsql make_wp_presentation_public ""
}

ad_returnredirect "presentation-top?[export_url_vars pres_item_id]"

