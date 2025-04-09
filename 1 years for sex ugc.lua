if game.PlaceId == 90998286454316 then
wait() 
spawn(function()
        for _, descendant in ipairs(game:GetService("Workspace").Easy_Obbys.ObbyPortals.Unbeatable.WinPoint:GetDescendants()) do
            if descendant:IsA("TouchTransmitter") and
                    game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character.PrimaryPart then
                task.spawn(function()
                    firetouchinterest(descendant:FindFirstAncestorWhichIsA("Part"),
                        game.Players.LocalPlayer.Character.PrimaryPart, 1)
                    task.wait()
                    firetouchinterest(descendant:FindFirstAncestorWhichIsA("Part"),
                        game.Players.LocalPlayer.Character.PrimaryPart, 0)
                end)
            end
        end
    end) game.Players.LocalPlayer.Character:PivotTo(CFrame.new(game.Workspace.Easy_Obbys.ObbyPortals.Unbeatable.WinPoint.Position)) 
    wait(0.5) 
    game.Players.LocalPlayer:Kick("GET OUT") 
    game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
end
