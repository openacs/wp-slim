<?xml version="1.0"?>

<queryset>

<fullquery name="style_select_data">      
      <querytext>

    select s.style_id, s.name, count(file_size) as images, sum(file_size) as total_size
    from wp_styles s left join wp_style_images i on (s.style_id = i.style_id) 
    where 
    s.owner = :user_id
    group by s.style_id, s.name
    order by lower(s.name)

      </querytext>
</fullquery>

 
</queryset>
