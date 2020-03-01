# $WebResponse = Invoke-WebRequest "https://www.wikihow.com/Special:Randomizer"

$core = "https://www.wikihow.com"
$folder = "C:\Users\Me\Dropbox\powershell\wikihow"
$index = -1

ForEach ($Image in $WebResponse.Images)
{
    # Get the full http web address of the image
    $source = $WebResponse.Images[$index].'data-src'
    
    # get the final portion of the web address (just the image name)
    $FileName = (Split-Path -path $source -Leaf).ToString()

    # combine the output folder with the file name
    $output = $folder + "\" + $FileName
    
    #download the file at the http address to the output file
    Invoke-WebRequest -Uri $source -OutFile $output

    $index++
}

$index = 0