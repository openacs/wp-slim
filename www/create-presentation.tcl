# /packages/wimpy-point/www/presentation-create.tcl
ad_page_contract {
    
    # This file displays the form for creating a new presentation.
     @author Paul Konigsberg (paul@arsdigita.com)
     @creation-date Thu Nov  9 10:04:22 2000
     @cvs-id $Id$
} {
} -properties {
    header
}

set package_id [ad_conn package_id]

ad_require_permission $package_id wp_create_presentation

set title "Create Presentation"

#set presentation_id [db_nextval acs_object_id_seq]

set header "<h2>$title</h2>
[ad_context_bar  $title]
<hr>"


ad_return_template
