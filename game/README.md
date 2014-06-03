## Overview

This program implements a visual novel.  The purpose is to illustrate 
one way to use SDL2 and Lua to build a 2D video game.

The project contents include the following.

    src/ - The app's C source code.

    working/ - The working directory when testing the program. 
               Put files needed by the program here.

    lua/ - The Lua source code. (Needed for the Windows build.)

    osx/ - Build scripts to generate package installer for Mac OS X distribution.

    ios/ - Xcode project to generate installer for iOS distribution.

    win/ - Files needed to build on Windows.
           Also will include a script to build a Windows installer.

    android/ - Will contain scripts to build and test for Android.
               Also will include script to build Android installation file.

## Building the code

### Mac

Downlowd the source distributions of SDL2 and SDL2_ttf, and do the following in both of them:

    ./configure
    make
    sudo make install

This installs the library include files into /usr/local/include/SDL2 and the library binaries 
in /usr/local/lib.

Run build.sh to build and run on success.  Run run.sh to run already built executable.

### Windows

You can try getting the build script build.bat working on your system.
Alternatively, you should create a Visual Studio project to build the code.

## Running

After building


## Buttons

In this project, a button is a gui primitive that can be used for the following purposes.

- Render an image
- Render a single line of text
- Define a clickable region

Button instances are created from the following functions exported by the button module.

                function                |     description
--------------------------------------- | -----------------------------------------
create_from_texture(t, x, y, w, h)      | create button from an existing texture
create_from_image(filename, x, y, w, h) | create button from image
create_from_text(text, x, y, font)      | create button from text using given font

Examples:

    Button   = require('app.Button')
    stop_btn = Button.create_from_text("Stop", 100, 160)
    tree_btn = Button.create_from_image("images/tree.bmp", 200, 50)


A button instance is a table that contains the following keys:

key | value
--- | -----
 t  | the texture to render 
 x  | the x coordinate of the button
 y  | the y coordinate of the button
 w  | the width of the button
 h  | the height of the button

A metatable provides the following functions to buttons.

   function    |    description
-------------- | -----------------
draw()         | Draw the button at its x,y coordinate.
contains(x, y) | Returns true if (x, y) are inside the button.

Examples:

    stop_btn:draw()
    if stop_btn:contains(x, y) then quit() end

## Textures

There are 2 ways to create textures directly: load from an image file or create 
from a font. You can also create textures indirectly by creating buttons. In either 
case, you need to first obtain a reference to the textures module as follows.

    textures = require('eng.textures')

To load an image, call the image function of the textures module as follows.

    ima, w, h = textures.image('textures/ima.bmp')

Textures obtained through the image function are cached in the textures module,
so it is inexpensive to call the image function repeatedly for a given image file.

To create an image from a font, you need to first get a font and then
use this with the textures module to create the texture.

    dialog_font = fonts.get('dialog')
    text, w, h = textures.text('Hello', dialog_font)

Render a texture by calling its draw method.

    ima:draw()

To delete a texture, set all references to the texture to nil.

    ima = nil

Removing all references to a texture will cause the texture to eventually be garbage collected.
During garbage collection, the texture's __gc method will invoke the C function to destroy the
texture.  If you do not want to wait for the garbage collector to run at an unknown point in the
future, then force garbage collection as follows.

    collectgarbage()

## Fonts

Fonts are loaded through the fonts module.  Obtain a reference to this module as follows.

    fonts = require('eng.fonts')

The fonts module exports a single function named 'get', which is used as follows to obtain
references to loaded fonts.

    dialog_font = fonts.get('dialog')

The fonts module contains an internal table named 'fontspecs', which contains the game's
predefined fonts.  You should customize this table to define the fonts you need. The following
is an example of the fontspecs table.

    local fontspecs = {
            dialog = { filename = 'fonts/DroidSansMono.ttf', size = 16 },
            button = { filename = 'fonts/DroidSansMono.ttf', size = 22 },
            title  = { filename = 'fonts/DroidSansMono.ttf', size = 28 }
    }

Font instances are used in the following functions.

    textures.text(text, font)
    Button.create_from_text(text, x, y, font)

If font is omitted in a call to Button.create_from_text, then the "button" font is used.
For this reason a button font should always be included in fontspecs.


## Sound effects (and small music)

Music data that is small can be treated like sound effects, which means the song can be completely
loaded into RAM.  Large sized music will take up too much space, requiring a streaming
process whereby chunks of sound data are read from persistent storage and mixed into the
audio buffers.  Also, we need to add code that decodes audio samples from ogg files.  Ogg files
are needed to reduce the size of audio data stored with the game.

Sound data is in wave format and stored under a folder named 'waves'. To play a wave file,
get a wave object from the waves module and then call its play function.  (Use the colon operator
to call the wave's play function.)

    waves = require('eng.waves')
    door = waves.get('waves/door.wav')
    door:play()

Call the loop method of a wave object to make the sound play continuously until its stop
method is called.

    wave = waves.get('waves/music.wav')
    music = wave.loop()
    ...
    music:stop()


## Architecture Notes

The code is written in C and Lua.

All userdata is light, which means that metatables are not attached to any userdata on
the C-side.  To guard against resource leaks, the Lua side always wraps a userdata object
in a table with a metatable with a garbage collection function.  This garbage collection
function is responsible to de-allocate resources.

Wrapped userdata objects currently include textures, fonts and waves (sound data).

I placed Lua code that I feel belongs on the side of the engine developer under the
folder named 'eng'. I may change this name to 'res' because the modules in this folder
manage resources.

The program as it is written is prone to memory fragmentation.  A memory management
strategy is needed to fix this.

I ill also redo the way rendering works.  There is no need to repeatedly call draw if
nothing changes.

