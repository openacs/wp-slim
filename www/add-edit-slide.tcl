# /packages/wp/www/add-edit-slide.tcl
ad_page_contract {
     
    # This file presents the form for users to create a slide.
     @author Paul Konigsberg (paul@arsdigita.com)
     @creation-date Mon Nov 20 12:07:24 2000
     @cvs-id $Id$
} {
    pres_item_id:naturalnum,notnull
    {sort_key:naturalnum,optional ""}
    slide_item_id:naturalnum,optional
    {edit_slide:naturalnum,optional ""}
    {edit_preamble:naturalnum,optional ""}
} -properties {
    context
    pres_item_id
    sort_key
    pres_title
}

####################
# Global variables #
####################
set osi ""
set def ""
set bullet_num ""


set user_id [ad_verify_and_get_user_id]
set creation_ip [ad_conn peeraddr]
set package_id [ad_conn package_id]
permission::require_permission -party_id $user_id -object_id $pres_item_id -privilege wp_edit_presentation

##############################
# Get the presentation title #
##############################

db_1row get_presentation { *SQL* }

if {![empty_string_p $edit_slide]} {
    db_1row get_bullets_stored { *SQL* }
    append bullet_num [llength $bullets_stored]
    db_1row get_slide_sort_key { *SQL* }
} else {
     if {[empty_string_p $sort_key] } {
         set sort_key [db_string get_sort_key { *SQL* }]
     }
}
###############################
# Messages shown in help text #
###############################

set optional_preamble [_ wp-slim.lt_optional_random_text_]
set you_can [_ wp-slim.lt_You_can_add_additiona]
set optional_postamble [_ wp-slim.lt_optional_random_text__1]


################################################################################
# Since 2 htmlarea can't interact in the same page or at least I can't make it #
# there are two edits one for the preamble text and the other one fot the      #
# postamble                                                                    #
################################################################################


if { $edit_preamble == ""} {
   set edit_preamble 1
}

if { $edit_preamble == 1 } {
    ad_form -name f -export {pres_item_id sort_key} -form {
	slide_item_id:key
	{slide_title:text(text)
	    {label "<b>#wp-slim.Slide_Titlenbsp#</b>"}
	    {html { size 50}}
	}
	{preamble:richtext(richtext),nospell,optional
	    {label "<b>Preamble Text:</b>"}
	    {html {rows 10 cols 70}}
	    {help_text "$optional_preamble" }
	    {value $def}
	    {section "#wp-slim.Preamble#"}
	    {htmlarea_p 1}
	}
    }
} else {
    ad_form -name f -export {pres_item_id sort_key} -form {
	slide_item_id:key
	{slide_title:text(text)
	    {label "<b>#wp-slim.Slide_Titlenbsp#</b>"}
	    {html { size 50}}
	}
	{preamble:richtext(richtext),nospell,optional
	    {label "<b>Preamble Text:</b>"}
	    {html {rows 10 cols 70}}
	    {help_text "$optional_preamble" }
	    {value $def}
	    {section "#wp-slim.Preamble#"}
	    {htmlarea_p 0}
	}
    }

}


###############################################################################################
# Generates the number of bullets, first there are 5 free bullets, then always 3 free bullets #
###############################################################################################

if { $bullet_num <= 2} {
    set array_max 5
} else {
    set array_max [expr $bullet_num + 3] 
}

###################################################################################
# Creates the bullets list dynamically. The list of list elements has the bullets #
###################################################################################

set elements [list]
for {set j 1} {$j <= $array_max} {incr j} {
    set element [list bullet.$j:text(text),optional \
			    {html { size 60 }} \
			    {value $def}]
    if { $j == 1 } {
	lappend element [list section "#wp-slim.Bullet_Items#"]
	lappend element [list after_html "&nbsp;<img src=\"pics/1white.gif\" width=18 height=15\"><a href=\"javascript:swapWithNext(1)\"\><img src=\"pics/down.gif\" width=18 height=15 border=0></a>"]
    }
    if { $j == $array_max } {
	set swap_num [expr $array_max - 1]
        lappend element [list help_text "$you_can"]
        lappend element [list after_html "&nbsp;<a href=\"javascript:swapWithNext($swap_num)\"><img src=\"pics/up.gif\" width=18 height=15 bord\er=0></a><img src=\"pics/1white.gif\" width=18 height=15>"]
    }
    if { $j > 1 && $j < $array_max } {
	set swap_num [expr $j - 1 ]
        lappend element [list after_html "&nbsp;<a href=\"javascript:swapWithNext($swap_num)\"><img src=\"pics/up.gif\" width=18 height=15 bord\er=0></a><a href=\"javascript:swapWithNext($j)\"><img src=\"pics/down.gif\" width=18 height=15 border=0></a>"]
    }
    lappend element [list label "<b>Bullet $j:</b>" ]
    lappend elements [list $element]
}     


###############################
# Add the bullets to the form #
###############################

set i 0
foreach item $elements {
    ad_form -extend -name f -form [lindex $elements $i]
    incr i
}

############################
# Add the end of the form  #
############################

if { $edit_preamble == 1} {
    ad_form -extend -name f -form {
	{postamble:richtext(richtext),nospell,optional
	    {label "<b>Postamble Text:</b>"}  
	    {html {rows 10 cols 70}}
	    {help_text "$optional_postamble" }
	    {value $def}
	    {section "#wp-slim.Postamble#"}
	    {htmlarea_p 0}
	}
    }
} else {
    ad_form -extend -name f -form {
	{postamble:richtext(richtext),nospell,optional
	    {label "<b>Postamble Text:</b>"}  
	    {html {rows 10 cols 70}}
	    {help_text "$optional_postamble" }
	    {value $def}
	    {section "#wp-slim.Postamble#"}
	    {htmlarea_p 1}
	}
    }
}

if { $edit_slide == 1} {
    set context [list [list "presentation-top?[export_url_vars pres_item_id]" "$pres_title"] "[_ wp-slim.Edit_Slide]"]
    ad_form -extend -name f -form {
        {attach:text(radio)
	    {label "<b>#wp-slim.Upload_Attachments#</b>"}
	    {options {{#wp-slim.No# f} {#wp-slim.Yes# t}}}
            {value f}
	}
    }
} else {
    set context [list [list "presentation-top?[export_url_vars pres_item_id]" "$pres_title"] "[_ wp-slim.New_Slide]"]
    ad_form -extend -name f -form {
        {attach:text(hidden)
	    {value "f"}
       	}
    }
}

####################
# FORM PROCESSING  #
####################
	
ad_form -extend -name f -new_data {

    # makes a bullet list to send to the procedure
    set bullet_list [list]
    for {set i 1} {$i <= $array_max} {incr i} {
	set bullet_value [set bullet.$i]
	if { ![empty_string_p $bullet_value ] } {
            lappend bullet_list [set bullet.$i]
       }
    }

    #insert the slide
    db_exec_plsql wp_slide_insert { *SQL* }
    if { $attach == "t"} {
    set context [list [list "presentation-top?[export_url_vars pres_item_id]" "$pres_title"] [list "add-edit-slide?[export_url_vars slide_item_id pres_item_id edit_slide]" "[_ wp-slim.Edit_Slide]"] "$slide_title"]
        ad_returnredirect attach-list?[export_url_vars pres_item_id slide_item_id]
    } else {
        ad_returnredirect presentation-top?[export_url_vars pres_item_id]
    }
} -edit_data {
  
    # makes a bullet list to send to the procedure
    set bullet_items [list]
    for {set i 1} {$i <= $array_max} {incr i} {
	set bullet_value [set bullet.$i]
	if { ![empty_string_p $bullet_value ] } {
            lappend bullet_items [set bullet.$i]
       }
    }

    # update the slide in the db
    db_exec_plsql update_slide { *SQL* }
    if { $attach == "t"} {
    set context [list [list "presentation-top?[export_url_vars pres_item_id]" "$pres_title"] [list "add-edit-slide?[export_url_vars slide_item_id pres_item_id edit_slide]" "[_ wp-slim.Edit_Slide]"] "$slide_title"]
        ad_returnredirect attach-list?[export_url_vars pres_item_id slide_item_id]
    } else {
        ad_returnredirect presentation-top?[export_url_vars pres_item_id]
    }
} -edit_request {

    db_1row get_slide_info { *SQL* }
    set index 1
    foreach item $bullet_items {
        set bullet.$index $item
	incr index
    }
    append osi $original_slide_id   
}
