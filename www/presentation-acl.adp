<master>
<property name="title">Authorization</property>
<property name="context">@context@</property>

<form name=f>

<p>
<table cellpadding=0 cellspacing=0>

<if @public_p@ eq t>
The presentation is public, so anyone is allowed to view it. You can <nobr><a href="presentation-public?pres_item_id=@pres_item_id@&public_p=f">make the presentation private</a></nobr> if you want only certain users to be able to view it.
<p>
</if>
<else>
<tr valign=top>
<td align=right width="30%">
<br>The following users may view the presentation:<p>(or you can <a href="presentation-public?pres_item_id=@pres_item_id@&public_p=t">make the presentation public</a> so everyone can view it)
</td>
<td>&nbsp;</td>

<td>
<table border=2 cellpadding=10>
<tr>
<td align=center>
  <table cellspacing=0 cellpadding=0>
  <if @read_users:rowcount@ eq 0>
      <tr><td><i>No users.</i></td></tr>
  </if>
  <else>
      <multiple name="read_users">
          <tr><td>
          <a href="/shared/community-member?user_id=@read_users.person_id@">@read_users.first_names@ @read_users.last_name@</a>
          <if @read_users.person_id@ eq @creation_user@>
            (creator)
          </if>
          <else>
            [<a href="presentation-acl-delete?pres_item_id=@pres_item_id@&user_id=@read_users.person_id@&role=read">remove</a>]
          </else>
          </td></tr>
      </multiple>
  </else>
  </table><hr>
  <input type=button value="Add One" onClick="location.href='presentation-acl-add?pres_item_id=@pres_item_id@&role=read&title=@encoded_title@'">
  <input type=button value="Add Group" onClick="location.href='presentation-acl-add-group?pres_item_id=@pres_item_id@&role=read&title=@encoded_title@'">
</td>
</tr>
</table>
</td>
</tr>
</else>

<tr><td>&nbsp;</td></tr>

<tr valign=top>
<td align=right width="30%">
<br>The following users may view and make changes to the presentation:</td>
<td>&nbsp;</td>

<td>
<table border=2 cellpadding=10>
<tr>
<td align=center>
  <table cellspacing=0 cellpadding=0>
  <if @write_users:rowcount@ eq 0>
      <tr><td><i>No users.</i></td></tr>
  </if>
  <else>
      <multiple name="write_users">
          <tr><td>
          <a href="/shared/community-member?user_id=@write_users.person_id@">@write_users.first_names@ @write_users.last_name@</a>
          <if @write_users.person_id@ eq @creation_user@>
            (creator)
          </if>
          <else>
            [<a href="presentation-acl-delete?pres_item_id=@pres_item_id@&user_id=@write_users.person_id@&role=write">remove</a>]
          </else>
          </td></tr>
      </multiple>
  </else>
  </table><hr>
  <input type=button value="Add One" onClick="location.href='presentation-acl-add?pres_item_id=@pres_item_id@&role=write&title=@encoded_title@'">
  <input type=button value="Add Group" onClick="location.href='presentation-acl-add-group?pres_item_id=@pres_item_id@&role=write&title=@encoded_title@'">
</td>
</tr>
</table>
</td>
</tr>

<tr><td>&nbsp;</td></tr>

<tr valign=top>
<td align=right width="30%">
<br>The following users may view and make changes to the presentation, and decide who gets to view/edit it:</td>
<td>&nbsp;</td>

<td>
<table border=2 cellpadding=10>
<tr>
<td align=center>
  <table cellspacing=0 cellpadding=0>
  <if @admin_users:rowcount@ eq 0>
      <tr><td><i>No users.</i></td></tr>
  </if>
  <else>
      <multiple name="admin_users">
          <tr><td>
          <a href=/shared/community-member?user_id=@admin_users.person_id@>@admin_users.first_names@ @admin_users.last_name@</a>
          <if @admin_users.person_id@ eq @creation_user@>
            (creator)
          </if>
          <else>
            [<a href="presentation-acl-delete?pres_item_id=@pres_item_id@&user_id=@admin_users.person_id@&role=admin">remove</a>]
          </else>
          </td></tr>
      </multiple>
  </else>
  </table><hr>
  <input type=button value="Add One" onClick="location.href='presentation-acl-add?pres_item_id=@pres_item_id@&role=admin&title=@encoded_title@'">
  <input type=button value="Add Group" onClick="location.href='presentation-acl-add-group?pres_item_id=@pres_item_id@&role=admin&title=@encoded_title@'">
</td>
</tr>
</table>
</td>
</tr>

</td>
</tr>
</table>

</p>
