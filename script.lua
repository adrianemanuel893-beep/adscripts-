local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "BRASILIN_SCRIPTS"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local am = Color3.fromRGB(255,190,0)
local ver = Color3.fromRGB(0,180,0)
local br = Color3.fromRGB(255,255,255)

local function arrastar(o)
	local m,i,pz
	o.InputBegan:Connect(function(e)
		if e.UserInputType==Enum.UserInputType.MouseButton1 or e.UserInputType==Enum.UserInputType.Touch then
			m=true i=e.Position pz=o.Position
		end
	end)
	UIS.InputChanged:Connect(function(e)
		if not m then return end
		if e.UserInputType~=Enum.UserInputType.MouseMovement and e.UserInputType~=Enum.UserInputType.Touch then return end
		local d=e.Position-i
		o.Position=UDim2.new(pz.X.Scale,pz.X.Offset+d.X,pz.Y.Scale,pz.Y.Offset+d.Y)
	end)
	UIS.InputEnded:Connect(function(e)
		if e.UserInputType==Enum.UserInputType.MouseButton1 or e.UserInputType==Enum.UserInputType.Touch then m=false end
	end)
end

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0,65,0,65)
btn.Position = UDim2.new(0.03,0,0.5,-32)
btn.BackgroundColor3 = am
btn.Text = "🇧🇷"
btn.TextSize = 28
btn.TextColor3 = br
btn.Font = Enum.Font.GothamBold
btn.Parent = gui
Instance.new("UICorner",btn).CornerRadius = UDim.new(1,0)
arrastar(btn)

local pan = Instance.new("Frame")
pan.Size = UDim2.new(0,260,0,230)
pan.Position = UDim2.new(0.5,-130,0.5,-115)
pan.BackgroundColor3 = ver
pan.Visible = false
pan.Parent = gui
Instance.new("UICorner",pan).CornerRadius = UDim.new(0,20)
local st = Instance.new("UIStroke",pan)
st.Color = am
st.Thickness = 5

local tit = Instance.new("TextLabel")
tit.Size = UDim2.new(1,-20,0,45)
tit.Position = UDim2.new(0,10,0,5)
tit.BackgroundTransparency = 1
tit.Text = "🇧🇷 BRASILIN SCRIPTS"
tit.TextColor3 = am
tit.TextSize = 20
tit.Font = Enum.Font.GothamBold
tit.Parent = pan

function botao(t,y)
	local b=Instance.new("TextButton")
	b.Size=UDim2.new(1,-30,0,45)
	b.Position=UDim2.new(0,15,0,y)
	b.BackgroundColor3=am
	b.Text=t
	b.TextColor3=br
	b.TextSize=15
	b.Font=Enum.Font.GothamBold
	b.Parent=pan
	Instance.new("UICorner",b).CornerRadius=UDim.new(0,12)
	return b
end

local b1 = botao("🔵 CRIAR BOLA",60)
local b2 = botao("⚡ TELEGUIADO",120)
local bola

b1.MouseButton1Click:Connect(function()
	if bola then bola:Destroy() bola=nil b1.Text="🔵 CRIAR BOLA" return end
	local c=player.Character if not c then return end
	local r=c:FindFirstChild("HumanoidRootPart") if not r then return end
	bola=Instance.new("Part")
	bola.Shape=Enum.PartType.Ball
	bola.Size=Vector3.new(3,3,3)
	bola.Position=r.Position+Vector3.new(0,7,0)
	bola.Anchored=true
	bola.CanCollide=false
	bola.Material=Enum.Material.Neon
	bola.Color=Color3.fromRGB(0,255,0)
	bola.Parent=workspace
	local l=Instance.new("PointLight",bola)
	l.Color=Color3.fromRGB(0,255,0)
	l.Brightness=5
	l.Range=20
	b1.Text="❌ REMOVER BOLA"
end)

b2.MouseButton1Click:Connect(function()
	if not bola or not bola.Parent then return end
	local c=player.Character if not c then return end
	local r=c:FindFirstChild("HumanoidRootPart") if not r then return end
	local d=bola.Position+Vector3.new(0,3,0)
	r.AssemblyLinearVelocity=(d-r.Position).Unit*500
	task.wait(0.15)
	r.AssemblyLinearVelocity=Vector3.zero
end)

btn.MouseButton1Click:Connect(function() pan.Visible=not pan.Visible end)
