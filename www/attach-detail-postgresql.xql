<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="revisions_get">      
      <querytext>
      
    select r.revision_id,
           to_char(ao.creation_date, 'HH24:MI:SS Mon DD, YYYY') as creation_date,
           ao.creation_ip
    from cr_revisions r,
         acs_objects ao
    where r.item_id = :attach_item_id
    and   ao.object_id = r.revision_id

      </querytext>
</fullquery>

 
</queryset>
