

		-- MANTENHA O RESTANTE DO PAINEL IGUAL.
-- SUBSTITUA SOMENTE AS PARTES DO TP INSTANT E AUTO TP POR ESTAS:

--------------------------------------------------
-- TP INSTANT — 3,5 SEGUNDOS
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

	local humanoid =
		character:FindFirstChildOfClass("Humanoid")

	if not root or not humanoid then return end

	teleportando = true
	tpInstant.Text = "⚡  TP 3.5s"

	--------------------------------------------------
	-- TELEPORTE DIRETO
	--------------------------------------------------

	local destino =
		bola.CFrame + Vector3.new(0,3,0)

	root.CFrame = destino

	root.AssemblyLinearVelocity =
		Vector3.zero

	root.AssemblyAngularVelocity =
		Vector3.zero

	--------------------------------------------------
	-- CONTAGEM RÁPIDA ATÉ 3,5s
	--------------------------------------------------

	local inicio = os.clock()

	while os.clock() - inicio < 3.5 do

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
-- AUTO TP — VELOCIDADE 200 NO CHÃO
--------------------------------------------------

local autoAtivo = false
local velocidadeOriginal = 16

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

	local character = player.Character
	if not character then return end

	local root =
		character:FindFirstChild("HumanoidRootPart")

	local humanoid =
		character:FindFirstChildOfClass("Humanoid")

	if not root or not humanoid then return end

	velocidadeOriginal = humanoid.WalkSpeed

	autoAtivo = true
	autoTP.Text = "🟢  AUTO TP • 200"

	--------------------------------------------------
	-- VELOCIDADE 200
	--------------------------------------------------

	humanoid.WalkSpeed = 200
	humanoid.PlatformStand = false

	--------------------------------------------------
	-- ANDAR ATÉ A BOLA PELO CHÃO
	--------------------------------------------------

	while autoAtivo
		and bola
		and bola.Parent
		and root.Parent
		and humanoid.Parent do

		local destino =
			bola.Position

		local diferenca =
			destino - root.Position

		local distancia =
			diferenca.Magnitude

		if distancia <= 3 then

			humanoid:Move(
				Vector3.zero,
				false
			)

			break
		end

		--------------------------------------------------
		-- MOVIMENTO NORMAL DO HUMANOID
		-- mantém os pés no chão
		--------------------------------------------------

		local direcao =
			Vector3.new(
				diferenca.X,
				0,
				diferenca.Z
			)

		if direcao.Magnitude > 0 then

			humanoid:Move(
				direcao.Unit,
				false
			)
		end

		RunService.Heartbeat:Wait()
	end

	--------------------------------------------------
	-- PARAR
	--------------------------------------------------

	humanoid:Move(
		Vector3.zero,
		false
	)

	humanoid.WalkSpeed =
		velocidadeOriginal

	autoAtivo = false

	autoTP.Text =
		"🤖  AUTO TP  •  200"
end)