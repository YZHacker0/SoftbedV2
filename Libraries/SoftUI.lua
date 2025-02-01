function create(i, prop)
	local new = Instance.new(i)
	for i, v in pairs(prop) do
		new[i] = v;
	end
	return new;
end
local function areFramesOverlapping(frame1, frame2)
    local frame1Pos = frame1.AbsolutePosition
    local frame1Size = frame1.AbsoluteSize
    local frame2Pos = frame2.AbsolutePosition
    local frame2Size = frame2.AbsoluteSize

    return frame1Pos.X < frame2Pos.X + frame2Size.X and
           frame1Pos.X + frame1Size.X > frame2Pos.X and
           frame1Pos.Y < frame2Pos.Y + frame2Size.Y and
           frame1Pos.Y + frame1Size.Y > frame2Pos.Y
end
local soft = {};
local module = {};
module.ready = false;

function module:Init()
	if module.ready then return end;
	local playerGui = game.Players.LocalPlayer:WaitForChild('PlayerGui')
    if playerGui:FindFirstChild('SoftUI') then
        playerGui:WaitForChild('SoftUI'):Destroy()
    end
	soft.Root = create('ScreenGui', {
		['ResetOnSpawn'] = false;
		['ZIndexBehavior'] = Enum.ZIndexBehavior.Sibling;
		['Name'] = 'SoftUI',
		['Parent'] = game.Players.LocalPlayer.PlayerGui;
	})
	module.ready = true;
	return soft;
end
module.windows = {};
function soft:Window(text, callback)
	local win = {};
	local this = {};
	local spacing = 10
	this.Window = create('Frame', {
		["AutomaticSize"] = Enum.AutomaticSize.X;
		["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
		["BackgroundTransparency"] = 0.30000001192092896;
		["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		["BorderSizePixel"] = 0;
		["Position"] = UDim2.new(0, spacing + ((172 + spacing) * (#module.windows)), 0, 0);
		["Size"] = UDim2.new(0, 172, 0, 24);
		["Name"] = table.concat(text:lower():split(' '), '_');
		["Active"] = true;
		["Parent"] = soft.Root;
	});
	this.connections = {}
	local windowId = #module.windows
    module.windows[windowId] = this
    this.index = windowId
    function win:Highlight()
        for i = 0, #module.windows do
            winz = module.windows[i]
            winz.highlighted = false
        end
        this.highlighted = true
    end
    win:Highlight()
	function win:Destroy()
        if this.connections then
            for _, conn in pairs(this.connections) do
                conn:Disconnect()
            end
        end
        module.windows[this.index] = nil
        this.Window:Destroy()
    end
	task.spawn(function()
    local UserInputService = game:GetService("UserInputService")
    local gui = this.Window -- The current window being dragged

    local dragging = false
    local dragInput
    local dragStart
    local startPos

    -- Function to update the position of the dragged window
    local function update(input)
        if not dragging then return end

        -- Calculate the new position based on the mouse/touch movement
        local delta = input.Position - dragStart
        local newPos = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )

        -- Move the current window
        if this.highlighted then
            gui.Position = newPos
        end
    end

    -- Connect input events
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position

            -- Stop dragging when the input ends (e.g., mouse button is released)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end)
	------> Arrow 
	create('ImageButton', {
		["Image"] = "rbxasset://textures/DeveloperFramework/button_arrow_right.png";
		["AutoButtonColor"] = false;
		['BackgroundColor3'] = Color3.fromRGB(255, 255, 255);
		['BackgroundTransparency'] = 1;
		['BorderColor3'] = Color3.fromRGB(0, 0, 0);
		['BorderSizePixel'] = 0;
		['Position'] = UDim2.new(0, 7, 0, 5);
		['Size'] = UDim2.new(0, 13, 0, 13);
		['Name'] = "Arrow";
		['Parent'] = this.Window;
	})
	task.spawn(function()
		local isVisible = false
		local icons = {
			open = 'rbxasset://textures/DeveloperFramework/button_arrow_down.png',
			closed = 'rbxasset://textures/DeveloperFramework/button_arrow_right.png'
		}
		this.Window:WaitForChild('Items')
		local function update()
			game:GetService('TweenService'):Create(this.Window.Arrow, TweenInfo.new(.20), {
				['Rotation'] = isVisible and 90 or 0
			}):Play()
			this.Window.Items.Visible = isVisible
		end
		this.Window.Arrow.MouseButton1Click:Connect(function()
			isVisible = not isVisible
			update()
		end)
		update()
	end)
	------> End of Arrow
	create('TextLabel', {
		['Font'] = Enum.Font.Code;
		['TextColor3'] = Color3.fromRGB(255, 255, 255);
		['TextSize'] = 14;
		['BackgroundColor3'] = Color3.fromRGB(255, 255, 255);
		['BackgroundTransparency'] = 1;
		['BorderColor3'] = Color3.fromRGB(0, 0, 0);
		['BorderSizePixel'] = 0;
		['Size'] = UDim2.new(0, 172, 0, 24);
		['Name'] = "Title";
		['Parent'] = this.Window;
		['Text'] = text;
	});
	create('Frame', {
		['AutomaticSize'] = Enum.AutomaticSize.XY;
		['BackgroundColor3'] = Color3.fromRGB(0, 0, 0);
		['BorderColor3'] = Color3.fromRGB(0, 0, 0);
		['BorderSizePixel'] = 0;
		['Position'] = UDim2.new(0, 0, 1, 0);
		['Size'] = UDim2.new(0, 172, 1, 0);
		['Name'] = "Items";
		['Parent'] = this.Window;
	})
	create('UIPadding', {
		['PaddingLeft'] = UDim.new(0, 3);
		['Parent'] = this.Window.Items;
	})
	create('UIListLayout', {
		['Padding'] = UDim.new(0, 3);
		['SortOrder'] = Enum.SortOrder.LayoutOrder;
		['Parent'] = this.Window.Items;
	})
	create('Frame', {
		['BackgroundColor3'] = Color3.fromRGB(255, 255, 255);
		['BackgroundTransparency'] = 1;
		['BorderColor3'] = Color3.fromRGB(0, 0, 0);
		['BorderSizePixel'] = 0;
		['LayoutOrder'] = 999999;
		['Position'] = UDim2.new(0, 0, 0.909090936, 0);
		['Name'] = "endFrame";
		['Parent'] = this.Window.Items;
	})
	function win:Button(text, callback)
		local button = create('TextButton', {
			['Font'] = Enum.Font.Code;
			['RichText'] = true;
			['TextColor3'] = Color3.fromRGB(0, 0, 0);
			['TextSize'] = 14;
			['AutoButtonColor'] = false;
			['BackgroundColor3'] = Color3.fromRGB(185.00000417232513, 44.000001177191734, 255);
			['BorderColor3'] = Color3.fromRGB(0, 0, 0);
			['BorderSizePixel'] = 0;
			['Size'] = UDim2.new(0, 165, 0, 27);
			['Name'] = "Button";
			['Text'] = text;
			['Parent'] = this.Window.Items;
		});
		create('UICorner', {
			['CornerRadius'] = UDim.new(0, 3);
			['Parent'] = button;
		})
		button.MouseButton1Click:Connect(function()
			callback(button)
		end);
		return button;
	end
	function win:Toggle(text, callback)
		local btn = {};
		local state = false;
		local button = create('TextButton', {
			['Font'] = Enum.Font.Code;
			['RichText'] = true;
			['TextColor3'] = Color3.fromRGB(0, 0, 0);
			['TextSize'] = 14;
			['AutoButtonColor'] = false;
			['BackgroundColor3'] = Color3.fromRGB(185.00000417232513, 44.000001177191734, 255);
			['BorderColor3'] = Color3.fromRGB(0, 0, 0);
			['BorderSizePixel'] = 0;
			['Size'] = UDim2.new(0, 165, 0, 27);
			['Name'] = "Toggle";
			['Text'] = text;
			['Parent'] = this.Window.Items;
		});
		create('UICorner', {
			['CornerRadius'] = UDim.new(0, 3);
			['Parent'] = button;
		})
		button.BackgroundColor3 = state and Color3.fromRGB(255, 46, 245) or Color3.fromRGB(185, 44, 255)
		button.TextColor = state and BrickColor.White() or BrickColor.Black();

		function btn:Set(s)
			state = s;
			button.BackgroundColor3 = s and Color3.fromRGB(255, 46, 245) or Color3.fromRGB(185, 44, 255)
			button.TextColor = s and BrickColor.White() or BrickColor.Black();
			callback(s, button)
		end
		function btn:Get() return state end;
		button.MouseButton1Click:Connect(function()
			state = not state;
			btn:Set(state)
		end)
		btn.Instance = button;
		function btn:Destroy() button:Destroy() end;
		return btn;
	end

	function win:Input(ph, callback)
		local input = create('TextBox', {
			['CursorPosition'] = -1;
			['Font'] = Enum.Font.Code;
			['PlaceholderColor3'] = Color3.fromRGB(8.000000473111868, 8.000000473111868, 8.000000473111868);
			['PlaceholderText'] = ph;
			['Text'] = "";
			['TextColor3'] = Color3.fromRGB(255, 255, 255);
			['TextSize'] = 14;
			['BackgroundColor3'] = Color3.fromRGB(185.00000417232513, 44.000001177191734, 255);
			['BorderColor3'] = Color3.fromRGB(0, 0, 0);
			['BorderSizePixel'] = 0;
			['Position'] = UDim2.new(0, 0, 0.822784781, 0);
			['Size'] = UDim2.new(0, 165, 0, 25);
			['Name'] = "Input";
			['Parent'] = this.Window.Items;
		});
		create('UICorner', {
			['CornerRadius'] = UDim.new(0, 3);
			['Parent'] = input;
		})
		local cur;
		input.Focused:Connect(function()
			cur = input.Text;
		end)
		input.FocusLost:Connect(function()
			if input.Text ~= cur then
				callback(input.Text)
				input.Text = '';
			end
		end)
		return input;

	end
	function win:Category(text)
		return create('TextLabel', {
			['Font'] = Enum.Font.Code;
			['RichText'] = true;
			['Text'] = text;
			['TextColor3'] = Color3.fromRGB(255, 255, 255);
			['TextSize'] = 14;
			['BackgroundColor3'] = Color3.fromRGB(255, 255, 255);
			['BackgroundTransparency'] = 0.8500000238418579;
			['BorderColor3'] = Color3.fromRGB(0, 0, 0);
			['BorderSizePixel'] = 0;
			['Position'] = UDim2.new(0, -5, 0.588235319, 0);
			['Size'] = UDim2.new(0, 165, 0, 22);
			['Name'] = "Category";
			['Parent'] = this.Window.Items;
		})
	end
	function win:Label(text)
		return create('TextLabel', {
			['Font'] = Enum.Font.Code;
			['RichText'] = true;
			['Text'] = text;
			['TextColor3'] = Color3.fromRGB(255, 255, 255);
			['TextDirection'] = Enum.TextDirection.LeftToRight;
			['TextSize'] = 14;
			['TextWrapped'] = true;
			['TextXAlignment'] = Enum.TextXAlignment.Left;
			['AutomaticSize'] = Enum.AutomaticSize.Y;
			['BackgroundColor3'] = Color3.fromRGB(0, 0, 0);
			['BackgroundTransparency'] = 1;
			['BorderColor3'] = Color3.fromRGB(0, 0, 0);
			['BorderSizePixel'] = 0;
			['Position'] = UDim2.new(0, 0, 0.800000012, 0);
			['Size'] = UDim2.new(0, 165, 0, 13);
			['Name'] = "Label";
			['Parent'] = this.Window.Items;
		})
	end
	win.Instance = this.Window;
	if callback then
		callback(win)
		return win;
	end
	return win;
end

return module
