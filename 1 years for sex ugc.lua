if game.PlaceId == 90998286454316 then
    coroutine.wrap(function()
        local a = game.Players.LocalPlayer
        local b = a.Character or a.CharacterAdded:Wait()
        local c = b:WaitForChild("HumanoidRootPart")
        local d = game:GetService("Workspace").Easy_Obbys.ObbyPortals.Unbeatable.WinPoint

        for _, v in ipairs(d:GetDescendants()) do
            if v:IsA("TouchTransmitter") then
                coroutine.wrap(function()
                    local part = v:FindFirstAncestorWhichIsA("Part")
                    if part and c then
                        firetouchinterest(part, c, 1)
                        task.wait()
                        firetouchinterest(part, c, 0)
                    end
                end)()
            end
        end

        b:PivotTo(CFrame.new(-336, 49, 552))
        task.wait(0.1)
        b:PivotTo(CFrame.new(d.Position))
        
        task.wait(2)
        a:Kick("GET OUT")
        task.wait(0.6)
        game:GetService("TeleportService"):Teleport(game.PlaceId, a)
    end)()
end
