# Init
#region Init
$corefolder = (Get-Location).ToString()

$error.Clear()

Try {
$newFolder = New-Item -path $corefolder -name "wiki-temp" -ItemType "directory" –ErrorAction ‘Stop’
}
Catch [System.IO.IOException] {
"CATCH"
$fullDIR = $corefolder + "\wiki-temp\"
Remove-Item $fullDIR -Force -Recurse
$newFolder = New-Item -path $corefolder -name "wiki-temp" -ItemType "directory"
}

$error.Clear()

$pageList = @()

$index = 0
$loopIndex = 0
#$loopCount = 10

do {
  write-host -nonewline "Enter a numeric value between 1 and 25: "
  $inputString = read-host
  $loopCount = $inputString -as [Double]
  $ok = $loopCount -ne $NULL -AND $loopCount -ne 0
  if ( -not $ok ) { write-host "You must enter a numeric value" }
}
until ( $ok )


#endregion Init

if ($loopCount -gt 25)
{
"You've asked for $loopCount images but that's too many! Reducing to 25"
$loopCount = 25
}


while ($loopIndex -lt $loopCount)
{
$loopDisplay = $loopIndex + 1
# New Web Request each loop
$WebResponse = Invoke-WebRequest "https://www.wikihow.com/Special:Randomizer"

# Get Page Title
#region Get Title
$Content = $WebResponse.Content

$end = $Content.IndexOf("</title>")

$top = $Content.Substring(0,$end)

$start = $Content.IndexOf("<title>") + 7

$rawtitle = $top.Substring($start)

# remove colons!!
if ($RawTitle -like "*:*")
{
$colonIndex = $RawTitle.IndexOf(":")
$RawTitle = $RawTitle.Substring(0,$colonIndex)
}
else {}

# remove "(with Pictures)"
if ($RawTitle -like "*(with*")
{
$IndexOfParenthesis = $rawtitle.IndexOf("(with")
$RawTitle = $RawTitle.Substring(0,$IndexOfParenthesis)
}
else {}

# remove "- wikiHow XXXX"
if ($RawTitle -like "* - wikiHow*")
{
$IndexOfWiki = $rawtitle.IndexOf("wikiHow") - 3
$RawTitle = $RawTitle.Substring(0,$IndexOfWiki)
}
else {}

$FinalTitle = $rawtitle

$Finaltitle

#endregion Get Title

$Random = Get-Random -min 0 -max ($WebResponse.Images.Count - 1)

# Get the full http web address of the image
$Source = $WebResponse.Images[$Random].'data-src'

do 
{
    if($Source -eq $null)
        {
            if ($Random -eq $($WebResponse.Images.Count))
            {
            $Random = 0
            }
            else 
            {
            $Random++
            }
        
        $Source = $WebResponse.Images[$Random].'data-src'
        }
    else 
        {
        $sourceOK = $true
        }
}
until ($SourceOK)
    
# get the final portion of the web address (just the image name)
$FileName = (Split-Path -path $Source -Leaf).ToString()
$extIndex = $FileName.IndexOf(".")

$fileExt = $FileName.Substring($extIndex)
if ($fileExt -like "*.gif*")
{ "HEY! THIS IS A GIF" }

# combine the output folder with the file name
$output = $corefolder + "\wiki-temp\" + $loopDisplay + $FileExt
#$output = $corefolder + "\" + $count + "\" + $loopDisplay + $FileExt
# $output = $corefolder + "\" + $count + "\" + $loopIndex + " - " + $title + $FileExt

    
#download the file at the http address to the output file
$download = Invoke-WebRequest -Uri $Source -OutFile $output

$newString = $loopDisplay.ToString() + " - " + $FinalTitle
$PageList += $newString

$loopIndex++
#endregion Loop


}

$pageStrings = Out-String -InputObject $pageList

$RandomTitleNumber = Get-Random -min 0 -max $pageList.Count

$RandomTitle = $pageList[$RandomTitleNumber]

$titleIndex = $RandomTitle.IndexOf("-") + 2

$RandomTitleFinal = $RandomTitle.Substring($titleIndex)

$tempFolder = $corefolder + "\wiki-temp\"

$newFile = New-Item -path $tempFolder -name "pages.txt" -ItemType "file" -value $pageStrings

Start-Sleep -s 2

Rename-Item -Path $tempFolder -newname $RandomTitleFinal

$finalPath = $corefolder + "\" + $RandomTitleFinal + "\"

Invoke-Item $finalPath
