local sub = string.sub;

local Drawing = loadstring(game:HttpGet('https://raw.githubusercontent.com/TechHog8984/DrawingApi2/main/latest'))();
local Properties = Drawing.Properties;
Drawing.addCustom('TextButton', 'Square', 	--custom type, real type (both required)
	{	--properties (required)
		Raw = {		--(optional) only accessable through rawget & rawset
			__textobject = Drawing.new{'Text'};
		},
		--for the below 2 tables, each property will be a table with the first value being the acceptable types (seperated by a comma)
		--and the second value being the default. this can be nil even if your acceptable types do not include nil.

		Drawing = {	--(optional)drawing properties. these will show up onscreen and have to be a valid property
					--that you can find on the synapse docs for the real type (in this case, Square). 
					--below it is used to set default properties.
			Size = {'Vector2', Vector2.new(230, 100)},
			Position = {'Vector2', Vector2.new(1920/2 - 115, 1080/2 - 50)},
		},
		Object = {	--(optional) "fake" properties. these will not show up onscreen and can be whatever you want
					--below it is used with the metatable below to set text properties through the textbutton object as apposed to the text object itself
			Text = {'string', 'Text'},
			TextColor = {'Color3,string', '0 0 0'},

			TextTransparency = {'number', 1},
			TextSize = {'number', 25},
			TextCentered = {'boolean', false},
			TextOutline = {'boolean', false},
			TextOutlineColor = {'Color3,string', '1 1 1'},
			TextBounds = {'Vector2', nil},
			Font = {'number', 0},

			--mouse & click stuff
			CanDrag = {'boolean', false},
			Hovering = {'boolean', false},
			CanClick = {'boolean', false},
			Dragging = {'boolean', false},
			MouseButton1Up = {'boolean', false},
			MouseButton1Down = {'boolean', false},
		}
	},
	{	--metatable (optional)

		--does NOT override the default metatable. is used in addition to the default metatable. 
		--if the __index function exists, it will call it and return either the result of calling it or what the default metatable would have returned.
		__index = function(self, Index, Value)
			--get the text object
			local TextObject = rawget(self, '__textobject');
			if TextObject then
				if sub(Index, 1, 4) == 'Text' and Index ~= 'TextBounds' then
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
				elseif Index == 'TextBounds' or Index == 'Font' then
					--^TextBounds is called that on the actual text object, so doing TextTextBound would be a bit weird.
					return TextObject[RealIndex];
				end;
			else
				return error('Failed to get textobject.', 2);
			end;
		end,

		--you are supposed to return whether or not you want to override or not.
		--true meaning the default metatable won't do anything. this is not reccomended unless you want a fully custom object
		--false meaning that everything that the default metatable would do will happen (default object behavior, allows you do get and set properties)
		__newindex = function(self, Index, Value)
			local TextObject = rawget(self, '__textobject');
			if TextObject then
				if sub(Index, 1, 4) == 'Text' then
					if Index == 'Text' then
						TextObject.Text = Value;
						return false;
					else
						local RealIndex = sub(Index, 5, -1);
						if Properties.Default.Drawing[RealIndex] or Properties.Default.Object[RealIndex] or Properties.Text.Drawing[RealIndex] or Properties.Text.Object[RealIndex] then
							TextObject[RealIndex] = Value;
							return false;
						end;
					end;
				elseif Index == 'Position' then
					TextObject.Position = (Value + self.Size / 2) - TextObject.TextBounds / 2;
					return false;
				elseif Index == 'Size' then
					TextObject.Position = (self.Position + Value / 2) - TextObject.TextBounds / 2;
					return false;
				end;
			else
				return error('Failed to get textobject.', 3);
			end;
		end,
	},
	function(Object)	--(optional) init function, called after the initalization (/ creation) of an object
		--below is used to set a couple default properties of the text object and to add it to TextObject's Descendants table (so it will be destroyed when calling :Remove on TextObject.)
		local TextObject = rawget(Object, '__textobject');
		TextObject.ZIndex = Object.ZIndex + 1;
		TextObject.Position = (Object.Position + Object.Size / 2) - TextObject.TextBounds / 2;
		table.insert(Object.Descendants, TextObject);
	end
);
local TextButton = Drawing.new{'TextButton'};

--crappy code below
local UIS = game:GetService'UserInputService';

local gml = UIS.GetMouseLocation
local function GetMouseLocation(...)
	return gml(UIS, ...)
end

local IBCon = UIS.InputBegan:Connect(function(Input)
	if TextButton and rawget(TextButton, '__exists') and Input and Input.UserInputType then
		if Input.UserInputType == Enum.UserInputType.MouseButton1 and TextButton.Hovering then
			TextButton.CanClick = true;
			TextButton.MouseButton1Down = true;
			TextButton.MouseButton1Up = false;
			TextButton.Dragging = (TextButton.CanDrag and true) or false;
		end;
	end;
end);
local OldMousePos = GetMouseLocation();
local ICCon = UIS.InputChanged:Connect(function(Input)
	if TextButton and rawget(TextButton, '__exists') and Input and Input.UserInputType then
		if Input.UserInputType == Enum.UserInputType.MouseMovement then
			local MousePos = GetMouseLocation();

			local ObjectPos = TextButton.Position;
			local DrawingSize = TextButton.Size;
			local Hovering = MousePos.X >= ObjectPos.X and MousePos.X <= ObjectPos.X + DrawingSize.X and MousePos.Y >= ObjectPos.Y and MousePos.Y <= ObjectPos.Y + DrawingSize.Y;

			local OldHovering = TextButton.Hovering;

			TextButton.Hovering = Hovering;

			if OldHovering and not Hovering then
				TextButton.CanClick = false;
			end;

			if TextButton.CanDrag and TextButton.Dragging then
				TextButton.Position += (MousePos - OldMousePos);
			end;

			OldMousePos = MousePos;
		end;
	end;
end);

local IECon = UIS.InputEnded:Connect(function(Input)
	if TextButton and rawget(TextButton, '__exists') and Input and Input.UserInputType then
		if Input.UserInputType == Enum.UserInputType.MouseButton1 then
			TextButton.Dragging = false;
			if TextButton.MouseButton1Down then
				TextButton.MouseButton1Down = false;
				TextButton.MouseButton1Up = true;

				if TextButton.CanClick then
					print('Clicked!');
				end;
			end;
		end;
	end;
end);

wait(5);
IBCon:Disconnect();
ICCon:Disconnect();
IECon:Disconnect();
TextButton:Remove();
