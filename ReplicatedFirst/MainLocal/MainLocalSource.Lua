---The parent is the Actual LocalScript and this is the source

-- Variables
local camera            = workspace.CurrentCamera
local Player            = game.Players.LocalPlayer
local GridGen           = require(script.GridGenerator)
local StartingPart      = workspace:WaitForChild("Part")
local RunService        = game:GetService("RunService")
local StartingPos       = StartingPart.Position
local cameraOffset      = Vector3.new(2, 2, 8)
local GridXSize         = 10
local GridZSize         = 10
local GridParts         = GridGen.GenerateGrid(GridXSize, GridZSize, StartingPart)
local TweenService      = game:GetService("TweenService")
local Info              = TweenInfo.new(0.1, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut)
local MiddlePart        = GridParts[tostring(math.ceil(GridXSize/2))..tostring(math.ceil(GridZSize/2))]
local FirstPart         = GridParts[tostring(1)..tostring(1)]
local FurthestPart      = GridParts[tostring(GridXSize)..tostring(GridZSize)]
local Map               = require(script.Map)
local PartTweens        = {}
StartingPart:Destroy()


--Allows us to position the camera while the game runs
local cameraAngleX      = -120
local cameraAngleY      = -40
workspace.X.Value       = cameraAngleX
workspace.Y.Value       = cameraAngleY
workspace.X.Changed:Connect(function()
	cameraAngleX = workspace.X.Value
end)
workspace.Y.Changed:Connect(function()
	cameraAngleY = workspace.Y.Value
end)

--Every remdered frame we re-position and orientate the camera to look at the position we specified, incase the user attempts to move the camera
RunService.RenderStepped:Connect(function()
	if camera.CameraType ~= Enum.CameraType.Scriptable then
		camera.CameraType   = Enum.CameraType.Scriptable
	end
	local NewCameraPosition = StartingPos + Vector3.new(-3, 15, -3)

	local startCFrame       = CFrame.new((NewCameraPosition)) * CFrame.Angles(0, math.rad(cameraAngleX), 0) * CFrame.Angles(math.rad(cameraAngleY), 0, 0)
	local cameraCFrame      = startCFrame:ToWorldSpace(CFrame.new(cameraOffset.X, cameraOffset.Y, cameraOffset.Z))
	local cameraFocus       = startCFrame:ToWorldSpace(CFrame.new(cameraOffset.X, cameraOffset.Y, -10000))
	camera.CFrame           = CFrame.new(cameraCFrame.Position, cameraFocus.Position)
end)

--Where we calculate the new height for each part and animate it
local Angle = math.rad(0)
while true do
	wait()
	local function NewHeight(Part)
		local DistanceFromMid = (Part.Position - MiddlePart.Position).Magnitude
		local MaxD            = (FirstPart.Position - FurthestPart.Position).Magnitude
		--If set to something higher like 200 it'll create more frequent wave, meaning, it'll start a new wave
		--while the initial wave is still heading towards the center
		local WaveFrequency   = 100
		local Offset          = Map(DistanceFromMid, 0, MaxD, -math.pi, math.pi) * WaveFrequency
		local a               = math.rad(Angle + Offset)
		local Height          = math.floor(Map(math.sin(a), -1, 1, 4, 20))
		return Height
	end
	--Play the animation on every part
	local prevx = 0
	for PartName, Part in pairs(GridParts) do
		local x, z            = table.unpack(string.split(PartName, ","))
		if tonumber(x) > prevx then
			prevx             = tonumber(x)
			Angle            -= math.rad(90)
		end
		--Create and Play a new animation on the part
		TweenService:Create(Part, Info, {Size = Vector3.new(Part.Size.X, NewHeight(Part), Part.Size.Z)}):Play()
	end
end
