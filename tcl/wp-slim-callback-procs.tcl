ad_library {
    Library of callbacks implementations for wp-slim
}

#Callbacks for application-track

ad_proc -callback application-track::getApplicationName -impl presentation {} { 
        callback implementation 
    } {
        return "presentation"
    }    
      
ad_proc -callback application-track::getGeneralInfo -impl presentation {} { 
        callback implementation 
    } {
	db_1row my_query {
		select count(c.presentation_id) as result
			from cr_wp_presentations c,dotlrn_communities com,acs_objects a
		    	where com.community_id=:comm_id
			and apm_package__parent_id(a.context_id) = com.package_id			
			and a.object_id = c.presentation_id
	}
   			
	
	
	return "$result"
    }            
    
    
   
   
   
ad_proc -callback application-track::getSpecificInfo -impl presentation {} { 
        callback implementation 
    } {
   	
	upvar $query_name my_query
	upvar $elements_name my_elements

	set my_query {
		select com.community_id as id,com.pretty_name as name,c.presentation_id as p_id,c.pres_title as title
			from cr_wp_presentations c,dotlrn_communities com,acs_objects a
		    	where com.community_id=:class_instance_id
			and apm_package__parent_id(a.context_id) = com.package_id			
			and a.object_id = c.presentation_id
	}
		
	
		
	set my_elements {
		id {
	            label "Community_id"
	            display_col id	                        
	 	    html {align center}	 	                
	        }
	        name {
	            label "Name"
	            display_col name 	      	              
	 	    html {align center}	 	                
	        }
	        p_id {
	            label "Presentation_id"
	            display_col p_id 	      	              
	 	    html {align center}  	                
	        }
	        title {
	            label "Title"
	            display_col title 	      	              
	 	    html {align center}  	                
	        }
	}
        
	

        return "OK"
    }