

	local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

--------------------------------------------------
-- GUI
--------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "ADSCRIPTS"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

--------------------------------------------------
-- CORES
--------------------------------------------------

local amarelo = Color3.fromRGB(255,190,0)
local amareloClaro = Color3.fromRGB(255,225,80)
local branco = Color3.fromRGB(255,255,255)
local escuro = Color3.fromRGB(30,30,30)

--------------------------------------------------
-- FUNÇÃO ARRASTAR
--------------------------------------------------

local function arrastavel(obj)

	local movendo = false
	local inicio
	local posicao

	obj.InputBegan:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.Touch
			or input.UserInputType == Enum.UserInputType.MouseButton1 then

			movendo = true
			inicio = input.Position
			posicao = obj.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(input)

		if not movendo then return end

		if input.UserInputType ~= Enum.UserInputType.Touch
			and input.UserInputType ~= Enum.UserInputType.MouseMovement then
			return
		end

		local delta = input.Position - inicio

		obj.Position = UDim2.new(
			posicao.X.Scale,
			posicao.X.Offset + delta.X,
			posicao.Y.Scale,
			posicao.Y.Offset + delta.Y
		)
	end)

	UserInputService.InputEnded:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.Touch
			or input.UserInputType == Enum.UserInputType.MouseButton1 then

			movendo = false
		end
	end)
end

--------------------------------------------------
-- QUADRADINHO COM A
--------------------------------------------------

local mini = Instance.new("TextButton")

mini.Size = UDim2.new(0,58,0,58)
mini.Position = UDim2.new(0.5,-29,0.5,-29)

mini.BackgroundColor3 = amarelo
mini.Text = "A"
mini.TextColor3 = branco
mini.TextSize = 34
mini.Font = Enum.Font.GothamBlack

mini.BorderSizePixel = 0
mini.AutoButtonColor = true
mini.Parent = gui

local miniCorner = Instance.new("UICorner")
miniCorner.CornerRadius = UDim.new(0,14)
miniCorner.Parent = mini

local miniStroke = Instance.new("UIStroke")
miniStroke.Color = branco
miniStroke.Thickness = 2
miniStroke.Parent = mini

arrastavel(mini)

--------------------------------------------------
-- PAINEL PEQUENO
--------------------------------------------------

local panel = Instance.new("Frame")

panel.Size = UDim2.new(0,285,0,245)
panel.Position = UDim2.new(0.5,-142,0.5,-122)

panel.BackgroundColor3 = escuro
panel.BorderSizePixel = 0
panel.Visible = false
panel.Parent = gui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0,20)
panelCorner.Parent = panel

local panelStroke = Instance.new("UIStroke")
panelStroke.Color = amarelo
panelStroke.Thickness = 3
panelStroke.Parent = panel

arrastavel(panel)

--------------------------------------------------
-- BRILHO DO PAINEL
--------------------------------------------------

local brilho = Instance.new("UIGradient")

brilho.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(45,45,45)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(20,20,20))
})

brilho.Rotation = 90
brilho.Parent = panel

--------------------------------------------------
-- TÍTULO
--------------------------------------------------

local titulo = Instance.new("TextLabel")

titulo.Size = UDim2.new(1,-20,0,45)
titulo.Position = UDim2.new(0,10,0,4)

titulo.BackgroundTransparency = 1
titulo.Text = "AD SCRIPTS"
titulo.TextColor3 = amarelo
titulo.TextSize = 23
titulo.Font = Enum.Font.GothamBlack

titulo.Parent = panel

--------------------------------------------------
-- LINHA DECORATIVA
--------------------------------------------------

local linha = Instance.new("Frame")

linha.Size = UDim2.new(1,-40,0,2)
linha.Position = UDim2.new(0,20,0,48)

linha.BackgroundColor3 = amarelo
linha.BorderSizePixel = 0
linha.Parent = panel

--------------------------------------------------
-- FUNÇÃO BOTÃO
--------------------------------------------------

local function botao(texto,y)

	local b = Instance.new("TextButton")

	b.Size = UDim2.new(1,-35,0,48)
	b.Position = UDim2.new(0,17.5,0,y)

	b.BackgroundColor3 = amarelo
	b.Text = texto
	b.TextColor3 = branco
	b.TextSize = 16
	b.Font = Enum.Font.GothamBold

	b.BorderSizePixel = 0
	b.AutoButtonColor = true
	b.Parent = panel

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0,13)
	c.Parent = b

	local s = Instance.new("UIStroke")
	s.Color = amareloClaro
	s.Thickness = 2
	s.Parent = b

	return b
end

--------------------------------------------------
-- BOTÕES
--------------------------------------------------

local criarBola =
	botao("🔵  Criar Bola",60)

local tpInstant =
	botao("⚡  TP Instant",115)

local autoTP =
	botao("🤖  AUTO TP  •  200",170)

--------------------------------------------------
-- BOLA
--------------------------------------------------

local bola = nil

criarBola.MouseButton1Click:Connect(function()

	if bola then

		bola:Destroy()
		bola = nil

		criarBola.Text = "🔵  Criar Bola"

		return
	end

	local character = player.Character
	if not character then return end

	local root =
		character:FindFirstChild("HumanoidRootPart")

	if not root then return end

	bola = Instance.new("Part")

	bola.Name = "BolaTP"
	bola.Shape = Enum.PartType.Ball
	bola.Size = Vector3.new(3,3,3)

	bola.Position =
		root.Position +
		root.CFrame.LookVector * 8

	bola.Anchored = true
	bola.CanCollide = false
	bola.Material = Enum.Material.Neon
	bola.Color = Color3.fromRGB(0,140,255)

	bola.Parent = workspace

	local luz =
		Instance.new("PointLight")

	luz.Color = Color3.fromRGB(0,150,255)
	luz.Brightness = 3
	luz.Range = 12

	luz.Parent = bola

	criarBola.Text = "❌  Remover Bola"
end)

--------------------------------------------------
-- TP INSTANT
--------------------------------------------------

local teleportando = false

tpInstant.MouseButton1Click:Connect(function()

	if teleportando then return end

	if not bola or not bola.Parent then

		tpInstant.Text = "⚠️  CRIE A BOLA"

		task.wait(0.5)

		tpInstant.Text = "⚡  TP Instant"

		return
	end

	local character = player.Character
	if not character then return end

	local root =
		character:FindFirstChild("HumanoidRootPart")

	if not root then return end

	teleportando = true
	tpInstant.Text = "⚡  TP..."

	local destino =
		bola.CFrame + Vector3.new(0,3,0)

	root.CFrame = destino

	root.AssemblyLinearVelocity =
		Vector3.zero

	root.AssemblyAngularVelocity =
		Vector3.zero

	local inicio = os.clock()

	while os.clock() - inicio < 0.7 do

		if not root.Parent or not bola.Parent then
			break
		end

		root.CFrame = destino

		root.AssemblyLinearVelocity =
			Vector3.zero

		root.AssemblyAngularVelocity =
			Vector3.zero

		RunService.Heartbeat:Wait()
	end

	tpInstant.Text = "⚡  TP Instant"
	teleportando = false
end)

--------------------------------------------------
-- AUTO TP 200
--------------------------------------------------

local autoAtivo = false

autoTP.MouseButton1Click:Connect(function()

	if autoAtivo then

		autoAtivo = false
		autoTP.Text = "🤖  AUTO TP  •  200"

		return
	end

	if not bola or not bola.Parent then

		autoTP.Text = "⚠️  CRIE A BOLA"

		task.wait(0.5)

		autoTP.Text = "🤖  AUTO TP  •  200"

		return
	end

	autoAtivo = true
	autoTP.Text = "🟢  AUTO TP ATIVO"

	local character = player.Character

	if not character then
		autoAtivo = false
		return
	end

	local root =
		character:FindFirstChild("HumanoidRootPart")

	if not root then
		autoAtivo = false
		return
	end

	while autoAtivo
		and bola
		and bola.Parent
		and root.Parent do

		local destino =
			bola.Position + Vector3.new(0,3,0)

		local distancia =
			(destino - root.Position).Magnitude

		if distancia <= 2 then

			root.AssemblyLinearVelocity =
				Vector3.zero

			break
		end

		local direcao =
			(destino - root.Position).Unit

		root.AssemblyLinearVelocity =
			direcao * 200

		RunService.Heartbeat:Wait()
	end

	root.AssemblyLinearVelocity =
		Vector3.zero

	autoAtivo = false

	autoTP.Text =
		"🤖  AUTO TP  •  200"
end)

--------------------------------------------------
-- ABRIR / FECHAR
--------------------------------------------------

mini.MouseButton1Click:Connect(function()

	panel.Visible =
		not panel.Visible
end)