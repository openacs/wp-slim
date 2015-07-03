<master>
<property name="doc(title)">#wp-slim.Confirm_Add_User#</property>
<property name="context">@context;literal@</property>

<form action="presentation-acl-add-3">

<input type="hidden" name="pres_item_id" value="@pres_item_id@">
<input type="hidden" name="user_id_from_search" value="@user_id_from_search@">
<input type="hidden" name="first_names_from_search" value="@first_names_from_search@">
<input type="hidden" name="last_name_from_search" value="@last_name_from_search@">
<input type="hidden" name="email_from_search" value="@email_from_search@">
<input type="hidden" name="role" value="@role@">


<p>#wp-slim.lt_Are_you_sure_you_want#

<blockquote>
<table cellspacing="0" cellpadding="0"><tr valign="baseline">
<td><input name="email" type="checkbox" checked>&nbsp;</td>
<td>#wp-slim.lt_Send_an_E-mail_messag#<br>#wp-slim.lt_Includethe_following_#
<br>
<textarea name=message rows=5 cols=40></textarea>
</td></tr></table>
</blockquote>

<p><center>
<input type="button" value="#wp-slim.No_I_want_to_cancel#" onClick="location.href='presentation-acl?pres_item_id="@pres_item_id@'"">
<spacer type=horizontal size="50">
<input type="submit" value="#wp-slim.Yes_proceed#">
</p></center>
