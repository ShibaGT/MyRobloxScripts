-- Use this on the MAIN to autofarm!
-- made with <3 by tai

local lp = game:GetService("Players").LocalPlayer
local backpack = lp:WaitForChild("Backpack")
local savedPos = nil
local farming = false

local function teleport(pos)
    if lp.Character and lp.Character.PrimaryPart then
        lp.Character:SetPrimaryPartCFrame(CFrame.new(pos))
    end
end

local function farmLoop()
	while true do
		local success, err = pcall(function()
			if farming and savedPos then
				if lp.Character and lp.Character.PrimaryPart then
					teleport(savedPos)

					-- Press G
					game:GetService("Players").LocalPlayer.Character.Communicate:FireServer({
						{
							Goal = "KeyPress",
							Key = Enum.KeyCode.G
						}
					})

					if not backpack:FindFirstChild("Jet Dive") then
						game:GetService("Players").LocalPlayer.Character.Communicate:FireServer({
							{
								Goal = "Console Move",
								Tool = game:GetService("Players").LocalPlayer.Backpack["Thunder Kick"]
							}
						})

						game:GetService("Players").LocalPlayer.Character.Communicate:FireServer({
							{
								Goal = "Console Move",
								Tool = game:GetService("Players").LocalPlayer.Backpack["Flamewave Cannon"]
							}
						})
					else
						game:GetService("Players").LocalPlayer.Character.Communicate:FireServer({
							{
								Goal = "Console Move",
								Tool = backpack["Jet Dive"]
							}
						})

						game:GetService("Players").LocalPlayer.Character.Communicate:FireServer({
							{
								Goal = "Console Move",
								Tool = backpack["Blitz Shot"]
							}
						})

						game:GetService("Players").LocalPlayer.Character.Communicate:FireServer({
							{
								Goal = "Console Move",
								Tool = backpack["Ignition Burst"]
							}
						})

						game:GetService("Players").LocalPlayer.Character.Communicate:FireServer({
							{
								Goal = "Console Move",
								Tool = backpack["Machine Gun Blows"]
							}
						})
					end
				end
			end
		end)

		if not success then
			warn("farmLoop error:", err)
			task.wait(5) -- retry delay after error
		else
			task.wait(0.1)
		end
	end
end

spawn(farmLoop)

for _,player in ipairs(game.Players:GetPlayers()) do
    player.Chatted:Connect(function(msg)
        msg = msg:lower()
        if player == lp then
            if msg == ".sp" then
                if player.Character and player.Character.PrimaryPart then
                    savedPos = player.Character.PrimaryPart.Position
                    print("[.setpos] Saved position of " .. player.Name .. ":", savedPos)
                end
            end
            if msg == ".fa" then
                if savedPos then
					wait(5)
                    farming = true
                    print("[.farm] Started farming loop.")
                else
                    print("[.farm] No position saved.")
                end
            end
            if msg == ".st" then
                farming = false
                print("[.stop] Stopped farming.")
            end   
        end
    end)
end
