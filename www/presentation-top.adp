<master>
<property name="title">@presentation_title;noquote@</property>
<property name="context">@context;noquote@</property>

<h3>The Slides</h3>
   <if  @slides:rowcount@ eq 0>
          <a href="create-slide?sort_key=1&pres_item_id=@pres_item_id@">Create the first slide.</a>
   </if>
   <else>
     <table border=0 cellspacing=10 cellpadding=0>
     <multiple name="slides">
     <tr>
     <td>@slides.sort_key@.</td>
     <td> <a href="@subsite_name@display/@pres_item_id@/@slides.slide_item_id@.wimpy">@slides.slide_title@</a> </td>
     <td>
[ <a href="edit-slide?slide_item_id=@slides.slide_item_id@&pres_item_id=@pres_item_id@">edit</a> |
<if @delete_p@ eq t>
  <a href="delete-slide?slide_item_id=@slides.slide_item_id@&pres_item_id=@pres_item_id@&slide_title=@slides.slide_title@">delete</a> |
</if>
<a href="attach-list?slide_item_id=@slides.slide_item_id@&pres_item_id=@pres_item_id@">attach</a> |
<a href="slide-revisions?slide_item_id=@slides.slide_item_id@&pres_item_id=@pres_item_id@">view revisions</a>]
     </td>
     <td> <img src="pics/arrow.gif" alt="arrow" align=top> <font size=-1><a href="create-slide?pres_item_id=@pres_item_id@&sort_key=@slides.sort_key@">Insert</a></font> </td>
     </tr>
     </multiple>
     <tr>
     <td></td>
     <td> <a href="slides-reorder?pres_item_id=@pres_item_id@">Change order of slides</a> </td>
     <td></td>
     <td> <img src="pics/arrow.gif" alt="arrow" align=top> <font size=-1><a href="create-slide?pres_item_id=@pres_item_id@">Add</a></font> </td>
     </tr>
     </table>
</else>


<h3>Options</h3>
<ul>
<li> <a href="display/@pres_item_id@/">Show presentation.</a>
<li> <a href="presentation-print-view.tcl?item_id=@pres_item_id@">Printer friendly view. </a>
<li> <a href="edit-presentation?pres_item_id=@pres_item_id@">Edit presentation properties.</a>
<if @delete_p@ eq t>
  <li> <a href="delete-presentation?pres_item_id=@pres_item_id@&title=@encoded_title@">Delete this presentation.</a>
</if>
</ul>

<h3>Viewers / Collaborators</h3>

<ul>
<if @public_p@ eq t>
  <li> Everyone can view the presentation, since it is public.
</if>
<multiple name="users">
  <li><a href="/shared/community-member?user_id=@users.person_id@">@users.full_name@</a>
  <if @users.person_id@ eq @creation_user@>
    (creator)
  </if>
  <if @users.person_id@ eq @user_id@>
    (You)
  </if>
  <if @users.privilege@ eq "wp_admin_presentation">
  [ admin ]
  </if>
  <elseif @users.privilege@ eq "wp_edit_presentation">
  [ editor ]
  </elseif>
  <else>
  [ viewer ]
  </else>
</multiple>

<if @admin_p@ eq t>
  <li><a href="presentation-acl?pres_item_id=@pres_item_id@">Change people who can view/edit this presentation</a>
<if @show_comments_p@ eq "t">
  <li>All viewers can see the comments (<a href=toggle-comments-view?pres_item_id=@pres_item_id@&presentation_id=@presentation_id@&view=f>make available only for editors</a>)
	</if>
<else>
  <li>Editors can see the comments (<a href=toggle-comments-view?pres_item_id=@pres_item_id@&presentation_id=@presentation_id@&view=t>make available to all viewers</a>)
</else>
</if>
</ul>


<h3>Versioning</h3>

<ul>
<li><a href="presentation-revisions?pres_item_id=@pres_item_id@">All revisions of this presentation</a>
</ul>
