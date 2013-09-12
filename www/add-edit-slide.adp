<master>
<property name="doc(title)">#wp-slim.Create_A_Slide#</property>
<property name="context">@context@</property>

<script language=javascript>
 
function swapWithNext(index)
{
  var val = document.f['bullet.' + index].value;
  document.f['bullet.' + index].value = document.f['bullet.' + (index+1)].value;
  document.f['bullet.' + (index+1)].value = val;
}

</script>

<formtemplate id=f></formtemplate>
