<master>
<property name="title">Wimpy Point Users</property>
<property name="context">@context@</property>

Select an author from this list of users who have created presentations (number of presentations shown in parentheses.)

<ul>
<multiple name=users>
<li><a href="/shared/community-member?user_id=@users.person_id@">@users.first_names@ @users.last_name@</a>, @users.email@ (@users.num_presentations@)
</multiple>
</ul>

