<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="revisions_get">      
      <querytext>
      
    select r.revision_id,
           to_char(ao.creation_date, 'HH24:MI:SS Mon DD, YYYY') as creation_date,
           ao.creation_ip,
           i.live_revision,
           p.first_names || ' ' || p.last_name as full_name
    from cr_revisions r,
         cr_items i,
         acs_objects ao,
         persons p
    where r.item_id = :slide_item_id
    and   ao.object_id = r.revision_id
    and   i.item_id = r.item_id
    and   p.person_id = ao.creation_user
    order by creation_date

      </querytext>
</fullquery>

 
</queryset>
