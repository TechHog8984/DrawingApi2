local Drawingnew = Drawing.new;

local CreateRP = createrenderproperty;
local DestroyRP = destroyrenderproperty;
local GetRP = getrenderproperty;
local SetRP = setrenderproperty;

if not (CreateRP and DestroyRP and GetRP and SetRP) then
	local LineMT = getupvalue(Drawingnew, 4);
	local Line__index = LineMT.__index;
	local Line__newindex = LineMT.__newindex;

	CreateRP = CreateRP or getupvalue(Drawingnew, 1);
	DestroyRP = DestroyRP or getupvalue(Line__index, 3);
	GetRP = GetRP or getupvalue(Line__index, 4);
	SetRP = SetRP or getupvalue(Line__newindex, 4);

	local genv = getgenv();
	genv.createrenderproperty = CreateRP;
	genv.destroyrenderproperty = DestroyRP;
	genv.getrenderproperty = GetRP;
	genv.setrenderproperty = SetRP;
end;

local function ObjectRemove(Object)
	rawset(Object, '__exists', false);
	return DestroyRP(rawget(Object, '__object'));
end;

local white = Color3.new(1,1,1);
local black = Color3.new(0,0,0);
local ZeroZero = Vector2.new(0, 0);
local Drawing = {
	Fonts = {
		UI = 0,
		System = 1,
		Plex = 2,
		Monospace = 3,
	},
};
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
				Color = {'Color3', white},

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
				Color = {'Color3', white},

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
				Color = {'Color3', white},

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
				Color = {'Color3', white},

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
				Color = {'Color3', white},

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
				Color = {'Color3', white},

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
local ObjectMT = {
	__index = function(self, Index)
		if type(self) == 'table' then
			if rawget(self, '__exists') then
				local Holder = rawget(self, '__holder');
				if Holder then
					local Type = rawget(self, '__type') or rawget(self, 'ClassName');
					if Type then
						local Object = rawget(self, '__object');
						if Object then
							local Property = Properties.Default.Drawing[Index] or Properties[Type].Drawing[Index] or Properties.Default.Object[Index] or Properties[Type].Object[Index];
							if Property then
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
		if type(self) == 'table' then
			if rawget(self, '__exists') then
				local Holder = rawget(self, '__holder');
				if Holder then
					local Type = rawget(self, '__type') or rawget(self, 'ClassName');
					if Type then
						local Object = rawget(self, '__object');
						if Object then
							local DrawingProperty = Properties.Default.Drawing[Index] or Properties[Type].Drawing[Index];
							local ObjectProperty = Properties.Default.Object[Index] or Properties[Type].Object[Index];

							local ValueType = typeof(Value);
							if DrawingProperty or ObjectProperty then
								if DrawingProperty then
									if ValueType == DrawingProperty[1] then
										Holder[Index] = Value;
										return SetRP(Object, Index, Value);
									else
										return error('Expected ' .. DrawingProperty[1] .. ', got ' .. ValueType, 2);
									end;
								elseif ObjectProperty then
									if ValueType == ObjectProperty[1] then
										Holder[Index] = Value;
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
		if type(self) == 'table' then
			if rawget(self, '__exists') then
				return self.Name or self.ClassName;
			else
				return error('Object no longer exists.', 2);
			end;
		else
			return error('Expected Object (table), got ' .. typeof(self), 2);
		end;
	end,
}

local function CreateObject(Arg1)
	local Type;
	local Info;
	if type(Arg1) == 'string' then
		Type = Arg1;
	elseif type(Arg1) == 'table' and type(Arg1[1]) == 'string' then
		Type = Arg1[1];
		Info = Arg1;
		Info[1] = nil;
	else
		return error('Failed to get type. Try passing it through as the first arg / first item in the table', 2);
	end;
	local RenderObject = CreateRP(Type);
	local Object = {
		__object = RenderObject,
		__exists = true,
		__type = Type,
		__holder = {},
	};
	setmetatable(Object, ObjectMT);

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
		for I, V in next, Info do
			Object[I] = V;
		end;
	end;

	return Object;
end;

Drawing.new = function(...)
	return CreateObject(...);
end;

return Drawing;
