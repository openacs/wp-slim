<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="attachment_insert">      
      <querytext>
      
begin
    select item_id into :1
    from cr_items
    where content_type = 'cr_wp_attachment'
    and   name = :client_filename
    and   parent_id = :slide_item_id;
exception
    when no_data_found then
        :1 := content_item.new(
              creation_user => :user_id,
              creation_ip   => :creation_ip,
              creation_date => sysdate,
              name          => :client_filename,
              parent_id     => :slide_item_id,
              content_type  => 'cr_wp_attachment'
              );
end;

      </querytext>
</fullquery>

 
<fullquery name="mime_type_insert">      
      <querytext>
      
	insert into cr_mime_types (mime_type) 
	select :mime_type
	from dual
	where not exists (select 1 from cr_mime_types where mime_type = :mime_type)
    
      </querytext>
</fullquery>

 
<fullquery name="live_revision_set">      
      <querytext>
      
begin
    content_item.set_live_revision(:revision_id);
end;

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
    from dual
    where not exists (select 1 from cr_wp_attachments where attach_id = :revision_id)

      </querytext>
</fullquery>

 
</queryset>
