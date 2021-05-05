# Stormworks-2-Mobile
The Stormworks 2 Mobile project is all about controlling Stormworks creations from a mobile platform.

# Modifications

If you make modifications to the project we would greatly apreciate it to let us know what you changed. And, if other players also want that modification, please share it to them.
# Installation

Please follow the installation procedure step by step, it's not a hard one. If you experience any difficulties please make a ticket on our Discord server.

1. Install the APK on your Android phone. It can be found here https://drive.google.com/drive/folders/12gHON-0CU6Nxu7ISQH-hBKtJIH4eVM9N?usp=sharing.
2. Install XAMPP, here is a download link: https://www.apachefriends.org/download.html.
3. Go to the installation directory of XAMPP and open the htdocs folder.
4. Download the files from here (https://www.github.com/T1ckeR/Stormworks-2-Mobile/tree/main/Web%20Server) into the HTDOCS folder.
5. Open the XAMPP application and start the Apache service. 
6. Open Stormworks and make a new creation.
7. Make a microcontroller and put a Lua block in there.
8. If you want to use the image part of the app please put this (https://www.github.com/T1ckeR/Stormworks-2-Mobile/tree/main/Stormworks%20Scripts%2FimageScript.lua) Lua code into your microcontroller. If you want to use the control side of the app (joysticks, buttons, sliders) then please put this (https://www.github.com/T1ckeR/Stormworks-2-Mobile/tree/main/Stormworks%20Scripts%2FcontrolSystem.lua) code into your Lua block.

The control system Lua block hass the following composite outputs:
<br>NUMBERS CHANNEL:
<br>1 | AXIS 1
<br>2 | AXIS 2
<br>3 | AXIS 3
<br>4 | AXIS 4

<br>
5 | SLIDER 1
6 | SLIDER 2
7 | SLIDER 3
8 | SLIDER 4
