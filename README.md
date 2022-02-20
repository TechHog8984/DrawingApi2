# DrawingApi2
Custom synapse Drawing API

# Why?
The synapse Drawing API is doodoo, so I made my own. This is fully backwards compatible and also includes many useful features and benefits.


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
