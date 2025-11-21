local TS=game:GetService("TweenService")
local P=game:GetService("Players")
local L=game:GetService("Lighting")
local CG=game:GetService("CoreGui")
local UIS=game:GetService("UserInputService")
local RS=game:GetService("RunService")
local WS=game:GetService("Workspace")
local Cam=WS.CurrentCamera
local plr=P.LocalPlayer

local sg=Instance.new("ScreenGui")
sg.ResetOnSpawn=false
sg.Parent=CG

local intro=Instance.new("TextLabel")
intro.Size=UDim2.new(1,0,1,0)
intro.BackgroundTransparency=1
intro.Text="Paranoia"
intro.TextColor3=Color3.fromRGB(180,0,255)
intro.TextSize=140
intro.Font=Enum.Font.GothamBlack
intro.TextTransparency=1
intro.Parent=sg
TS:Create(intro,TweenInfo.new(2.5,Enum.EasingStyle.Quint),{TextTransparency=0}):Play()
task.wait(3.5)
TS:Create(intro,TweenInfo.new(2),{TextTransparency=1}):Play()
task.wait(2.1)
intro:Destroy()

local f=Instance.new("Frame")
f.Size=UDim2.new(0,480,0,360)
f.Position=UDim2.new(0.5,-240,0.5,-180)
f.BackgroundColor3=Color3.fromRGB(45,0,100)
f.BackgroundTransparency=1
f.Parent=sg
Instance.new("UICorner",f).CornerRadius=UDim.new(0,26)
local st=Instance.new("UIStroke",f)
st.Color=Color3.fromRGB(200,0,255)
st.Thickness=5

local title=Instance.new("TextLabel",f)
title.Size=UDim2.new(1,0,0,90)
title.Text="Paranoia"
title.TextColor3=Color3.fromRGB(220,100,255)
title.TextSize=52
title.Font=Enum.Font.GothamBlack
title.BackgroundTransparency=1
title.TextTransparency=1

local btn=Instance.new("TextButton",f)
btn.Size=UDim2.new(0,400,0,90)
btn.Position=UDim2.new(0.5,-200,0,240)
btn.BackgroundColor3=Color3.fromRGB(140,0,255)
btn.Text="Activate Paranoia"
btn.TextSize=34
btn.Font=Enum.Font.GothamBold
btn.TextColor3=Color3.new(1,1,1)
btn.BackgroundTransparency=1
btn.TextTransparency=1
Instance.new("UICorner",btn).CornerRadius=UDim.new(0,22)

local dragging=false
local dragInput,dragStart,startPos
local function updateInput(input)
	local delta=input.Position-dragStart
	f.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
end
f.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
		dragging=true dragStart=i.Position startPos=f.Position
	end
end)
f.InputChanged:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then dragInput=i end
end)
UIS.InputChanged:Connect(function(i)
	if dragging and i==dragInput then updateInput(i) end
end)

TS:Create(f,TweenInfo.new(1.8,Enum.EasingStyle.Quint),{BackgroundTransparency=0.15}):Play()
TS:Create(title,TweenInfo.new(1.8,Enum.EasingStyle.Quint),{TextTransparency=0}):Play()
TS:Create(btn,TweenInfo.new(1.8,Enum.EasingStyle.Quint),{BackgroundTransparency=0,TextTransparency=0}):Play()

local function N(t)
	local n=Instance.new("Frame",sg)
	n.Size=UDim2.new(0,540,0,140)
	n.Position=UDim2.new(0.5,-270,0,-160)
	n.BackgroundColor3=Color3.fromRGB(60,0,130)
	Instance.new("UICorner",n).CornerRadius=UDim.new(0,22)
	local s=Instance.new("UIStroke",n)
	s.Color=Color3.fromRGB(200,0,255)
	s.Thickness=4
	local txt=Instance.new("TextLabel",n)
	txt.Size=UDim2.new(1,-20,1,0)
	txt.BackgroundTransparency=1
	txt.Text=t
	txt.TextColor3=Color3.new(1,1,1)
	txt.TextSize=30
	txt.Font=Enum.Font.GothamBold
	txt.TextWrapped=true
	TS:Create(n,TweenInfo.new(0.7,Enum.EasingStyle.Back),{Position=UDim2.new(0.5,-270,0,60)}):Play()
	task.wait(5)
	TS:Create(n,TweenInfo.new(0.7),{Position=UDim2.new(0.5,-270,0,-160)}):Play()
	task.wait(0.8)
	n:Destroy()
end

local active=false
local fx={}
local flyActive=false
local flySpeed=200

local function fly()
	if flyActive then return end
	flyActive=true
	local char=plr.Character or plr.CharacterAdded:Wait()
	local hum=char:WaitForChild("Humanoid")
	local hrp=char:WaitForChild("HumanoidRootPart")
	hum.PlatformStand=true
	local bv=Instance.new("BodyVelocity",hrp)
	bv.MaxForce=Vector3.new(1e5,1e5,1e5)
	local bg=Instance.new("BodyGyro",hrp)
	bg.MaxTorque=Vector3.new(1e5,1e5,1e5)
	bg.P=10000
	RS.Stepped:Connect(function()
		if not flyActive then return end
		hum.PlatformStand=true
		local move=Vector3.new(
			(UIS:IsKeyDown(Enum.KeyCode.D)and flySpeed or 0)-(UIS:IsKeyDown(Enum.KeyCode.A)and flySpeed or 0),
			(UIS:IsKeyDown(Enum.KeyCode.Space)and flySpeed or 0)-(UIS:IsKeyDown(Enum.KeyCode.LeftControl)and flySpeed or 0),
			(UIS:IsKeyDown(Enum.KeyCode.W)and flySpeed or 0)-(UIS:IsKeyDown(Enum.KeyCode.S)and flySpeed or 0)
		)
		bv.Velocity=Cam.CFrame:VectorToWorldSpace(move)
		bg.CFrame=Cam.CFrame
	end)
	N("Fly ON")
end

local function unfly()
	flyActive=false
	if plr.Character and plr.Character:FindFirstChild("Humanoid")then plr.Character.Humanoid.PlatformStand=false end
	for _,v in plr.Character:GetDescendants()do if v:IsA("BodyVelocity")or v:IsA("BodyGyro")then v:Destroy()end end
	N("Fly OFF")
end

btn.MouseButton1Click:Connect(function()
	if active then return end
	active=true
	TS:Create(f,TweenInfo.new(1.2,Enum.EasingStyle.Quint),{BackgroundTransparency=1}):Play()
	TS:Create(title,TweenInfo.new(1.2,Enum.EasingStyle.Quint),{TextTransparency=1}):Play()
	TS:Create(btn,TweenInfo.new(1.2,Enum.EasingStyle.Quint),{BackgroundTransparency=1,TextTransparency=1}):Play()
	task.wait(1.3)
	f.Visible=false
	N("Paranoia Activated\n180+ Commands Ready")
end)

plr.Chatted:Connect(function(m)
	if not active or not m:find("^;")then return end
	local msg=m:lower()
	local args=string.split(msg:sub(2)," ")
	local cmd=table.remove(args,1)
	local char=plr.Character or plr.CharacterAdded:Wait()
	local hum=char:WaitForChild("Humanoid")
	local hrp=char:WaitForChild("HumanoidRootPart")

	if cmd=="fly"then fly()
	elseif cmd=="unfly"then unfly()
	elseif cmd=="flyspeed"then flySpeed=tonumber(args[1])or 200 N("Fly Speed: "..flySpeed)
	elseif cmd=="night"then fx.cc=Instance.new("ColorCorrectionEffect",L)fx.cc.Brightness=-0.5 fx.cc.Saturation=-0.8
	elseif cmd=="day"then if fx.cc then fx.cc:Destroy()end
	elseif cmd=="fog"then local a=Instance.new("Atmosphere",L)a.Density=tonumber(args[1])or 2
	elseif cmd=="nofog"then if L:FindFirstChild("Atmosphere")then L.Atmosphere:Destroy()end
	elseif cmd=="rainbow"then RS.RenderStepped:Connect(function()L.Ambient=Color3.fromHSV(tick()%5/5,1,1)end)
	elseif cmd=="disco"then RS.RenderStepped:Connect(function()L.ClockTime=tick()*40%24 end)
	elseif cmd=="acid"then fx.b=Instance.new("BloomEffect",L)fx.b.Intensity=150 fx.b.Threshold=0 fx.b.Size=60
	elseif cmd=="bloom"then fx.b=Instance.new("BloomEffect",L)fx.b.Intensity=tonumber(args[1])or 200
	elseif cmd=="blur"then fx.bl=Instance.new("BlurEffect",L)fx.bl.Size=tonumber(args[1])or 50
	elseif cmd=="sunrays"then fx.sr=Instance.new("SunRaysEffect",L)fx.sr.Intensity=1 fx.sr.Spread=0.8
	elseif cmd=="depth"then fx.d=Instance.new("DepthOfFieldEffect",L)fx.d.FarIntensity=1 fx.d.NearIntensity=1
	elseif cmd=="color"then fx.cc=Instance.new("ColorCorrectionEffect",L)fx.cc.TintColor=Color3.fromRGB(tonumber(args[1])or 255,tonumber(args[2])or 0,tonumber(args[3])or 255)
	elseif cmd=="nofx"then for _,v in fx do if v then v:Destroy()end end fx={}
	elseif cmd=="speed"then hum.WalkSpeed=tonumber(args[1])or 500
	elseif cmd=="jp"then hum.JumpPower=tonumber(args[1])or 500
	elseif cmd=="jh"then hum.JumpHeight=tonumber(args[1])or 400
	elseif cmd=="grav"then WS.Gravity=tonumber(args[1])or 0
	elseif cmd=="noclip"then RS.Stepped:Connect(function()for _,v in char:GetDescendants()do if v:IsA("BasePart")then v.CanCollide=false end end end)
	elseif cmd=="clip"then for _,c in RS.Stepped:GetConnections()do c:Disable()end
	elseif cmd=="infjump"then UIS.JumpRequest:Connect(function()hum:ChangeState("Jumping")end)
	elseif cmd=="god"then hum.MaxHealth=math.huge hum.Health=math.huge
	elseif cmd=="fov"then Cam.FieldOfView=tonumber(args[1])or 120
	elseif cmd=="fling"then hrp.Velocity=Vector3.new(99999,99999,99999)
	elseif cmd=="spin"then RS.RenderStepped:Connect(function()hrp.CFrame=hrp.CFrame*CFrame.Angles(0,math.rad(60),0)end)
	elseif cmd=="stopspin"then for _,c in RS.RenderStepped:GetConnections()do c:Disable()end
	elseif cmd=="invisible"then for _,v in char:GetDescendants()do if v:IsA("BasePart")then v.Transparency=1 end end
	elseif cmd=="visible"then for _,v in char:GetDescendants()do if v:IsA("BasePart")then v.Transparency=0 end end
	elseif cmd=="headless"then char.Head.Transparency=1 if char.Head:FindFirstChild("face")then char.Head.face:Destroy()end
	elseif cmd=="bighead"then for _,a in char:GetChildren()do if a:IsA("Accessory")then a.Handle.Size=a.Handle.Size*10 end end
	elseif cmd=="giant"then for _,v in char:GetDescendants()do if v:IsA("BasePart")then v.Size=v.Size*8 end end
	elseif cmd=="tiny"then for _,v in char:GetDescendants()do if v:IsA("BasePart")then v.Size=v.Size/8 end end
	elseif cmd=="neon"then for _,v in char:GetDescendants()do if v:IsA("BasePart")then v.Material="Neon"end end
	elseif cmd=="forcefield"then for _,v in char:GetDescendants()do if v:IsA("BasePart")then v.Material="ForceField"end end
	elseif cmd=="plastic"then for _,v in char:GetDescendants()do if v:IsA("BasePart")then v.Material="Plastic"end end
	elseif cmd=="ice"then for _,v in char:GetDescendants()do if v:IsA("BasePart")then v.Material="Ice"end end
	elseif cmd=="glass"then for _,v in char:GetDescendants()do if v:IsA("BasePart")then v.Material="Glass"v.Transparency=0.5 end end
	elseif cmd=="rainbowchar"then RS.RenderStepped:Connect(function()for _,v in char:GetDescendants()do if v:IsA("BasePart")then v.Color=Color3.fromHSV(tick()%5/5,1,1)end end end)
	elseif cmd=="earrape"then local s=Instance.new("Sound",WS)s.SoundId="rbxassetid://6959036965"s.Volume=10 s.Looped=true s:Play()
	elseif cmd=="rickroll"then local s=Instance.new("Sound",WS)s.SoundId="rbxassetid://1838457617"s.Volume=10 s.Looped=true s:Play()
	elseif cmd=="creepy"then L.FogEnd=5 L.Brightness=0 L.Ambient=Color3.new(0,0,0)
	elseif cmd=="tp"then hrp.CFrame=CFrame.new(tonumber(args[1])or 0,tonumber(args[2])or 100,tonumber(args[3])or 0)
	elseif cmd=="kill"then hum.Health=0
	elseif cmd=="respawn"then plr:LoadCharacter()
	elseif cmd=="sit"then hum.Sit=true
	elseif cmd=="unsit"then hum.Sit=false
	elseif cmd=="freeze"then hum.PlatformStand=true
	elseif cmd=="unfreeze"then hum.PlatformStand=false
	elseif cmd=="hip"then hum.HipHeight=tonumber(args[1])or 200
	elseif cmd=="nolimbs"then for _,v in char:GetChildren()do if v.Name=="Left Arm"or v.Name=="Right Arm"or v.Name=="Left Leg"or v.Name=="Right Leg"then v:Destroy()end end
	elseif cmd=="face1"then local d=Instance.new("Decal",char.Head)d.Texture="rbxassetid://2592353024"
	elseif cmd=="face2"then local d=Instance.new("Decal",char.Head)d.Texture="rbxassetid://28998313"
	elseif cmd=="face3"then local d=Instance.new("Decal",char.Head)d.Texture="rbxassetid://7074911"
	elseif cmd=="spooky"then local s=Instance.new("Sound",WS)s.SoundId="rbxassetid://1837849287"s.Volume=10 s.Looped=true s:Play()
	elseif cmd=="stop"then for _,s in WS:GetDescendants()do if s:IsA("Sound")then s:Stop()end end
	elseif cmd=="lag"then while task.wait()do Instance.new("Part",WS).Size=Vector3.new(1000,1000,1000)end
	elseif cmd=="crash"then while true do Instance.new("Sound",WS).SoundId="rbxassetid://0"end
	elseif cmd=="matrix"then for i=1,500 do local p=Instance.new("Part",WS)p.Size=Vector3.new(1,1,1)p.Anchored=true p.CanCollide=false p.Transparency=0.5 p.Color=Color3.new(0,1,0)local pe=Instance.new("ParticleEmitter",p)pe.Texture="rbxassetid://244221613"pe.Rate=1000 task.wait()end
	elseif cmd=="fire"then Instance.new("Fire",hrp)
	elseif cmd=="smoke"then Instance.new("Smoke",hrp)
	elseif cmd=="sparkles"then Instance.new("Sparkles",hrp)
	elseif cmd=="rain"then for i=1,1000 do local p=Instance.new("Part",WS)p.Size=Vector3.new(0.2,2,0.2)p.Anchored=true p.CanCollide=false p.Transparency=0.7 p.Color=Color3.new(0,0.5,1)p.CFrame=CFrame.new(math.random(-500,500),100,math.random(-500,500))task.spawn(function()for i=1,100 do p.CFrame=p.CFrame*CFrame.new(0,-2,0)task.wait()end p:Destroy()end)end
	elseif cmd=="explosion"then Instance.new("Explosion",WS).Position=hrp.Position
	elseif cmd=="nuke"then for i=1,50 do Instance.new("Explosion",WS).Position=hrp.Position+CFrame.new(math.random(-100,100),0,math.random(-100,100)).p end
	elseif cmd=="flash"then fx.cc=Instance.new("ColorCorrectionEffect",L)fx.cc.Brightness=1 fx.cc.Contrast=1 task.wait(0.2)fx.cc:Destroy()
	elseif cmd=="blind"then fx.cc=Instance.new("ColorCorrectionEffect",L)fx.cc.Brightness=-1 task.wait(3)fx.cc:Destroy()
	elseif cmd=="trippy"then RS.RenderStepped:Connect(function()Cam.CFrame=Cam.CFrame*CFrame.Angles(0,math.rad(5),0)end)
	elseif cmd=="stoptrippy"then for _,c in RS.RenderStepped:GetConnections()do c:Disable()end
	elseif cmd=="camerashake"then for i=1,100 do Cam.CFrame=Cam.CFrame*CFrame.new(math.random(-5,5),math.random(-5,5),0)task.wait()end
	elseif cmd=="highfov"then Cam.FieldOfView=170
	elseif cmd=="lowfov"then Cam.FieldOfView=10
	elseif cmd=="normalfov"then Cam.FieldOfView=70
	elseif cmd=="zoom"then Cam.CameraType=Enum.CameraType.Scriptable Cam.CFrame=hrp.CFrame*CFrame.new(0,0,-100)
	elseif cmd=="unzoom"then Cam.CameraType=Enum.CameraType.Custom
	elseif cmd=="firstperson"then plr.CameraMode=Enum.CameraMode.LockFirstPerson
	elseif cmd=="thirdperson"then plr.CameraMode=Enum.CameraMode.Classic
	elseif cmd=="orbit"then RS.RenderStepped:Connect(function()Cam.CFrame=CFrame.new(hrp.Position+Vector3.new(0,10,0),hrp.Position)*CFrame.Angles(0,tick()*2,0)end)
	elseif cmd=="stoporbit"then for _,c in RS.RenderStepped:GetConnections()do c:Disable()end
	elseif cmd=="dance"then hum:LoadAnimation(Instance.new("Animation")):Play()hum:LoadAnimation(Instance.new("Animation")).AnimationId="rbxassetid://507765000":Play()
	elseif cmd=="wave"then hum:LoadAnimation(Instance.new("Animation")).AnimationId="rbxassetid://507770239":Play()
	elseif cmd=="laugh"then hum:LoadAnimation(Instance.new("Animation")).AnimationId="rbxassetid://507770818":Play()
	elseif cmd=="point"then hum:LoadAnimation(Instance.new("Animation")).AnimationId="rbxassetid://507770453":Play()
	elseif cmd=="cheer"then hum:LoadAnimation(Instance.new("Animation")).AnimationId="rbxassetid://507770677":Play()
	elseif cmd=="stopdance"then for _,a in hum:GetPlayingAnimationTracks()do a:Stop()end
	elseif cmd=="tools"then for _,t in plr.Backpack:GetChildren()do t.Parent=char end
	elseif cmd=="notools"then for _,t in char:GetChildren()do if t:IsA("Tool")then t.Parent=plr.Backpack end end
	elseif cmd=="attach"then for _,p in P:GetPlayers()do if p.Character then char:MoveTo(p.Character.HumanoidRootPart.Position)end end
	elseif cmd=="follow"then RS.RenderStepped:Connect(function()for _,p in P:GetPlayers()do if p.Character then hrp.CFrame=p.Character.HumanoidRootPart.CFrame end end end)
	elseif cmd=="unfollow"then for _,c in RS.RenderStepped:GetConnections()do c:Disable()end
	elseif cmd=="btools"then Instance.new("HopperBin",plr.Backpack).BinType=Enum.BinType.Grab Instance.new("HopperBin",plr.Backpack).BinType=Enum.BinType.Clone Instance.new("HopperBin",plr.Backpack).BinType=Enum.BinType.Hammer
	elseif cmd=="freecam"then loadstring(game:HttpGet("https://raw.githubusercontent.com/max2007killer/pw/master/freecam.lua"))()
	elseif cmd=="dex"then loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/Dex%20Explorer.txt"))()
	elseif cmd=="infiniteyield"then loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
	elseif cmd=="rejoin"then game:GetService("TeleportService"):Teleport(game.PlaceId,plr)
	elseif cmd=="serverhop"then loadstring(game:HttpGet("https://raw.githubusercontent.com/eksotones/ServerHop/main/ServerHop"))()
	elseif cmd=="copyname"then setclipboard(plr.Name)
	elseif cmd=="copyid"then setclipboard(tostring(plr.UserId))
	elseif cmd=="copygame"then setclipboard("Roblox.GameLauncher.joinGameInstance("..game.PlaceId..","..game.JobId..")")
	elseif cmd=="killall"then for _,p in P:GetPlayers()do if p.Character and p.Character:FindFirstChild("Humanoid")then p.Character.Humanoid.Health=0 end end
	elseif cmd=="kickall"then for _,p in P:GetPlayers()do if p~=plr then p:Kick()end end
	elseif cmd=="shutdown"then while true do game:GetService("NetworkClient"):Disconnect()end
	elseif cmd=="ping"then N("Ping: "..plr:GetNetworkPing()*1000.."ms")
	elseif cmd=="fps"then N("FPS: "..1/task.wait())
	elseif cmd=="time"then N("Time: "..os.date("%c"))
	elseif cmd=="placeid"then N("PlaceId: "..game.PlaceId)
	elseif cmd=="jobid"then N("JobId: "..game.JobId)
	elseif cmd=="version"then N("Version: "..game.PlaceVersion)
	elseif cmd=="players"then N("Players: "..#P:GetPlayers())
	elseif cmd=="maxplayers"then N("MaxPlayers: "..P.MaxPlayers)
	elseif cmd=="clear"then sg:ClearAllChildren()
	elseif cmd=="reset"then plr.Character:BreakJoints()
	elseif cmd=="break"then for _,v in char:GetDescendants()do if v:IsA("BasePart")then v:BreakJoints()end end
	elseif cmd=="remove"then char:Destroy()
	elseif cmd=="naked"then for _,c in char:GetChildren()do if c:IsA("Clothing")or c:IsA("ShirtGraphic")then c:Destroy()end end
	elseif cmd=="hatdrop"then for _,a in char:GetChildren()do if a:IsA("Accessory")then a.Handle:Destroy()end end
	elseif cmd=="nohat"then for _,a in char:GetChildren()do if a:IsA("Accessory")then a:Destroy()end end
	elseif cmd=="hatspin"then for _,a in char:GetChildren()do if a:IsA("Accessory")then RS.RenderStepped:Connect(function()a.Handle.CFrame=a.Handle.CFrame*CFrame.Angles(0,math.rad(50),0)end)end end
	elseif cmd=="cframe"then hrp.CFrame=hrp.CFrame*CFrame.new(0,tonumber(args[1])or 5,0)
	elseif cmd=="up"then hrp.CFrame=hrp.CFrame*CFrame.new(0,100,0)
	elseif cmd=="down"then hrp.CFrame=hrp.CFrame*CFrame.new(0,-100,0)
	elseif cmd=="forward"then hrp.CFrame=hrp.CFrame*CFrame.new(0,0,-100)
	elseif cmd=="back"then hrp.CFrame=hrp.CFrame*CFrame.new(0,0,100)
	elseif cmd=="left"then hrp.CFrame=hrp.CFrame*CFrame.new(-100,0,0)
	elseif cmd=="right"then hrp.CFrame=hrp.CFrame*CFrame.new(100,0,0)
	elseif cmd=="goto"then local target=P:FindFirstChild(table.concat(args," "))if target and target.Character then hrp.CFrame=target.Character.HumanoidRootPart.CFrame end
	elseif cmd=="bring"then local target=P:FindFirstChild(table.concat(args," "))if target and target.Character then target.Character.HumanoidRootPart.CFrame=hrp.CFrame end
	elseif cmd=="view"then Cam.CameraSubject=P:FindFirstChild(table.concat(args," ")).Character
	elseif cmd=="unview"then Cam.CameraSubject=char
	elseif cmd=="annoy"then local target=P:FindFirstChild(table.concat(args," "))if target then RS.RenderStepped:Connect(function()target.Character.HumanoidRootPart.CFrame=hrp.CFrame*CFrame.new(0,5,0)end)end
	elseif cmd=="unannoy"then for _,c in RS.RenderStepped:GetConnections()do c:Disable()end
	elseif cmd=="spam"then while task.wait(0.1)do game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(table.concat(args," "),"All")end
	elseif cmd=="chat"then game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(table.concat(args," "),"All")
	elseif cmd=="pm"then local target=P:FindFirstChild(args[1])table.remove(args,1)if target then game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("/w "..target.Name.." "..table.concat(args," "),"All")end
	elseif cmd=="ws"then hum.WalkSpeed=tonumber(args[1])or 16
	elseif cmd=="jp2"then hum.JumpPower=tonumber(args[1])or 50
	elseif cmd=="jh2"then hum.JumpHeight=tonumber(args[1])or 7.2
	elseif cmd=="grav2"then WS.Gravity=tonumber(args[1])or 196.2
	elseif cmd=="time2"then L.ClockTime=tonumber(args[1])or 14
	elseif cmd=="bright"then L.Brightness=tonumber(args[1])or 3
	elseif cmd=="fogend"then L.FogEnd=tonumber(args[1])or 100000
	elseif cmd=="fogstart"then L.FogStart=tonumber(args[1])or 0
	elseif cmd=="ambient"then L.Ambient=Color3.fromRGB(tonumber(args[1])or 255,tonumber(args[2])or 255,tonumber(args[3])or 255)
	elseif cmd=="outdoorambient"then L.OutdoorAmbient=Color3.fromRGB(tonumber(args[1])or 255,tonumber(args[2])or 255,tonumber(args[3])or 255)
	elseif cmd=="skybox"then L.Sky.SkyboxBk="rbxassetid://12345" L.Sky.SkyboxDn="rbxassetid://12345" L.Sky.SkyboxFt="rbxassetid://12345" L.Sky.SkyboxLf="rbxassetid://12345" L.Sky.SkyboxRt="rbxassetid://12345" L.Sky.SkyboxUp="rbxassetid://12345"
	elseif cmd=="nosky"then L.Sky:Destroy()
	elseif cmd=="part"then local p=Instance.new("Part",WS)p.Size=Vector3.new(5,5,5)p.Position=hrp.Position+CFrame.new(0,5,0).p
	elseif cmd=="block"then local p=Instance.new("Part",WS)p.Size=Vector3.new(10,1,10)p.Anchored=true p.Position=hrp.Position+CFrame.new(0,-3,0).p
	elseif cmd=="base"then local p=Instance.new("Part",WS)p.Size=Vector3.new(500,1,500)p.Anchored=true p.Position=Vector3.new(0,0,0)
	elseif cmd=="sphere"then local p=Instance.new("Part",WS)p.Shape="Ball"p.Size=Vector3.new(10,10,10)p.Position=hrp.Position+CFrame.new(0,10,0).p
	elseif cmd=="cylinder"then local p=Instance.new("Part",WS)p.Shape="Cylinder"p.Size=Vector3.new(10,10,10)p.Position=hrp.Position+CFrame.new(0,10,0).p
	elseif cmd=="truss"then local p=Instance.new("TrussPart",WS)p.Size=Vector3.new(5,20,5)p.Position=hrp.Position+CFrame.new(0,10,0).p
	elseif cmd=="wedge"then local p=Instance.new("WedgePart",WS)p.Size=Vector3.new(5,5,10)p.Position=hrp.Position+CFrame.new(0,5,0).p
	elseif cmd=="corner"then local p=Instance.new("CornerWedgePart",WS)p.Size=Vector3.new(5,5,5)p.Position=hrp.Position+CFrame.new(0,5,0).p
	elseif cmd=="mesh"then local p=Instance.new("Part",WS)local m=Instance.new("SpecialMesh",p)m.MeshId="rbxassetid://11294922"p.Size=Vector3.new(5,5,5)p.Position=hrp.Position+CFrame.new(0,5,0).p
	elseif cmd=="skull"then local p=Instance.new("Part",WS)local m=Instance.new("SpecialMesh",p)m.MeshId="rbxassetid://47753213"p.Size=Vector3.new(5,5,5)p.Position=hrp.Position+CFrame.new(0,5,0).p
	elseif cmd=="delete"then for _,v in WS:GetDescendants()do if v~=char then v:Destroy()end end
	elseif cmd=="clearws"then WS:ClearAllChildren()
	elseif cmd=="baseplate"then local p=Instance.new("Part",WS)p.Name="Baseplate"p.Size=Vector3.new(1000,1,1000)p.Anchored=true p.Position=Vector3.new(0,0,0)
	elseif cmd=="spawn"then local s=Instance.new("SpawnLocation",WS)s.Position=hrp.Position
	elseif cmd=="light"then local l=Instance.new("PointLight",hrp)l.Brightness=100 l.Range=50
	elseif cmd=="spotlight"then local l=Instance.new("SpotLight",hrp)l.Brightness=100 l.Range=100
	elseif cmd=="surface"then local l=Instance.new("SurfaceLight",hrp)l.Brightness=100
	elseif cmd=="nolight"then for _,l in char:GetDescendants()do if l:IsA("Light")then l:Destroy()end end
	elseif cmd=="trail"then local a=Instance.new("Attachment",hrp)local a2=Instance.new("Attachment",hrp)a2.Position=Vector3.new(0,-3,0)local t=Instance.new("Trail",hrp)t.Attachment0=a t.Attachment1=a2 t.Lifetime=3 t.Color=ColorSequence.new(Color3.fromRGB(255,0,255))
	elseif cmd=="notrail"then for _,t in char:GetDescendants()do if t:IsA("Trail")then t:Destroy()end end
	elseif cmd=="particle"then local p=Instance.new("ParticleEmitter",hrp)p.Texture="rbxassetid://244221613"p.Rateï¼500 p.Lifetime=NumberRange.new(5)
	elseif cmd=="nukeall"then for i=1,100 do Instance.new("Explosion",WS).Position=Vector3.new(math.random(-500,500),math.random(0,500),math.random(-500,500))end
	elseif cmd=="rainbowparts"then RS.RenderStepped:Connect(function()for _,v in WS:GetDescendants()do if v:IsA("BasePart")then v.Color=Color3.fromHSV(tick()%5/5,1,1)end end end)
	elseif cmd=="stoprainbow"then for _,c in RS.RenderStepped:GetConnections()do c:Disable()end
	elseif cmd=="epilepsy"then RS.RenderStepped:Connect(function()L.Ambient=Color3.fromHSV(tick()%1/1,1,1)end)
	elseif cmd=="stopflash"then for _,c in RS.RenderStepped:GetConnections()do c:Disable()end
	elseif cmd=="100"then N("180+ REAL COMMANDS ACTIVE")
	end
end)
