local Drawing = loadstring(game:HttpGet'https://raw.githubusercontent.com/TechHog8984/DrawingApi2/main/latest')();

Drawing.AddDefaultCustomObjects();
Drawing.EnableCursor();

local Frame1 = Drawing.new{'Square', CanDrag = true, Position = Vector2.new(705, 254), Size = Vector2.new(500, 500), Color = Color3.fromRGB(65, 65, 65)};
local Button1 = Drawing.new{'TextButton', Parent = Frame1, Text = 'XAlignment', Position = Vector2.new(795, 354), Size = Vector2.new(180, 100), Color = Color3.fromRGB(83, 83, 83)};
local Button2 = Drawing.new{'TextButton', Parent = Frame1, Text = 'YAlignment', Position = Vector2.new(795, 504), Size = Vector2.new(180, 100), Color = Color3.fromRGB(83, 83, 83)};

local Size = Vector2.new(35, 35);
local CloseButton = Drawing.new{'TextButton', Text = 'Close', TextSize = 18, Parent = Frame1, Position = Vector2.new(Frame1.Position.X + Frame1.Size.X - Size.X, Frame1.Position.Y), Size = Size, Color = Color3.fromRGB(235, 65, 65)};

CloseButton.MouseButton1Click:Connect(function()
	Frame1:Remove();
end);

local I = 1;
Button1.MouseButton1Click:Connect(function()
	I += 1;
	if I == 4 then
		I = 1;
	end;

	if I == 1 then
		Button1.TextXAlign = 'Center';
	elseif I == 2 then
		Button1.TextXAlign = 'Right';
	elseif I == 3 then
		Button1.TextXAlign = 'Left';
	end;
end);
local I = 1;
Button2.MouseButton1Click:Connect(function()
	I += 1;
	if I == 4 then
		I = 1;
	end;

	if I == 1 then
		Button2.TextYAlign = 'Center';
	elseif I == 2 then
		Button2.TextYAlign = 'Top';
	elseif I == 3 then
		Button2.TextYAlign = 'Bottom';
	end;
end);
