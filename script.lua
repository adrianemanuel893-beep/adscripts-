--==================================================
-- ADSCRIPTS
-- TP INSTANT + CAMERA + POSICAO SEGURA
--==================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer

local AUTO_SPEED = 300
local TP_HOLD_TIME = 1.5

-- Distância acima do chão
local SAFE_HEIGHT = 4

local tpAtual = 1
local tpMovendo = false
local autoAtivo = false

local bolas = {
    [1] = nil,
    [2] = nil
}

--==================================================
-- GUI
--==================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = "ADSCRIPTS"
Gui.ResetOnSpawn = false
Gui.Parent = Player:WaitForChild("PlayerGui")

local Mini = Instance.new("TextButton")
Mini.Size = UDim2.new(0,44,0,44)
Mini.Position = UDim2.new(0,12,0.5,-22)
Mini.BackgroundColor3 = Color3.fromRGB(255,255,255)
Mini.TextColor3 = Color3.fromRGB(255,190,0)
Mini.Text = "A"
Mini.TextSize = 23
Mini.Font = Enum.Font.GothamBold
Mini.Parent = Gui

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(0,11)
MiniCorner.Parent = Mini

--==================================================
-- PAINEL
--==================================================

local Panel = Instance.new("Frame")
Panel.Size = UDim2.new(0,300,0,300)
Panel.Position = UDim2.new(0.5,-150,0.5,-150)
Panel.BackgroundColor3 = Color3.fromRGB(255,255,255)
Panel.BorderSizePixel = 0
Panel.Parent = Gui

local PanelCorner = Instance.new("UICorner")
PanelCorner.CornerRadius = UDim.new(0,13)
PanelCorner.Parent = Panel

--==================================================
-- TOPO
--==================================================

local Top = Instance.new("Frame")
Top.Size = UDim2.new(1,0,0,45)
Top.BackgroundColor3 = Color3.fromRGB(255,205,0)
Top.BorderSizePixel = 0
Top.Parent = Panel

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0,13)
TopCorner.Parent = Top

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-50,1,0)
Title.Position = UDim2.new(0,12,0,0)
Title.BackgroundTransparency = 1
Title.Text = "ADSCRIPTS"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Top

local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.new(0,34,0,32)
Minimize.Position = UDim2.new(1,-39,0,6)
Minimize.BackgroundColor3 = Color3.fromRGB(255,255,255)
Minimize.TextColor3 = Color3.fromRGB(255,190,0)
Minimize.Text = "—"
Minimize.TextSize = 21
Minimize.Font = Enum.Font.GothamBold
Minimize.Parent = Top

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0,8)
MinCorner.Parent = Minimize

--==================================================
-- TABS
--==================================================

local Tabs = Instance.new("Frame")
Tabs.Size = UDim2.new(1,-16,0,35)
Tabs.Position = UDim2.new(0,8,0,53)
Tabs.BackgroundTransparency = 1
Tabs.Parent = Panel

local function CriarTab(texto,pos)

    local b = Instance.new("TextButton")

    b.Size = UDim2.new(0.31,0,1,0)
    b.Position = UDim2.new(pos,0,0,0)
    b.BackgroundColor3 = Color3.fromRGB(245,245,245)
    b.Text = texto
    b.TextColor3 = Color3.fromRGB(70,70,70)
    b.TextSize = 11
    b.Font = Enum.Font.GothamBold
    b.Parent = Tabs

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,7)
    c.Parent = b

    return b
end

local MainTab = CriarTab("MAIN",0)
local BolasTab = CriarTab("BOLAS TP",0.345)
local ComoTab = CriarTab("COMO USAR",0.69)

--==================================================
-- PÁGINAS
--==================================================

local function CriarPagina()

    local p = Instance.new("Frame")

    p.Size = UDim2.new(1,-16,1,-98)
    p.Position = UDim2.new(0,8,0,93)
    p.BackgroundTransparency = 1
    p.Parent = Panel

    return p
end

local MainPage = CriarPagina()
local BolasPage = CriarPagina()
local ComoPage = CriarPagina()

BolasPage.Visible = false
ComoPage.Visible = false

--==================================================
-- BOTÕES
--==================================================

local function CriarBotao(parent,texto,y)

    local b = Instance.new("TextButton")

    b.Size = UDim2.new(1,0,0,45)
    b.Position = UDim2.new(0,0,0,y)

    b.BackgroundColor3 =
        Color3.fromRGB(255,205,0)

    b.TextColor3 =
        Color3.fromRGB(255,255,255)

    b.Text = texto
    b.TextSize = 14
    b.Font = Enum.Font.GothamBold
    b.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,10)
    c.Parent = b

    return b
end

local TPButton =
    CriarBotao(
        MainPage,
        "⚡ TP INSTANT • 1.5s",
        5
    )

local AutoButton =
    CriarBotao(
        MainPage,
        "🤖 AUTO TP • 300",
        58
    )

local Bola1Button =
    CriarBotao(
        BolasPage,
        "🔵 BOLA TP 1",
        5
    )

local Bola2Button =
    CriarBotao(
        BolasPage,
        "🟣 BOLA TP 2",
        58
    )

--==================================================
-- CRIAR BOLA
--==================================================

local function CriarBola(numero)

    local char = Player.Character

    if not char then
        return
    end

    local root =
        char:FindFirstChild("HumanoidRootPart")

    if not root then
        return
    end

    if bolas[numero]
        and bolas[numero].Parent then

        bolas[numero]:Destroy()
        bolas[numero] = nil

        return
    end

    local bola = Instance.new("Part")

    bola.Name =
        "BOLA TP "..numero

    bola.Shape =
        Enum.PartType.Ball

    bola.Size =
        Vector3.new(3,3,3)

    bola.Material =
        Enum.Material.Neon

    bola.Anchored = true
    bola.CanCollide = false
    bola.CanTouch = false
    bola.CanQuery = false

    if numero == 1 then

        bola.Color =
            Color3.fromRGB(0,170,255)

    else

        bola.Color =
            Color3.fromRGB(170,0,255)
    end

    bola.Position =
        root.Position +
        root.CFrame.LookVector * 8

    bola.Parent = workspace

    local luz =
        Instance.new("PointLight")

    luz.Brightness = 3
    luz.Range = 15
    luz.Color = bola.Color
    luz.Parent = bola

    bolas[numero] = bola
end

Bola1Button.MouseButton1Click:Connect(function()
    CriarBola(1)
end)

Bola2Button.MouseButton1Click:Connect(function()
    CriarBola(2)
end)

--==================================================
-- ENCONTRAR CHÃO
--==================================================

local function EncontrarChao(posicao, char)

    local params =
        RaycastParams.new()

    params.FilterType =
        Enum.RaycastFilterType.Exclude

    params.FilterDescendantsInstances = {
        char
    }

    local origem =
        posicao + Vector3.new(0,80,0)

    local direcao =
        Vector3.new(0,-160,0)

    local resultado =
        workspace:Raycast(
            origem,
            direcao,
            params
        )

    if resultado then

        return resultado.Position
    end

    return nil
end

--==================================================
-- POSIÇÃO SEGURA
--==================================================

local function CalcularPosicaoSegura(bola,char,humanoid)

    local chao =
        EncontrarChao(
            bola.Position,
            char
        )

    if chao then

        return Vector3.new(
            bola.Position.X,
            chao.Y +
            humanoid.HipHeight +
            SAFE_HEIGHT,
            bola.Position.Z
        )
    end

    -- Se não encontrar chão,
    -- fica acima da própria bola.
    return bola.Position +
        Vector3.new(
            0,
            SAFE_HEIGHT + 2,
            0
        )
end

--==================================================
-- TP INSTANT
--==================================================

TPButton.MouseButton1Click:Connect(function()

    if tpMovendo then
        return
    end

    local char =
        Player.Character

    if not char then
        return
    end

    local root =
        char:FindFirstChild(
            "HumanoidRootPart"
        )

    local humanoid =
        char:FindFirstChildOfClass(
            "Humanoid"
        )

    if not root or not humanoid then
        return
    end

    local bola =
        bolas[tpAtual]

    if not bola
        or not bola.Parent then

        return
    end

    tpMovendo = true

    local camera =
        workspace.CurrentCamera

    --==============================================
    -- GUARDA A CÂMERA
    --==============================================

    local cameraLook =
        camera.CFrame.LookVector

    local cameraDistancia =
        (camera.CFrame.Position -
        root.Position).Magnitude

    --==============================================
    -- CALCULA POSIÇÃO SEGURA
    --==============================================

    local destino =
        CalcularPosicaoSegura(
            bola,
            char,
            humanoid
        )

    --==============================================
    -- TP
    --==============================================

    root.CFrame =
        CFrame.new(
            destino
        )

    root.AssemblyLinearVelocity =
        Vector3.zero

    root.AssemblyAngularVelocity =
        Vector3.zero

    --==============================================
    -- CÂMERA JUNTO
    --==============================================

    camera.CameraType =
        Enum.CameraType.Scriptable

    camera.CFrame =
        CFrame.lookAt(
            destino -
            cameraLook *
            cameraDistancia,

            destino
        )

    --==============================================
    -- 1.5 SEGUNDOS
    --==============================================

    local fim =
        os.clock() +
        TP_HOLD_TIME

    while os.clock() < fim do

        if not bola
            or not bola.Parent then

            break
        end

        destino =
            CalcularPosicaoSegura(
                bola,
                char,
                humanoid
            )

        root.CFrame =
            CFrame.new(
                destino
            )

        root.AssemblyLinearVelocity =
            Vector3.zero

        root.AssemblyAngularVelocity =
            Vector3.zero

        camera.CFrame =
            CFrame.lookAt(
                destino -
                cameraLook *
                cameraDistancia,

                destino
            )

        RunService.RenderStepped:Wait()
    end

    --==============================================
    -- DEVOLVE A CÂMERA
    --==============================================

    camera.CameraType =
        Enum.CameraType.Custom

    camera.CameraSubject =
        humanoid

    root.AssemblyLinearVelocity =
        Vector3.zero

    root.AssemblyAngularVelocity =
        Vector3.zero

    --==============================================
    -- PRÓXIMA BOLA
    --==============================================

    if tpAtual == 1
        and bolas[2]
        and bolas[2].Parent then

        tpAtual = 2

    else

        tpAtual = 1
    end

    tpMovendo = false
end)

--==================================================
-- AUTO TP 300
--==================================================

AutoButton.MouseButton1Click:Connect(function()

    autoAtivo =
        not autoAtivo

    if autoAtivo then

        AutoButton.Text =
            "🛑 AUTO TP • ATIVO"

    else

        AutoButton.Text =
            "🤖 AUTO TP • 300"

        local char =
            Player.Character

        if char then

            local root =
                char:FindFirstChild(
                    "HumanoidRootPart"
                )

            if root then

                root.AssemblyLinearVelocity =
                    Vector3.zero
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()

    if not autoAtivo then
        return
    end

    local char =
        Player.Character

    if not char then
        return
    end

    local root =
        char:FindFirstChild(
            "HumanoidRootPart"
        )

    if not root then
        return
    end

    local bola =
        bolas[1]

    if not bola
        or not bola.Parent then

        bola = bolas[2]
    end

    if bola and bola.Parent then

        local direcao =
            Vector3.new(
                bola.Position.X -
                root.Position.X,

                0,

                bola.Position.Z -
                root.Position.Z
            )

        local distancia =
            direcao.Magnitude

        if distancia > 3 then

            root.AssemblyLinearVelocity =
                direcao.Unit *
                AUTO_SPEED

        else

            root.AssemblyLinearVelocity =
                Vector3.zero

            autoAtivo = false

            AutoButton.Text =
                "🤖 AUTO TP • 300"
        end
    end
end)

--==================================================
-- COMO USAR
--==================================================

local Scroll =
    Instance.new("ScrollingFrame")

Scroll.Size =
    UDim2.new(1,0,1,0)

Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 4

Scroll.CanvasSize =
    UDim2.new(0,0,0,400)

Scroll.Parent = ComoPage

local Tutorial =
    Instance.new("TextLabel")

Tutorial.Size =
    UDim2.new(1,-8,0,390)

Tutorial.Position =
    UDim2.new(0,4,0,0)

Tutorial.BackgroundTransparency = 1

Tutorial.TextColor3 =
    Color3.fromRGB(50,50,50)

Tutorial.TextSize = 12
Tutorial.Font = Enum.Font.Gotham
Tutorial.TextWrapped = true

Tutorial.TextYAlignment =
    Enum.TextYAlignment.Top

Tutorial.TextXAlignment =
    Enum.TextXAlignment.Left

Tutorial.Text = [[
📖 COMO USAR

🔵 BOLA TP 1
Cria o primeiro ponto.

🟣 BOLA TP 2
Cria o segundo ponto.

⚡ TP INSTANT • 1.5s
Vai direto para a posição.

O personagem fica acima
do chão para evitar ficar
dentro do piso.

A câmera acompanha o TP.

1º clique → BOLA 1
2º clique → BOLA 2
3º clique → BOLA 1

🤖 AUTO TP • 300
Vai em direção à bola
com velocidade 300.

💡 DICA
Deixa a bola atrás da linha branca.
]]

Tutorial.Parent = Scroll

--==================================================
-- ABAS
--==================================================

local function Mostrar(pagina)

    MainPage.Visible = false
    BolasPage.Visible = false
    ComoPage.Visible = false

    pagina.Visible = true
end

MainTab.MouseButton1Click:Connect(function()
    Mostrar(MainPage)
end)

BolasTab.MouseButton1Click:Connect(function()
    Mostrar(BolasPage)
end)

ComoTab.MouseButton1Click:Connect(function()
    Mostrar(ComoPage)
end)

--==================================================
-- MINIMIZAR
--==================================================

local minimizado = false

Minimize.MouseButton1Click:Connect(function()

    minimizado =
        not minimizado

    if minimizado then

        Tabs.Visible = false
        MainPage.Visible = false
        BolasPage.Visible = false
        ComoPage.Visible = false

        Panel.Size =
            UDim2.new(
                0,300,
                0,45
            )

        Minimize.Text = "+"

    else

        Panel.Size =
            UDim2.new(
                0,300,
                0,300
            )

        Tabs.Visible = true
        MainPage.Visible = true

        Minimize.Text = "—"
    end
end)

--==================================================
-- BOTÃO A
--==================================================

Mini.MouseButton1Click:Connect(function()

    Panel.Visible =
        not Panel.Visible
end)

--==================================================
-- ARRASTAR
--==================================================

local arrastando = false
local inicioMouse
local inicioPos

Top.InputBegan:Connect(function(input)

    if input.UserInputType ==
        Enum.UserInputType.MouseButton1
        or input.UserInputType ==
        Enum.UserInputType.Touch then

        arrastando = true
        inicioMouse = input.Position
        inicioPos = Panel.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)

    if not arrastando then
        return
    end

    if input.UserInputType ==
        Enum.UserInputType.MouseMovement
        or input.UserInputType ==
        Enum.UserInputType.Touch then

        local delta =
            input.Position -
            inicioMouse

        Panel.Position =
            UDim2.new(
                inicioPos.X.Scale,
                inicioPos.X.Offset +
                delta.X,

                inicioPos.Y.Scale,
                inicioPos.Y.Offset +
                delta.Y
            )
    end
end)

UserInputService.InputEnded:Connect(function(input)

    if input.UserInputType ==
        Enum.UserInputType.MouseButton1
        or input.UserInputType ==
        Enum.UserInputType.Touch then

        arrastando = false
    end
end)