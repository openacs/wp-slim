<master>
<property name=title>User Search <if @group_name;noquote@ not nil>in @group_name;noquote@</if></property>
<property name="context">"User search"</property>

Search 
<if @search_type@ eq "keyword">
  for name or email matching "@keyword@"
 </if><else>
 <if @search_type@ eq "email">
  for email "@email@"
 </if><else>
  for last name "@last_name@"
</else></else>

<ul>

<multiple name="user_search">

  <li><a href="@target@?user_id=@user_search.user_id@&@user_search.export_vars@&@passthrough_parameters@">@user_search.first_names@ @user_search.last_name@ (@user_search.email@)</a>
  <if @user_search.member_state@ ne "approved">
     <font color=red>@user_search.member_state@</font>
  </if>

</multiple>

<if @user_search:rowcount@ eq 0>
  <li>No users found.
</if>
</ul>

