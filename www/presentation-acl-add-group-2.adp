<master src="master">
<property name="title">Confirm Add Users</property>

<form action="presentation-acl-add-group-3">
<h2>Confirm Add Users</h2>
@nav_bar@
<hr>

<input type=hidden name=pres_item_id value="@pres_item_id@">
<input type=hidden name=group_id value="@group_id@">
<input type=hidden name=role value="@role@">


<p>Are you sure you want to give the following users permission to @role@ the presentation @title@?

<ul>
<multiple name=group>
<li> @group.first_names@ @group.last_name@
</multiple>
</ul>

<p><center>
<input type=button value="No, I want to cancel." onClick="location.href='presentation-acl?pres_item_id=@pres_item_id@'">
<spacer type=horizontal size=50>
<input type=submit value="Yes, proceed.">
</p></center>