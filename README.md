# DrawingApi2
Custom synapse Drawing API

# Why?
The synapse Drawing API is doodoo, so I made my own. This is fully backwards compatible and also includes many useful features and benefits.

# Links

## [Changelog](#changelog)
## [Extra info](#extra%20info)

# Changelog
<!-- V1 {<br>
<p>Main creation of the code.<br>
Currently is just a clone of the Drawing API and only supports fonts and Drawing.new</p>
}

V1.1 {
  
} -->

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

# Extra info
