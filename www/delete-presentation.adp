<master>
<property name="title">Delete Presentation</property>
<property name="context">@context@</property>

<form method=post action="delete-presentation-2">

<input type=hidden name=pres_item_id value="@pres_item_id@">


Do you really want to delete @title@?
All slides will be permanently deleted.

<p>If you're really sure, please reenter your password.

<p><b>Password:</b> <input type=password size=20 name=password> <input type=submit value="Delete Presentation">

</p>
