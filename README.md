# WikiHow-Game
This tool pulls random images from WikiHow articles using PowerShell's Invoke-WebRequest cmdlet.

To use simply download and run the "Game Maker.ps1" script. 

You'll be prompted for how many images you want to pull. The hard limit it 25 per run. 
Then it will pull one image (at random) from that many different articles on WikiHow and put them in a numbered folder with each image numbered 1 - n.

The script also creates a "pages.txt" file that includes the image number and title of each page it came from.

This originated as an idea for an improv game but in general the image resolution on WikiHow is too low to do what I had originally intended.
