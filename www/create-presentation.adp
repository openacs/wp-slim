<master src="master">
<property name="title">Create Presentation</property>
<property name="context">@context@</property>

<form method=POST action="create-presentation-2">

<table>
<tr>
    <td></td><td>
Give this presentation a title.  Pick a title that you've never used
before, otherwise you won't be able to tell this new presentation from 
old ones.  Also, keep the title reasonably short so that if you choose
a style where the overall presentation title is presented on each slide,
it won't take up too much space.
    </td>
  </tr>
  <tr>
    <th nowrap align=right>Title:</th>
    <td><input type=text name=pres_title size=50 value=""></td>
  </tr>
  <tr>
    <td></td><td>
If you want a signature at the bottom of each slide, then enter it here:
    </td>
  </tr>
  <tr>
    <th nowrap align=right>Page Signature:</th>
    <td><input type=text name=page_signature size=50 value=""></td>
  </tr>
  <tr>
    <td></td><td>
(Personally, I like to have my email address, hyperlinked to my home
page; remember that HTML is OK here and you can have up to 200 characters.)

<p>If you want a copyright notice somewhere on each slide, enter it here:
    </td>
  </tr>
  <tr>
    <th nowrap align=right>Copyright Notice:</th>
    <td><input type=text name=copyright_notice size=50 value=""></td>
  </tr>
  <tr>
    <td></td><td>
WimpyPoint keeps track of the last modification time
of each slide.  If you'd like that displayed on each slide, you can
say so here:
    </td>
  </tr>
  <tr>
    <th nowrap align=right>Show Modification Date?</th>
    <td>
<input type=radio name=show_modified_p value=t > Yes
<input type=radio name=show_modified_p value=f checked> No
    </td>
  </tr>
  <tr>
    <td></td><td>
If you want to hide this presentation from everyone except yourself
and any collaborators that you add, you should say so.  Eventually
you'll probably want to change this and make the presentation public,
unless you are only using WimpyPoint to generate .html
pages and/or hardcopy slides that you will show privately.
    </td>
  </tr>
  <tr>
    <th nowrap align=right>Available to Public?</th>
    <td>
<input type=radio name=public_p value=t > Yes
<input type=radio name=public_p value=f checked> No
    </td>
  </tr>
  <tr>
    <td></td><td>
Suggestion: if you have truly secret information for a presentation,
you'd be best off keeping it on your desktop machine.  We try to keep
our database secure but remember that your packets are being sent in
the clear.


    </td>
  </tr>
  <tr>
    <th nowrap align=right>Style:</th>
    <td><select name=style>
<option value=-1 selected>Default (Plain)

</select>
    </td>
  </tr>
  <tr>
    <td></td><td>
<p>Finally, if you're planning on making the presentation public, you might want to let the
world know whom you gave the presentation to and for what purpose.
    </td>
  </tr>
  <tr valign=top>
    <th nowrap align=right><br>Audience:</th>
    <td><textarea name=audience rows=4 cols=50
wrap=virtual>Audience:</textarea></td>
  </tr>
  <tr valign=top>
    <th nowrap align=right><br>Background:</th>
    <td><textarea name=background rows=4 cols=50 
wrap=virtual>Background:</textarea></td>
  </tr>

</table>
<center><input type=submit value="Save Presentation"></center>
</form>
