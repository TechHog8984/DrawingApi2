--[string manipulation]
local gmatch = string.gmatch;
local sub = string.sub;
local find = string.find;
local match = string.match;

--[other helper functions]
local CreateEvent = assert(loadstring(game:HttpGet'https://raw.githubusercontent.com/TechHog8984/Event-Manager/main/src.lua'), 'Failed to get CreateEvent.')();
local taskspawn = task.spawn;
local tableinsert = table.insert;

local tableclone; tableclone = function(...)
	local Result = {};

	for I, Table in next, ({...}) do
		for I,V in next, Table do
			if type(V) == 'table' then
				Result[I] = tableclone(V);
			elseif type(V) ~= 'nil' then
				Result[I] = V;
			end;
		end;
	end;

	return Result;
end;

--[hook the old Drawing.new function in order to get the necessary renderproperty and renderobject functions]

--get the old Drawing table and new function
local OldDrawing = Drawing;
local Drawingnew = OldDrawing.new;

--if the functions are already in environment (i.e the script was already ran)
local CreateRO = createrenderobject;
local DestroyRO = destroyrenderobject;
local GetRP = getrenderproperty;
local SetRP = setrenderproperty;

--check if they any one of them doesn't exist
if not (CreateRO and DestroyRO and GetRP and SetRP) then
	--get the line metatable for the __index and __newindex functions
	local LineMT = getupvalue(Drawingnew, 4);
	local Line__index = LineMT.__index;
	local Line__newindex = LineMT.__newindex;

	--get all of the functions through either the Drawing.new function of the line metatable functions
	CreateRO = CreateRO or getupvalue(Drawingnew, 1);
	DestroyRO = DestroyRO or getupvalue(Line__index, 3);
	GetRP = GetRP or getupvalue(Line__index, 4);
	SetRP = SetRP or getupvalue(Line__newindex, 4);

	--put then in the global environment so this doesn't happen every time the script is ran
	local genv = getgenv();
	genv.createrenderobject = CreateRO;
	genv.destroyrenderobject = DestroyRO;
	genv.getrenderproperty = GetRP;
	genv.setrenderproperty = SetRP;
end;

--[main script]
local function ObjectRemove(Object)
	--if the object has descendants, loop through them and remove then
	if Object.Descendants then
		for I, Descendant in next, Object.Descendants do
			if type(Descendant) == 'table' and rawget(Descendant, '__exists') then
				Descendant:Remove();
			end;
		end;
	end;
	--set the __exists value of the object to false;
	rawset(Object, '__exists', false);
	--run destroyrenderproperty on the object, removing it from the D3D render list
	return DestroyRO(rawget(Object, '__object'));
end;

--some values that are used multiple times for property lists
local white = Color3.new(1,1,1);
local black = Color3.new(0,0,0);
local ZeroZero = Vector2.new(0, 0);
local SixteenSixteen = Vector2.new(16, 16);
local ColorProperty = {'Color3,string', white};
local ThicknessProperty = {'number', 16};

--actual Drawing table
local Drawing = {
	Fonts = OldDrawing.Fonts,
	Objects = {},
};

local Properties;
do --properties
	--for below properties, the first value in the table is the expected type(s), and the second value is the default value.
	--if the default value is nil, it will be the true default that the createrenderobject function assigns it.
	
	Properties = {
		Default = {
			Drawing = {
				Visible = {'boolean', true},
				ZIndex = {'number', 0},
				Transparency = {'number', 1},
			},
			Object = {
				Name = {'string', 'Object'},
				ClassName = {'string', 'Object'},
				Remove = {'function', ObjectRemove},
				Destroy = {'function', ObjectRemove},
				Descendants = {'table', nil},
				Parent = {'table', nil},

				CanDrag = {'boolean', false},
				Hovering = {'boolean', false},
				CanClick = {'boolean', false},
				CanRightClick = {'boolean', false},

				Dragging = {'boolean', false},
				IsMouseButton1Up = {'boolean', false},
				IsMouseButton1Down = {'boolean', false},
				IsMouseButton2Up = {'boolean', false},
				IsMouseButton2Down = {'boolean', false},

				MouseButton1Up = {'userdata', nil},
				MouseButton1Down = {'userdata', nil},
				MouseButton1Click = {'userdata', nil},
				MouseButton2Up = {'userdata', nil},
				MouseButton2Down = {'userdata', nil},
				MouseButton2Click = {'userdata', nil},
				
				Changed = {'userdata', nil},
			},
		},
		Line = {
			Drawing = {
				Color = ColorProperty,

				Thickness = {'number', 0},
				From = {'Vector2', ZeroZero},
				To = {'Vector2', ZeroZero},
			},
			Object = {
				Name = {'string', 'Line'},
				ClassName = {'string', 'Line'},
			},
		},
		Text = {
			Drawing = {
				Color = ColorProperty,

				Text = {'string', 'Text'},
				Size = {'number', 16},
				Center = {'boolean', false},
				Outline = {'boolean', false},
				OutlineColor = {'Color3,string', black},
				Position = {'Vector2', ZeroZero}, 
				TextBounds = {'Vector2', nil},
				Font = {'number', 0},
			},
			Object = {
				Name = {'string', 'Text'},
				ClassName = {'string', 'Text'},
			},
		},
		Image = {
			Drawing = {
				Data = {'string', nil},
				Size = {'Vector2', SixteenSixteen},
				Position = {'Vector2', ZeroZero},
				Rounding = {'boolean,number', 0},
			},
			Object = {
				Name = {'string', 'Image'},
				ClassName = {'string', 'Image'},
			},
		},
		Circle = {
			Drawing = {
				Color = ColorProperty,

				Thickness = ThicknessProperty,
				NumSides = {'number', 100},
				Radius = {'number', 1},
				Filled = {'boolean', true},
				Position = {'Vector2', ZeroZero},
			},
			Object = {
				Name = {'string', 'Circle'},
				ClassName = {'string', 'Circle'},
			},
		},
		Square = {
			Drawing = {
				Color = ColorProperty,

				Thickness = ThicknessProperty,
				Size = {'Vector2', SixteenSixteen},
				Position = {'Vector2', ZeroZero},
				Filled = {'boolean', true},
			},
			Object = {
				Name = {'string', 'Square'},
				ClassName = {'string', 'Square'},
			},
		},
		Quad = {
			Drawing = {
				Color = ColorProperty,

				Thickness = ThicknessProperty,
				PointA = {'Vector2', ZeroZero},
				PointB = {'Vector2', ZeroZero},
				PointC = {'Vector2', ZeroZero},
				PointD = {'Vector2', ZeroZero},
				Filled = {'boolean', true},
			},
			Object = {
				Name = {'string', 'Quad'},
				ClassName = {'string', 'Quad'},
			},
		},
		Triangle = {
			Drawing = {
				Color = ColorProperty,

				Thickness = ThicknessProperty,
				PointA = {'Vector2', ZeroZero},
				PointB = {'Vector2', ZeroZero},
				PointC = {'Vector2', ZeroZero},
				Filled = {'boolean', true},
			},
			Object = {
				Name = {'string', 'Triangle'},
				ClassName = {'string', 'Triangle'},
			},
		},
	};
	Drawing.Properties = Properties;
end;

--used for checking multiple types, such as how color can accept both a Color3 and a string
local function CheckType(Type, Value)
	--get the type of Value
	local ValueType = typeof(Value);
	--loop through each time there is something that isn't a comma (everything before / after a comma)
	for X in gmatch(Type, '([^,]+)') do
		--if this is the type of Value, then return true
		if X == ValueType then
			return true;
		end;
	end;
	--if no match was found, return false
	return false;
end;

local ObjectMT;
do --object metatable
	ObjectMT = {
		__index = function(self, Index)
			--bunch of checks for ease of debugging.
			--basically makes sure it is an object with the values that it should have
			if type(self) == 'table' then
				if rawget(self, '__exists') then
					local Holder = rawget(self, '__holder');
					if Holder then
						local Type = rawget(self, '__type') or rawget(self, 'ClassName');
						if Type then
							local Object = rawget(self, '__object');
							if Object then
								--find the property either in the default list or in the specific object's list
								local DrawingProperty = Properties.Default.Drawing[Index] or Properties[Type].Drawing[Index];
								local ObjectProperty = Properties.Default.Object[Index] or Properties[Type].Object[Index];
								if DrawingProperty or ObjectProperty then
									--get custom info, if it is a custom object, for a custom metatable
									local Custom = Drawing.CustomObjects[Type]
									if Custom and Custom.CustomMT and Custom.CustomMT.__index then
										--return either whatever __index returns or what would be returned without a custom mt (Holder[Index] or GetRP(Object, Index))
										return Custom.CustomMT.__index(self, Index) or Holder[Index] or (DrawingProperty and GetRP(Object, Index));
									else
										--if property exists and the custom info doesn't, return that property's value in the Holder, which contains all of the properties for the object, or the render property through GetRP
										return Holder[Index] or (DrawingProperty and GetRP(Object, Index));
									end;
								else
									return error(tostring(Index) .. ' is not a valid property for ' .. Type .. '.', 2);
								end;
							else
								return error('Object doesn\'t have an __object (Render Object).', 2);
							end;
						else
							return error('Object doesn\'t have an __type / ClassName.', 2);
						end;
					else
						return error('Object doesn\'t have an __holder.', 2);
					end;
				else
					return error('Object no longer exists.', 2);
				end;
			else
				return error('Expected Object (table), got ' .. typeof(self), 2);
			end;
		end,
		__newindex = function(self, Index, Value)
			--bunch of checks for ease of debugging.
			--basically makes sure it is an object with the values that it should have
			if type(self) == 'table' then
				if rawget(self, '__exists') then
					local Holder = rawget(self, '__holder');
					if Holder then
						local Type = rawget(self, '__type') or rawget(self, 'ClassName');
						if Type then
							local Object = rawget(self, '__object');
							if Object then
								local ChangedEvent = self.Changed;
								--check if we are setting Parent
								if Index == 'Parent' then
									if type(Value) == 'table' then
										--if we are setting parent to an actual object, add it to the descendants and set the property
										if Value.Descendants then
											table.insert(Value.Descendants, self);
										end;
										Holder[Index] = Value;
										if ChangedEvent then
											ChangedEvent:Fire(Index);
										end;
									elseif type(Value) == 'nil' then
										--if we are setting parent to nil, remove Object from the old parent's descendants table
										local OldParent = self.Parent;
										Holder[Index] = Value;
										if ChangedEvent then
											ChangedEvent:Fire(Index);
										end;
										if type(OldParent) == 'table' and OldParent.Descendants then
											local IndexIn = (table.find(OldParent.Descendants, self));
											if IndexIn then
												table.remove(OldParent.Descendants, IndexIn);
											end;
										end;
									end;
								else
									--get the property in a drawing property list or in an object property list (the distinction between the 2 will be present in a couple lines down)
									local DrawingProperty = Properties.Default.Drawing[Index] or Properties[Type].Drawing[Index];
									local ObjectProperty = Properties.Default.Object[Index] or Properties[Type].Object[Index];

									--get the type of the value, really only used for error checking
									local ValueType = typeof(Value);
									--check if the property exists
									if DrawingProperty or ObjectProperty then
										--check if we are setting the color to allow support for strings
										if Index == 'Color' then
											--just so that I don't f*ck up any variables
											local Old = Value;
											local New;

											if ValueType == 'Color3' then
												--if it is a Color3, just return that
												New = Old;
											elseif ValueType == 'string' then
												if sub(Value, 1, 1) == '#' then
													--if it starts with a # (a hex color code), use the Color3.fromHex function
													New = Color3.fromHex(Value);
												elseif match(Value, '%d') then
													--^otherwise, check if it has a number
													local RGB = {};
													--gets every number that has a number after it
													local m = gmatch(Value, '([%d]+)');
													--every time m is called, a new value is returned
													RGB[1] = m();
													RGB[2] = m();
													RGB[3] = m();

													--unpack the table and use the Color3.fromRGB function
													New = Color3.fromRGB(unpack(RGB));
												else
													return error('Invalid syntax for setting color. Try passing through a hex color code or rgb valuesz(three numbers seperated by any amount of non-number characters).', 2);
												end;
											end;

											Value = New;
										end;

										local Custom = Drawing.CustomObjects[Type]

										if DrawingProperty then
											--^check if it is a drawingproperty, so that we can set the renderproperty of the object
											if CheckType(DrawingProperty[1], Value) then
												--^validate the type
												local newindex = Custom and Custom.CustomMT and Custom.CustomMT.__newindex

												if (not newindex) or (not newindex(self, Index, Value)) then
												-- if not (Custom and Custom.CustomMT and (Custom.CustomMT.__newindex and Custom.CustomMT.__newindex(self, Index))) then
													Holder[Index] = Value;
													if ChangedEvent then
														ChangedEvent:Fire(Index);
													end;
													--^set the value to the holder, which holds all property values
													SetRP(Object, Index, Value);
													--^set the render property, so it actually affects the object on the screen
													return true;
												end;
											else
												return error('Expected ' .. DrawingProperty[1] .. ', got ' .. ValueType, 2);
											end;
										elseif ObjectProperty then
											--^check if it is an objectproperty, so that we DON'T set the renderproperty of the object
											if CheckType(ObjectProperty[1], Value) then
												local newindex = Custom and Custom.CustomMT and Custom.CustomMT.__newindex

												if (not newindex) or (not newindex(self, Index, Value)) then
												-- if not (Custom and Custom.CustomMT and (Custom.CustomMT.__newindex and Custom.CustomMT.__newindex(self, Index))) then
													Holder[Index] = Value;
													if ChangedEvent then
														ChangedEvent:Fire(Index);
													end;
													--^set the value to the holder, which holds all property values
													return true;
												end;
											else
												return error('Expected ' .. ObjectProperty[1] .. ', got ' .. ValueType, 2);
											end;
										end;
									else
										return error(tostring(Index) .. ' is not a valid property for ' .. Type .. '.', 2);
									end;
								end;
							else
								return error('Object doesn\'t have an __object (Render Object).', 2);
							end;
						else
							return error('Object doesn\'t have an __type / ClassName.', 2);
						end;
					else
						return error('Object doesn\'t have an __holder.', 2);
					end;
				else
					return error('Object no longer exists.', 2);
				end;
			else
				return error('Expected Object (table), got ' .. typeof(self), 2);
			end;
		end,
		__tostring = function(self)
			--couple of checks for ease of debugging.
			--basically makes sure it is an object with the values that it should have
			if type(self) == 'table' then
				if rawget(self, '__exists') then
					--return either the Name of the object or its ClassName
					return self.Name or self.ClassName;
				else
					return error('Object no longer exists.', 2);
				end;
			else
				return error('Expected Object (table), got ' .. typeof(self), 2);
			end;
		end,
	};
	Drawing.ObjectMT = ObjectMT;
end;

--for making custom objects
local CustomObjects = {};

Drawing.CustomObjects = CustomObjects;
local function AddCustomObject(Type, RealType, CustomProperties, CustomMT, Init)
	if type(Type) == 'string' then
		if type(RealType) == 'string' then
			if type(CustomProperties) == 'table' then
				CustomObjects[Type] = {
					Raw = CustomProperties and CustomProperties.Raw,
					Real = RealType,
					CustomMT = CustomMT,
					Init = Init,
				};
				CustomProperties.Raw = nil;
				local RealProperties = tableclone(Properties[RealType]);
				for I,V in next, CustomProperties.Drawing do
					RealProperties.Drawing[I] = V;
				end;
				for I,V in next, CustomProperties.Object do
					RealProperties.Object[I] = V;
				end;

				CustomObjects[Type].Properties = RealProperties;

				Properties[Type] = RealProperties;
			else
				return error('Expected Properties (table) as third argument, got ' .. type(Properties), 2);
			end;
		else
			return error('Expected RealType (string) as second argument, got ' .. type(RealType), 2);
		end;
	else
		return error('Expected Type (string) as first argument, got ' .. type(Type), 2);
	end;
end;
Drawing.addCustom = AddCustomObject;

function Drawing:AddDefaultCustomObjects()
	local DefaultTextObjectProperties = {
		Raw = {		
			__textobject = {},
		},
		Drawing = {
			Size = {'Vector2', Vector2.new(230, 100)},
			Position = {'Vector2', Vector2.new(1920/2 - 115, 1080/2 - 50)},
		},
		Object = {
			Text = {'string', 'Text'},
			TextColor = {'Color3,string', '0 0 0'},

			TextTransparency = {'number', 1},
			TextSize = {'number', 25},
			TextCentered = {'boolean', false},
			TextOutline = {'boolean', false},
			TextOutlineColor = {'Color3,string', '1 1 1'},
			TextBounds = {'Vector2', nil},
			TextXAlign = {'string', 'Center'},
			TextYAlign = {'string', 'Center'},
			Font = {'number', 0},
		}
	};

	local function PositionText(TextObject)
		if type(TextObject) == 'table' and rawget(TextObject, '__exists') then
			local ParentObject = TextObject.Parent;
			if type(ParentObject) == 'table' then
				local ParentPosition = ParentObject.Position;
				local ParentSize = ParentObject.Size;
				
				local X, Y;
				if ParentObject.TextXAlign == 'Center' then
					X = (ParentPosition.X + ParentSize.X / 2) - TextObject.TextBounds.X / 2;
				elseif ParentObject.TextXAlign == 'Left' then
					X = ParentPosition.X;
				elseif ParentObject.TextXAlign == 'Right' then
					X = (ParentPosition.X + ParentSize.X) - TextObject.TextBounds.X;
				end;

				if ParentObject.TextYAlign == 'Center' then
					Y = (ParentPosition.Y + ParentSize.Y / 2) - TextObject.TextBounds.Y / 2;
				elseif ParentObject.TextYAlign == 'Top' then
					Y = ParentPosition.Y;
				elseif ParentObject.TextYAlign == 'Bottom' then
					Y = (ParentPosition.Y + ParentSize.Y) - TextObject.TextBounds.Y;
				end;

				if X and Y then
					TextObject.Position = Vector2.new(X, Y);
				end;
			end;
		end;
	end;

	local Metatable = {	
		__index = function(self, Index, Value)
			--get the text object
			local TextObject = rawget(self, '__textobject');
			if type(TextObject) == 'table' then
				if Index == 'TextBounds' or Index == 'Font' then
					return TextObject[Index];
				elseif sub(Index, 1, 4) == 'Text' then
					--^if the index starts with Text
					if Index == 'Text' then
						--if the index actually is text, then return the text of the TextObject.
						return TextObject.Text
					else
						--otherwise, subtract the Text and see if that property exists (I.E.: TextTransparency -> Transparenecy, TextColor -> Color, etc,.)
						local RealIndex = sub(Index, 5, -1);
						if Properties.Default.Drawing[RealIndex] or Properties.Default.Object[RealIndex] or Properties.Text.Drawing[RealIndex] or Properties.Text.Object[RealIndex] then
							return TextObject[RealIndex];
						end;
					end;
				end;
			else
				return error('Failed to get textobject.', 2);
			end;
		end,

		__newindex = function(self, Index, Value)
			local TextObject = rawget(self, '__textobject');
			if TextObject then
				if Index == 'Font' then
					TextObject[Index] = Value;
				elseif sub(Index, 1, 4) == 'Text' then
					if Index == 'Text' then
						TextObject[Index] = Value;
						return false;
					else
						local RealIndex = sub(Index, 5, -1);
						if Properties.Default.Drawing[RealIndex] or Properties.Default.Object[RealIndex] or Properties.Text.Drawing[RealIndex] or Properties.Text.Object[RealIndex] then
							TextObject[RealIndex] = Value;
							return false;
						end;
					end;
				end;
			else
				return error('Failed to get textobject.', 3);
			end;
		end,
	};

	local function InitFunc(Object)
		local TextObject = Drawing.new('Text');

		for I, V in next, DefaultTextObjectProperties.Object do
			if I and sub(I, 1, 4) == 'Text' then
				if I == 'Text' then
					TextObject.Text = V[2];
				else
					local RealIndex = sub(I, 5, -1);
					if Properties.Default.Drawing[RealIndex] or Properties.Default.Object[RealIndex] or Properties.Text.Drawing[RealIndex] or Properties.Text.Object[RealIndex] then
						TextObject[RealIndex] = V[2];
					end;
				end;
			end;
		end;

		TextObject.ZIndex = Object.ZIndex + 1;
		TextObject.Parent = Object;
		rawset(Object, '__textobject', TextObject);

		PositionText(TextObject);
		Object.Changed:Connect(function(Prop)
			if Prop == 'Position' or Prop == 'Size' or Prop == 'Font' or Prop == 'TextXAlign' or Prop == 'TextYAlign' then
				PositionText(TextObject);
			end;
		end);
	end;

	local ButtonProperties = tableclone(DefaultTextObjectProperties);
	ButtonProperties.Object.ClassName = {'string', 'TextButton'};

	local LabelProperties = tableclone(DefaultTextObjectProperties);
	LabelProperties.Object.ClassName = {'string', 'TextLabel'};

	Drawing.addCustom('TextButton', 'Square',
		ButtonProperties,
		Metatable,
		InitFunc
	);
	Drawing.addCustom('TextLabel', 'Square', 	
		LabelProperties, 
		Metatable,	
		InitFunc
	);
end;

--main function. is pretty much Drawing.new
local function CreateObject(Arg1)
	local Type;
	local Info;
	if type(Arg1) == 'string' then
		--if the first arg is a string, then it is the type
		Type = Arg1;
	elseif type(Arg1) == 'table' and type(Arg1[1]) == 'string' then
		--otherwise, if the first arg is a table and the first item in that table is a string (the type), then set those accordingly
		Type = Arg1[1];
		Info = Arg1;
		--this "Info" table contains all the properties that will be set later,
		--so we will nullify that value so we don't try to set the type as a property
		Info[1] = nil;
	else
		return error('Failed to get type. Try passing it through as either the first arg ("Type") or the first item in a table {"Type"}', 2);
	end;

	--get the custom info, if it is a custom object
	local Custom = CustomObjects[Type];

	--get the real type, if it is a custom object, or just the type, if it is not a custom object
	local RealType = (Custom and Custom.Real) or Type;

	--create the renderobject
	local RenderObject = CreateRO(RealType);
	--create the actual Object
	local Object = {
		__object = RenderObject,
		__exists = true,
		__type = Type,
		__holder = {},
		Descendants = {};
	};

	--if there is custom info, loop through the Raw table, if it exists, and set all respective values
	if Custom and Custom.Raw then
		for I, V in next, Custom.Raw do
			Object[I] = V;
		end;
	end;

	--set the metatable of the object, so you can interact with it correctly
	setmetatable(Object, ObjectMT);

	--messy code that sets the default properties by looping through the many tables and checking if the default value isn't nil
	for I, Property in next, Properties.Default.Drawing do
		if type(I) ~= 'nil' and type(Property) == 'table' and type(Property[2]) ~= 'nil' then
			Object[I] = Property[2];
		end;
	end;
	for I, Property in next, Properties.Default.Object do
		if type(I) ~= 'nil' and type(Property) == 'table' and type(Property[2]) ~= 'nil' then
			Object[I] = Property[2];
		end;
	end;
	for I, Property in next, Properties[Type].Drawing do
		if type(I) ~= 'nil' and type(Property) == 'table' and type(Property[2]) ~= 'nil' then
			Object[I] = Property[2];
		end;
	end;
	for I, Property in next, Properties[Type].Object do
		if type(I) ~= 'nil' and type(Property) == 'table' and type(Property[2]) ~= 'nil' then
			Object[I] = Property[2];
		end;
	end;

	Object.MouseButton1Up = CreateEvent();
	Object.MouseButton1Down = CreateEvent();
	Object.MouseButton1Click = CreateEvent();
	Object.Changed = CreateEvent();
	
	--once the object is made, if there is custom info and there is the init function which should be called after the object is initialized (/ created), call it
	if Custom and Custom.Init then
		taskspawn(Custom.Init, Object);
	end;

	if type(Info) == 'table' then
		--if the Info table is a table (if it exists and is a table, that is), loop through it and set the properties
		for I, V in next, Info do
			Object[I] = V;
		end;
	end;

	--add Object to Drawing.Objects
	tableinsert(Drawing.Objects, Object);

	--return the actual Object
	return Object;
end;
Drawing.new = CreateObject;
Drawing.New = CreateObject;
Drawing.create = CreateObject;
Drawing.Create = CreateObject;

function Drawing.DisableCursor()
	if Drawing.Cursor then
		Drawing.Cursor:Remove();
	end;
end;
local CursorURL = 'https://i.ibb.co/CtZ9rg8/Cursor.png';
local CursorDATA = game:HttpGet(CursorURL);
function Drawing.EnableCursor()
	Drawing.DisableCursor();
	local Cursor = Drawing.new{'Image', Data = CursorDATA, Size = Vector2.new(12, 10), Visible = false, ZIndex = 15};
	Drawing.Cursor = Cursor;
end;

do --Input Handling
	local UIS = game:GetService'UserInputService';

	local InputBeganCon = UIS.InputBegan:Connect(function(Input)
		local UIT = Input.UserInputType;
		if UIT then
			local MouseButton1 = UIT == Enum.UserInputType.MouseButton1;
			local MouseButton2 = UIT == Enum.UserInputType.MouseButton2; 

			for I, Object in next, Drawing.Objects do
				if type(Object) == 'table' and rawget(Object, '__exists') then
					if MouseButton1 and Object.Hovering then
						Object.CanClick = true;
						Object.Dragging = (Object.CanDrag and true) or false;
						Object.IsMouseButton1Down = true;
						Object.IsMouseButton1Up = false;

						Object.MouseButton1Down:Fire();
					elseif MouseButton2 and Object.Hovering then
						Object.CanRightClick = true;
						Object.IsMouseButton2Down = true;
						Object.IsMouseButton2Up = false;

						Object.MouseButton2Down:Fire();
					end;
				end;
			end;
		end;
	end);
	local InputEndedCon = UIS.InputEnded:Connect(function(Input)
		local UIT = Input.UserInputType;
		if UIT then
			local MouseButton1 = UIT == Enum.UserInputType.MouseButton1;
			local MouseButton2 = UIT == Enum.UserInputType.MouseButton2; 
			for I, Object in next, Drawing.Objects do
				if type(Object) == 'table' and rawget(Object, '__exists') then
					if MouseButton1 then
						Object.Dragging = false;
						if Object.IsMouseButton1Down then
							Object.IsMouseButton1Down = false;
							Object.IsMouseButton1Up = true;

							Object.MouseButton1Up:Fire();
							if Object.CanClick then
								Object.MouseButton1Click:Fire();
							end;
						end;
					elseif MouseButton2 then
						Object.IsMouseButton2Down = false;
						Object.IsMouseButton2Up = true;

						Object.MouseButton2Up:Fire();
						if Object.CanRightClick then
							Object.MouseButton2Click:Fire();
						end;
					end;
				end
			end;
		end;
	end);

	local gml = UIS.GetMouseLocation;
	local function GetMouseLocation(...)
		return gml(UIS, ...);
	end;

	local function IsHovering(Object)
		if type(Object) == 'table' and rawget(Object, '__exists') then
			local MousePos = GetMouseLocation();
			local ObjectPos = Object.Position;
			local DrawingSize = Object.Size;
			
			local PosX = (typeof(ObjectPos) == 'Vector2' and ObjectPos.X) or ObjectPos;
			local PosY = (typeof(ObjectPos) == 'Vector2' and ObjectPos.Y) or ObjectPos;
			
			if Object.ClassName == 'Text' then
				DrawingSize = Object.TextBounds;
			end;

			local SizeX = (typeof(DrawingSize) == 'Vector2' and DrawingSize.X) or DrawingSize;
			local SizeY = (typeof(DrawingSize) == 'Vector2' and DrawingSize.Y) or DrawingSize;

			return MousePos.X >= PosX and MousePos.X <= PosX + SizeX and MousePos.Y >= PosY and MousePos.Y <= PosY + SizeY;
		else
			return error('Object doesn\'t exist', 2);
		end;
	end;
	Drawing.IsHovering = IsHovering;

	local OldMousePos = GetMouseLocation();
	local InputChangedCon = UIS.InputChanged:Connect(function(Input)
		local MouseMovement = Input.UserInputType and Input.UserInputType == Enum.UserInputType.MouseMovement;
		for I, Object in next, Drawing.Objects do
			if type(Object) == 'table' and rawget(Object, '__exists') and Object ~= Drawing.Cursor then
				if MouseMovement then
					local MousePos = GetMouseLocation();

					local Hovering = IsHovering(Object);
					local OldHovering = Object.Hovering;

					Object.Hovering = Hovering;

					if OldHovering and not Hovering then
						Object.CanClick = false;
						Object.CanRightClick = false;
					end;

					if Object.CanDrag and Object.Dragging then
						Object.Position += (MousePos - OldMousePos);
						for I, Descendant in next, Object.Descendants do
							if type(Descendant) == 'table' and rawget(Descendant, '__exists') and Descendant ~= rawget(Object, '__textobject') and Descendant.Position then
								Descendant.Position += (MousePos - OldMousePos);
							end;
						end;
					end;

					OldMousePos = MousePos;
				end;
			end;
		end;

		if Drawing.Cursor and MouseMovement then
			Drawing.Cursor.Visible = false;
			for I, Object in next, Drawing.Objects do
				if type(Object) == 'table' and rawget(Object, '__exists') and Object ~= Drawing.Cursor then
					if IsHovering(Object) then
						Drawing.Cursor.Visible = true;
						Drawing.Cursor.Position = OldMousePos;
						break;
					end;
				end;
			end;
		end;
	end);
end;

return Drawing;
