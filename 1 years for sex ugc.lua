if game.PlaceId == 90998286454316 then
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
    end)
game.Players.LocalPlayer.Character:PivotTo(CFrame.new(Vector3.new(-336, 49, 552))) game.Players.LocalPlayer.Character:PivotTo(CFrame.new(game.Workspace.Easy_Obbys.ObbyPortals.Unbeatable.WinPoint.Position)) 
wait(2) 
    game.Players.LocalPlayer:Kick("GET OUT") 
wait(0.6) 
    game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
end
