local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "ADSCRIPTS"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local am = Color3.fromRGB(255,190,0)
local amCl = Color3.fromRGB(255,220,50)
local br = Color3.fromRGB(255,255,255)

function arrastar(o)
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
btn.Size = UDim2.new(0,70,0,70)
btn.Position = UDim2.new(0.5,-35,0.5,-35)
btn.BackgroundColor3 = am
btn.Text = "🇧🇷\n𝓐"
btn.TextSize = 27
btn.TextColor3 = br
btn.Font = Enum.Font.GothamBold
btn.Parent = gui
Instance.new("UICorner",btn).CornerRadius = UDim.new(0,18)
local st1 = Instance.new("UIStroke",btn)
st1.Color = br
st1.Thickness = 3
arrastar(btn)

local pan = Instance.new("Frame")
pan.Size = UDim2.new(0,350,0,310)
pan.Position = UDim2.new(0.5,-175,0.5,-155)
pan.BackgroundColor3 = br
pan.Visible = false
pan.Parent = gui
Instance.new("UICorner",pan).CornerRadius = UDim.new(0,25)
local st2 = Instance.new("UIStroke",pan)
st2.Color = am
st2.Thickness = 4

local tit = Instance.new("TextLabel")
tit.Size = UDim2.new(1,-20,0,60)
tit.Position = UDim2.new(0,10,0,5)
tit.BackgroundTransparency = 1
tit.Text = "🇧🇷 AD SCRIPTS"
tit.TextColor3 = am
tit.TextSize = 27
tit.Font = Enum.Font.GothamBold
tit.Parent = pan

function botao(t,y)
	local b=Instance.new("TextButton")
	b.Size=UDim2.new(1,-40,0,50)
	b.Position=UDim2.new(0,20,0,y)
	b.BackgroundColor3=am
	b.Text=t
	b.TextColor3=br
	b.TextSize=18
	b.Font=Enum.Font.GothamBold
	b.Parent=pan
	Instance.new("UICorner",b).CornerRadius=UDim.new(0,15)
	local s=Instance.new("UIStroke",b)
	s.Color=amCl
	s.Thickness=2
	return b
end

local b1 = botao("🔵 Criar Bola",75)
local b2 = botao("⚡ TP Instant",140)
local b3 = botao("🤖 AUTO TP • Velocidade 200",205)

local bola
b1.MouseButton1Click:Connect(function()
	if bola then bola:Destroy() bola=nil b1.Text="🔵 Criar Bola" return end
	local c=player.Character if not c then return end
	local r=c:FindFirstChild("HumanoidRootPart") if not r then return end
	bola=Instance.new("Part")
	bola.Name="BolaTP"
	bola.Shape=Enum.PartType.Ball
	bola.Size=Vector3.new(3,3,3)
	bola.Position=r.Position+r.CFrame.LookVector*8
	bola.Anchored=true
	bola.CanCollide=false
	bola.Material=Enum.Material.Neon
	bola.Color=Color3.fromRGB(0,140,255)
	bola.Parent=workspace
	local l=Instance.new("PointLight",bola)
	l.Color=Color3.fromRGB(0,150,255)
	l.Brightness=3
	l.Range=12
	b1.Text="❌ Remover Bola"
end)

local tpg
b2.MouseButton1Click:Connect(function()
	if tpg then return end
	if not bola or not bola.Parent then
		b2.Text="⚠️ CRIE A BOLA" task.wait(0.5)
		b2.Text="⚡ TP Instant" return
	end
	local c=player.Character if not c then return end
	local r=c:FindFirstChild("HumanoidRootPart") if not r then return end
	tpg=true b2.Text="⚡ TP..."
	local d=bola.CFrame+Vector3.new(0,3,0)
	r.CFrame=d
	local t0=os.clock()
	while os.clock()-t0<0.7 do
		if not r.Parent or not bola.Parent then break end
		r.CFrame=d RS.Heartbeat:Wait()
	end
	b2.Text="⚡ TP Instant" tpg=false
end)

local on
b3.MouseButton1Click:Connect(function()
	if on then on=false b3.Text="🤖 AUTO TP • Velocidade 200" return end
	if not bola or not bola.Parent then
		b3.Text="⚠️ CRIE A BOLA" task.wait(0.5)
		b3.Text="🤖 AUTO TP • Velocidade 200" return
	end
	on=true b3.Text="🟢 AUTO TP ATIVO"
	local c=player.Character if not c then on=false return end
	local r=c:FindFirstChild("HumanoidRootPart") if not r then on=false return end
	while on and bola and bola.Parent and r.Parent do
		local d=bola.Position+Vector3.new(0,3,0)
		if (d-r.Position).Magnitude<=2 then
			r.AssemblyLinearVelocity=Vector3.zero break
		end
		r.AssemblyLinearVelocity=(d-r.Position).Unit*200
		RS.Heartbeat:Wait()
	end
	r.AssemblyLinearVelocity=Vector3.zero
	on=false b3.Text="🤖 AUTO TP • Velocidade 200"
end)

btn.MouseButton1Click:Connect(function() pan.Visible=not pan.Visible end)
