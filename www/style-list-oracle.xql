<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="style_select_data">      
      <querytext>

    select s.style_id, s.name, count(file_size) as images, sum(file_size) as total_size
    from wp_styles s, wp_style_images i 
    where s.style_id = i.style_id(+)
    and s.owner = :user_id
    group by s.style_id, s.name
    order by lower(s.name)

      </querytext>
</fullquery>

 
</queryset>
