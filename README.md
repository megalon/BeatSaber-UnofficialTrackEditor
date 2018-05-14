## IMPORTANT!

## This project is no longer being worked on. For a more complete, 3D editor for Beat Saber tracks, check out Ikeiwa's project Edit Saber

https://github.com/Ikeiwa/EditSaber

# Beat Saber Unofficial 2D Track Editor

## This project is currently functional, but the features are limited.

Currently supports:

+ Loading a WAV or MP3 file into the editor. (No OGG yet!)

+ Loading / Saving track .json files
 
+ Placing / deleting notes, mines, events, and obstacles

+ Locking the grid to 8th / 16th / 32nd notes, or placing at arbitrary positions

+ Placing notes while the track is playing by pressing keys on the keyboard.

![Example image](https://i.imgur.com/XZVS8Bc.png)


To run:

## Grab the latest binary from the Releases tab

https://github.com/megalon/BeatSaber-UnofficialTrackEditor/releases

If you are using the Mac OS app, you will need to manually allow it in gatekeeper since it's unsigned. 

Here is a screenshot with more information:

![MacOS info](https://cdn.discordapp.com/attachments/444407770402521088/444470171524923394/Screen_Shot_2018-05-11_at_8.05.19_AM.jpg)

## Build it yourself:

Download Processing 3.3.7
https://processing.org/download/

**Install the Minim library**

Tools -> Add Tool... -> Libraries tab -> Search for "Minim" -> Select it then click "Install"

**Install the G4P library**

Download the latest build of G4P. Click the sourceforge link on this page:
http://www.lagers.org.uk/g4p/download.html

Extract the zip, and place extracted G4P folder in Processing's library directory 
C:\Users\(username)\Documents\Processing\libraries\


**Open the project in Processing**

Open BeatSaberTrackEditor.pde

Run the project by clicking the triangular play button. Press the square stop button to end.

## Currently working on:

This project is no longer being worked on.

If someone can somehow get .ogg support working, I may pick this project back up.

## Next steps:

Roadmap if the project was picked up again:

.ogg support!

Cut, undo, redo.

Offset track data to align with song

Support triplets, zooming
