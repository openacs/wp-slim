# wp-slim/style-list.tcl
ad_page_contract {
    Shows all styles.
    @param none
    @creation-date  28 Nov 1999
    @author Jon Salz <jsalz@mit.edu>
    @author Rocael HR <roc@viaro.net>
} {
}

set user_id [ad_verify_and_get_user_id]

set context {"your styles"}


db_multirow styles_select style_select_data { *SQL* } {
    if {$total_size == ""} { set total_size 0 }
    set total_size "[format "%.1f" [expr $total_size / 1024.0]]K"
} 

db_release_unused_handles


ad_return_template
