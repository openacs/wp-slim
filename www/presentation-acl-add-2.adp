<master>
<property name="title">Confirm Add User</property>
<property name="context">@context;noquote@</property>

<form action="presentation-acl-add-3">

<input type=hidden name=pres_item_id value="@pres_item_id@">
<input type=hidden name=user_id_from_search value="@user_id_from_search@">
<input type=hidden name=first_names_from_search value="@first_names_from_search@">
<input type=hidden name=last_name_from_search value="@last_name_from_search@">
<input type=hidden name=email_from_search value="@email_from_search@">
<input type=hidden name=role value="@role@">


<p>Are you sure you want to give @first_names_from_search@ @last_name_from_search@ permission to view the presentation test?

<blockquote>
<table cellspacing=0 cellpadding=0><tr valign=baseline>
<td><input name=email type=checkbox checked>&nbsp;</td>
<td>Send an E-mail message to @first_names_from_search@ with a link to the presentation.<br>Include
the following message (optional):
<br>
<textarea name=message rows=5 cols=40></textarea>
</td></tr></table>
</blockquote>

<p><center>
<input type=button value="No, I want to cancel." onClick="location.href='presentation-acl?pres_item_id=@pres_item_id@'">
<spacer type=horizontal size=50>
<input type=submit value="Yes, proceed.">
</p></center>