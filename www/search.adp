<master>
<property name=title>#wp-slim.User_Search# <if @group_name@ not nil>#wp-slim.in_group_name#</if></property>
<property name="context">#wp-slim.User_search#</property>

#wp-slim.Search# 
<if @search_type@ eq "keyword">
  #wp-slim.lt_for_name_or_email_mat#
 </if><else>
 <if @search_type@ eq "email">
  #wp-slim.for_email_email#
 </if><else>
  #wp-slim.lt_for_last_name_last_na#
</else></else>

<ul>

<multiple name="user_search">

  <li><a href="@target@?user_id=@user_search.user_id@&@user_search.export_vars@&@passthrough_parameters@">@user_search.first_names@ @user_search.last_name@ (@user_search.email@)</a>
  <if @user_search.member_state@ ne "approved">
     <font color=red>@user_search.member_state@</font>
  </if>

</multiple>

<if @user_search:rowcount@ eq 0>
  <li>#wp-slim.No_users_found#
</if>
</ul>


