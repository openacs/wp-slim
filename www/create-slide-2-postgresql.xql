<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="wp_slide_insert">      
      <querytext>

  select wp_slide__new(
    	:pres_item_id,
	now(),
	:user_id,
      	:creation_ip,
 	:slide_title,
	'-1',      	
	'-100',
      	:sort_key,
      	:preamble,
	:bullet_list,
	:postamble,
	't',
	'f',
	NULL,
        :package_id
      );

      </querytext>
</fullquery>

 
</queryset>
