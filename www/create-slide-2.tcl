# /packages/wp/www/create-slide-2.tcl
ad_page_contract {

     @author Paul Konigsberg (paul@arsdigita.com)     
     @creation-date Tue Nov 21 10:41:42 2000
     @cvs-id $Id$
} {
    pres_item_id:naturalnum,notnull
    slide_title:notnull
    sort_key:naturalnum
    preamble:html
    array_max:integer
    bullet:array,html
    postamble:html   
}

set package_id [ad_conn package_id]


set user_id [ad_verify_and_get_user_id]
set creation_ip [ad_conn peeraddr]

set bullet_list [list]
for {set i 1} {$i <= $array_max} {incr i} {
    if {![empty_string_p $bullet($i)]} {
        lappend bullet_list $bullet($i)
    }
}

#insert the slide
db_exec_plsql wp_slide_insert {}

ad_returnredirect "presentation-top?[export_url_vars pres_item_id]"
