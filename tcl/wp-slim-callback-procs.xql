<?xml version="1.0"?>
<queryset>

  <fullquery name="callback::MergePackageUser::impl::wp-slim.upd_wp_styles">      
    <querytext>
      update wp_styles 
      set owner = :to_user_id
      where owner = :from_user_id
    </querytext>
  </fullquery>

  <fullquery name="callback::MergeShowUserInfo::impl::wp-slim.sel_wp_styles">      
    <querytext>
      select style_id , name 
      from wp_styles
      where owner = :user_id
    </querytext>
  </fullquery>
 
</queryset>
