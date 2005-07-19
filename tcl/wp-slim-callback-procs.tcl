ad_library {
    
    Library for Wimpy Point's callbacks implementations
    
    @author Enrique Catalan (quio@galileo.edu)
    @creation-date Jul 19, 2005
    @cvs-id $Id$
}

ad_proc -callback merge::MergeShowUserInfo -impl wp-slim {
    -user_id:required
} {
    Merge the wp items of two users.
} {
    set msg "Wimpty point items of $user_id"
    set result [list $msg]
    
    set styles [db_list_of_lists sel_wp_styles { *SQL* } ] 
    
    lappend result "Styles of $user_id: $styles"
    
    return $result
}

ad_proc -callback merge::MergePackageUser -impl wp-slim {
    -from_user_id:required
    -to_user_id:required
} {
    Merge the wp items of two users.
} {
    set msg "Merging wp-slim "
    ns_log Notice $msg
    set result [list $msg]
    
    db_dml upd_wp_styles  { *SQL* }
    
    lappend result "Merge of wp-slim is done"
    
    return $result
}
