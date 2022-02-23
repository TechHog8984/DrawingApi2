--[string manipulation]
local gmatch = string.gmatch;
local sub = string.sub;
local find = string.find;
local match = string.match;


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
	--set the __exists value of the object to false;
	rawset(Object, '__exists', false);
	--run destroyrenderproperty on the object, removing it from the D3D render list
	return DestroyRO(rawget(Object, '__object'));
end;

--some values that are used multiple times for property lists
local white = Color3.new(1,1,1);
local black = Color3.new(0,0,0);
local ZeroZero = Vector2.new(0, 0);
local ColorProperty = {'Color3,string', white};

--actual Drawing table
local Drawing = {
	Fonts = OldDrawing.Fonts,
};

--for below properties, the first value in the table is the expected type(s), and the second value is the default value.
--if the default value is nil, it will be the true default that the createrenderobject function assigns it.
local Properties;
do --properties
	Properties = {
		Default = {
			Drawing = {
				Visible = {'boolean', true},
				ZIndex = {'number', nil},
				Transparency = {'number', nil},
			},
			Object = {
				Name = {'string', 'Object'},
				ClassName = {'string', 'Object'},
				Remove = {'function', ObjectRemove},
			},
		},
		Line = {
			Drawing = {
				Color = ColorProperty,

				Thickness = {'number', nil},
				From = {'Vector2', nil},
				To = {'Vector2', nil},
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
				Size = {'number', nil},
				Center = {'boolean', nil},
				Outline = {'boolean', nil},
				OutlineColor = {'Color3', black},
				Position = {'Vector2', nil}, 
				TextBounds = {'Vector2', nil},
				Font = {'number', nil},
			},
			Object = {
				Name = {'string', 'Text'},
				ClassName = {'string', 'Text'},
			},
		},
		Image = {
			Drawing = {
				Data = {'string', nil},
				Size = {'Vector2', nil},
				Position = {'Vector2', nil},
				Rounding = {'boolean', nil},
			},
			Object = {
				Name = {'string', 'Image'},
				ClassName = {'string', 'Image'},
			},
		},
		Circle = {
			Drawing = {
				Color = ColorProperty,

				Thickness = {'number', nil},
				NumSides = {'number', nil},
				Radius = {'number', nil},
				Filled = {'boolean', true},
				Position = {'Vector2', nil},
			},
			Object = {
				Name = {'string', 'Circle'},
				ClassName = {'string', 'Circle'},
			},
		},
		Square = {
			Drawing = {
				Color = ColorProperty,

				Thickness = {'number', nil},
				Size = {'Vector2', nil},
				Position = {'Vector2', nil},
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

				Thickness = {'number', nil},
				PointA = {'Vector2', nil},
				PointB = {'Vector2', nil},
				PointC = {'Vector2', nil},
				PointD = {'Vector2', nil},
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

				Thickness = {'number', nil},
				PointA = {'Vector2', nil},
				PointB = {'Vector2', nil},
				PointC = {'Vector2', nil},
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
	--loop through each time there is something that isn't a comma (everything before and after a comma)
	for X in gmatch(Type, '([^,]+)') do
		--if this type is the type of Value, then return true
		if X == ValueType then
			return true;
		end;
	end;
	--if no match was found, return false
	return false;
end;

--default object metatable
local ObjectMT = {
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
							local Property = Properties.Default.Drawing[Index] or Properties[Type].Drawing[Index] or Properties.Default.Object[Index] or Properties[Type].Object[Index];
							if Property then
								--if it exists, return that property's value in the Holder, which contains all of the properties for the object
								return Holder[Index];
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
										--^check if it is a string
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

								if DrawingProperty then
									--^check if it is a drawingproperty, so that we can set the renderproperty of the object
									if CheckType(DrawingProperty[1], Value) then
										--^validate the type
										Holder[Index] = Value;
										--^set the value to the holder, which holds all property values
										return SetRP(Object, Index, Value);
										--^set the render property, so it actually affects the object on the screen
									else
										return error('Expected ' .. DrawingProperty[1] .. ', got ' .. ValueType, 2);
									end;
								elseif ObjectProperty then
									--^check if it is an objectproperty, so that we DON'T set the renderproperty of the object
									if CheckType(ObjectProperty[1], Value) then
										--^validate the type
										Holder[Index] = Value;
										--^set the value to the holder, which holds all property values
									else
										return error('Expected ' .. ObjectProperty[1] .. ', got ' .. ValueType, 2);
									end;
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
}

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
		--so we will nullify(maybe the right word?) that value so we don't try to set the type as a property
		Info[1] = nil;
	else
		return error('Failed to get type. Try passing it through as either the first arg or the first item in a table', 2);
	end;
	--create the renderobject
	local RenderObject = CreateRO(Type);
	--create the actual Object
	local Object = {
		__object = RenderObject,
		__exists = true,
		__type = Type,
		__holder = {},
	};
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

	if type(Info) == 'table' then
		--if the Info table is a table (if it exists and is a table, that is), loop through it and set the properties
		for I, V in next, Info do
			Object[I] = V;
		end;
	end;

	--return the actual Object
	return Object;
end;

Drawing.new = function(...)
	return CreateObject(...);
end;

return Drawing;
