<master src="master">
<property name="title">Delete Presentation</property>

<form method=post action="delete-presentation-2">
<h2>Delete Presentation</h2>
@nav_bar@
<hr>

<input type=hidden name=pres_item_id value="@pres_item_id@">


Do you really want to delete @title@?
All slides will be permanently deleted.

<p>If you're really sure, please reenter your password.

<p><b>Password:</b> <input type=password size=20 name=password> <input type=submit value="Delete Presentation">

</p>
