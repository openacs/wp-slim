<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="update_slide">      
      <querytext>
    select wp_slide__new_revision (
	now(),
	:user_id,
	:creation_ip,
	:slide_item_id,
	:slide_title,
      	:preamble,
	:bullet_items,
	:postamble,
	'-1',
	:original_slide_id,
	:sort_key,
	't',
	'f'
      );

      </querytext>
</fullquery>

 
</queryset>
