<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="attachment_insert">      
      <querytext>

        select wp_attachment__new(
		:attachment,
		:display,
		:slide_item_id,
		now(),
		:user_id,
		:creation_ip
              );
      </querytext>
</fullquery>

 
<fullquery name="mime_type_insert">      
      <querytext>
      
	insert into cr_mime_types (mime_type) 
	select :mime_type
	
	where not exists (select 1 from cr_mime_types where mime_type = :mime_type)
    
      </querytext>
</fullquery>

 
<fullquery name="live_revision_set">      
      <querytext>
	select content_item__set_live_revision(:revision_id);

      </querytext>
</fullquery>

 
<fullquery name="attributes_insert">      
      <querytext>
      
    insert into cr_wp_attachments
    (
    attach_id,
    display
    )
    select
    :revision_id,
    :display
    
    where not exists (select 1 from cr_wp_attachments where attach_id = :revision_id)

      </querytext>
</fullquery>

 
</queryset>
