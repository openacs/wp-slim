<master>
<property name="title">#wp-slim.Authorization#</property>
<property name="context">@context@</property>

<form name=f>

<p>
<table cellpadding=0 cellspacing=0>

<if @public_p@ eq t>
#wp-slim.lt_The_presentation_is_p# #wp-slim.lt_You_can_nobra_hrefpre#
<p>
</if>
<else>
<tr valign=top>
<td align=right width="30%">
<br>#wp-slim.lt_The_following_users_m#<p>(#wp-slim.lt_or_you_can_a_hrefpres#)
</td>
<td>&nbsp;</td>

<td>
<table border=2 cellpadding=10>
<tr>
<td align=center>
  <table cellspacing=0 cellpadding=0>
  <if @read_users:rowcount@ eq 0>
      <tr><td><i>#wp-slim.No_users#</i></td></tr>
  </if>
  <else>
      <multiple name="read_users">
          <tr><td>
          <a href="/shared/community-member?user_id=@read_users.person_id@">@read_users.first_names@ @read_users.last_name@</a>
          <if @read_users.person_id@ eq @creation_user@>
            #wp-slim.creator#
          </if>
          <else>
            [<a href="presentation-acl-delete?pres_item_id=@pres_item_id@&user_id=@read_users.person_id@&role=read">#wp-slim.remove#</a>]
          </else>
          </td></tr>
      </multiple>
  </else>
  </table><hr>
  <input type=button value="#wp-slim.Add_One#" onClick="location.href='presentation-acl-add?pres_item_id=@pres_item_id@&role=read&title=@encoded_title@'">
  <input type=button value="#wp-slim.Add_Group#" onClick="location.href='presentation-acl-add-group?pres_item_id=@pres_item_id@&role=read&title=@encoded_title@'">
</td>
</tr>
</table>
</td>
</tr>
</else>

<tr><td>&nbsp;</td></tr>

<tr valign=top>
<td align=right width="30%">
<br>#wp-slim.lt_The_following_users_m_1#</td>
<td>&nbsp;</td>

<td>
<table border=2 cellpadding=10>
<tr>
<td align=center>
  <table cellspacing=0 cellpadding=0>
  <if @write_users:rowcount@ eq 0>
      <tr><td><i>#wp-slim.No_users#</i></td></tr>
  </if>
  <else>
      <multiple name="write_users">
          <tr><td>
          <a href="/shared/community-member?user_id=@write_users.person_id@">@write_users.first_names@ @write_users.last_name@</a>
          <if @write_users.person_id@ eq @creation_user@>
            #wp-slim.creator#
          </if>
          <else>
            [<a href="presentation-acl-delete?pres_item_id=@pres_item_id@&user_id=@write_users.person_id@&role=write">#wp-slim.remove#</a>]
          </else>
          </td></tr>
      </multiple>
  </else>
  </table><hr>
  <input type=button value="#wp-slim.Add_One#" onClick="location.href='presentation-acl-add?pres_item_id=@pres_item_id@&role=write&title=@encoded_title@'">
  <input type=button value="#wp-slim.Add_Group#" onClick="location.href='presentation-acl-add-group?pres_item_id=@pres_item_id@&role=write&title=@encoded_title@'">
</td>
</tr>
</table>
</td>
</tr>

<tr><td>&nbsp;</td></tr>

<tr valign=top>
<td align=right width="30%">
<br>#wp-slim.lt_The_following_users_m_2#</td>
<td>&nbsp;</td>

<td>
<table border=2 cellpadding=10>
<tr>
<td align=center>
  <table cellspacing=0 cellpadding=0>
  <if @admin_users:rowcount@ eq 0>
      <tr><td><i>#wp-slim.No_users#</i></td></tr>
  </if>
  <else>
      <multiple name="admin_users">
          <tr><td>
          <a href=/shared/community-member?user_id=@admin_users.person_id@>@admin_users.first_names@ @admin_users.last_name@</a>
          <if @admin_users.person_id@ eq @creation_user@>
            #wp-slim.creator#
          </if>
          <else>
            [<a href="presentation-acl-delete?pres_item_id=@pres_item_id@&user_id=@admin_users.person_id@&role=admin">#wp-slim.remove#</a>]
          </else>
          </td></tr>
      </multiple>
  </else>
  </table><hr>
  <input type=button value="#wp-slim.Add_One#" onClick="location.href='presentation-acl-add?pres_item_id=@pres_item_id@&role=admin&title=@encoded_title@'">
  <input type=button value="#wp-slim.Add_Group#" onClick="location.href='presentation-acl-add-group?pres_item_id=@pres_item_id@&role=admin&title=@encoded_title@'">
</td>
</tr>
</table>
</td>
</tr>

</td>
</tr>
</table>

</p>

