ad_page_contract {

     @author Paul Konigsberg (paul@arsdigita.com)     
     @creation-date Thu Nov  9 20:44:46 2000
     @cvs-id $Id$
} {
    { audience:html "" }
    { background:html "" }
    { page_signature:html "" }
    { copyright_notice:html "" }
    pres_title:html,notnull
    { style:integer -1 }
    show_modified_p:notnull
    public_p:notnull
}

set package_id [ad_conn package_id]



set user_id [ad_verify_and_get_user_id]
set creation_ip [ad_conn peeraddr]

set pres_item_id [db_exec_plsql wp_presentation_insert {
    begin        
      :1 := wp_presentation.new(
      creation_date    => sysdate,
      creation_user    => :user_id,
      creation_ip      => :creation_ip,
      pres_title       => :pres_title,
      page_signature   => :page_signature,
      copyright_notice => :copyright_notice,
      style            => :style,
      public_p         => :public_p,
      show_modified_p  => :show_modified_p,
      audience         => :audience,
      background       => :background
      );
    end;
}]

ad_returnredirect "presentation-top?[export_url_vars pres_item_id]"

