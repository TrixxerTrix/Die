local pfs,plrs = game:GetService("PathfindingService"),game:GetService("Players")
local http,rs = game:GetService("HttpService"),game:GetService("ReplicatedStorage")
local hrp = plrs.LocalPlayer.Character.HumanoidRootPart
function pathFind(pos)
    if not typeof(pos) == ("Vector3") then return end
    local path = pfs:CreatePath({});path:ComputeAsync(hrp.Position,pos)
    local pathfinding_fol = Instance.new("Folder",workspace)
    pathfinding_fol.Name = http:GenerateGUID(true)
    local antiseatfol = Instance.new("Folder",rs)
    antiseatfol.Name = http:GenerateGUID(true)
    spawn(function()
        if not _G.SeatsAvoided then
            for i, v in next, workspace:GetDescendants() do
                if v:IsA("Seat") then
                    v.Parent = antiseatfol
                end
            end
        end
    end)

    local wps = path:GetWaypoints()
    for i, wp in next, wps do
        local part = Instance.new("Part")
        part.Shape,part.Material,part.Size = "Ball",Enum.Material.Neon,Vector3.new(0.6, 0.6, 0.6)
        part.Position,part.Anchored,part.CanCollide = wp.Position + Vector3.new(0,1.6,0),true,false
        part.Parent,part.Transparency = pathfinding_fol,0.6
        if i == 1 then
            part.Size = Vector3.new(1.2,1.2,1.2)
            part.Color = Color3.new(0,1,0)
        elseif i == #wps then
            part.Size = Vector3.new(1.2,1.2,1.2)
            part.Color = Color3.new(1,0,0)
        end
    end
    for i, wp in next, wps do
        if wp.Action == Enum.PathWaypointAction.Jump then
            plrs.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
        plrs.LocalPlayer.Character.Humanoid:MoveTo(wp.Position)
        plrs.LocalPlayer.Character.Humanoid.MoveToFinished:Wait()
    end
    pathfinding_fol:Destroy()
    antiseatfol.Parent = workspace
    for i, v in next, workspace:GetChildren() do
        if v:IsA("Folder") and #v:GetChildren() == 0 then v:Destroy() end
    end
    return
end
function pathFindTable(table)
    if not typeof(table) == "table" then return end
    for i, v3 in next, table do pathFind(v3) end
    return
end
for i = 1,2 do
    pathfindTable({
        [1] = Vector3.new(-1011.2380981445, 17.99347114563, 8957.63671875),
        [2] = Vector3.new(-1009.1943359375, 17.99347114563, 8992.517578125),
        [3] = Vector3.new(-959.66491699219, 17.99347114563, 8991.5546875),
        [4] = Vector3.new(-958.37261962891, 17.99347114563, 8957.392578125)
    })
end
pathfindTable({
    [1] = Vector3.new(-1031.4885253906, 26.392995834351, 8985.8662109375),
    [2] = Vector3.new(-989.02899169922, 26.393482208252, 9015.9345703125)
})
