<master>
<property name="title">Wimpy Point Users</property>
<property name="context">@context;noquote@</property>

Select an author from this list of users who have created presentations (number of presentations shown in parentheses.)

<ul>
<multiple name=users>
<li><a href="/shared/community-member?user_id=@users.person_id@">@users.first_names@ @users.last_name@</a>, @users.email@ (@users.num_presentations@)
</multiple>
</ul>
<p>
Note: this is not a complete list of the users.
Users who are collaborators on
presentations owned by others are excluded.  Users who have created
only private presentations are excluded.
