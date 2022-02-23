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
	--if the object has descendants, loop through them and remove then
	if Object.Descendants then
		for I, Descendant in next, Object.Descendants do
			if Descendant and rawget(Descendant, '__exists') then
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
				Descendants = {'table', nil},
				Parent = {'table', nil},
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
								--check if we are setting Parent
								if Index == 'Parent' then
									if type(Value) == 'table' then
										--if we are setting parent to an actual object, add it to the descendants and set the property
										if Value.Descendants then
											table.insert(Value.Descendants, self);
										end;
										Holder[Index] = Value;
									elseif type(Value) == 'nil' then
										--if we are setting parent to nil, remove Object from the old parent's descendants table
										local OldParent = self.Parent;
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
				local RealProperties = {};
				RealProperties.Drawing = Properties[RealType].Drawing;
				RealProperties.Object = Properties[RealType].Object;

				for I,V in next, CustomProperties.Drawing do
					RealProperties.Drawing[I] = V;
				end;
				for I,V in next, CustomProperties.Object do
					RealProperties.Object[I] = V;
				end;

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
	};

	--set the Descendants
	Object.Descendants = {};

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

	if type(Info) == 'table' then
		--if the Info table is a table (if it exists and is a table, that is), loop through it and set the properties
		for I, V in next, Info do
			Object[I] = V;
		end;
	end;

	--once the object is made, if there is custom info and there is the init function which should be called after the object is initialized (/ created), call it
	if Custom and Custom.Init then
		task.spawn(Custom.Init, Object);
	end;

	--return the actual Object
	return Object;
end;
Drawing.new = CreateObject;
Drawing.New = CreateObject;
Drawing.create = CreateObject;
Drawing.Create = CreateObject;

return Drawing;
