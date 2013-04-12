set root_directory [file dirname [string trimright $::acs::tcllib "/"]]
source "$root_directory/www/default-master.tcl"
set package_url [ad_conn package_url]
set wp_header [wp_header $style_id]