$Content = $webresponse.Content

$start = $Content.IndexOf("<title>")

$end = $Content.IndexOf("</title>") - 17

$top = $Content.Substring(7,$end)

$title = $top.Substring($start)

$title