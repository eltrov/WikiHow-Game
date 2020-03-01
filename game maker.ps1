# $WebResponse = Invoke-WebRequest "https://www.wikihow.com/Special:Randomizer"
$error.Clear()

# First Run
#region First Run

# Check for count file, create if not present
Try { $try = Get-Item -path "$corefolder\count.txt" -ErrorAction Stop}
Catch { New-Item -path "$corefolder\count.txt" -ItemType "file" -Value "0001" }


#endregion First Run

$index = 0
$corefolder = "C:\Users\Me\Dropbox\powershell\wikihow"

# $coreURL = "https://www.wikihow.com"
# $date = Get-Date -format MM-dd-yyyy

# Read from file
$count = Get-Content "$corefolder\count.txt"

$countInt = $count -as [int]

New-Item -path $corefolder -name $count -ItemType "directory"




# Begin Loop
#region Begin Loop


# Get Page Title
#region Get Title
$Content = $webresponse.Content

$start = $Content.IndexOf("<title>")

$end = $Content.IndexOf("</title>") - 17

$top = $Content.Substring(7,$end)

$title = $top.Substring($start)

$title
#endregion Get Title

$random = Get-Random -min 0 -max ($webresponse.Images.Count - 1)

# Get the full http web address of the image
$source = $WebResponse.Images[$random].'data-src'
    
# get the final portion of the web address (just the image name)
$FileName = (Split-Path -path $source -Leaf).ToString()
$fileExt = $FileName.Substring($FileName.Length-4,4)

# combine the output folder with the file name
$output = $folder + "\" + $count + "\" + $title + $FileExt
# $output = $folder + "\" + $FileName
    
#download the file at the http address to the output file
Invoke-WebRequest -Uri $source -OutFile $output



# Count File Incrementation
#region Count File Incrementation

$countInt+=1
$countInt.Length

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

Set-Content -path "$corefolder\count.txt" -Value $countWrite
#endregion Count File Incrementation