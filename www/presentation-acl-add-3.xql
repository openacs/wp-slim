<?xml version="1.0"?>
<queryset>

<fullquery name="email_get">      
      <querytext>
      
	select email as sender_email
	from parties
	where party_id = :user_id
    
      </querytext>
</fullquery>

 
</queryset>
