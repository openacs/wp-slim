# /packages/wimpy-point/www/presentation-create.tcl
ad_page_contract {
    
    # This file displays the form for creating a new presentation.
     @author Paul Konigsberg (paul@arsdigita.com)
     @creation-date Thu Nov  9 10:04:22 2000
     @cvs-id $Id$
} {
} -properties {
    title:onevalue
    context:onevalue
}

set title "Create Presentation"
set context [list $title]

