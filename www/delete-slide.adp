<master src="master">
<property name="title">Delete a Slide</property>

<form>
<h2>Delete a Slide</h2>
@nav_bar@
<hr>

Are you sure that you want to delete this slide?

<ul>
<li>Title:  as
<li>Contents:
</ul>

<input type=button value="Yes, delete the slide." onClick="location.href='delete-slide-2?pres_item_id=@pres_item_id@&slide_item_id=@slide_item_id@'">
<input type=button value="No, I want to go back." onClick="location.href='presentation-top?pres_item_id=@pres_item_id@'">

</p>