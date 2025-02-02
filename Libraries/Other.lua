function create(i, k)
	local e = Instance.new(i);
	for k, v in pairs(k) do
		e[k] = v;
	end
	return e;
end

local layout = game.Players.LocalPlayer:FindFirstChild('PlayerGui'):WaitForChild('SoftUI');

local isReady = true;
function sendNotification(title, text, duration)
	repeat task.wait() until isReady == true;
	isReady = false;

	local this = create('Frame', {
		['AnchorPoint'] = Vector2.new(0.5, 0);
		['BackgroundColor3'] = Color3.fromRGB(0, 0, 0);
		['BorderColor3'] = Color3.fromRGB(0, 0, 0);
		['BorderSizePixel'] = 0;
		['ClipsDescendants'] = true;
		['Position'] = UDim2.new(0.5, 0, 0, -10);
		['Size'] = UDim2.new(0, 274, 0, 79);
		['Visible'] = false;
		['Name'] = "notification";
		['Parent'] = layout;
	})
	create('UICorner', {
		['Parent'] = this;
	})
	local timer = create('Frame', {
		['BackgroundColor3'] = Color3.fromRGB(226.00001692771912, 5.000000176951289, 255);
		['BorderColor3'] = Color3.fromRGB(0, 0, 0);
		['BorderSizePixel'] = 0;
		['Position'] = UDim2.new(0, 3, 1, -10);
		['Size'] = UDim2.new(1, -7, 0, 7);
		['Name'] = "timer";
		['Parent'] = this;
	})

	create('UICorner', {
		['Parent'] = timer;
		['CornerRadius'] = UDim.new(0, 5);
	});

	local Title = create('TextLabel', {
		['Font'] = Enum.Font.Code;
		['Text'] = "";
		['TextColor3'] = Color3.fromRGB(255, 255, 255);
		['TextScaled'] = true;
		['TextSize'] = 14;
		['TextWrapped'] = true;
		['BackgroundColor3'] = Color3.fromRGB(255, 255, 255);
		['BackgroundTransparency'] = 1;
		['BorderColor3'] = Color3.fromRGB(0, 0, 0);
		['BorderSizePixel'] = 0;
		['Position'] = UDim2.new(0, 0, 0.198607609, 0);
		['Size'] = UDim2.new(0, 274, 0, 17);
		['Name'] = "Title";
		['Parent'] = this;
	})

	local Text = create('TextLabel', {
		['Font'] = Enum.Font.Code;
		['Text'] = "";
		['TextColor3'] = Color3.fromRGB(255, 255, 255);
		['TextSize'] = 14;
		['TextWrapped'] = true;
		['BackgroundColor3'] = Color3.fromRGB(0, 0, 0);
		['BackgroundTransparency'] = 1;
		['BorderColor3'] = Color3.fromRGB(0, 0, 0);
		['BorderSizePixel'] = 0;
		['Position'] = UDim2.new(0, 0, 0.413797498, 0);
		['Size'] = UDim2.new(0, 274, 0, 36);
		['Name'] = "Text";
		['Parent'] = this;
	})
	this.Position = UDim2.new(0.5, 0,0, -10)
	timer.Size = UDim2.new(0, 7, 0 ,7)
	this.Visible = true;
	Title.Text = title;
	Text.Text = text;
	spawn(function()
	    timer:TweenSize(UDim2.new(1, -7, 0, 7), 'In', 'Linear', duration or 5, true);
	    task.wait(duration)
	    game:GetService('TweenService'):Create(this, TweenInfo.new(.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
		['Position'] = UDim2.new(0.5, 0, -1, 0)
	    }):Play()
    	task.wait(0.5);
    	isReady = true;
    local	this:Destroy()
	end)
end


local isReady2 = true
function cooldown(sec)
	if not isReady2 then return false end;
	isReady2 = false;
	local bg = create('Frame', {
		["AnchorPoint"] = Vector2.new(0.5, 0);
		["BackgroundColor3"] = Color3.fromRGB(133.00000727176666, 0, 145.00000655651093);
		["BackgroundTransparency"] = 0.699999988079071;
		["BorderColor3"] = Color3.fromRGB(255, 255, 255);
		["BorderSizePixel"] = 0;
		["Position"] = UDim2.new(0.5, 0, 1, -200);
		["Size"] = UDim2.new(0.25, 0, 0, 20);
		["Visible"] = false;
		["Name"] = "cooldown";
		["Parent"] = layout;
	})

	local prog = create('Frame', {
		["BackgroundColor3"] = Color3.fromRGB(234.00000125169754, 0, 255);
		["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		["BorderSizePixel"] = 0;
		["Size"] = UDim2.new(0.389255434, 0, 1, 0);
		["Name"] = "prog";
		["Parent"] = bg;
	})

	local timer = create('TextLabel', {
		["Font"] = Enum.Font.Code;
		["Text"] = "";
		["TextColor3"] = Color3.fromRGB(255, 255, 255);
		["TextSize"] = 20;
		["TextStrokeTransparency"] = 0;
		["TextWrapped"] = true;
		["TextYAlignment"] = Enum.TextYAlignment.Bottom;
		["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		["BackgroundTransparency"] = 1;
		["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		["BorderSizePixel"] = 0;
		["Size"] = UDim2.new(1, 0, 1, 0);
		["Name"] = "timer";
		["Parent"] = bg;
	})

	create('UIStroke', {
		["Parent"] = bg;
	});
	task.spawn(function()
		bg.Visible = true;
		prog.Size = UDim2.new(1,0,1,0)
		timer.Text = sec..'s'
		prog:TweenSize(UDim2.new(0, 0, 1, 0), 'In', 'Linear', sec, true);
		for i = sec, 0, -.1 do
			timer.Text = math.floor(i * 10) / 10 .. 's';
			task.wait(.1)
		end
		bg.Visible = false;
		isReady2 = true;
		bg:Destroy()
	end)
	return true;
end

return {
	['Notify'] = sendNotification;
	['ProgressBar'] = cooldown;	
};
