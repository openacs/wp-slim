<master>
<property name="title">Invite User</property>
<property name="context">@context@</property>

<form action="invite-2" method=post>

<input type=hidden name=pres_item_id value="@pres_item_id@">
<input type=hidden name=role value="@role@">
<input type=hidden name=title value="@encoded_title@">

<p>
<table border=2 cellpadding=10><tr><td>
<table>
  <tr><td colspan=2>
	Please provide the name and E-mail address of the person whom you want to invite to @role@ the presentation, and we'll send an E-mail inviting him or her to do so, and describing how to register with ArsDigita. The E-mail will appear to come from you, and you'll receive a copy.</P><hr>
  </td></tr>
  <tr><th align=right>Name:&nbsp;</th><td><input name=name size=40></td></tr>
  <tr><th align=right>E-mail:&nbsp;</th><td><input name=email size=40></td></tr>
  <tr valign=top><th align=right><br>Message:&nbsp;</th><td><textarea name=message rows=6 cols=40></textarea><br><i>If you like, you can provide a brief message to include in the invitation E-mail.</i></td></tr>
  <tr><td colspan=2 align=center><hr><input type=submit value="Send Invitation E-Mail"></td></tr>
</table>

</td></tr></table></p>

