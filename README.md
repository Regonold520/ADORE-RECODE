# ADÖRE

**ADÖRE** is a helper library for [LÖVE2D](https://love2d.org/) designed to make common game development tasks faster and cleaner.  
It provides built-in systems for things like:
- An easy to use UI system with anchors
- Simple object system with parent and child relations
- Easy and efficient drawing
- Camera translations and managment
- AND MORE :D

Ok so stuff below here is cool docs im obliged to make so you can actually like use it:

## Setup
Setup is super easy, either drag in the /lib folder into the root of your LOVE project, or download the demo project to test it out!
You also will need a sprites folder because thats the folder the lib scans for **.png** files not yucky jpgs... yet

## Important Stuff You Should Know
Ive added vector 2s (dont tell anyone but its secretly just a table with an X and Y) 
like {x = 0, y = 0} == Vector2(0,0), ill add more helper stuff to do with them in the future

### Main.lua
just make it look something like this, just make it require the main adore file in the lib and call the required calls
```
local adore = require("lib/adore")

function love.load()
    adore:load()
end

function love.update(dt)
    adore:update(dt)
end

function love.draw()
    adore:draw()
end
```

## Objects
Objects are going to be everything in your project (apart from UI cus thats like different)
The way you make an object is super simple all you do is run:
```
Adore.lib.object:new(quad, fileName, newPos, id, layer, scriptPath)
```
There are some variables all objects have that are made by calling this (objects are just tables with these variables in them)
The datatypes will be shown with []
- quad [Quad]
- drawable [Image]
- globalPos [Vector2]
- localPos [Vector2]
- rot [Number]
- scale [Vector2]
- id [String]
- layer [Number]
- script [Table, with script stuff in it]
- tags [Table, with taggy stuff in it]
- parent [Table / Object]
- children [Table, with objecty stuff in it]

Here is an example of an object being made in the Demo Project:
```
local bredBG = Adore.lib.object:new(love.graphics.newQuad(0,0,58,58,58,58), "breadBacker.png",Vector2(0), "bredBG", 0, "scripts/bredBG")
```

Objects have parents and children, the children of parents inherit the positions of all parents above it resulting in global position and local position being the object's personal offset for a position

basically globalPosition = all parents local positions added together.


The way you make an object parented to another is by doing:
```
parentObject:addChild(childObject)
```
There are a bunch of object helper functions in **lib/object.lua** i reccomend checking it out.

Objects also have "tags", just a list of strings that you can use to identify them in a controlled way

## Ui
i have done UI in an interesting way, there are "anchors" all around the screen, (8 cardinal directions + the middle), and any ui placed at an anchor point will autofix itself to fit on the screen, I will be adding custom offsets like percentage screen amounts and such, but for now you get the anchor points

There are different ways of making different UI objects for now we have 3 of them:
- Panel ```Adore.ui:addPanel(id, anchor, offset, uiType, layer, scriptPath)```
- Button ```Adore.ui:addPanel(id, anchor, offset, uiType, layer, scriptPath)```
- Text ```Adore.ui:addText(id, anchor, offset, layer, font)```

All UI elements share these common values however, similar to objects:
- type [String]
- anchor = [String (anchor name)]
- offset = [Vector2]
- quad = [Quad]
- drawable = [Image, Text etc.]
- layer = [Number]
- anchorOffset = [Vector2]
- script = [Table, but full of scripty stuff]

For Ui that requires some sort of Image like a panel or a button, you will have to register a uiType in advance with:
```
Adore.ui:registerUiType(quad, drawable, id)
```

And with things like text you will need to register fonts like:
```
Adore.ui:addFont(id, filePath)
```

Here is an example of a panel being made in the Demo Project, with uiType registeration:
```
Adore.ui:registerUiType(love.graphics.newQuad(0,0,32,32,32,32),Adore:findSprite("breadpanel.png"), "test")
Adore.ui:addButton("testPanel", "tr", Vector2(0,0), Adore.ui.types.test, 1)
```

## Camera
pretty straightforward, it is just a set of values that control how to game is viewed, and these values are:

```
Adore.camera.x = 0
Adore.camera.y = 0
Adore.camera.zoom = 1
Adore.camera.rot = 0
```

### I havent included EVERYTHING in the library so i reccomend downloading the demo project or just root throught the librsry for all the nuancy functions and stuff. Thats pretty much it (for now) Have fun coding :D !
