<master>
<property name="title">Add Group</property>
<property name="context">@context@</property>

<form action="presentation-acl-add-group-2">

<input type=hidden name=pres_item_id value="@pres_item_id@">
<input type=hidden name=role value="@role@">
<input type=hidden name=title value="@title@">


<center>

<p><table border=2 cellpadding=10 width="60%"><tr><td>
<table cellspacing=0 cellpadding=0>
<tr><td colspan=2>Please select the name of the group
you wish to give permission to @role@ thee presentation test.
<hr></td></tr>
<tr><td align=center>
<select name=group_id>
<multiple name=groups>
  <option value=@groups.group_id@>@groups.group_name@
</multiple>
</select>
<tr><td colspan=2 align=center>
<hr>
<input type=submit value=Add>
</td></tr>
</table></td></tr></table></p></center>
