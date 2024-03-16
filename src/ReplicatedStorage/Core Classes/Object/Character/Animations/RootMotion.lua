local rootMotion = {}

-- Move humanoid by a certain distance.
function rootMotion:MoveHumanoid(Humanoid, Direction, dt)

	local Distance = Direction.Magnitude
	Humanoid.WalkSpeed = Distance / dt
	if Distance > 0 then
		Humanoid:Move(Direction.Unit, false)
	else
		Humanoid:Move(Vector3.zero, false)
	end

end

-- This will basically remove the Y axis rotation of the transform.
function rootMotion:GetTransform(Transform)

	local _, _, Heading = Transform:ToEulerAngles(Enum.RotationOrder.YXZ)
	local Orientation = CFrame.fromEulerAngles(0, 0, Heading, Enum.RotationOrder.YXZ)
	return Orientation + Transform.Position

end

return rootMotion
