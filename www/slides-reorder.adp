<master>
<property name="title">Reorder Slides</property>
<property name="context">@context@</property>

<form name=f>
To move a slide in your presentation, select its title and click the Up or Down arrow.
When you're done, click <i>Save Changes</i>.

<script language=javascript>

function up() {
    with (document.f.slides) {
        if (selectedIndex > 0) {
            var sel = selectedIndex;
            var selectedText = options[sel].text;
            var selectedValue = options[sel].value;
            options[sel].text = options[sel-1].text;
            options[sel].value = options[sel-1].value;
            options[sel-1].text = selectedText;
            options[sel-1].value = selectedValue;
            --selectedIndex;
        }
    }
}

function down() {
    with (document.f.slides) {
        if (selectedIndex >= 0 && selectedIndex < length - 1) {
            var sel = selectedIndex;
            var selectedText = options[sel].text;
            var selectedValue = options[sel].value;
            options[sel].text = options[sel+1].text;
            options[sel].value = options[sel+1].value;
            options[sel+1].text = selectedText;
            options[sel+1].value = selectedValue;
            ++selectedIndex;
        }
    }
}

function done() {
    var query = '';

    with (document.f.slides) {
        var i;
        for (i = 0; i < length; ++i)
            query += '&slide_item_id=' + options[i].value;
    }

    location.href = 'slides-reorder-2?pres_item_id=@pres_item_id@' + query;
}
</script>

<center>

<p>
<table>
<tr><td rowspan=2>
<select name=slides size=10>
@out@
</select>
</td>
<td align=center valign=middle><a href="javascript:up()"><img src="pics/up.gif" border=0 alt="up"></a></td>
</tr>
<tr>
<td align=center valign=middle><a href="javascript:down()"><img src="pics/down.gif" border=0 alt="down"></a></td>
</tr>

<tr><td align=center><input type=button value="Save Changes" onClick="done()"></td></tr>

</table>
</center>