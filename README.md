# DrawingApi2
Custom synapse Drawing API

# Why?
The synapse Drawing API is doodoo, so I made my own. This is fully backwards compatible and also includes many useful features and benefits.

# Links

#### [Changelog](#changelog)
#### [Extra info](#extra-info-1)

# Changelog

## V1
> ### Initial creation of code.
> ### Functions exactly as the DrawingAPI would.

## V1.1
> ### Added support for passing in a table containing property info instead of the type.
> ### You can still use Drawing.new and pass through the type normally.
> ### Example:
 ```lua
 Drawing.new{'Square', Position = Vector2.new(1,1), ...}
 ```

## V1.2
> ### Added more color support.
> ### You can now pass through a string containing one of 2 things for the Color property: A Hex Color Code or a string with RGB info.
> ### Example of a Hex Color Code:
  ```lua
  Drawing.new{'Square', Color = '#40c254'}; --green color
  ```
> ### Example of RGB info:
  ```lua
  Drawing.new{'Square', Color = '255, 100, 255'}; --pink color
  ```
> ### For the RGB info, any seperator will work, as long as it is not a number. (There can even be full words or sentences between them, if you really want)

## V1.3
> ### Bug fixes with the color support
> ### Fully documented the code.

## V1.4
> ### Added aliases for Drawing.new: .new, .New, .create, .Create
> ### Added support for custom objects.
> ### See [Examples](/examples) for more info.

## V1.5
> ### Added Parent property to all objects.
> ### Is used in addition to Descendants. When you set an Object's Parent, it will add said Object to its now Parent's Descendants table. This will make sure that whenever you :Remove the Parent, Object will be removed as well.

## V1.6 (BIG UPDATE, !MISSING NOTES!)
> ### Bug fixes and a couple of minor overall code improvements.
> 
> ### Added default custom objects which is the TextButton in [this example](/examples/Custom%20TextButton.lua) (improved heavily) and TextLabel.
> ### These default custom objects can be accessed once calling Drawing.AddDefaultCustomObjects().
> 
> ### Added cursor which can be enabled / disabled by calling Drawing.(Enable/Disable)Cursor().
> ### Cursor is disabled by default.
> 
> ### Added mouse input detection to handle clicking and other mouse-related events.
> ### Added "MouseButton1Up", "MouseButton1Down", "MouseButton1Click", and "Changed" events for all objects.
> ### Added "CanDrag"(\<boolean>) property that determines whether or not the object is draggable.
> ### Added some boolean properties used internally with click detection for all objects, although you can still access them (and even set them, although that will definitely mess with things if you don't know what you are doing)
  > #### ^ These are as follows:
  > #### "CanDrag"
  > #### "Hovering"
  > #### "CanClick"
  > #### "Dragging"
  > #### "IsMouseButton1Up" &
  > #### "IsMouseButton1Down"
> # !NOTE! AS OF NOW Mouse Input features ONLY WORK on "Image"s and "Square"s!!!!

# Extra info
