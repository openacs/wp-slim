<master>
<property name="doc(title)">#wp-slim.Add_Group#</property>
<property name="context">@context;literal@</property>

<form action="presentation-acl-add-group-2">

<input type="hidden" name="pres_item_id" value="@pres_item_id@">
<input type="hidden" name="role" value="@role@">
<input type="hidden" name="title" value="@title@">


<center>

<p><table border="2" cellpadding="10" width="60%"><tr><td>
<table cellspacing="0" cellpadding="0">
<tr><td colspan="2">#wp-slim.lt_Please_select_the_nam#
<hr></td></tr>
<tr><td align="center">
<select name=group_id>
<multiple name=groups>
  <option value=@groups.group_id@>@groups.group_name@
</multiple>
</select>
<tr><td colspan="2" align="center">
<hr>
<input type="submit" value="#wp-slim.Add#">
</td></tr>
</table></td></tr></table></p></center>

