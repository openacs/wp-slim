<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="wp_styles">      
      <querytext>

    select style_id, (case when owner = :user_id then name || ' (yours)' else name end) as name
    from wp_styles
    where owner = :user_id
    or public_p = 't'
    order by name

      </querytext>
</fullquery>

 
</queryset>
