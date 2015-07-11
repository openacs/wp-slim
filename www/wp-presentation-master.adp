<html>
<head>
<link rel=stylesheet href="@package_url@styles/<if @style_id@ eq "-1">default</if><else>@style_id@</else>/style.css" type="text/css">
<title>@title@</title>

</head>
<body @wp_header@>
<if @body_start_include@ not nil>
<include src="@body_start_include;literal@" />
</if>
<slave>

<br>
@copyright_notice@

<hr />
<address><a href="mailto:@page_signature@">@page_signature@</a></address>

</body>
</html>






