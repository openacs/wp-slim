<?xml version="1.0"?>
<queryset>

<fullquery name="user_info_get">      
      <querytext>
      
    select persons.first_names || ' ' || persons.last_name as user_name,
           parties.email as user_email
    from persons, parties
    where persons.person_id = :user_id
    and   parties.party_id = :user_id

      </querytext>
</fullquery>

 
</queryset>
