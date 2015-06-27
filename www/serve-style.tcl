# /packages/wp-slim/www/serve-style.tcl
ad_page_contract {
     
    # This file builds the respective CSS for a specific defined style.
     @author Rocael HR (roc@viaro.net)
} {
} 

set url [ad_conn url]

if {![regexp {styles/(default|[0-9]+)/(.*)} $url match style_id file_name]} {
    ns_log notice "Could not get a style_id out of url=$url"
    ad_abort_script
}

if { $style_id eq "default" } {
       set style_id -1
}


# Serve the top presentation page.
set css [db_string get_style {
    select css
    from wp_styles
    where style_id = :style_id
}]


doc_return  200 "text/css" $css
