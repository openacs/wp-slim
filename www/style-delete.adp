<master>
<property name="title">Delete @name@</property>
<property name="context">@context@</property>

<form action=style-delete-2.tcl>
@form_vars@
Are you sure that you want to delete the style @name@ @images_str@?

<p><center>
<input type=button value="No, I want to cancel." onClick="location.href='style-list.tcl'">
<spacer type=horizontal size=50>
<input type=submit value="Yes, proceed.">
</p></center>
</form>
