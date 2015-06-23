<master>
<property name="doc(title)">#wp-slim.Invite_User#</property>
<property name="context">@context@</property>

<form action="invite-2" method=post>

<input type="hidden" name="pres_item_id" value="@pres_item_id@">
<input type="hidden" name="role" value="@role@">
<input type="hidden" name="title" value="@encoded_title@">

<p>
<table border="2" cellpadding="10"><tr><td>
<table>
  <tr><td colspan="2">
	#wp-slim.lt_Please_provide_the_na#</P><hr>
  </td></tr>
  <tr><th align="right">#wp-slim.Namenbsp#</th><td><input name="name" size="40"></td></tr>
  <tr><th align="right">#wp-slim.E-mailnbsp#</th><td><input name="email" size="40"></td></tr>
  <tr valign="top"><th align="right"><br>#wp-slim.Messagenbsp#</th><td><textarea name=message rows=6 cols=40></textarea><br><i>#wp-slim.lt_If_you_like_you_can_p#</i></td></tr>
  <tr><td colspan="2" align="center"><hr><input type="submit" value="#wp-slim.lt_Send_Invitation_E-Mai#"></td></tr>
</table>

</td></tr></table></p>


