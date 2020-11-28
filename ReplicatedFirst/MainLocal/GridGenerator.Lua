local module = {}

--returns: Array {Part}
--desc: Creates a grid and then returns the grid parts generated
function module.GenerateGrid(Width, Length, StartingOnObj)
	local AllObjects = {}
	for X=1, Width do
		for Z=1, Length do
			local Clone = StartingOnObj:Clone()
			--Half the size since the position starts in the middle of the object, size is the same for both x and z
			local Size = Clone.Size.X
			Clone.Position = Vector3.new(Clone.Position.X + (Size * X), Clone.Position.Y, Clone.Position.Z + (Size * Z))
			Clone.Name = tostring(X)..tostring(Z)
			--Place it under the same parent as the Starting Object
			Clone.Parent = StartingOnObj.Parent
			AllObjects[Clone.Name] = Clone
		end
	end
	return AllObjects
end
return module
