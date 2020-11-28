
--When the player joins, anchor their character model
game.Players.PlayerAdded:Connect(function(Player)
	Player.CharacterAdded:Connect(function(Char)
		
		Char.PrimaryPart.Anchored = true
		
	end)
end)