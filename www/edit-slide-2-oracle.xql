<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="update_slide">      
      <querytext>
      
    begin
      wp_slide.new_revision (
      creation_user     => :user_id,
      creation_ip       => :creation_ip,
      creation_date     => sysdate,
      slide_item_id     => :slide_item_id,
      slide_title       => :slide_title,
      preamble          => :preamble,
      postamble         => :postamble,
      bullet_items      => :bullet_items,
      original_slide_id => :original_slide_id,
      sort_key          => :sort_key
      );
    end;

      </querytext>
</fullquery>

 
</queryset>
