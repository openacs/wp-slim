# /packages/wimpy-point/www/presentation-print-view.tcl
ad_page_contract {
This  generates a printer friendly view of a presentation, suitable for print-out thru' a browser.
    @author Samir Joshi(samir@symphinity.com)
    @creation-date Thu 8 Aug 2002

} {
   item_id:naturalnum,notnull
} -properties {
   pres_title:onevalue		   
   page_signature:onevalue	
   copyright_notice:onevalue
   public_p:onevalue
   show_modified_p :onevalue
   audience:onevalue
   background:onevalue
	slides:multirow
    owner_name:onevalue
    owner_id : onevalue
}
set user_id [ad_verify_and_get_user_id]

set subsite_name [ad_conn package_url]
regexp {^(.+)/$} $subsite_name match subsite_name

set package_id [ad_conn package_id]
set pres_item_id  $item_id 		
set url [ad_conn url]

db_1row get_owner_name {
}
	
db_1row get_presentation_data {
}

db_1row get_aud_data {
}

db_1row get_back_data {
}
	
db_multirow slides  get_slide_info {
}

ad_return_template





