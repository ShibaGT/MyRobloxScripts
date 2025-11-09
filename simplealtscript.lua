-- made with love by tai

if not game:IsLoaded() then 
    game.Loaded:Wait() 
end

local lp = game.Players.LocalPlayer
local savedPos = nil
local farming = false

local Services = setmetatable({}, {
    __index = function(_, service)
        return game:GetService(service)
    end
})

local replicatesignal = rawget(_G, "replicatesignal") or nil

local function resetCharacter()
    local speaker = lp
    local humanoid = speaker.Character and speaker.Character:FindFirstChildWhichIsA("Humanoid")
    if replicatesignal and speaker.Kill then
        replicatesignal(speaker.Kill)
    elseif humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Dead)
    else
        speaker.Character:BreakJoints()
    end
end

local function teleport(pos)
    if lp.Character and lp.Character.PrimaryPart then
        lp.Character:SetPrimaryPartCFrame(CFrame.new(pos))
    end
end

local function farmLoop()
    while true do
        if farming and savedPos then
            if lp.Character and lp.Character.PrimaryPart then
                teleport(savedPos)
                wait(2.5)
                resetCharacter()
                lp.CharacterAdded:Wait()
            end
            wait(0.5)
        else
            wait(0.5)
        end
    end
end

spawn(farmLoop)

for _,player in ipairs(game.Players:GetPlayers()) do
    player.Chatted:Connect(function(msg)
        msg = msg:lower()
        if player ~= lp then
            if msg == ".sp" then
                if player.Character and player.Character.PrimaryPart then
                    savedPos = player.Character.PrimaryPart.Position
                    print("[.setpos] Saved position of " .. player.Name .. ":", savedPos)
                end
            end
            if msg == ".br" then
                if savedPos then
                    teleport(savedPos)
                    print("[.bring] Teleported")
                else
                    print("[.bring] No position saved.")
                end
            end
            if msg == ".fa" then
                if savedPos then
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
            if msg == ".ra" then
                local UserSettings = UserSettings()
                UserSettings.GameSettings.MasterVolume = 0
                task.wait()
                game:GetService("RunService"):Set3dRenderingEnabled(false)
                task.wait()
                game:GetService("Players").LocalPlayer.PlayerGui:Destroy()
                task.wait()
                game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
                task.wait()
                for i,v in next, workspace:GetDescendants() do
                if v:IsA'Seat' then
                v:Destroy()
                end
                end
                task.wait()
                repeat task.wait() until game:GetService("Players").LocalPlayer
                local connections = getconnections or get_signal_cons
                if connections then
                    for _, v in pairs(connections(game:GetService("Players").LocalPlayer.Idled)) do
                        if v.Disable then
                            v:Disable()
                        elseif v.Disconnect then
                            v:Disconnect()
                        end
                    end
                end
                print("[.ram] Removed assets & more.")
            end     
        end
    end)
end
