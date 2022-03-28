<!--

- > ### Drawing Properties (On Screen):
  - > #### _Name_:
      - > ##### type: "`types`"
      - > ##### default: `value`

- > ### Object Properties:
  - > #### _Name_:
    - > ##### type: "`string`"
    - > ##### default: `"Line"`
  - > #### _ClassName_:
    - > ##### type: "`string`"
    - > ##### default: `"Line"` 

-->

# Objects

> ## Default (All Objects)
- > ### Drawing Properties (On Screen):
  - > #### _Visible_:
    - > ##### type: "`boolean`"
    - > ##### default: `true`
  - > #### _ZIndex_:
    - > ##### type: "`number`"
    - > ##### default: `0`
  - > #### _Transparency_:
    - > ##### type: "`number`"
    - > ##### default: `1`
- > ### Object Properties:
  - > #### _Name_:
    - > ##### type: "`string`"
    - > ##### default: `"Object"`
  - > #### _ClassName_:
    - > ##### type: "`string`"
    - > ##### default: `"Object"`
  - > #### _Descendants_:
    - > ##### type: "`table`"
  - > #### _Parent_:
    - > ##### type: "`Object"` (table)
    - > ##### default: `nil`
  - > #### _CanDrag_:
    - > ##### type: "`boolean`"
    - > ##### default: `false`
  - > #### _Hovering_:
    - > ##### type: "`boolean`"
    - > ##### default: `false`
  - > #### _CanClick_:
    - > ##### type: "`boolean`"
    - > ##### default: `false`
  - > #### _CanRightClick_:
    - > ##### type: "`boolean`"
    - > ##### default: `false`
  - > #### _Dragging_:
    - > ##### type: "`boolean`"
    - > ##### default: `false`
  - > #### _IsMouseButton1Up_:
    - > ##### type: "`boolean`"
    - > ##### default: `false`
  - > #### _IsMouseButton1Down_:
    - > ##### type: "`boolean`"
    - > ##### default: `false`
  - > #### _IsMouseButton2Up_:
    - > ##### type: "`boolean`"
    - > ##### default: `false`
  - > #### _IsMouseButton2Down_:
    - > ##### type: "`boolean`"
    - > ##### default: `false`
  - > #### _MouseButton1Up_:
    - > ##### type: "`Event`" (userdata)
  - > #### _MouseButton1Down_:
    - > ##### type: "`Event`" (userdata)
  - > #### _MouseButton1Click_:
    - > ##### type: "`Event`" (userdata)
  - > #### _MouseButton2Up_:
    - > ##### type: "`Event`" (userdata)
  - > #### _MouseButton2Down_:
    - > ##### type: "`Event`" (userdata)
  - > #### _MouseButton2Click_:
    - > ##### type: "`Event`" (userdata)
  - > #### _Changed_:
    - > ##### type: "`Event`" (userdata)

> ## Line
- > ### Drawing Properties (On Screen):
  - > #### _Color_:
    - > ##### type: "`Color3,string`"
    - > ##### default: `Color3.new(1,1,1)` (white)
  - > #### _Thickness_:
    - > ##### type: "`number`"
    - > ##### default: `0`
  - > #### _From_:
    - > ##### type: "`Vector2`"
    - > ##### default: `Vector2.new(0,0)` (top left)
  - > #### _To_:
    - > ##### type: "`Vector2`"
    - > ##### default: `Vector2.new(0,0)` (top left)
- > ### Object Properties:
  - > #### _Name_:
    - > ##### type: "`string`"
    - > ##### default: `"Line"`
  - > #### _ClassName_:
    - > ##### type: "`string`"
    - > ##### default: `"Line"`

> ## Text
- > ### Drawing Properties (On Screen):
  - > #### _Color_:
    - > ##### type: "`Color3,string`"
    - > ##### default: `Color3.new(1,1,1)` (white)
  - > #### _Text_:
      - > ##### type: "`string`"
      - > ##### default: `"Text"`
  - > #### _Size_:
      - > ##### type: "`number`"
      - > ##### default: `16`
  - > #### _Center_:
      - > ##### type: "`boolean`"
      - > ##### default: `false`
  - > #### _Outline_:
      - > ##### type: "`boolean`"
      - > ##### default: `false`
  - > #### _OutlineColor_:
      - > ##### type: "`Color3,string`"
      - > ##### default: `Color3.new(0,0,0)` (black)
  - > #### _Position_:
      - > ##### type: "`Vector2`"
      - > ##### default: `Vector2.new(0,0)` (top left)
  - > #### _TextBounds_:
      - > ##### type: "`Vector2`"
  - > #### _Font_:
      - > ##### type: "`number,Drawing.fonts`"
      - > ##### default: `0` (UI, see [this page](https://x.synapse.to/docs/reference/drawing_lib.html#fonts) for a list of fonts)
- > ### Object Properties:
  - > #### _Name_:
    - > ##### type: "`string`"
    - > ##### default: `"Text"`
  - > #### _ClassName_:
    - > ##### type: "`string`"
    - > ##### default: `"Text"`

> ## Image
- > ### Drawing Properties (On Screen):
  - > #### _Data_:
      - > ##### type: "`string`" (image data i.e game:HttpGet(url))
  - > #### _Size_:
      - > ##### type: "`Vector2`"
      - > ##### default: `Vector2.new(16,16)`
  - > #### _Position_:
      - > ##### type: "`Vector2`"
      - > ##### default: `Vector2.new(0,0)` (top left)
  - > #### _Rounding_:
      - > ##### type: "`boolean,number`"
      - > ##### default: `0`
- > ### Object Properties:
  - > #### _Name_:
    - > ##### type: "`string`"
    - > ##### default: `"Image"`
  - > #### _ClassName_:
    - > ##### type: "`string`"
    - > ##### default: `"Image"` 

> ## Circle
- > ### Drawing Properties (On Screen):
  - > #### _Color_:
    - > ##### type: "`Color3,string`"
    - > ##### default: `Color3.new(1,1,1)` (white)
  - > #### _Thickness_:
      - > ##### type: "`number`"
      - > ##### default: `16`
  - > #### _NumSides_:
      - > ##### type: "`number`"
  - > #### _Radius_:
      - > ##### type: "`number`"
      - > ##### default: `1`
  - > #### _Filled_:
      - > ##### type: "`boolean`"
      - > ##### default: `true`
  - > #### _Position_:
      - > ##### type: "`Vector2`"
      - > ##### default: `Vector2.new(0,0)` (top left)
- > ### Object Properties:
  - > #### _Name_:
    - > ##### type: "`string`"
    - > ##### default: `"Circle"`
  - > #### _ClassName_:
    - > ##### type: "`string`"
    - > ##### default: `"Circle"` 

> ## Square
- > ### Drawing Properties (On Screen):
  - > #### _Color_:
    - > ##### type: "`Color3,string`"
    - > ##### default: `Color3.new(1,1,1)` (white)
  - > #### _Thickness_:
      - > ##### type: "`number`"
      - > ##### default: `16`
   - > #### _Size_:
      - > ##### type: "`Vector2`"
      - > ##### default: `Vector2.new(0,0)` (top left)
   - > #### _Position_:
      - > ##### type: "`Vector2`"
      - > ##### default: `Vector2.new(16,16)`
- > ### Object Properties:
  - > #### _Name_:
    - > ##### type: "`string`"
    - > ##### default: `"Square"`
  - > #### _ClassName_:
    - > ##### type: "`string`"
    - > ##### default: `"Square"` 

> ## Quad
- > ### Drawing Properties (On Screen):
  - > #### _Color_:
    - > ##### type: "`Color3,string`"
    - > ##### default: `Color3.new(1,1,1)` (white)
  - > #### _Thickness_:
      - > ##### type: "`number`"
      - > ##### default: `16`
  - > #### _PointA_:
      - > ##### type: "`Vector2`"
      - > ##### default: `Vector2.new(0,0)` (top left)
  - > #### _PointB_:
      - > ##### type: "`Vector2`"
      - > ##### default: `Vector2.new(0,0)` (top left)
  - > #### _PointC_:
      - > ##### type: "`Vector2`"
      - > ##### default: `Vector2.new(0,0)` (top left)
  - > #### _PointD_:
      - > ##### type: "`Vector2`"
      - > ##### default: `Vector2.new(0,0)` (top left)
  - > #### _Filled_:
      - > ##### type: "`boolean`"
      - > ##### default: `true`
- > ### Object Properties:
  - > #### _Name_:
    - > ##### type: "`string`"
    - > ##### default: `"Quad"`
  - > #### _ClassName_:
    - > ##### type: "`string`"
    - > ##### default: `"Quad"`

> ## Triangle
- > ### Drawing Properties (On Screen):
  - > #### _Color_:
    - > ##### type: "`Color3,string`"
    - > ##### default: `Color3.new(1,1,1)` (white)
  - > #### _Thickness_:
      - > ##### type: "`number`"
      - > ##### default: `16`
  - > #### _PointA_:
      - > ##### type: "`Vector2`"
      - > ##### default: `Vector2.new(0,0)` (top left)
  - > #### _PointB_:
      - > ##### type: "`Vector2`"
      - > ##### default: `Vector2.new(0,0)` (top left)
  - > #### _PointC_:
      - > ##### type: "`Vector2`"
      - > ##### default: `Vector2.new(0,0)` (top left)
  - > #### _Filled_:
      - > ##### type: "`boolean`"
      - > ##### default: `true`
- > ### Object Properties:
  - > #### _Name_:
    - > ##### type: "`string`"
    - > ##### default: `"Triangle"`
  - > #### _ClassName_:
    - > ##### type: "`string`"
    - > ##### default: `"Triangle"`

# Custom Objects

> ## TextButton

> ## TextLabel
