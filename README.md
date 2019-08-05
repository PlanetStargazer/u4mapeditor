# u4mapeditor

The U4 map viewer was written with LÖVE2D for LUA and should run on any modern Windows PC with at least 1920x1080 resolution.

In order to get the program to work, you need to copy WORLD.MAP from your copy of Ultima 4 to the same folder where you extracted the 7zip file.

When you run the u4mapviewer.exe you are greeted by a view of Chunk #0 of the map in the middle of the screen. With WASD you can move between chunks. Using the mouse you can draw tiles onto the active chunk. Picking new tiles is as easy as clicking onto them (there's a toolbar below the map). You can scroll through all tiles using the scroll wheel of your mouse.

If you don't want to use the mouse, you can move the cursor within a chunk by the cursor keys. You change the active tile using the comma and semicolon keys. The toolbar can be scrolled using plus and minus on your numpad.

You can save changes by pressing Ctrl+X.

By using F1 to F4 you can switch between the following tilesets: C64, EGA, John Steele EGA, John Steele VGA.

Since my dream goal is writing a CRPG inspired by the early Ultima games, I started working on a proper game engine which is actually included in the editor at the moment. By pressing TAB you can switch between the editor and the "game". The game allows the avatar to move around the world map by using WASD. If you want to mute the background music, press M. In the editor mode you can press J to jump to the chunk the avatar is in.

Please let me know what you think about my little project. Every comment is appreciated!
Feel free to contact me via ezekiel (dot) stargazer (at) gmail (dot) com. ^_^
