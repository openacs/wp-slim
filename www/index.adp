<master src="master">
<property name="title">WimpyPoint</property>

<h2>WimpyPoint</h2>
<a href="/pvt/home">Your Workspace</a>: Wimpy Point
<hr>

<h2> My Presentations</h2>

<ul>
<multiple name=presentations>
<li><a href="display/@presentations.pres_item_id@/">@presentations.pres_title@</a> created on @presentations.creation_date@ [ <a href="presentation-top?pres_item_id=@presentations.pres_item_id@">edit</a> ]
</multiple>
</ul>


<h2> Everyone's Presentations</h2>

<ul>
<multiple name=allpresentations>
<li><a href="display/@allpresentations.pres_item_id@/">@allpresentations.pres_title@</a> created by <a href="/shared/community-member?user_id=@allpresentations.creation_user@">@allpresentations.full_name@</a> on @allpresentations.creation_date@ 
<if @allpresentations.edit_p@ eq t>
[ <a href="presentation-top?pres_item_id=@allpresentations.pres_item_id@">edit</a> ]
</if>
</multiple>
</ul>


<h2>Options</h2>
<ul>
  <li><a href="create-presentation">Create a new presentation.</a>
  <li>Show a list of <a href="users">all WimpyPoint users.</a>       
</ul>