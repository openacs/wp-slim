<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="wp_slide_insert">      
      <querytext>
      
    begin
      :1 := wp_slide.new(
      pres_item_id      => :pres_item_id,
      creation_user     => :user_id,
      creation_ip       => :creation_ip,
      creation_date     => sysdate,
      slide_title       => :slide_title,
      original_slide_id => -100,
      sort_key          => :sort_key,
      preamble          => :preamble,
      postamble         => :postamble,
      bullet_items      => :bullet_list
      );
    end;

      </querytext>
</fullquery>

 
</queryset>
