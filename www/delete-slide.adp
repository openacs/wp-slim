<master src="master">
<property name="title">Delete a Slide</property>
<property name="context">@context@</property>

<form>

Are you sure that you want to delete this slide?

<ul>
<li>Title:  as
<li>Contents:
</ul>

<input type=button value="Yes, delete the slide." onClick="location.href='delete-slide-2?pres_item_id=@pres_item_id@&slide_item_id=@slide_item_id@'">
<input type=button value="No, I want to go back." onClick="location.href='presentation-top?pres_item_id=@pres_item_id@'">

</p>