<html>
<head>
<link rel=stylesheet href="<%=[ad_conn package_url]%>styles/<if @style_id@ eq "-1">default</if><else>@style_id@</else>/style.css" type="text/css">
<title>@title@</title>
@header_stuff@
</head>
<body <%=[wp_header $style_id]%>>
<if @body_start_include@ not nil>
<include src="@body_start_include@" />
</if>
<slave>

<br>
@copyright_notice@

<hr />
<address><a href="mailto:@page_signature@">@page_signature@</a></address>
@ds_link@
</body>
</html>


