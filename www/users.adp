<master src="master">
<property name="title">Wimpy Point Users</property>

<h2>Wimpy Point Users</h2>
@nav_bar@
<hr>
Select an author from this list of users who have created presentations (number of presentations shown in parentheses.)

<ul>
<multiple name=users>
<li><a href="/shared/community-member?user_id=@users.person_id@">@users.first_names@ @users.last_name@</a>, @users.email@ (@users.num_presentations@)
</multiple>
</ul>

