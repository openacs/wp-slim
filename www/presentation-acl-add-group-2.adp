<master>
<property name="doc(title)">#wp-slim.Confirm_Add_Users#</property>
<property name="context">@context;literal@</property>
<form action="presentation-acl-add-group-3">

<input type="hidden" name="pres_item_id" value="@pres_item_id@">
<input type="hidden" name="group_id" value="@group_id@">
<input type="hidden" name="role" value="@role@">


<p>#wp-slim.lt_Are_you_sure_you_want_1#

<ul>
<multiple name=group>
<li> @group.first_names@ @group.last_name@
</multiple>
</ul>

<p><center>
<input type="button" value="#wp-slim.No_I_want_to_cancel#" onClick="location.href='presentation-acl?pres_item_id="@pres_item_id@'"">
<spacer type=horizontal size="50">
<input type="submit" value="#wp-slim.Yes_proceed#">
</p></center>
