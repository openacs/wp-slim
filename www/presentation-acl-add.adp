<master>
<property name="title">Add User</property>
<property name="context">@context@</property>
<form action="search">

@params@

<center>

<p><table border=2 cellpadding=10 width="60%"><tr><td>
<table cellspacing=0 cellpadding=0>
<tr><td colspan=2>Please enter part of the E-mail address or last name of the user
you wish to give permission to view the presentation test.<p>If you can't find the person you're looking for,
he or she probably hasn't yet registered on ArsDigita, but you can <a href="invite?pres_item_id=@pres_item_id@&role=@role@&title=@encoded_title@">invite him or her to
view your presentation</a>.</p>
<hr></td></tr>
<tr><th align=right>Last Name:&nbsp;</th><td><input name=last_name size=30></td></tr>
<tr><th align=right><i>or</i> E-mail:&nbsp;</th><td><input name=email size=30></td></tr>
<tr><td colspan=2 align=center>
<hr>
<input type=submit value=Search>
</td></tr>
</table></td></tr></table></p>
</center>