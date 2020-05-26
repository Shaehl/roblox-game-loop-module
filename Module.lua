local Module = {}

function Module:Message(msg)
	print("[GAME]: "..msg)
	self.Event:Fire("message", msg)
end

--[[
		     _           _____
		 ___| |__   __ _|___ /
		/ __| '_ \ / _` | |_ \
		\__ | | | | (_| |___) |
		|___|_| |_|\__,_|____/

	---	Template for game loop		---
	---	Made by sha3 (1003129349)	---
--]]

function Module:StartTimer(dly, msg, clb)
	if self.Timer then return end -- already playing

	local function End()
		self.Timer = nil
		self.Event:Fire("timerEnd")
	end

	self.Event:Fire("timerStart", dly)
	for i = dly, 0, -1 do
		if not self.Timer or i < self.Timer then
			if msg then
				pcall(function() self:Message(string.format(msg, tostring(i))) end) -- pcall, bc maybe mag doesn't have "%s". idk
			end
			self.Timer = i
			local succ = clb and clb() or true -- check plrs for example
			if not succ then
				End() break
			end
			wait(1)
		end
	end
	End()
end

function Module:StartIntermission(dly)
	dly = dly or 30
	if Module:StartTimer(dly, "%ss until round start.", function()
			repeat
				wait()
			until #game.Players:GetPlayers() > 0
			return true
	end) then
		return true
	end
end

function MakeLoopCoroutine(self)
	return coroutine.create(function()
		while wait() do
			self:StartIntermission()
			if self.GameStart then self.GameStart() self.Event:Fire("gameStart") end
			if self.GameEnd then self.GameEnd() self.Event:Fire("gameEnd") end
		end
	end)
end


local module = {}
function module.new(t)
	local self = setmetatable(Module, t)
	self.Loop = MakeLoopCoroutine(self)
	self.Event = Instance.new("BindableEvent")

	local rEvent = Instance.new("RemoteEvent")
	rEvent.Name = "GameLoop"
	rEvent.Parent = game.ReplicatedStorage
	self.Event.Event:connect(function(...) rEvent:FireAllClients(...) end)

	return self
end
return module
