<master>
<property name="title">#wp-slim.Reorder_Slides#</property>
<property name="context">@context@</property>

<form name=f>
#wp-slim.lt_To_move_a_slide_in_yo# <i>#wp-slim.Save_Changes#</i>.

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
@out;noquote@
</select>
</td>
<td align="center" valign="top"><a href="javascript:up()"><img src="pics/up.gif" border="0" alt="#wp-slim.up#"></a></td>
</tr>
<tr>
<td align="center" valign="bottom"><a href="javascript:down()"><img src="pics/down.gif" border="0" alt="#wp-slim.down#"></a></td>
</tr>

<tr><td align=center><input type="button" value="#wp-slim.Save_Changes#" onClick="done()"></td></tr>

</table>
</center>
