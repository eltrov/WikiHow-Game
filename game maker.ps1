
$error.Clear()

# First Run
#region First Run

# Check for count file, create if not present
Try { $try = Get-Item -path "$corefolder\count.txt" -ErrorAction Stop}
Catch { $new = New-Item -path "$corefolder\count.txt" -ItemType "file" -Value "0001" }


#endregion First Run

$corefolder = (Get-Location).ToString()

# $coreURL = "https://www.wikihow.com"
# $date = Get-Date -format MM-dd-yyyy

# Read from file
$count = Get-Content "$corefolder\count.txt"

$countInt = $count -as [int]

$newFolder = New-Item -path $corefolder -name $count -ItemType "directory"

$pageList = @()

$index = 0
$loopIndex = 0
$loopCount = 10

while ($loopIndex -lt $loopCount)
{
$loopDisplay = $loopIndex + 1
# New Web Request each loop
$WebResponse = Invoke-WebRequest "https://www.wikihow.com/Special:Randomizer"

# Get Page Title
#region Get Title
$Content = $webresponse.Content

$end = $Content.IndexOf("</title>")

$top = $Content.Substring(0,$end)

$start = $Content.IndexOf("<title>") + 7

$rawtitle = $top.Substring($start)

######################################
"raw: " + $RawTitle

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
#>


"fix: "+ $Finaltitle

#endregion Get Title

$random = Get-Random -min 0 -max ($webresponse.Images.Count - 1)

# Get the full http web address of the image
$source = $WebResponse.Images[$random].'data-src'
    
# get the final portion of the web address (just the image name)
$FileName = (Split-Path -path $source -Leaf).ToString()
$extIndex = $FileName.IndexOf(".")

$fileExt = $FileName.Substring($extIndex)
if ($fileExt -like "*.gif*")
{ "HEY! THIS IS A GIF" }

# combine the output folder with the file name
$output = $corefolder + "\" + $count + "\" + $loopDisplay + $FileExt
# $output = $corefolder + "\" + $count + "\" + $loopIndex + " - " + $title + $FileExt

    
#download the file at the http address to the output file
$download = Invoke-WebRequest -Uri $source -OutFile $output

$newString = $loopDisplay.ToString() + " - " + $FinalTitle
$PageList += $newString

$loopIndex++
#endregion Loop


}

$pageStrings = Out-String -InputObject $pageList

# Count File Incrementation
#region Count File Incrementation

$countInt+=1

if ($countInt.Length -eq 1)
{
$countWrite = "000" + $countInt
}
elseif ($countInt.Length -eq 2)
{
$countWrite = "00" + $countInt
}
elseif ($countInt.Length -eq 3)
{
$countWrite = "0" + $countInt
}
elseif ($countInt.Length -eq 4)
{
$countWrite = $countInt
}

$output = Set-Content -path "$corefolder\count.txt" -Value $countWrite

$newFile = New-Item -path $corefolder\$count -name "Pages.txt" -ItemType "file" -value $pageStrings
#endregion Count File Incrementation