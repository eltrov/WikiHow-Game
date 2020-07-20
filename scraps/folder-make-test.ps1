$error.clear()
Try {
$newFolder = New-Item -path $corefolder -name "wiki-temp" -ItemType "directory" –ErrorAction ‘Stop’
}
Catch [System.IO.IOException] {
"CATCH"
$fullDIR = $corefolder + "\wiki-temp\"
Remove-Item $fullDIR -Force -Recurse
$newFolder = New-Item -path $corefolder -name "wiki-temp" -ItemType "directory"
}