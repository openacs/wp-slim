# /packages/wp/www/edit-slide-2.tcl
ad_page_contract {

    # This file actually edits a slide.
    @author Paul Konigsberg (paulk@arsdigita.com)
    @creation-date Tue Nov 21 13:25:23 2000
    @cvs-id $Id$
} {
    slide_item_id:naturalnum,notnull
    pres_item_id:naturalnum,notnull
    slide_title
    preamble
    postamble
    sort_key
    original_slide_id
    array_max
    button
    bullet:array
    bullet_num:integer
} -properties {
    slide_item_id
    pres_item_id
    nav_bar
    attachment_count
}


set user_id [ad_verify_and_get_user_id]
set creation_ip [ad_conn peeraddr]

# construct the list of bullet_items
set bullet_items [list]
for {set index 1} {$index < [expr $bullet_num + 2]} {incr index} {
    if {![empty_string_p $bullet($index)]} {
        lappend bullet_items $bullet($index)
    }
}

db_exec_plsql update_slide {
    begin
      wp_slide.new_revision (
      creation_user     => :user_id,
      creation_ip       => :creation_ip,
      creation_date     => sysdate,
      slide_item_id     => :slide_item_id,
      slide_title       => :slide_title,
      preamble          => :preamble,
      postamble         => :postamble,
      bullet_items      => :bullet_items,
      original_slide_id => :original_slide_id,
      sort_key          => :sort_key
      );
    end;
}

if {[regexp {Upload} $button]} {
    set nav_bar [ad_context_bar [list "presentation-top?[export_url_vars pres_item_id]" "Presentation Top"] [list "edit-slide?[export_url_vars slide_item_id pres_item_id]" "Edit Slide"] "$slide_title"]
    # get the number of attachments
    set attachment_count [db_string get_number_of_attachments {
	select count(1) 
	from cr_items
        where content_type = 'cr_wp_attachment'
	and   parent_id = :slide_item_id
    }]
    ad_return_template upload-attachments
} else {
    ad_returnredirect presentation-top?[export_url_vars pres_item_id]
}
