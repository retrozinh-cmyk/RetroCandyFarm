local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local TweenService=game:GetService("TweenService")
local PathfindingService=game:GetService("PathfindingService")
local HttpService=game:GetService("HttpService")
local TeleportService=game:GetService("TeleportService")
local UserInputService=game:GetService("UserInputService")
local LP=Players.LocalPlayer
local PGui=LP:WaitForChild("PlayerGui")
local VIM,VU
pcall(function() VIM=game:GetService("VirtualInputManager") end)
pcall(function() VU=game:GetService("VirtualUser") end)
local ENV=(getgenv and getgenv()) or _G
local function pickFn(...)
for _,n in next,{...} do
local ok,f=pcall(function() return ENV[n] or (shared and shared[n]) or _G[n] end)
if ok and type(f)=="function" then return f end
end
end
local function nestedFn(root,name)
local ok,t=pcall(function() return ENV[root] or _G[root] end)
if ok and type(t)=="table" and type(t[name])=="function" then return t[name] end
end
local EXE={
fireprompt=pickFn("fireproximityprompt","FireProximityPrompt","fireProximityPrompt","fire_proximity_prompt"),
firesignal=pickFn("firesignal","fire_signal","FireSignal"),
getconns=pickFn("getconnections","get_signal_cons","getsignalcons","GetConnections","getconnection"),
clipboard=pickFn("setclipboard","toclipboard","write_clipboard","WriteClipboard","Clipboard_Set","set_clipboard","Setclipboard"),
http=pickFn("request","http_request","syn_request","fluxus_request") or nestedFn("syn","request") or nestedFn("http","request"),
protectgui=pickFn("protectgui","protect_gui") or nestedFn("syn","protect_gui"),
}
local idfn=pickFn("identifyexecutor","getexecutorname","get_executor_name")
EXE.Name="Unknown"
if idfn then pcall(function() EXE.Name=tostring(idfn()) end) end
local exeLower=string.lower(EXE.Name)
EXE.Delta=exeLower:find("delta",1,true)~=nil
EXE.Solara=exeLower:find("solara",1,true)~=nil
EXE.Xeno=exeLower:find("xeno",1,true)~=nil
EXE.Capabilities={
 fireprompt=type(EXE.fireprompt)=="function",firesignal=type(EXE.firesignal)=="function",
 getconnections=type(EXE.getconns)=="function",http=type(EXE.http)=="function",
 protectgui=type(EXE.protectgui)=="function",vim=VIM~=nil,vu=VU~=nil
}
local GUI_PARENT=PGui
local gethuiFn=pickFn("gethui","get_hidden_gui","gethuiinstance")
pcall(function()
if gethuiFn then local h=gethuiFn();if h then GUI_PARENT=h end end
if GUI_PARENT==PGui then
local cg=game:GetService("CoreGui")
local test=Instance.new("Folder");test.Name="JJS_DeltaProbe";test.Parent=cg;test:Destroy();GUI_PARENT=cg
end
end)
pcall(function()
local parents={PGui}
if GUI_PARENT and GUI_PARENT~=PGui then parents[#parents+1]=GUI_PARENT end
for _,parent in ipairs(parents) do
for _,c in ipairs(parent:GetChildren()) do if c.Name:find("^JJS_") then c:Destroy() end end
end
for _,n in ipairs({"JJS_ESP","JJS_Nodes","JJS_SafePlatform","JJS_Trajectory","JJS_SmallObs"}) do
local o=workspace:FindFirstChild(n); if o then o:Destroy() end
end
end)
local ESP_F=Instance.new("Folder");ESP_F.Name="JJS_ESP";ESP_F.Parent=workspace
local NODE_F=Instance.new("Folder");NODE_F.Name="JJS_Nodes";NODE_F.Parent=workspace
local TRAJ_F=Instance.new("Folder");TRAJ_F.Name="JJS_Trajectory";TRAJ_F.Parent=workspace
local OBS_F=Instance.new("Folder");OBS_F.Name="JJS_SmallObs";OBS_F.Parent=workspace
pcall(function() LP:SetAttribute("JJS_User", true) end)
local Cfg={
AntiAFK=false,AntiAFKInterval=55,
AutoFarm=false,SafeMode=false,WaitTimer=true,
DoorESP=true,BlatantMode=false,IgnoreDoorWithPlayers=false,
ShowTrajectory=false,PlayerESP=false,ItemESP=true,SafeIdlePoint=false,
PlayerESPName=true,PlayerESPDistance=true,PlayerESPHighlight=true,
DoorESPName=true,DoorESPDistance=true,DoorESPHighlight=true,
ItemESPName=true,ItemESPDistance=true,ItemESPHighlight=true,
RouteDebugger=true,ItemAutoRefresh=true,LowLag=false,CompactMinimize=true,AutoGuiScale=true,GuiScaleMin=0.50,GuiScaleMaxMobile=0.72,
BlatantAutoForward=true,
BlatantHeight=100,BlatantForward=5,BlatantForwardStep=5,
BlatantStepDelay=0.02,BlatantSpeed=100,
BlatantLongRouteChunk=180,BlatantRouteFailBeforeRecede=2,BlatantRouteRecede=14,
BlatantStageTimeout=12,BlatantProgressTimeout=3.0,BlatantMaxSegmentFails=3,BlatantMinProgress=1.25,
BlatantRecoverySide=16,BlatantRecoveryBack=12,BlatantSegmentCheckInterval=0.14,
BlatantExtraHeightStep=35,BlatantMaxHeightTries=8,
BlatantSkyObstacleRadius=14,BlatantSkyRetreat=12,BlatantSkyDrop=22,BlatantSkyAvoidTries=6,
BlatantCeilingEscape=true,BlatantCeilingSearchRadius=96,BlatantCeilingSearchStep=12,BlatantCeilingProbeRadius=3,BlatantCeilingClearance=8,
BlatantUnexpectedShift=32,BlatantBackwardShift=18,
BlatantDescentSearchRadius=72,BlatantDescentStep=12,BlatantDescentClearance=4,BlatantRouteCommit=true,
SmoothGroundReturn=true,SmoothGroundCurveForward=8,SmoothGroundCurveUp=5,SmoothGroundMidLift=3,
DynamicObstacleCheck=true,ObstacleCheckInterval=0.18,SafeRecheckDelay=0.8,
Full3DPath=true,AirPathRadius=2.4,AirPathPadding=4,AirPathMaxNodes=20,AirPathMaxDetours=9,AirGroundThreshold=12,
LineSafeCacheTTL=0.07,LineSafeCacheMax=220,
SafeClearance=4,SafeAscentStep=12,SafeSearchRadius=56,SafeMaxRoutes=20,CandyCooldown=3,
WalkSpeed=80,AgentRadius=4,AgentHeight=5,YOffset=3,ReachDist=1,
DoorStandoff=3,DoorSkipTime=5,DoorRefreshInterval=0.40,
DoorSlowdown=true,DoorSlowdownDistance=50,DoorSlowdownMinSpeed=28,DoorSlowdownCurve=1.35,
WaypointSpacing=8,MoveTimeout=3,
PathCacheDuration=0.75,PathCacheMoveTolerance=4,
PathLookAhead=10,PathLookAhead3D=12,PathMinSkipDistance=2.5,
PathRecalculateOnlyWhenBlocked=true,
StuckWindow=1.2,StuckMinDist=2.5,StuckMaxRetries=6,
DoorRetryCooldown=4,DoorDoubleCheckRadius=15,
ItemRetryCooldown=4,ItemDoubleCheckRadius=10,
CooldownRadius=5,CooldownSuccess=3,
DoorPlayerCheckRadius=15,WaitTimerRadius=10,
InteractTimeout=12,InteractRetryDelay=0.12,WaitTimerMaxSeconds=60,
SafePoint=Vector3.new(1219,159,515),
SafePlatformHeight=500,SafePlatformSize=Vector3.new(30,2,30),
SafePlatformPos=nil,SafeClimbDuration=4.0,SafeModeCheckInterval=0.5,
PlayerESPMaxDistance=500,ItemESPMaxDistance=9999,ItemMaxDistance=10000,ItemLongRouteChunk=180,ESPUpdateInterval=0.25,TrajectoryMaxPoints=8,
AntiFalseDoor=true,FalseDoorFails=3,FalseDoorTimeout=8,
SmartOrbit=true,OrbitRadius=6,OrbitSpeed=360,
OrbitMaxTime=45,SmartCooldown=4,ResumeDelay=0.4,
SkeletonDoorRadius=20,
AntiSkeleton=true,SkeletonRadius=500,
SkeletonNames={"skeleton","esqueleto"},
PumpkinMinigame=false,PumpkinPartNames={"pumpkim","pumpkin"},
PumpkinCheckInterval=0.25,PumpkinOrbitRadius=3,
PumpkinOrbitTimeout=30,PumpkinPathfindReach=50,PumpkinPathfindTimeout=20,
PumpkinTeleportOnReach=true,PumpkinOrbitAfterTeleport=true,
PumpkinAutoCombat=false,PumpkinM1Interval=0.16,PumpkinSkillRetry=0.70,
PumpkinEscapeAfterCollect=true,PumpkinEscapeDistance=550,PumpkinEscapeSpeed=135,PumpkinEscapeStages=3,PumpkinEscapeJitter=75,
SafePlatformAwayFromPlayers=false,SafePlatformAwayDistance=450,
AntiCandyScape=false,CandyScapeRadius=50,CandyScapeTime=3,
ItemsReturnBack=false,ItemsTraceMinDist=3,ItemNearPickupRadius=22,
ItemBlatant=false,ItemBlatantSpeed=180,ItemBringDistance=4.5,ItemBringAttempts=3,
ItemFull3D=true,Item3DRetries=5,Item3DTopClearance=4,Item3DMaxLift=18,Item3DForwardNudge=3,
FenceTraversal=true,FenceMinHeight=6,FenceMaxHeight=42,FenceThinSize=5,FenceTopClearance=6,FenceSideClearance=6,
ItemMaxAttempts=8,
Item3DFast=true,Item3DFastDistance=250,Item3DChunk=210,Item3DQuickNodes=16,Item3DQuickDetours=6,
PathTravelMode="Ground",PathTravelY=5,TweenTimeLapse=1.0,
LockedDoorCheckInterval=0.15,LockedDoorMaxDrift=15,
AvoidSmallParts=true,
SmallPartMaxSize=6,SmallPartMaxHeight=3,
SmallPartDetectRadius=25,SmallPartDetectMinArea=0.5,
SmallPartPadding=4,
RouteScoring=true,RouteCandidateCount=8,RouteOpenClearance=7,RouteOpenPenalty=9,RouteTurnPenalty=0.045,RouteVerticalPenalty=0.28,RouteTightAgentPenalty=6,RouteScoreSamples=14,
SmartRouteRetries=5,SmartRouteRetryDelay=0.06,
DoorRouteRetries=4,DoorInteractPerRoute=3.0,DoorOpenCheckDelay=0.18,
RouteScoreBlockedPenalty=60,RouteScoreSmallObsPenalty=10,
RouteScoreLengthPenalty=0.05,RouteScoreWaypointPenalty=1,
RouteScoreDetourPenalty=2,
HeightAwarePath=true,HeightProbeUp=10,HeightProbeDown=12,
HeightStep=2.5,HeightMaxAdjust=10,HeightClearance=2.5,
HeightSmallPartMaxSize=7,HeightSmallPartMaxY=5,HeightCheckRadius=5,
HeightRouteFailSwitch=2,
AntiFalseDoorRadius=150,
AntiFalseDoorRetry=5,
ServerHopPages=3,ServerHopMinPlayers=0,ServerHopMaxPlayers=12,ServerHopAutoCrowded=false,ServerHopCrowdedAbove=18,ServerHopReexec=false,
RuntimeTick=0.02,PhysicsParamsTTL=0.22,DoorDeepScanInterval=5,ItemPanelRefreshFallback=2.0,
RouteLoopTimeout=7.5,RouteLoopReturnRadius=12,RouteLoopMinProgress=14,RouteLoopCooldown=1.2,
SimpleRouteWaypointSpacing=14,SimpleRouteMaxAttempts=2,
OverlapMaxParts=32,ItemMaxPathCycles=22,
}
local State={
deviceProfile="PC",mobileLite=false,
threads={},flags={Farm=false,Blatant=false,Pumpkin=false},
doors={list={},last=0,lastDeep=0,lastBlatantDeep=0,skip={},flip={},fails={},recent={}},
esp={},dead=false,activeTween=nil,trajRefs={},cooldowns={},
pathCache={t=0},conns={},falseDoors={},skel={list={}},
afdActive=false,asActive=false,afdRun=0,asRun=0,
hooks={},api={},
smart={active=false,nextAllowed=0,resume={}},
pumpkin={active=false,run=0,hasPumpkin=false,combat={lastM1=0,skillLast={},moveset=nil,movesetAt=0}},
items={selected={},panel=nil,trace={},recent={},running=false,cancel=false,runId=0,runOriginCF=nil},
candy={active=false},
lastHRPTime=0,cachedHRP=nil,lastESPDraw=0,lastPrune=0,
safePlatform=nil,safeModeActive=false,allDoorsDone=false,
promptLast={},
safeModeAtPlatform=false,safeModeClimbing=false,
panelsHidden=false,
lockedDoor=nil,
smallParts={list={},last=0,refreshInterval=0.7},
lineCache={data={},count=0},
physicsCache={ray=nil,rayAt=0,overlap=nil,overlapAt=0,char=nil,safePlatform=nil},
doorMeta={},
control={state="Idle",history={},route={target=nil,waypoint=nil,reason="Idle",stuck=nil},queue={},favorites={},search="",retryQueue={},panel=nil,historyLabel=nil,routeLabel=nil,queueLabel=nil,stateLabel=nil,compact=nil},
}
local function inMapRange(_)
return true
end
local function objectPos(obj)
if not obj then return nil end
if obj:IsA("BasePart") then return obj.Position end
if obj:IsA("Model") then
local ok,p=pcall(function() return obj:GetPivot().Position end)
if ok then return p end
local bp=obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart",true)
return bp and bp.Position or nil
end
return nil
end
-- Compatibility hardening: some obfuscators/executors can lose optional nested tables.
State.api=type(State.api)=="table" and State.api or {}
State.control=type(State.control)=="table" and State.control or {}
State.control.history=type(State.control.history)=="table" and State.control.history or {}
State.control.route=type(State.control.route)=="table" and State.control.route or {target=nil,waypoint=nil,reason="Idle",stuck=nil}
State.control.queue=type(State.control.queue)=="table" and State.control.queue or {}
State.control.favorites=type(State.control.favorites)=="table" and State.control.favorites or {}
State.control.retryQueue=type(State.control.retryQueue)=="table" and State.control.retryQueue or {}
State.items=type(State.items)=="table" and State.items or {selected={},trace={},recent={},running=false,cancel=false,runId=0}
State.pathCache=type(State.pathCache)=="table" and State.pathCache or {t=0}
local GUI={}
local TITLE_BASE="🎃 JJS v12.02 Route Watchdog"
local function getHRP()
local now=os.clock()
if now-State.lastHRPTime<1/60 then
local c=State.cachedHRP
if c and c.Parent then return c end
end
local ch=LP.Character
local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
State.cachedHRP=hrp;State.lastHRPTime=now
return hrp
end
local function getHum()
local ch=LP.Character
return ch and ch:FindFirstChildOfClass("Humanoid")
end
local function standHeight()
local hum,hrp=getHum(),getHRP()
if hum and hrp then
local h=hrp.Size.Y/2
if hum.RigType==Enum.HumanoidRigType.R15 then h=h+hum.HipHeight else h=h+2 end
if h>=2 and h<=8 then return h+0.1 end
end
return Cfg.YOffset
end
local function bindClick(btn,fn)
local last=0
local function h()
local n=os.clock()
if n-last<0.3 then return end
last=n;pcall(fn)
end
btn.MouseButton1Click:Connect(h)
btn.InputBegan:Connect(function(i)
if i.UserInputType==Enum.UserInputType.Touch then
local sp=i.Position
local conn
conn=i.Changed:Connect(function()
if i.UserInputState==Enum.UserInputState.End then
conn:Disconnect()
if (i.Position-sp).Magnitude<12 then h() end
end
end)
end
end)
end
local function makeDraggable(frame,handle)
handle=handle or frame
local dragging,dragStart,startPos
local function update(input)
local d=input.Position-dragStart
frame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
end
handle.InputBegan:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
dragging=true;dragStart=input.Position;startPos=frame.Position
input.Changed:Connect(function()
if input.UserInputState==Enum.UserInputState.End then dragging=false end
end)
end
end)
handle.InputChanged:Connect(function(input)
if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
update(input)
end
end)
end
local function stopThread(key)
State.flags[key]=false
if State.threads[key] then pcall(task.cancel,State.threads[key]);State.threads[key]=nil end
end
local function coolPos(pos,duration)
State.cooldowns[pos]={t=os.clock()+duration,r=Cfg.CooldownRadius}
end
local function coolSuccess(pos) coolPos(pos,Cfg.CooldownSuccess) end
local function isCooling(pos)
for p,c in pairs(State.cooldowns) do
if c.t<os.clock() then State.cooldowns[p]=nil
elseif (p-pos).Magnitude<=c.r then return true end
end
return false
end
local function mobileViewport()
local cam=workspace.CurrentCamera
local vp=cam and cam.ViewportSize or Vector2.new(1280,720)
local mobile=UserInputService.TouchEnabled and (vp.X<1000 or vp.Y<700)
return mobile,vp
end
local function responsivePanel(frame,desktopSize,desktopPos,mobileHeight)
local function apply()
if not frame or not frame.Parent then return end
local mobile,vp=mobileViewport()
local oldScale=frame:FindFirstChild("JJS_AutoScale")
if oldScale then oldScale:Destroy() end
if mobile then
local baseW=desktopSize.X.Offset>0 and desktopSize.X.Offset or 300
local baseH=desktopSize.Y.Offset>0 and desktopSize.Y.Offset or (mobileHeight or 500)
local w=math.min(baseW,math.max(250,vp.X-18))
local h=math.min(baseH,math.max(300,vp.Y-64))
frame.Size=UDim2.fromOffset(w,h)
frame.AnchorPoint=Vector2.new(.5,.5)
frame.Position=UDim2.new(.5,0,.5,0)
else
frame.AnchorPoint=Vector2.zero
frame.Size=desktopSize
frame.Position=desktopPos
end
end
apply()
local cam=workspace.CurrentCamera
if cam then
local key="guiResp_"..tostring(frame.Name)
if State.conns[key] then pcall(function() State.conns[key]:Disconnect() end) end
State.conns[key]=cam:GetPropertyChangedSignal("ViewportSize"):Connect(function() pcall(apply) end)
end
end
local function history(msg)
msg=tostring(msg or "")
State.control=type(State.control)=="table" and State.control or {}
local h=type(State.control.history)=="table" and State.control.history or {}
State.control.history=h
table.insert(h,1,os.date("%H:%M:%S").."  "..msg)
while #h>8 do table.remove(h) end
local label=State.control.historyLabel
if label and label.Parent then pcall(function() label.Text=table.concat(h,"\n") end) end
end
State.api=type(State.api)=="table" and State.api or {}
State.api.pushHistory=history
State.api=type(State.api)=="table" and State.api or {}
function State.api.setState(name)
State.control.state=tostring(name or "Idle")
if State.control.stateLabel and State.control.stateLabel.Parent then State.control.stateLabel.Text="STATE: "..State.control.state end
if State.control.compact and State.control.compact.Parent then State.control.compact.Text="🎃  "..State.control.state.."  •  "..(GUI.Status and GUI.Status.Text or "") end
end
State.api=type(State.api)=="table" and State.api or {}
function State.api.routeDebug(target,waypoint,reason,stuck)
if State.mobileLite and not Cfg.RouteDebugger then return end
local r=State.control.route
if target~=nil then r.target=target end
if waypoint~=nil then r.waypoint=waypoint end
if reason~=nil then r.reason=tostring(reason) end
if stuck~=nil then r.stuck=stuck end
local function f(v)
if typeof(v)=="Vector3" then return ("%.0f, %.0f, %.0f"):format(v.X,v.Y,v.Z) end
return tostring(v or "-")
end
if State.control.routeLabel and State.control.routeLabel.Parent then
State.control.routeLabel.Text=("ROUTE\nTarget: %s\nWaypoint: %s\nReason: %s\nStuck: %s"):format(f(r.target),f(r.waypoint),r.reason or "-",f(r.stuck))
end
end
State.api=type(State.api)=="table" and State.api or {}
function State.api.queueSet(item,status,attempt)
local key=typeof(item)=="Instance" and item or tostring(item)
State.control.queue[key]={name=typeof(item)=="Instance" and item.Name or tostring(item),status=status or "Waiting",attempt=attempt or 0}
local lines={}
for _,q in pairs(State.control.queue) do lines[#lines+1]=(q.name.."  •  "..q.status..(q.attempt>0 and (" #"..q.attempt) or "")) end
table.sort(lines)
if #lines==0 then lines[1]="Queue empty" end
if State.control.queueLabel and State.control.queueLabel.Parent then State.control.queueLabel.Text=table.concat(lines,"\n") end
end
State.api=type(State.api)=="table" and State.api or {}
function State.api.queueClear()
State.control.queue={}
if State.control.queueLabel and State.control.queueLabel.Parent then State.control.queueLabel.Text="Queue empty" end
end
State.api=type(State.api)=="table" and State.api or {}
function State.api.applyProfile(name)
name=tostring(name or "Normal")
if name=="Fast" then
Cfg.WalkSpeed=110;Cfg.BlatantSpeed=220;Cfg.BlatantHeight=100;Cfg.ESPUpdateInterval=.3;Cfg.ShowTrajectory=false;Cfg.LowLag=false
elseif name=="Mobile" then
Cfg.WalkSpeed=75;Cfg.BlatantSpeed=120;Cfg.ESPUpdateInterval=.45;Cfg.ShowTrajectory=false;Cfg.LowLag=true
elseif name=="Low Lag" then
Cfg.WalkSpeed=80;Cfg.ESPUpdateInterval=.8;Cfg.ShowTrajectory=false;Cfg.LowLag=true;Cfg.DynamicObstacleCheck=true
else
Cfg.WalkSpeed=80;Cfg.BlatantSpeed=100;Cfg.BlatantHeight=100;Cfg.ESPUpdateInterval=.25;Cfg.LowLag=false
end
history("Profile: "..name)
GUI.setStatus("Profile applied: "..name)
end

function State.api.antiAFKPulse()
if State.dead or not Cfg.AntiAFK then return false end

-- Preferred cross-platform method supported by many executors.
if VU then
local ok=pcall(function()
VU:CaptureController()
VU:ClickButton2(Vector2.new(0,0),workspace.CurrentCamera and workspace.CurrentCamera.CFrame or CFrame.new())
end)
if ok then return true end
end

-- Keyboard-event fallback for executors that expose VirtualInputManager.
if VIM then
local ok=pcall(function()
VIM:SendKeyEvent(true,Enum.KeyCode.LeftShift,false,game)
RunService.Heartbeat:Wait()
VIM:SendKeyEvent(false,Enum.KeyCode.LeftShift,false,game)
end)
if ok then return true end
end

return false
end

function State.api.stopAntiAFK()
Cfg.AntiAFK=false
if State.conns.AntiAFKIdle then
pcall(function() State.conns.AntiAFKIdle:Disconnect() end)
State.conns.AntiAFKIdle=nil
end
if State.threads.AntiAFK then
pcall(task.cancel,State.threads.AntiAFK)
State.threads.AntiAFK=nil
end
end

function State.api.startAntiAFK()
-- Clean previous handlers without leaving AntiAFK disabled.
if State.conns.AntiAFKIdle then
pcall(function() State.conns.AntiAFKIdle:Disconnect() end)
State.conns.AntiAFKIdle=nil
end
if State.threads.AntiAFK then
pcall(task.cancel,State.threads.AntiAFK)
State.threads.AntiAFK=nil
end

Cfg.AntiAFK=true
State.conns.AntiAFKIdle=LP.Idled:Connect(function()
if Cfg.AntiAFK and not State.dead then
task.defer(State.api.antiAFKPulse)
end
end)

-- Backup pulse. This does not run every frame and has negligible cost.
State.threads.AntiAFK=task.spawn(function()
while Cfg.AntiAFK and not State.dead do
task.wait(math.clamp(Cfg.AntiAFKInterval or 55,25,90))
if not Cfg.AntiAFK or State.dead then break end
State.api.antiAFKPulse()
end
end)
end

local function buildUI()
local Gui=Instance.new("ScreenGui")
Gui.Name="JJS_v1184";Gui.ResetOnSpawn=false
Gui.DisplayOrder=99999;Gui.IgnoreGuiInset=true
pcall(function() Gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling end)
local parentOK=pcall(function() Gui.Parent=GUI_PARENT or PGui end)
if not parentOK or not Gui.Parent then pcall(function() Gui.Parent=PGui end) end
if EXE.protectgui then pcall(function() EXE.protectgui(Gui) end) end
local Main=Instance.new("Frame",Gui)
responsivePanel(Main,UDim2.new(0,250,0,400),UDim2.new(0,80,0.15,0),State.mobileLite and 440 or 520)
Main.BackgroundColor3=Color3.fromRGB(18,10,25);Main.BorderSizePixel=0;Main.Active=true
Instance.new("UICorner",Main).CornerRadius=UDim.new(0,10)
local MS=Instance.new("UIStroke",Main);MS.Color=Color3.fromRGB(230,90,0);MS.Thickness=2
local Title=Instance.new("TextLabel",Main)
Title.Size=UDim2.new(1,-12,0,36);Title.Position=UDim2.new(0,12,0,0)
Title.BackgroundTransparency=1;Title.Text=TITLE_BASE.." • "..(State.deviceProfile or "PC")
Title.TextColor3=Color3.fromRGB(255,140,0);Title.Font=Enum.Font.SourceSansBold
Title.TextSize=15;Title.TextXAlignment=Enum.TextXAlignment.Left
local Body=Instance.new("Frame",Main)
Body.Size=UDim2.new(1,0,1,-36);Body.Position=UDim2.new(0,0,0,36)
Body.BackgroundTransparency=1;Body.ClipsDescendants=true
local Status=Instance.new("TextLabel",Body)
Status.Size=UDim2.new(1,-20,0,34);Status.Position=UDim2.new(0,10,0,4)
Status.BackgroundTransparency=1;Status.Text="Idle"
Status.TextColor3=Color3.fromRGB(200,200,200);Status.Font=Enum.Font.SourceSans
Status.TextSize=11;Status.TextXAlignment=Enum.TextXAlignment.Left
Status.TextYAlignment=Enum.TextYAlignment.Top;Status.TextWrapped=true
local List=Instance.new("ScrollingFrame",Body)
List.Size=UDim2.new(1,0,1,-44);List.Position=UDim2.new(0,0,0,44)
List.BackgroundTransparency=1;List.BorderSizePixel=0;List.ClipsDescendants=true
List.ScrollingEnabled=true;List.ScrollingDirection=Enum.ScrollingDirection.Y
List.CanvasSize=UDim2.new(0,0,0,0);List.ScrollBarThickness=6
List.ScrollBarImageColor3=Color3.fromRGB(230,90,0);List.ElasticBehavior=Enum.ElasticBehavior.Never
local Credit=Instance.new("TextLabel",Main)
Credit.Name="MadeByRetro";Credit.Size=UDim2.new(1,0,0,20);Credit.Position=UDim2.new(0,0,1,4)
Credit.BackgroundTransparency=1;Credit.Text="Made By Retro"
Credit.TextColor3=Color3.fromRGB(175,175,175);Credit.Font=Enum.Font.SourceSansSemibold;Credit.TextSize=11
Credit.TextXAlignment=Enum.TextXAlignment.Center;Credit.ZIndex=2
local CfgPanel=Instance.new("Frame",Gui)
responsivePanel(CfgPanel,UDim2.new(0,300,0,460),UDim2.new(0,340,0.10,0),560)
CfgPanel.BackgroundColor3=Color3.fromRGB(18,10,25);CfgPanel.BorderSizePixel=0
CfgPanel.Active=true;CfgPanel.Visible=false
Instance.new("UICorner",CfgPanel).CornerRadius=UDim.new(0,10)
local MS2=Instance.new("UIStroke",CfgPanel);MS2.Color=Color3.fromRGB(145,70,200);MS2.Thickness=2
local CfgTitle=Instance.new("TextLabel",CfgPanel)
CfgTitle.Size=UDim2.new(1,-50,0,36);CfgTitle.Position=UDim2.new(0,12,0,0)
CfgTitle.BackgroundTransparency=1;CfgTitle.Text="⚙ Config"
CfgTitle.TextColor3=Color3.fromRGB(215,155,255);CfgTitle.Font=Enum.Font.SourceSansBold
CfgTitle.TextSize=15;CfgTitle.TextXAlignment=Enum.TextXAlignment.Left
local CloseCfg=Instance.new("TextButton",CfgPanel)
CloseCfg.Size=UDim2.new(0,28,0,28);CloseCfg.Position=UDim2.new(1,-34,0,4)
CloseCfg.BackgroundColor3=Color3.fromRGB(150,40,40);CloseCfg.Text="✕"
CloseCfg.TextColor3=Color3.fromRGB(255,255,255);CloseCfg.Font=Enum.Font.SourceSansBold
CloseCfg.TextSize=14;CloseCfg.ZIndex=3
Instance.new("UICorner",CloseCfg).CornerRadius=UDim.new(0,6)
local CfgList=Instance.new("ScrollingFrame",CfgPanel)
CfgList.Size=UDim2.new(1,0,1,-36);CfgList.Position=UDim2.new(0,0,0,36)
CfgList.BackgroundTransparency=1;CfgList.BorderSizePixel=0;CfgList.ClipsDescendants=true
CfgList.ScrollingEnabled=true;CfgList.ScrollingDirection=Enum.ScrollingDirection.Y
CfgList.CanvasSize=UDim2.new(0,0,0,0);CfgList.ScrollBarThickness=6
CfgList.ScrollBarImageColor3=Color3.fromRGB(145,70,200);CfgList.ElasticBehavior=Enum.ElasticBehavior.Never
local FloatBtn=Instance.new("TextButton",Gui)
FloatBtn.Size=UDim2.new(0,52,0,52);FloatBtn.Position=UDim2.new(0,10,0,10)
FloatBtn.BackgroundColor3=Color3.fromRGB(230,110,20)
FloatBtn.Text="🎃";FloatBtn.TextColor3=Color3.fromRGB(255,255,255)
FloatBtn.Font=Enum.Font.SourceSansBold;FloatBtn.TextSize=28
FloatBtn.BorderSizePixel=0;FloatBtn.ZIndex=50;FloatBtn.AutoButtonColor=false
Instance.new("UICorner",FloatBtn).CornerRadius=UDim.new(1,0)
local floatStroke=Instance.new("UIStroke",FloatBtn)
floatStroke.Color=Color3.fromRGB(255,180,60);floatStroke.Thickness=2
makeDraggable(FloatBtn,FloatBtn)
makeDraggable(Main,Title);makeDraggable(CfgPanel,CfgTitle)
bindClick(CloseCfg,function() CfgPanel.Visible=false end)
local Compact=Instance.new("TextButton",Gui)
Compact.Name="CompactStatus";Compact.Size=UDim2.fromOffset(330,34);Compact.AnchorPoint=Vector2.new(.5,0)
Compact.Position=UDim2.new(.5,0,0,10);Compact.BackgroundColor3=Color3.fromRGB(18,18,22);Compact.TextColor3=Color3.fromRGB(255,170,70)
Compact.Font=Enum.Font.SourceSansBold;Compact.TextSize=12;Compact.Text="🎃  Idle";Compact.Visible=false;Compact.ZIndex=60
Instance.new("UICorner",Compact).CornerRadius=UDim.new(0,8)
bindClick(Compact,function() State.panelsHidden=false;Main.Visible=true;Compact.Visible=false end)
State.control.compact=Compact
return {Gui=Gui,Main=Main,Body=Body,Status=Status,List=List,Title=Title,
CfgPanel=CfgPanel,CfgList=CfgList,FloatBtn=FloatBtn,Compact=Compact,
setStatus=function(txt) Status.Text=txt;if State.control.compact and State.control.compact.Parent then State.control.compact.Text="🎃  "..State.control.state.."  •  "..tostring(txt) end end}
end
local function makeToggle(parent,label,y,init,fn)
local b=Instance.new("TextButton",parent)
b.Size=UDim2.new(1,-20,0,(UserInputService.TouchEnabled and 36 or 30));b.Position=UDim2.new(0,10,0,y)
b.BackgroundColor3=Color3.fromRGB(42,25,49);b.Text="";b.AutoButtonColor=true;b.ZIndex=2
Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
local dot=Instance.new("TextLabel",b)
dot.Size=UDim2.new(0,20,1,0);dot.Position=UDim2.new(0,6,0,0)
dot.BackgroundTransparency=1;dot.Font=Enum.Font.SourceSansBold;dot.TextSize=15;dot.ZIndex=3
local lbl=Instance.new("TextLabel",b)
lbl.Size=UDim2.new(1,-30,1,0);lbl.Position=UDim2.new(0,26,0,0)
lbl.BackgroundTransparency=1;lbl.TextColor3=Color3.fromRGB(255,255,255)
lbl.Font=Enum.Font.SourceSansSemibold;lbl.TextSize=12
lbl.TextXAlignment=Enum.TextXAlignment.Left;lbl.ZIndex=3
local on=init
local function render()
if on then
dot.Text="●";dot.TextColor3=Color3.fromRGB(90,255,90)
lbl.Text=label..": ON";b.BackgroundColor3=Color3.fromRGB(180,70,0)
else
dot.Text="○";dot.TextColor3=Color3.fromRGB(160,160,160)
lbl.Text=label..": OFF";b.BackgroundColor3=Color3.fromRGB(42,25,49)
end
end
local function set(v,silent)
if on==v then return end
on=v;render()
if not silent then pcall(fn,on) end
end
bindClick(b,function() set(not on) end);render()
return b,set
end
local function makeButton(parent,text,y,color,fn)
local b=Instance.new("TextButton",parent)
b.Size=UDim2.new(1,-20,0,(UserInputService.TouchEnabled and 36 or 30));b.Position=UDim2.new(0,10,0,y)
b.BackgroundColor3=color;b.Text=text;b.TextColor3=Color3.fromRGB(255,255,255)
b.Font=Enum.Font.SourceSansSemibold;b.TextSize=12;b.AutoButtonColor=true;b.ZIndex=2
Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
bindClick(b,fn)
return b
end
local function makeHalfButtons(parent,y,textA,colorA,fnA,textB,colorB,fnB)
local a=Instance.new("TextButton",parent)
a.Size=UDim2.new(0.5,-15,0,(UserInputService.TouchEnabled and 36 or 30));a.Position=UDim2.new(0,10,0,y)
a.BackgroundColor3=colorA;a.Text=textA;a.TextColor3=Color3.fromRGB(255,255,255)
a.Font=Enum.Font.SourceSansSemibold;a.TextSize=12;a.AutoButtonColor=true;a.ZIndex=2
Instance.new("UICorner",a).CornerRadius=UDim.new(0,6)
bindClick(a,fnA)
local b=Instance.new("TextButton",parent)
b.Size=UDim2.new(0.5,-15,0,(UserInputService.TouchEnabled and 36 or 30));b.Position=UDim2.new(0.5,5,0,y)
b.BackgroundColor3=colorB;b.Text=textB;b.TextColor3=Color3.fromRGB(255,255,255)
b.Font=Enum.Font.SourceSansSemibold;b.TextSize=12;b.AutoButtonColor=true;b.ZIndex=2
Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
bindClick(b,fnB)
end
local function makeCategory(parent,text,y)
local f=Instance.new("Frame",parent)
f.Size=UDim2.new(1,-20,0,22);f.Position=UDim2.new(0,10,0,y)
f.BackgroundColor3=Color3.fromRGB(45,24,58);f.BorderSizePixel=0
Instance.new("UICorner",f).CornerRadius=UDim.new(0,5)
local l=Instance.new("TextLabel",f)
l.Size=UDim2.new(1,-10,1,0);l.Position=UDim2.new(0,8,0,0)
l.BackgroundTransparency=1;l.Text=text;l.TextColor3=Color3.fromRGB(120,180,255)
l.Font=Enum.Font.SourceSansBold;l.TextSize=12;l.TextXAlignment=Enum.TextXAlignment.Left
return y+26
end
local function makeTextBox(parent,label,init,y,onChange)
local c=Instance.new("Frame",parent)
c.Size=UDim2.new(1,-20,0,28);c.Position=UDim2.new(0,10,0,y)
c.BackgroundTransparency=1;c.ZIndex=2
local lbl=Instance.new("TextLabel",c)
lbl.Size=UDim2.new(0.55,0,1,0);lbl.BackgroundTransparency=1;lbl.Text=label
lbl.TextColor3=Color3.fromRGB(210,210,210);lbl.Font=Enum.Font.SourceSansSemibold
lbl.TextSize=11;lbl.TextXAlignment=Enum.TextXAlignment.Left;lbl.ZIndex=2
local box=Instance.new("TextBox",c)
box.Size=UDim2.new(0.42,0,0.85,0);box.Position=UDim2.new(0.56,0,0.08,0)
box.BackgroundColor3=Color3.fromRGB(42,25,49);box.Text=tostring(init)
box.TextColor3=Color3.fromRGB(255,255,255);box.Font=Enum.Font.SourceSansBold
box.TextSize=12;box.ClearTextOnFocus=false;box.ZIndex=2
Instance.new("UICorner",box).CornerRadius=UDim.new(0,5)
local current=init
box.FocusLost:Connect(function()
local n=tonumber(box.Text)
if n then current=n;pcall(onChange,n) else box.Text=tostring(current) end
end)
return box
end
local function clearTrajectory()
for _,v in ipairs(State.trajRefs) do if v and v.Parent then v:Destroy() end end
State.trajRefs={}
for _,c in ipairs(TRAJ_F:GetChildren()) do c:Destroy() end
end
local function showTrajectory(points,color)
clearTrajectory()
if not points or #points<2 then return end
local maxP=Cfg.TrajectoryMaxPoints
local step=math.max(1,math.ceil(#points/maxP))
local pointColor=color or Color3.fromRGB(255,140,0)
local lineColor=Color3.fromRGB(255,180,50)
for i=1,#points,step do
local pos=points[i]
local p=Instance.new("Part")
p.Name="TrajPoint_"..i;p.Shape=Enum.PartType.Ball
p.Size=Vector3.new(0.6,0.6,0.6);p.Anchored=true
p.CanCollide=false;p.CanQuery=false;p.CanTouch=false
p.Material=Enum.Material.Neon;p.Color=pointColor
p.Transparency=0.25;p.CFrame=CFrame.new(pos);p.Parent=TRAJ_F
State.trajRefs[#State.trajRefs+1]=p
end
for i=1,#points-1,step do
local a,b=points[i],points[math.min(i+step,#points)]
local mid=(a+b)/2
local dist=(b-a).Magnitude
if dist>0.5 then
local line=Instance.new("Part")
line.Name="TrajLine";line.Size=Vector3.new(0.15,0.15,dist)
line.Anchored=true;line.CanCollide=false;line.CanQuery=false
line.Material=Enum.Material.Neon;line.Color=lineColor
line.Transparency=0.4;line.CFrame=CFrame.lookAt(mid,b);line.Parent=TRAJ_F
State.trajRefs[#State.trajRefs+1]=line
end
end
end
local function looksLikeDoorTimer(lbl)
if not lbl or not lbl:IsA("TextLabel") then return false end
local text=tostring(lbl.Text or "")
local low=string.lower(text)
local name=string.lower(lbl.Name or "")
if name:find("timer",1,true) or name:find("time",1,true) or name:find("count",1,true) then return true end
if text:match("^%s*%d+:%d+%s*$") then return true end
if text:match("^%s*%d+%.?%d*%s*s%s*$") then return true end
if low:find("open",1,true) or low:find("ready",1,true) or low:find("unlock",1,true) then return true end
return false
end
local function doorTimer(m)
if not m then return "0:00" end
local meta=State.doorMeta[m]
if not meta then meta={};State.doorMeta[m]=meta end
local lbl=meta.timerLabel
if lbl and lbl.Parent and lbl:IsDescendantOf(m) and looksLikeDoorTimer(lbl) then
return lbl.Text
end
local best=nil
for _,d in ipairs(m:GetDescendants()) do
if looksLikeDoorTimer(d) then
best=d
if tostring(d.Text or ""):match("^%s*%d+:%d+%s*$") then break end
end
end
if best then
meta.timerLabel=best
return best.Text
end
-- No real timer label found: do not reject a valid HalloweenDoor because of
-- an unrelated text label such as a title/name.
return "0:00"
end
local function timerZero(s)
local c=string.lower(tostring(s or ""):gsub("%s+",""))
if c=="" or c=="0" or c=="0:00" or c=="00:00" or c=="0.0" or c=="0s" then return true end
if c:find("open",1,true) or c:find("ready",1,true) or c:find("unlock",1,true) then return true end
local n=tonumber(c:gsub("s$",""))
return n~=nil and n<=0
end
local function getDoorPart(dm)
if not dm then return nil end
local meta=State.doorMeta[dm]
if not meta then meta={};State.doorMeta[dm]=meta end
local cached=meta.part
if cached and cached.Parent and cached:IsDescendantOf(dm) then return cached end
local part=dm:FindFirstChild("Union",true) or (dm:IsA("Model") and (dm.PrimaryPart or dm:FindFirstChildWhichIsA("BasePart",true))) or (dm:IsA("BasePart") and dm) or nil
meta.part=part
return part
end
function State.api.getBlatantDoorAnchor(d)
if not d or not d.Model then return d and d.Part or nil end
local model=d.Model
local meta=State.doorMeta[model]
if not meta then meta={};State.doorMeta[model]=meta end

local cached=meta.blatantAnchor
if cached and cached.Parent and cached:IsA("BasePart") and cached:IsDescendantOf(model) then
return cached
end

-- HalloweenDoor's Union is the authoritative orientation for Blatant.
local union=model:FindFirstChild("Union",true)
if union and union:IsA("BasePart") then
meta.blatantAnchor=union
return union
end

-- Fallback for maps where the union/pumpkin has a different object name.
for _,obj in ipairs(model:GetDescendants()) do
local n=string.lower(obj.Name)
if (n:find("pumpkim",1,true) or n:find("pumpkin",1,true)) then
if obj:IsA("BasePart") then
meta.blatantAnchor=obj
return obj
elseif obj:IsA("Model") then
local bp=obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart",true)
if bp then
meta.blatantAnchor=bp
return bp
end
end
end
end

meta.blatantAnchor=d.Part or getDoorPart(model)
return meta.blatantAnchor
end

function State.api.blatantDoorCandidates(d)
local anchor=State.api.getBlatantDoorAnchor(d)
if not anchor or not anchor.Parent then return {} end

local baseLook=Vector3.new(anchor.CFrame.LookVector.X,0,anchor.CFrame.LookVector.Z)
if baseLook.Magnitude<.05 then baseLook=Vector3.new(0,0,-1) else baseLook=baseLook.Unit end

local halfDepth=math.max(.05,anchor.Size.Z*.5)
local standDist=Cfg.DoorStandoff or 3
local list={}

for _,sign in ipairs({1,-1}) do
local look=baseLook*sign
local face=anchor.Position+look*halfDepth
local raw=face+look*standDist

local probe=Vector3.new(raw.X,math.max(raw.Y,anchor.Position.Y+anchor.Size.Y*.5)+12,raw.Z)
local hit=workspace:Raycast(probe,Vector3.new(0,-360,0),makeRayParams())
local y=hit and (hit.Position.Y+standHeight()) or raw.Y
local target=Vector3.new(raw.X,y,raw.Z)

list[#list+1]={
Anchor=anchor,
Look=look,
Face=face,
Target=target,
StandDistance=standDist,
Side=sign,
}
end

local hrp=getHRP()
if hrp then
table.sort(list,function(a,b)
local da=(a.Target-hrp.Position).Magnitude
local db=(b.Target-hrp.Position).Magnitude
local ha=State.api.blatantDoorHeadroom and State.api.blatantDoorHeadroom(d,a.Target)
local hb=State.api.blatantDoorHeadroom and State.api.blatantDoorHeadroom(d,b.Target)
if ha~=hb then return ha end
return da<db
end)
end
return list
end

function State.api.blatantDoorGeometry(d)
if d and d._BlatantGeo and d._BlatantGeo.Anchor and d._BlatantGeo.Anchor.Parent then
return d._BlatantGeo
end
local list=State.api.blatantDoorCandidates(d)
if #list==0 then return nil end
if d then d._BlatantGeo=list[1] end
return list[1]
end

local function prune()
local now=os.clock()
if now-State.lastPrune<0.5 then return end
State.lastPrune=now
for m,t in pairs(State.doors.skip) do if t<now or not m or not m.Parent then State.doors.skip[m]=nil end end
for m in pairs(State.doors.flip) do if not m or not m.Parent then State.doors.flip[m]=nil end end
for m in pairs(State.falseDoors) do if not m or not m.Parent then State.falseDoors[m]=nil end end
for m in pairs(State.doors.fails) do if not m or not m.Parent then State.doors.fails[m]=nil end end
for m,t in pairs(State.doors.recent) do if t<now or not m or not m.Parent then State.doors.recent[m]=nil end end
for m,t in pairs(State.items.recent) do if t<now or not m or not m.Parent then State.items.recent[m]=nil end end
for m in pairs(State.doorMeta) do if not m or not m.Parent then State.doorMeta[m]=nil end end
for p,c in pairs(State.cooldowns) do if c.t<now then State.cooldowns[p]=nil end end
end
local function refreshDoors(forceDeep)
State.doors.list={}
local seen={}
local function addDoor(dm)
if not dm or seen[dm] then return end
if State.afdActive and State.falseDoors[dm] then return end
seen[dm]=true
local tp=getDoorPart(dm)
if tp and tp.Position.Y>-100 and inMapRange(tp.Position) then
State.doors.list[#State.doors.list+1]={Model=dm,Part=tp}
end
end
local function tryAdd(obj)
if obj.Name=="HalloweenDoor" then addDoor(obj)
else
local c=obj:FindFirstChild("HalloweenDoor")
if c then addDoor(c) end
end
end
for _,obj in ipairs(workspace:GetChildren()) do tryAdd(obj) end
local ef=workspace:FindFirstChild("Effects")
if ef then for _,obj in ipairs(ef:GetChildren()) do tryAdd(obj) end end
if forceDeep or (#State.doors.list==0 and (os.clock()-State.doors.lastDeep>(Cfg.DoorDeepScanInterval or 5))) then
State.doors.lastDeep=os.clock()
local scanRoots={workspace:FindFirstChild("Map"),workspace:FindFirstChild("Effects"),workspace:FindFirstChild("Characters")}
for _,root in ipairs(scanRoots) do
if root then
for _,obj in ipairs(root:GetDescendants()) do
if obj.Name=="HalloweenDoor" then addDoor(obj) end
end
end
end
if forceDeep then
for _,obj in ipairs(workspace:GetDescendants()) do
if obj.Name=="HalloweenDoor" then addDoor(obj) end
end
end
end
end
local function playerNearPart(part,radius)
if not Cfg.IgnoreDoorWithPlayers then return false end
radius=radius or Cfg.DoorPlayerCheckRadius
if not part then return false end
for _,p in ipairs(Players:GetPlayers()) do
if p~=LP then
local oh=p.Character and p.Character:FindFirstChild("HumanoidRootPart")
if oh and (oh.Position-part.Position).Magnitude<=radius then return true end
end
end
return false
end
local function playerWithinRadius(pos,radius)
if not pos then return false end
for _,p in ipairs(Players:GetPlayers()) do
if p~=LP then
local oh=p.Character and p.Character:FindFirstChild("HumanoidRootPart")
if oh and (oh.Position-pos).Magnitude<=radius then return true end
end
end
return false
end
local function updateWaitCircle(part,show)
if show and part then
local c=State.esp.WaitCircle
if not c or not c.Parent then
c=Instance.new("Part")
c.Name="JJS_WaitCircle";c.Shape=Enum.PartType.Cylinder
c.Material=Enum.Material.Neon;c.Color=Color3.fromRGB(255,0,0)
c.Transparency=0.55;c.Anchored=true;c.CanCollide=false
c.CanQuery=false;c.CanTouch=false;c.Parent=ESP_F
State.esp.WaitCircle=c
end
local r=Cfg.WaitTimerRadius
c.Size=Vector3.new(0.2,r*2,r*2)
local groundY=part.Position.Y-(part.Size.Y/2)+0.05
c.CFrame=CFrame.new(part.Position.X,groundY,part.Position.Z)*CFrame.Angles(0,0,math.rad(90))
else
if State.esp.WaitCircle then State.esp.WaitCircle:Destroy();State.esp.WaitCircle=nil end
end
end
local function skeletonNear(pos,r)
if not State.asActive or not r or r<=0 then return false end
for _,sk in ipairs(State.skel.list) do
if sk.Root and sk.Root.Parent and (sk.Root.Position-pos).Magnitude<=r then return true end
end
return false
end
local function maybeRefreshDoors()
prune()
if (os.clock()-State.doors.last>Cfg.DoorRefreshInterval) then
refreshDoors();State.doors.last=os.clock()
end
end
local function nearestDoor()
maybeRefreshDoors()
local hrp=getHRP();if not hrp then return nil end
local now=os.clock()
local bestEmpty,bdEmpty=nil,math.huge
local bestAny,bdAny=nil,math.huge
for _,d in ipairs(State.doors.list) do
local recentT=State.doors.recent[d.Model]
local recentlyTried=recentT and recentT>now
if d.Part and d.Part.Parent and not State.doors.skip[d.Model] and not isCooling(d.Part.Position) and not skeletonNear(d.Part.Position,Cfg.SkeletonDoorRadius) and not recentlyTried then
if playerNearPart(d.Part,Cfg.DoorPlayerCheckRadius) then
State.doors.skip[d.Model]=os.clock()+Cfg.DoorSkipTime
continue
end
local t=doorTimer(d.Model)
if timerZero(t) then
local dist=(d.Part.Position-hrp.Position).Magnitude
local hasPlayer=playerNearPart(d.Part)
local entry={Model=d.Model,Part=d.Part,Distance=math.floor(dist),Timer=t,HasPlayer=hasPlayer}
if dist<bdAny then bdAny=dist;bestAny=entry end
if not hasPlayer and dist<bdEmpty then bdEmpty=dist;bestEmpty=entry end
end
end
end
if Cfg.IgnoreDoorWithPlayers then return bestEmpty end
return bestAny
end

local function nearestBlatantDoor()
local d=nearestDoor()
if d then return d end

local now=os.clock()
if now-(State.doors.lastBlatantDeep or 0)>=0.75 then
State.doors.lastBlatantDeep=now
refreshDoors(true)
State.doors.last=now
prune()
end

local hrp=getHRP()
if not hrp then return nil end
local best,bestDist=nil,math.huge

for _,entry in ipairs(State.doors.list) do
local model,part=entry.Model,entry.Part
if model and model.Parent and part and part.Parent and not (State.afdActive and State.falseDoors[model]) then
local skipT=State.doors.skip[model]
local recentT=State.doors.recent[model]
local blocked=(skipT and skipT>now) or (recentT and recentT>now) or isCooling(part.Position)
if not blocked then
local t=doorTimer(model)
if timerZero(t) then
local dist=(part.Position-hrp.Position).Magnitude
if dist<bestDist then
bestDist=dist
best={Model=model,Part=part,Distance=math.floor(dist),Timer=t,HasPlayer=playerNearPart(part,Cfg.DoorPlayerCheckRadius)}
end
end
end
end
end

if not best and #State.doors.list>0 then
-- Stale retry cooldowns should never make Blatant look permanently blind.
for _,entry in ipairs(State.doors.list) do
local model,part=entry.Model,entry.Part
if model and model.Parent and part and part.Parent and timerZero(doorTimer(model)) and not (State.afdActive and State.falseDoors[model]) then
local dist=(part.Position-hrp.Position).Magnitude
if dist<bestDist then
bestDist=dist
best={Model=model,Part=part,Distance=math.floor(dist),Timer=doorTimer(model),HasPlayer=false}
end
end
end
end
return best
end
local function allDoors() maybeRefreshDoors();return State.doors.list end
local function countReadyDoors()
maybeRefreshDoors()
local n=0
for _,d in ipairs(State.doors.list) do
if d.Part and d.Part.Parent and not State.doors.skip[d.Model] and not isCooling(d.Part.Position) and not playerNearPart(d.Part,Cfg.DoorPlayerCheckRadius) and timerZero(doorTimer(d.Model)) then n=n+1 end
end
return n
end
local function espNearestDoor()
maybeRefreshDoors()
local hrp=getHRP();if not hrp then return nil end
local best,bd=nil,math.huge
for _,d in ipairs(State.doors.list) do
if d.Part and d.Part.Parent then
local dist=(d.Part.Position-hrp.Position).Magnitude
if dist<bd then bd=dist;best={Model=d.Model,Part=d.Part,Distance=math.floor(dist)} end
end
end
return best
end
local function doorNormal(part)
local s,cf=part.Size,part.CFrame
local axis
if s.X<=s.Y and s.X<=s.Z then axis=cf.RightVector
elseif s.Z<=s.X and s.Z<=s.Y then axis=cf.LookVector
else axis=cf.LookVector end
local flat=Vector3.new(axis.X,0,axis.Z)
if flat.Magnitude<0.1 then flat=Vector3.new(cf.LookVector.X,0,cf.LookVector.Z) end
if flat.Magnitude<0.1 then flat=Vector3.new(0,0,1) end
return flat.Unit
end
local function standPos(d,dist)
local part=d.Part
local n=doorNormal(part)
local sign=1
local hrp=getHRP()
if hrp and (hrp.Position-part.Position):Dot(n)<0 then sign=-1 end
if State.doors.flip[d.Model] then sign=-sign end
local base=part.Position+n*sign*dist
return Vector3.new(base.X,part.Position.Y,base.Z)
end
local function adjustBlatantForward(delta)
Cfg.BlatantForward=math.clamp(Cfg.BlatantForward+delta,-20,50)
if GUI.setStatus then GUI.setStatus("Blatant Forward: "..Cfg.BlatantForward) end
end
local function markFalseDoor(model,reason)
if not model or State.falseDoors[model] then return end
State.falseDoors[model]=reason or "false"
State.doors.last=0
if State.lockedDoor and State.lockedDoor.Model==model then State.lockedDoor=nil end
GUI.setStatus("False door removed")
if State.hooks.onFalseDoor then pcall(State.hooks.onFalseDoor,model) end
end
local function failDoor(d,countFalse)
if d.Model and d.Model.Parent then
State.doors.skip[d.Model]=os.clock()+Cfg.DoorSkipTime
State.doors.recent[d.Model]=os.clock()+Cfg.DoorRetryCooldown
State.doors.flip[d.Model]=not State.doors.flip[d.Model]
if State.lockedDoor and State.lockedDoor.Model==d.Model then State.lockedDoor=nil end
if countFalse and State.afdActive then
local n=(State.doors.fails[d.Model] or 0)+1
State.doors.fails[d.Model]=n
if n>=Cfg.FalseDoorFails then markFalseDoor(d.Model,"failed "..n.."x") end
end
end
end
local function nearDoor(hrp,part)
local a,b=hrp.Position,part.Position
local flat=Vector3.new(a.X-b.X,0,a.Z-b.Z).Magnitude
return flat<=Cfg.DoorStandoff+2 and math.abs(a.Y-b.Y)<=10
end
local function stopTween()
if State.activeTween then
pcall(function() State.activeTween:Cancel() end)
State.activeTween=nil
end
end
function State.api.releaseCharacterControl(reason)
stopTween()
local ch=LP.Character
local hum=ch and ch:FindFirstChildOfClass("Humanoid")
local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
if hrp then
pcall(function()
hrp.Anchored=false
hrp.AssemblyAngularVelocity=Vector3.zero
end)
end
if hum then
pcall(function() hum.PlatformStand=false end)
pcall(function() hum.AutoRotate=true end)
pcall(function() hum.Sit=false end)
pcall(function()
local st=hum:GetState()
if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.PlatformStanding or st==Enum.HumanoidStateType.Seated then
hum:ChangeState(Enum.HumanoidStateType.GettingUp)
task.defer(function()
if hum and hum.Parent and hum.Health>0 then
pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
end
end)
else
hum:ChangeState(Enum.HumanoidStateType.Running)
end
end)
end
State.activeTween=nil
return true
end
local function makeRayParams()
local cache=State.physicsCache
local now=os.clock()
local ttl=Cfg.PhysicsParamsTTL or .22
if cache.ray and now-cache.rayAt<ttl and cache.char==LP.Character and cache.safePlatform==State.safePlatform then
return cache.ray
end
local rp=RaycastParams.new()
rp.FilterType=Enum.RaycastFilterType.Exclude
local list={ESP_F,NODE_F,TRAJ_F,OBS_F}
if State.safePlatform then list[#list+1]=State.safePlatform end
for _,p in ipairs(Players:GetPlayers()) do
if p.Character then list[#list+1]=p.Character end
end
rp.FilterDescendantsInstances=list
pcall(function() rp.RespectCanCollide=true end)
cache.ray=rp;cache.rayAt=now;cache.char=LP.Character;cache.safePlatform=State.safePlatform
return rp
end

State.api.makeOverlapParams=function()
local cache=State.physicsCache
local now=os.clock()
local ttl=Cfg.PhysicsParamsTTL or .22
if cache.overlap and now-cache.overlapAt<ttl and cache.char==LP.Character and cache.safePlatform==State.safePlatform then
return cache.overlap
end
local op=OverlapParams.new()
op.FilterType=Enum.RaycastFilterType.Exclude
local ignore={ESP_F,NODE_F,TRAJ_F,OBS_F}
if LP.Character then ignore[#ignore+1]=LP.Character end
if State.safePlatform then ignore[#ignore+1]=State.safePlatform end
op.FilterDescendantsInstances=ignore
pcall(function() op.RespectCanCollide=true end)
pcall(function() op.MaxParts=Cfg.OverlapMaxParts or 32 end)
cache.overlap=op;cache.overlapAt=now;cache.char=LP.Character;cache.safePlatform=State.safePlatform
return op
end
local function snapToGround(pos)
local hit=workspace:Raycast(pos+Vector3.new(0,2,0),Vector3.new(0,-300,0),makeRayParams())
if hit then return hit.Position+Vector3.new(0,standHeight(),0) end
return pos
end
local function clearLine(a,b)
local vec=b-a
if vec.Magnitude<0.1 then return true end
local rp=makeRayParams()
local flat=Vector3.new(vec.X,0,vec.Z)
local side=Vector3.zero
if flat.Magnitude>0.05 then side=flat.Unit:Cross(Vector3.yAxis)*Cfg.AgentRadius end
local offsets={Vector3.zero,side,-side,Vector3.new(0,-1.5,0),Vector3.new(0,1.5,0)}
for _,o in ipairs(offsets) do
if workspace:Raycast(a+o,vec,rp) then return false end
end
return true
end
local function volumeClear(a,b,radius)
local displacement=b-a
if displacement.Magnitude<0.1 then return true end
local rp=makeRayParams()
local radiusSafe=math.clamp(radius or math.max(1.5,Cfg.AgentRadius*0.6),1,4)
local ok,res=pcall(function() return workspace:Spherecast(a,radiusSafe,displacement,rp) end)
if ok then return res==nil end
return clearLine(a,b)
end
local function lineSafe(a,b)
local ttl=Cfg.LineSafeCacheTTL or 0
local cache=State.lineCache
local function q(v) return math.floor(v/2+0.5) end
local key=q(a.X)..":"..q(a.Y)..":"..q(a.Z)..">"..q(b.X)..":"..q(b.Y)..":"..q(b.Z)
if ttl>0 then
local e=cache.data[key]
if e and os.clock()-e.t<=ttl then return e.v end
end
local safe=true
if not volumeClear(a,b) then safe=false
else
local delta=b-a
if delta.Magnitude>18 then
local count=math.ceil(delta.Magnitude/15)
for i=1,count-1 do
local p=a+delta*(i/count)
if not volumeClear(p,p+delta.Unit*0.12) then safe=false;break end
end
end
end
if ttl>0 then
if cache.count>=(Cfg.LineSafeCacheMax or 220) then cache.data={};cache.count=0 end
if not cache.data[key] then cache.count=cache.count+1 end
cache.data[key]={v=safe,t=os.clock()}
end
return safe
end
local function volumeHit(a,b,radius)
local displacement=b-a
if displacement.Magnitude<0.1 then return nil end
local rp=makeRayParams()
local r=math.clamp(radius or Cfg.AirPathRadius or math.max(1.5,Cfg.AgentRadius*.6),1,5)
local ok,res=pcall(function() return workspace:Spherecast(a,r,displacement,rp) end)
if ok then return res end
return workspace:Raycast(a,displacement,rp)
end
local function pointVolumeClear(pos,radius)
local op=State.api.makeOverlapParams()
local r=math.max(1,radius or Cfg.AirPathRadius or 2.4)
local ok,parts=pcall(function()
return workspace:GetPartBoundsInBox(CFrame.new(pos),Vector3.new(r*2,r*2.5,r*2),op)
end)
if not ok or not parts then return true end
for _,p in ipairs(parts) do
if p:IsA("BasePart") and p.CanCollide then return false end
end
return true
end
local function safeTargetHeight(target)
local grounded=snapToGround(target)
if math.abs(grounded.Y-target.Y)<=math.max(4,Cfg.AirGroundThreshold or 12) then return grounded end
return target
end
local function groundDistanceAt(pos,maxDist)
local hit=workspace:Raycast(pos,Vector3.new(0,-(maxDist or 500),0),makeRayParams())
if not hit then return math.huge,nil end
return (pos.Y-hit.Position.Y),hit
end
local function needs3DRoute(fromPos,toPos)
if not Cfg.Full3DPath then return false end
local gd1=groundDistanceAt(fromPos,500)
local gd2=groundDistanceAt(toPos,500)
if gd1>(Cfg.AirGroundThreshold or 12) or gd2>(Cfg.AirGroundThreshold or 12) then return true end
if math.abs(fromPos.Y-toPos.Y)>(Cfg.AirGroundThreshold or 12) then return true end
return not lineSafe(fromPos,toPos)
end
local function airObstacleCandidates(fromPos,toPos,hit,variant)
local list={}
if not hit or not hit.Instance or not hit.Instance:IsA("BasePart") then return list end
local part=hit.Instance
local cf,size=part.CFrame,part.Size
local pad=(Cfg.AirPathPadding or 4)+(Cfg.AirPathRadius or 2.4)
local ext=Vector3.new(size.X*.5+pad,size.Y*.5+pad,size.Z*.5+pad)
local lp=cf:PointToObjectSpace(hit.Position)
local function clamp(v,m) return math.clamp(v,-math.max(0,m-pad*.5),math.max(0,m-pad*.5)) end
local cx,cy,cz=clamp(lp.X,size.X*.5),clamp(lp.Y,size.Y*.5),clamp(lp.Z,size.Z*.5)
local localPts={
Vector3.new( ext.X,cy,cz),Vector3.new(-ext.X,cy,cz),
Vector3.new(cx, ext.Y,cz),Vector3.new(cx,-ext.Y,cz),
Vector3.new(cx,cy, ext.Z),Vector3.new(cx,cy,-ext.Z),
Vector3.new( ext.X, ext.Y,cz),Vector3.new(-ext.X, ext.Y,cz),
Vector3.new( ext.X,-ext.Y,cz),Vector3.new(-ext.X,-ext.Y,cz),
Vector3.new(cx, ext.Y, ext.Z),Vector3.new(cx, ext.Y,-ext.Z),
Vector3.new(cx,-ext.Y, ext.Z),Vector3.new(cx,-ext.Y,-ext.Z),
}
local bias=((variant or 0)%7)*0.035
for i,p in ipairs(localPts) do
local wp=cf:PointToWorldSpace(p)
if inMapRange(wp) and pointVolumeClear(wp,Cfg.AirPathRadius) and lineSafe(fromPos,wp) then
local score=(wp-fromPos).Magnitude+(toPos-wp).Magnitude
local dy=math.abs(wp.Y-fromPos.Y)
score=score+dy*.08+((i-1)*bias)
list[#list+1]={p=wp,score=score}
end
end
table.sort(list,function(a,b) return a.score<b.score end)
return list
end
local function compute3DPath(fromPos,toPos,variant)
if lineSafe(fromPos,toPos) then return {fromPos,toPos},"direct3d" end
local maxNodes=math.max(8,Cfg.AirPathMaxNodes or 28)
local maxDetours=math.max(3,Cfg.AirPathMaxDetours or 12)
local open={{p=fromPos,g=0,f=(toPos-fromPos).Magnitude,parent=nil,depth=0}}
local visited={}
local function key(p)
local q=4
return math.floor(p.X/q+.5)..":"..math.floor(p.Y/q+.5)..":"..math.floor(p.Z/q+.5)
end
local expanded=0
while #open>0 and expanded<maxNodes do
table.sort(open,function(a,b) return a.f<b.f end)
local node=table.remove(open,1)
local k=key(node.p)
if not visited[k] then
visited[k]=true;expanded=expanded+1
if lineSafe(node.p,toPos) then
local rev={toPos,node.p}
local n=node.parent
while n do rev[#rev+1]=n.p;n=n.parent end
local path={}
for i=#rev,1,-1 do
if #path==0 or (path[#path]-rev[i]).Magnitude>.2 then path[#path+1]=rev[i] end
end
return path,"air3d"
end
if node.depth<maxDetours then
local hit=volumeHit(node.p,toPos,Cfg.AirPathRadius)
if hit then
local cands=airObstacleCandidates(node.p,toPos,hit,(variant or 0)+node.depth)
local limit=math.min(#cands,8)
for i=1,limit do
local p=cands[i].p
local pk=key(p)
if not visited[pk] then
local g=node.g+(p-node.p).Magnitude
open[#open+1]={p=p,g=g,f=g+(toPos-p).Magnitude,parent=node,depth=node.depth+1}
end
end
end
end
end
end
return nil,"no3dpath"
end
local function worldPartTopY(part)
if not part or not part:IsA("BasePart") then return nil end
local cf,s=part.CFrame,part.Size
local halfY=math.abs(cf.RightVector.Y)*s.X*.5+math.abs(cf.UpVector.Y)*s.Y*.5+math.abs(cf.LookVector.Y)*s.Z*.5
return part.Position.Y+halfY
end
local function smallPartLiftWaypoint(fromPos,toPos,variant)
if not Cfg.HeightAwarePath then return nil end
local hit=volumeHit(fromPos,toPos,math.max(1.5,Cfg.AirPathRadius or 2.4))
if not hit or not hit.Instance or not hit.Instance:IsA("BasePart") then return nil end
local part=hit.Instance
if not part.CanCollide then return nil end
local s=part.Size
local flatSize=math.max(s.X,s.Z)
local small=(flatSize<=(Cfg.HeightSmallPartMaxSize or 7) and s.Y<=(Cfg.HeightSmallPartMaxY or 5))
or (math.min(s.X,s.Z)<=2.5 and s.Y<=(Cfg.HeightSmallPartMaxY or 5)*1.5)
if not small then return nil end
local topY=worldPartTopY(part)
if not topY then return nil end
local dir=Vector3.new(toPos.X-fromPos.X,0,toPos.Z-fromPos.Z)
dir=dir.Magnitude>.05 and dir.Unit or Vector3.new(0,0,1)
local baseY=math.max(fromPos.Y,topY+standHeight()+(Cfg.Item3DTopClearance or 4))
local maxLift=Cfg.Item3DMaxLift or 18
local step=math.max(1,Cfg.HeightStep or 2.5)
local nudge=(Cfg.Item3DForwardNudge or 3)+((variant or 0)%3)
for extra=0,maxLift,step do
local wp=Vector3.new(hit.Position.X,baseY+extra,hit.Position.Z)+dir*nudge
if inMapRange(wp) and pointVolumeClear(wp,Cfg.AirPathRadius) and lineSafe(fromPos,wp) then
return wp,part
end
end
return nil
end
function State.api.fenceOverWaypoints(fromPos,toPos,variant)
if not Cfg.FenceTraversal then return nil end
local radius=math.max(1.5,Cfg.AirPathRadius or 2.4)
local hit=volumeHit(fromPos,toPos,radius)
if not hit or not hit.Instance or not hit.Instance:IsA("BasePart") then return nil end
local part=hit.Instance
if not part.CanCollide then return nil end
local s=part.Size
local thin=math.min(s.X,s.Z)
local height=s.Y
local n=string.lower(part.Name)
local namedFence=n:find("fence",1,true) or n:find("gate",1,true) or n:find("rail",1,true) or n:find("barrier",1,true) or n:find("grade",1,true) or n:find("cerca",1,true)
if not namedFence and not (height>=(Cfg.FenceMinHeight or 6) and height<=(Cfg.FenceMaxHeight or 42) and thin<=(Cfg.FenceThinSize or 5)) then return nil end
local topY=worldPartTopY(part)
if not topY then return nil end
local climb=topY-fromPos.Y
if climb>(Cfg.FenceMaxHeight or 42)+standHeight()+8 then return nil end
local flat=Vector3.new(toPos.X-fromPos.X,0,toPos.Z-fromPos.Z)
if flat.Magnitude<.05 then return nil end
local dir=flat.Unit
local sideClear=(Cfg.FenceSideClearance or 6)+radius
local top=topY+standHeight()+(Cfg.FenceTopClearance or 6)
local beforeXZ=hit.Position-dir*sideClear
local afterXZ=hit.Position+dir*sideClear
local before=Vector3.new(beforeXZ.X,math.max(top,fromPos.Y+2),beforeXZ.Z)
local after=Vector3.new(afterXZ.X,math.max(top,toPos.Y+2),afterXZ.Z)
if not pointVolumeClear(before,radius) or not pointVolumeClear(after,radius) then
for extra=3,18,3 do
local b=before+Vector3.new(0,extra,0)
local a=after+Vector3.new(0,extra,0)
if pointVolumeClear(b,radius) and pointVolumeClear(a,radius) and lineSafe(fromPos,b) and lineSafe(b,a) then before,after=b,a;break end
end
end
if not lineSafe(fromPos,before) or not lineSafe(before,after) then return nil end
return {before,after},part
end
local function computeItem3DPath(fromPos,toPos,variant)
if lineSafe(fromPos,toPos) then return {fromPos,toPos},"item-direct" end
local fencePts=State.api.fenceOverWaypoints(fromPos,toPos,variant)
if fencePts then
local before,after=fencePts[1],fencePts[2]
local rest=compute3DPath(after,toPos,(variant or 0)+1)
local pts={fromPos,before,after}
if rest and #rest>=2 then
for i=2,#rest do pts[#pts+1]=rest[i] end
return pts,"item-fence-over"
elseif lineSafe(after,toPos) then
pts[#pts+1]=toPos
return pts,"item-fence-direct"
end
end
local lift=smallPartLiftWaypoint(fromPos,toPos,variant)
if lift then
local rest=compute3DPath(lift,toPos,(variant or 0)+1)
if rest and #rest>=2 then
local pts={fromPos,lift}
for i=2,#rest do pts[#pts+1]=rest[i] end
return pts,"item-lift3d"
elseif lineSafe(lift,toPos) then
return {fromPos,lift,toPos},"item-lift-direct"
end
end
return compute3DPath(fromPos,toPos,variant or 0)
end
local function smoothPath(points)
if #points<=2 then return points end
local out={points[1]}
local i=1
while i<#points do
local far=i+1
local limit=math.min(#points,i+12)
for j=limit,i+2,-1 do
if lineSafe(points[i],points[j]) and math.abs(points[j].Y-points[i].Y)<=10 then far=j;break end
end
out[#out+1]=points[far]
i=far
end
return out
end
local function lockedDoorValid()
local ld=State.lockedDoor
if not ld then return true end
if not ld.Model or not ld.Model.Parent then return false end
local part=getDoorPart(ld.Model)
if not part then return false end
if ld.StartPos and (part.Position-ld.StartPos).Magnitude>Cfg.LockedDoorMaxDrift then return false end
return true
end
function State.api.doorSlowSpeed(baseSpeed)
baseSpeed=math.max(baseSpeed or Cfg.WalkSpeed,1)
if not Cfg.DoorSlowdown or not State.lockedDoor or not State.lockedDoor.Model or not State.lockedDoor.Model.Parent then return baseSpeed end
local hrp=getHRP();local part=getDoorPart(State.lockedDoor.Model)
if not hrp or not part then return baseSpeed end
local d=(part.Position-hrp.Position).Magnitude
local range=math.max(1,Cfg.DoorSlowdownDistance or 50)
if d>=range then return baseSpeed end
local minSpeed=math.clamp(Cfg.DoorSlowdownMinSpeed or 28,1,baseSpeed)
local curve=math.clamp(Cfg.DoorSlowdownCurve or 1.35,.25,4)
local t=math.clamp(d/range,0,1)^curve
return minSpeed+(baseSpeed-minSpeed)*t
end
function State.api.normalPathPoint(pos,isFinal)
if isFinal then return pos end
if Cfg.PathTravelMode=="Y5" then
return pos+Vector3.new(0,math.clamp(Cfg.PathTravelY or 5,0,20),0)
end
return snapToGround(pos)
end
local function moveToRaw(pos,flag,speedOverride)
if not inMapRange(pos) then return false end
local hrp=getHRP();if not hrp then return false end
local startPos=hrp.Position
State.api.routeDebug(pos,pos,"Moving",nil)
local dist=(pos-startPos).Magnitude
if dist<=Cfg.ReachDist then return true end
local speed=State.api.doorSlowSpeed(math.max(speedOverride or Cfg.WalkSpeed,1))
local dur=math.clamp((dist/speed)*math.clamp(Cfg.TweenTimeLapse or 1,.15,4),0.05,math.max(Cfg.MoveTimeout,0.1)*math.max(1,Cfg.TweenTimeLapse or 1))
local flat=Vector3.new(pos.X-startPos.X,0,pos.Z-startPos.Z)
local cf=(flat.Magnitude>0.05) and CFrame.lookAt(pos,pos+flat) or CFrame.new(pos)
stopTween()
local tw=TweenService:Create(hrp,TweenInfo.new(dur,Enum.EasingStyle.Linear),{CFrame=cf})
State.activeTween=tw
local done=false
tw.Completed:Connect(function() done=true end)
tw:Play()
local t0=os.clock()
local lastCheck=t0
local lastPos=startPos
local minProgress=math.huge
local lastLockCheck=t0
local lastObstacleCheck=t0
while not done and os.clock()-t0<dur+0.5 do
if State.dead or not flag() then stopTween();return false end
if State.lockedDoor and os.clock()-lastLockCheck>=Cfg.LockedDoorCheckInterval then
lastLockCheck=os.clock()
if not lockedDoorValid() then stopTween();State.pathCache={t=0};return false end
end
local cur=getHRP()
if not cur or cur~=hrp then stopTween();return false end
pcall(function() hrp.AssemblyLinearVelocity=Vector3.zero end)
local now=os.clock()
if Cfg.DynamicObstacleCheck and now-lastObstacleCheck>=Cfg.ObstacleCheckInterval then
lastObstacleCheck=now
if not lineSafe(cur.Position,pos) then State.api.routeDebug(pos,pos,"Dynamic obstacle",cur.Position);history("Route recalculated: obstacle");stopTween();return false end
end
if now-lastCheck>=Cfg.StuckWindow then
local curPos=cur.Position
local moved=(curPos-lastPos).Magnitude
local remaining=(pos-curPos).Magnitude
if remaining<minProgress then minProgress=remaining end
if moved<Cfg.StuckMinDist or (remaining>minProgress+Cfg.StuckMinDist) then
State.api.routeDebug(pos,pos,"Stuck → recover",curPos);history("Route recovery: stuck");stopTween();return false
end
lastCheck=now;lastPos=curPos
end
task.wait(Cfg.RuntimeTick or .02)
end
stopTween()
local h2=getHRP();if not h2 then return false end
return (pos-h2.Position).Magnitude<=Cfg.ReachDist+3
end
local function itemTweenTo(pos,flag,speedOverride)
flag=flag or function() return true end
local hrp=getHRP();if not hrp or not hrp.Parent then return false end
local start=hrp.Position
local dist=(pos-start).Magnitude
if dist<=Cfg.ReachDist+1 then return true end
local speed=math.max(speedOverride or Cfg.WalkSpeed,1)
local dur=math.max(.05,(dist/speed)*math.clamp(Cfg.TweenTimeLapse or 1,.15,4))
-- Items may have long waypoint segments; don't cut the tween at generic MoveTimeout.
dur=math.min(dur,math.max(8,(Cfg.MoveTimeout or 3)*4))
local flat=Vector3.new(pos.X-start.X,0,pos.Z-start.Z)
local goal=(flat.Magnitude>.05) and CFrame.lookAt(pos,pos+flat) or CFrame.new(pos)
stopTween()
local tw=TweenService:Create(hrp,TweenInfo.new(dur,Enum.EasingStyle.Linear),{CFrame=goal})
State.activeTween=tw
local done=false
local completed
completed=tw.Completed:Connect(function() done=true end)
tw:Play()
local t0=os.clock()
local lastPos=start
local lastProgress=t0
while not done and os.clock()-t0<dur+1 do
if State.dead or not flag() then
pcall(function() tw:Cancel() end)
if completed then pcall(function() completed:Disconnect() end) end
if State.activeTween==tw then State.activeTween=nil end
return false
end
local cur=getHRP()
if not cur or cur~=hrp then
pcall(function() tw:Cancel() end)
if completed then pcall(function() completed:Disconnect() end) end
if State.activeTween==tw then State.activeTween=nil end
return false
end
local moved=(cur.Position-lastPos).Magnitude
if moved>.35 then lastPos=cur.Position;lastProgress=os.clock() end
-- Only declare stuck after a generous window. Do NOT re-run lineSafe here;
-- the pathfinder already approved the waypoint.
if os.clock()-lastProgress>math.max(2.2,(Cfg.StuckWindow or 1.2)*1.8) then
pcall(function() tw:Cancel() end)
if completed then pcall(function() completed:Disconnect() end) end
if State.activeTween==tw then State.activeTween=nil end
State.api.routeDebug(pos,pos,"Items: tween stuck → recalc",cur.Position)
return false
end
pcall(function()
hrp.AssemblyLinearVelocity=Vector3.zero
hrp.AssemblyAngularVelocity=Vector3.zero
end)
task.wait(Cfg.RuntimeTick or .02)
end
if completed then pcall(function() completed:Disconnect() end) end
if State.activeTween==tw then State.activeTween=nil end
local h=getHRP()
return h and (h.Position-pos).Magnitude<=Cfg.ReachDist+4 or false
end

local function followItemPath(points,flag,speedOverride)
if not points or #points<2 then return false end
flag=flag or function() return true end
for i=2,#points do
if State.dead or not flag() then return false end
local h=getHRP();if not h then return false end
local raw=points[i]
local target=State.api.normalPathPoint(raw,i==#points)
State.api.routeDebug(points[#points],target,"Items waypoint "..i.."/"..#points,nil)
if (target-h.Position).Magnitude>Cfg.ReachDist+1 then
if not itemTweenTo(target,flag,speedOverride) then return false end
end
end
return true
end
local function farthestVisiblePathPoint(points,startIndex,maxLookAhead)
local hrp=getHRP()
if not hrp or not points or #points==0 then return nil end
startIndex=math.clamp(startIndex or 2,1,#points)
maxLookAhead=math.max(1,maxLookAhead or Cfg.PathLookAhead or 10)
local last=math.min(#points,startIndex+maxLookAhead-1)
local best=startIndex
for i=last,startIndex,-1 do
local p=points[i]
if p and lineSafe(hrp.Position,p) then
best=i
break
end
end
return best
end
local function followPointPath(points,flag,speedOverride,is3D)
if not points or #points<2 then return false end
flag=flag or function() return true end
local index=2
local lookAhead=is3D and (Cfg.PathLookAhead3D or 12) or (Cfg.PathLookAhead or 10)
while index<=#points do
if State.dead or not flag() then return false end
if not lockedDoorValid() then return false end
local hrp=getHRP()
if not hrp then return false end
local targetIndex=farthestVisiblePathPoint(points,index,lookAhead) or index
local target=points[targetIndex]
State.api.routeDebug(points[#points],target,"Waypoint "..targetIndex.."/"..#points,nil)
if (target-hrp.Position).Magnitude<=(Cfg.PathMinSkipDistance or 2.5) and targetIndex<#points then
index=targetIndex+1
else
if not lineSafe(hrp.Position,target) then return false end
if not moveToRaw(target,flag,speedOverride) then return false end
index=targetIndex+1
end
end
return true
end
function State.api.routeLoopWatch(origin,target,started,bestRemaining)
local h=getHRP()
if not h or not origin or not target then return false end
local elapsed=os.clock()-(started or os.clock())
if elapsed<(Cfg.RouteLoopTimeout or 7.5) then return false end

local currentRemaining=(target-h.Position).Magnitude
local originalDistance=(target-origin).Magnitude
local progress=originalDistance-math.min(bestRemaining or currentRemaining,currentRemaining)
local returned=(h.Position-origin).Magnitude<=(Cfg.RouteLoopReturnRadius or 12)

return returned or progress<(Cfg.RouteLoopMinProgress or 14)
end

function State.api.forcedSimpleRoute(target,flag,speed)
flag=flag or function() return true end
speed=speed or Cfg.WalkSpeed
local h=getHRP();if not h then return false end

GUI.setStatus("Route loop detected • forcing simple route")
State.api.routeDebug(target,h.Position,"FORCED SIMPLE ROUTE",h.Position)
stopTween()
State.pathCache={t=0}

local attempts=math.max(1,Cfg.SimpleRouteMaxAttempts or 2)
for attempt=1,attempts do
if State.dead or not flag() then return false end
h=getHRP();if not h then return false end

-- If the final segment is already open, don't waste a PathfindingService call.
if lineSafe(h.Position,target) then
if moveToRaw(target,flag,speed) then
return true
end
end

local path
local ok=pcall(function()
path=PathfindingService:CreatePath({
AgentRadius=math.max(2,Cfg.AgentRadius or 4),
AgentHeight=math.max(4,Cfg.AgentHeight or 5),
AgentCanJump=true,
AgentCanClimb=false,
WaypointSpacing=math.max(8,Cfg.SimpleRouteWaypointSpacing or 14),
})
path:ComputeAsync(h.Position,snapToGround(target))
end)

if ok and path and path.Status==Enum.PathStatus.Success then
local wps=path:GetWaypoints()
if wps and #wps>=2 then
local pts={}
for i,wp in ipairs(wps) do
pts[i]=wp.Position
end
pts[1]=h.Position
pts[#pts]=snapToGround(target)

-- Deliberately no smart look-ahead, no candidate scoring, no 3D detours.
for i=2,#pts do
if State.dead or not flag() then return false end
local cur=getHRP();if not cur then return false end
local p=State.api.normalPathPoint(pts[i],i==#pts)
State.api.routeDebug(target,p,("Simple waypoint %d/%d"):format(i,#pts),nil)
if (p-cur.Position).Magnitude>Cfg.ReachDist+1 then
if not moveToRaw(p,flag,math.min(speed,State.mobileLite and 75 or 110)) then
break
end
end
if i==#pts then
local done=getHRP()
if done and (target-done.Position).Magnitude<=Cfg.ReachDist+4 then
return true
end
end
end
end
end

task.wait(.08)
end
return false
end

local computePathSmart
function State.api.itemLongRouteHop(fromPos,toPos,variant)
local total=(toPos-fromPos).Magnitude
if total<=(Cfg.ItemLongRouteChunk or 180) then return nil end
local dir=(toPos-fromPos).Unit
local flat=Vector3.new(dir.X,0,dir.Z)
if flat.Magnitude<0.05 then flat=Vector3.new(0,0,1) else flat=flat.Unit end
local side=flat:Cross(Vector3.yAxis)
local chunk=math.clamp(Cfg.ItemLongRouteChunk or 180,80,240)
local distances={chunk,chunk*.82,chunk*.65,chunk*.5}
local lateral={0,18,-18,32,-32,48,-48}
local best,bestScore=nil,math.huge
for _,d in ipairs(distances) do
if d<total-6 then
local ratio=math.clamp(d/total,0,1)
local base=fromPos:Lerp(toPos,ratio)
for _,off in ipairs(lateral) do
local probe=base+side*off
local grounded=snapToGround(probe)
local candidate=Vector3.new(grounded.X,grounded.Y,grounded.Z)
local progress=total-(toPos-candidate).Magnitude
if progress>math.max(25,d*.28) and pointVolumeClear(candidate,Cfg.AirPathRadius) then
local pts=computeItem3DPath(fromPos,candidate,(variant or 0)+math.floor(math.abs(off)/16))
if pts and #pts>=2 then
local score=(toPos-candidate).Magnitude+math.abs(off)*.35+#pts*2
if score<bestScore then bestScore=score;best=pts end
end
end
end
end
end
return best
end
function State.api.itemNavPath(fromPos,toPos,variant)
local groundTarget=snapToGround(toPos)
local tries={
{math.max(2,Cfg.AgentRadius or 4),math.max(2,Cfg.AgentHeight or 5),math.max(3,Cfg.WaypointSpacing or 8)},
{2,math.max(4,(Cfg.AgentHeight or 5)-1),5},
{2,4,3},
}
local maxTry=State.mobileLite and 2 or 3
for i,c in ipairs(tries) do
if i>maxTry then break end
local ok,path=pcall(function()
return PathfindingService:CreatePath({AgentRadius=c[1],AgentHeight=c[2],AgentCanJump=true,AgentCanClimb=false,WaypointSpacing=c[3]})
end)
if ok and path then
local ok2=pcall(function() path:ComputeAsync(fromPos,groundTarget) end)
if ok2 and path.Status==Enum.PathStatus.Success then
local wps=path:GetWaypoints()
if wps and #wps>=2 then
local pts={}
for n,wp in ipairs(wps) do pts[n]=wp.Position end
pts[1]=fromPos;pts[#pts]=groundTarget
return pts,"item-nav-"..i
end
end
end
end
return nil,"item-nav-failed"
end
function State.api.itemRollingNavHop(fromPos,toPos,variant)
local total=(toPos-fromPos).Magnitude
local chunk=math.clamp(Cfg.ItemLongRouteChunk or 180,70,220)
if total<=chunk*1.05 then return State.api.itemNavPath(fromPos,toPos,variant) end
local flat=Vector3.new(toPos.X-fromPos.X,0,toPos.Z-fromPos.Z)
if flat.Magnitude<1 then return State.api.itemNavPath(fromPos,toPos,variant) end
local dir=flat.Unit
local side=dir:Cross(Vector3.yAxis)
local offsets={0,14,-14,28,-28,42,-42}
local lengths={chunk,chunk*.82,chunk*.66,chunk*.5}
local best,bestScore=nil,math.huge
for _,len in ipairs(lengths) do
for _,off in ipairs(offsets) do
local probe=fromPos+dir*len+side*off
local candidate=snapToGround(probe)
local progress=total-(toPos-candidate).Magnitude
if progress>math.max(20,len*.25) then
local pts
if computePathSmart then pts=select(1,computePathSmart(fromPos,candidate,nil,(variant or 0)+1)) end
if not pts then pts=State.api.itemNavPath(fromPos,candidate,(variant or 0)+1) end
if pts and #pts>=2 then
local score=(toPos-candidate).Magnitude+math.abs(off)*.25+#pts*1.5
if score<bestScore then bestScore=score;best=pts end
end
end
end
end
return best,best and "item-rolling-nav" or "item-rolling-failed"
end
function State.api.quickItem3DPath(fromPos,toPos,variant)
local oldNodes,oldDetours=Cfg.AirPathMaxNodes,Cfg.AirPathMaxDetours
Cfg.AirPathMaxNodes=math.min(oldNodes or 20,Cfg.Item3DQuickNodes or 16)
Cfg.AirPathMaxDetours=math.min(oldDetours or 9,Cfg.Item3DQuickDetours or 6)
local pts,kind=computeItem3DPath(fromPos,toPos,variant or 0)
Cfg.AirPathMaxNodes, Cfg.AirPathMaxDetours=oldNodes,oldDetours
return pts,kind
end
local function followItem3DPath(points,flag,speed)
if not points or #points<2 then return false end
for i=2,#points do
if State.dead or not flag() then return false end
local target=points[i]
State.api.routeDebug(points[#points],target,"Items 3D "..i.."/"..#points,nil)
if Cfg.ShowTrajectory then showTrajectory({getHRP() and getHRP().Position or target,target},Color3.fromRGB(160,120,255)) end
if not itemTweenTo(target,flag,speed) then return false end
end
return true
end
local function goToItem3D(target,flag,speed,variant)
flag=flag or function() return true end
speed=speed or Cfg.WalkSpeed
local finalPos=safeTargetHeight(target)
local maxCycles=math.max(8,Cfg.ItemMaxPathCycles or 22)
local cycle=0
local lastRemaining=math.huge
local stagnant=0
local firstHrp=getHRP()
local routeOrigin=firstHrp and firstHrp.Position or finalPos
local routeStarted=os.clock()
local bestRemaining=(finalPos-routeOrigin).Magnitude
local forcedUsed=false

while flag() and not State.dead and cycle<maxCycles do
local hrp=getHRP();if not hrp then return false end
finalPos=safeTargetHeight(target)
local remaining=(finalPos-hrp.Position).Magnitude
if remaining<=Cfg.ReachDist+3 then return true end

if remaining>=lastRemaining-.6 then stagnant+=1 else stagnant=math.max(0,stagnant-1) end
lastRemaining=remaining
State.pathCache={t=0}
GUI.setStatus(("Items: 3D calculating • %d studs"):format(math.floor(remaining)))

-- 250+ studs: calculate a bounded 3D chunk instead of one giant route.
local stepTarget=finalPos
if Cfg.Item3DFast and remaining>(Cfg.Item3DFastDistance or 250) then
local chunk=math.clamp(Cfg.Item3DChunk or 210,100,240)
local delta=finalPos-hrp.Position
stepTarget=hrp.Position+delta.Unit*math.min(chunk,delta.Magnitude)
-- lift the chunk target above local terrain so relief does not force a ground route.
local ground=snapToGround(stepTarget)
stepTarget=Vector3.new(stepTarget.X,math.max(stepTarget.Y,ground.Y+(Cfg.Item3DTopClearance or 4)+3),stepTarget.Z)
end

-- Quick 3D first for blocked/high/long routes.
local vertical=math.abs(stepTarget.Y-hrp.Position.Y)
local use3DFirst=Cfg.Item3DFast and (
remaining>=(Cfg.Item3DFastDistance or 250)
or vertical>(Cfg.AirGroundThreshold or 12)
or not lineSafe(hrp.Position,stepTarget)
)
local moved=false

if use3DFirst then
local pts=State.api.quickItem3DPath(hrp.Position,stepTarget,(variant or 0)+cycle)
if pts and #pts>=2 then
State.api.routeDebug(finalPos,pts[2],"Items: fast 3D route",nil)
moved=followItem3DPath(pts,flag,speed)
end
end

-- Open short route: use normal smart route only when 3D was unnecessary/failed.
if not moved then
hrp=getHRP();if not hrp then return false end
local nav=nil
if computePathSmart then nav=select(1,computePathSmart(hrp.Position,stepTarget,nil,(variant or 0)+cycle)) end
if not nav then nav=State.api.itemNavPath(hrp.Position,stepTarget,(variant or 0)+cycle) end
if nav and #nav>=2 then
State.api.routeDebug(finalPos,nav[2],"Items: smart route",nil)
moved=followItemPath(nav,flag,speed)
end
end

-- Hard terrain fallback: full 3D/fence planner.
if not moved then
hrp=getHRP();if not hrp then return false end
local pts=computeItem3DPath(hrp.Position,stepTarget,(variant or 0)+cycle)
if pts and #pts>=2 then
State.api.routeDebug(finalPos,pts[2],"Items: hard 3D fallback",nil)
moved=followItem3DPath(pts,flag,speed)
end
end

if not moved then
stagnant+=1
if stagnant>=2 then
hrp=getHRP()
if hrp then
local dir=Vector3.new(hrp.Position.X-finalPos.X,0,hrp.Position.Z-finalPos.Z)
if dir.Magnitude<.1 then dir=Vector3.new(hrp.CFrame.LookVector.X,0,hrp.CFrame.LookVector.Z) end
if dir.Magnitude>.1 then
local retreat=hrp.Position+dir.Unit*math.min(12,6+stagnant)
itemTweenTo(retreat,flag,math.min(speed,70))
end
end
stagnant=0
end
task.wait(.04)
end
cycle+=1
local watchHrp=getHRP()
if watchHrp then
local watchRemaining=(finalPos-watchHrp.Position).Magnitude
if watchRemaining<bestRemaining then bestRemaining=watchRemaining end
if not forcedUsed and State.api.routeLoopWatch(routeOrigin,finalPos,routeStarted,bestRemaining) then
forcedUsed=true
stopTween();State.pathCache={t=0}
local simpleOK=State.api.forcedSimpleRoute(finalPos,flag,speed)
if simpleOK then return true end
routeOrigin=(getHRP() and getHRP().Position) or routeOrigin
routeStarted=os.clock()
bestRemaining=(finalPos-routeOrigin).Magnitude
stagnant=0
end
end
end
local h=getHRP()
return h and (h.Position-finalPos).Magnitude<=Cfg.ReachDist+4 or false
end
local function moveTo(pos,flag,speedOverride)
local hrp=getHRP();if not hrp then return false end
flag=flag or function() return true end
if not Cfg.Full3DPath or lineSafe(hrp.Position,pos) then
return moveToRaw(pos,flag,speedOverride)
end
local pts=compute3DPath(hrp.Position,pos,0)
if not pts then return false end
if Cfg.ShowTrajectory then showTrajectory(pts,Color3.fromRGB(120,210,255)) end
return followPointPath(pts,flag,speedOverride,true)
end
local function traceStart() State.items.trace={} end
local function tracePush(pos)
local t=State.items.trace
if #t==0 then t[1]=pos;return end
local last=t[#t]
if (last-pos).Magnitude>=(Cfg.ItemsTraceMinDist or 3) then t[#t+1]=pos end
end
local function traceClear() State.items.trace={} end
local function traceReplayBack(flag,speed)
local t=State.items.trace
if not t or #t<2 then return true end
GUI.setStatus("Voltando ("..(#t-1).." pts)...")
speed=speed or Cfg.WalkSpeed
if Cfg.ShowTrajectory then
local reversed={}
for i=#t,1,-1 do reversed[#reversed+1]=t[i] end
showTrajectory(reversed,Color3.fromRGB(80,200,255))
end
local reversed={}
local hrp=getHRP()
if hrp then reversed[1]=hrp.Position end
for i=#t-1,1,-1 do reversed[#reversed+1]=t[i] end
if #reversed>=2 then
for i=2,#reversed do
if State.dead or (flag and not flag()) then return false end
local target=reversed[i]
if not goToItem3D(target,flag,speed,i-2) then
local h=getHRP()
if not h then return false end
State.pathCache={t=0}
local pts=computeItem3DPath(h.Position,target,i)
if not pts or not followItemPath(pts,flag,speed) then return false end
end
end
end
if Cfg.ShowTrajectory then task.delay(1.5,clearTrajectory) end
return true
end
local function makeOverlapParams()
local op=OverlapParams.new()
op.FilterType=Enum.RaycastFilterType.Exclude
local list={ESP_F,NODE_F,TRAJ_F,OBS_F}
if LP.Character then list[#list+1]=LP.Character end
if State.safePlatform then list[#list+1]=State.safePlatform end
op.FilterDescendantsInstances=list
pcall(function() op.RespectCanCollide=true end)
pcall(function() op.MaxParts=32 end)
return op
end
local function smallObstaclePenaltyAt(pos,radius)
if not Cfg.AvoidSmallParts then return 0 end
radius=radius or math.max(8,Cfg.SmallPartPadding*2)
local ok,parts=pcall(function()
return workspace:GetPartBoundsInRadius(pos,radius,makeOverlapParams())
end)
if not ok or not parts then return 0 end
local penalty=0
for _,obj in ipairs(parts) do
if obj:IsA("BasePart") and obj.CanCollide then
local s=obj.Size
local area=math.max(s.X,s.Z)
if area<=Cfg.SmallPartMaxSize and s.Y<=Cfg.SmallPartMaxHeight and area>=Cfg.SmallPartDetectMinArea then
local d=(obj.Position-pos).Magnitude
penalty=penalty+(1-math.clamp(d/radius,0,1))
end
end
end
return penalty
end
local function isHeightSmallObstacle(obj)
if not obj or not obj:IsA("BasePart") or not obj.CanCollide then return false end
local s=obj.Size
return math.max(s.X,s.Z)<=Cfg.HeightSmallPartMaxSize and s.Y<=Cfg.HeightSmallPartMaxY
end
local function heightAreaClear(pos)
local op=makeOverlapParams()
pcall(function() op.MaxParts=State.mobileLite and 20 or 48 end)
local bodyH=math.max(2.5,Cfg.AgentHeight*.75)
local size=Vector3.new(math.max(2,Cfg.AgentRadius*1.35),bodyH,math.max(2,Cfg.AgentRadius*1.35))
local center=pos+Vector3.new(0,0.4,0)
local ok,parts=pcall(function() return workspace:GetPartBoundsInBox(CFrame.new(center),size,op) end)
if not ok or not parts then return true end
local feetY=pos.Y-standHeight()
for _,obj in ipairs(parts) do
if obj:IsA("BasePart") and obj.CanCollide then
local topY=obj.Position.Y+(obj.Size.Y*.5)
if topY>feetY+0.45 then return false end
end
end
return true
end
local function hasSmallHeightObstacle(pos)
if not Cfg.HeightAwarePath then return false end
local op=makeOverlapParams()
pcall(function() op.MaxParts=State.mobileLite and 20 or 48 end)
local r=Cfg.HeightCheckRadius or 5
local size=Vector3.new(r*2,math.max(Cfg.HeightProbeUp+Cfg.HeightProbeDown,6),r*2)
local center=pos+Vector3.new(0,((Cfg.HeightProbeUp or 10)-(Cfg.HeightProbeDown or 12))/2,0)
local ok,parts=pcall(function() return workspace:GetPartBoundsInBox(CFrame.new(center),size,op) end)
if not ok or not parts then return false end
for _,obj in ipairs(parts) do
if isHeightSmallObstacle(obj) then
local dxz=Vector3.new(obj.Position.X-pos.X,0,obj.Position.Z-pos.Z).Magnitude
if dxz<=r+(math.max(obj.Size.X,obj.Size.Z)/2) then return true,obj end
end
end
return false
end
local function groundForHeightCandidate(pos)
local rp=makeRayParams()
local probe=(Cfg.HeightProbeDown or 12)+(Cfg.HeightMaxAdjust or 10)+6
local hit=workspace:Raycast(pos+Vector3.new(0,2,0),Vector3.new(0,-probe,0),rp)
if not hit then return nil end
return hit.Position+Vector3.new(0,standHeight(),0)
end
local function adjustPathPointHeight(pos,prevPos,nextPos)
if not Cfg.HeightAwarePath then return pos end
local found=hasSmallHeightObstacle(pos)
if not found then
local grounded=groundForHeightCandidate(pos)
if grounded and math.abs(grounded.Y-pos.Y)<=Cfg.HeightStep then return Vector3.new(pos.X,grounded.Y,pos.Z) end
return pos
end
local step=math.max(1,Cfg.HeightStep or 2.5)
local maxAdjust=math.max(step,Cfg.HeightMaxAdjust or 10)
local candidates={}
for y=step,maxAdjust,step do candidates[#candidates+1]=y end
for y=step,maxAdjust,step do candidates[#candidates+1]=-y end
local best,bestScore=nil,math.huge
for _,dy in ipairs(candidates) do
local cand=pos+Vector3.new(0,dy,0)
if dy<0 then
local g=groundForHeightCandidate(cand)
if g then cand=Vector3.new(cand.X,g.Y,cand.Z) end
end
if heightAreaClear(cand) then
local okPrev=not prevPos or volumeClear(prevPos,cand,math.max(1.2,Cfg.AgentRadius*.45))
local okNext=not nextPos or volumeClear(cand,nextPos,math.max(1.2,Cfg.AgentRadius*.45))
if okPrev and okNext then
local score=math.abs(cand.Y-pos.Y)
if dy<0 then score=score+0.35 end
if score<bestScore then bestScore=score;best=cand end
end
end
end
return best or pos
end
local function adjustPathHeights(points)
if not Cfg.HeightAwarePath or not points or #points<2 then return points end
local out={}
for i,p in ipairs(points) do
if i==1 or i==#points then out[i]=p
else out[i]=adjustPathPointHeight(p,out[i-1] or points[i-1],points[i+1]) end
end
return out
end
local function routeClearancePenaltyAt(pos,dir)
local clearance=math.max(3,Cfg.RouteOpenClearance or 7)
local rp=makeRayParams()
local flat=Vector3.new(dir.X,0,dir.Z)
if flat.Magnitude<.05 then flat=Vector3.new(0,0,1) else flat=flat.Unit end
local side=flat:Cross(Vector3.yAxis)
local origin=pos+Vector3.new(0,math.max(1.5,standHeight()*.45),0)
local penalty=0
local function probe(vec,weight)
local hit=workspace:Raycast(origin,vec*clearance,rp)
if hit then
local d=(hit.Position-origin).Magnitude
penalty=penalty+(1-math.clamp(d/clearance,0,1))*weight
end
end
probe(side,1);probe(-side,1)
probe(Vector3.yAxis,.65)
return penalty
end
local function scorePath(points,from,to,agentRadius)
if not points or #points<2 then return math.huge end
local score,totalLen=0,0
local lastDir=nil
local sampleEvery=math.max(1,math.floor((#points-1)/math.max(4,Cfg.RouteScoreSamples or 14)))
for i=1,#points-1 do
local a,b=points[i],points[i+1]
local vec=b-a
local seg=vec.Magnitude
totalLen=totalLen+seg
if not lineSafe(a,b) then score=score+(Cfg.RouteScoreBlockedPenalty or 60)*3 end
if seg>.05 then
local dir=vec.Unit
if lastDir then
local dot=math.clamp(lastDir:Dot(dir),-1,1)
score=score+math.deg(math.acos(dot))*(Cfg.RouteTurnPenalty or .045)
end
score=score+math.abs(vec.Y)*(Cfg.RouteVerticalPenalty or .28)
if i==1 or i==#points-1 or i%sampleEvery==0 then
local mid=(a+b)/2
score=score+routeClearancePenaltyAt(mid,dir)*(Cfg.RouteOpenPenalty or 9)
score=score+smallObstaclePenaltyAt(mid,math.min(Cfg.SmallPartDetectRadius,12))*(Cfg.RouteScoreSmallObsPenalty or 10)
end
lastDir=dir
end
end
score=score+(totalLen*(Cfg.RouteScoreLengthPenalty or .05))
score=score+(#points*(Cfg.RouteScoreWaypointPenalty or 1))
local direct=(to-from).Magnitude
local detour=math.max(0,totalLen-direct)
score=score+(detour*(Cfg.RouteScoreDetourPenalty or 2))
local defaultR=math.max(2,Cfg.AgentRadius or 4)
local usedR=math.max(1.5,agentRadius or defaultR)
if usedR<defaultR then
score=score+((defaultR-usedR)/defaultR)*(Cfg.RouteTightAgentPenalty or 6)
end
return score
end
local function computePathOnce(fromPos,toPos,r,h,w)
local up=Vector3.new(0,standHeight(),0)
local ok,path=pcall(function()
return PathfindingService:CreatePath({
AgentRadius=math.max(2,r),AgentHeight=math.max(2,h),
AgentCanJump=true,AgentCanClimb=false,WaypointSpacing=math.max(2,w),
})
end)
if not ok or not path then return nil end
local ok2=pcall(function() path:ComputeAsync(fromPos-up,toPos-up) end)
if not ok2 or path.Status~=Enum.PathStatus.Success then return nil end
local wps=path:GetWaypoints()
if not wps or #wps<2 then return nil end
local pts={}
for j,wp in ipairs(wps) do pts[j]=wp.Position+up end
pts[1]=fromPos
pts[#pts]=toPos
return pts
end
local function routeBiasPoint(fromPos,toPos,variant)
if not variant or variant<=0 then return nil end
local flat=Vector3.new(toPos.X-fromPos.X,0,toPos.Z-fromPos.Z)
if flat.Magnitude<8 then return nil end
local dir=flat.Unit
local side=dir:Cross(Vector3.yAxis)
local sign=(variant%2==1) and 1 or -1
local level=math.ceil(variant/2)
local offset=10+(level-1)*8
local mid=fromPos+(toPos-fromPos)*0.5+side*(offset*sign)
return snapToGround(mid)
end
computePathSmart=function(fromPos,toPos,overrideAgentHeight,routeVariant)
routeVariant=routeVariant or 0
local cache=State.pathCache
local nowT=os.clock()
if routeVariant==0 and cache.pts and cache.target and cache.from and (nowT-cache.t)<Cfg.PathCacheDuration
and (cache.target-toPos).Magnitude<.5 and (cache.from-fromPos).Magnitude<Cfg.PathCacheMoveTolerance and cache.h==overrideAgentHeight then
return cache.pts,"cached"
end

local baseR=math.max(2,Cfg.AgentRadius or 4)
local baseH=overrideAgentHeight or Cfg.AgentHeight
local baseW=Cfg.WaypointSpacing or 8
local profiles={
{r=baseR,w=baseW,off=0},
{r=math.max(2,baseR-.8),w=math.max(4,baseW-2),off=0},
{r=baseR+.8,w=baseW+2,off=0},
{r=baseR,w=math.max(4,baseW-1),off=14},
{r=baseR,w=math.max(4,baseW-1),off=-14},
{r=math.max(2,baseR-1.2),w=math.max(3,baseW-3),off=28},
{r=math.max(2,baseR-1.2),w=math.max(3,baseW-3),off=-28},
{r=math.max(2,baseR-1.5),w=3,off=0},
}
local maxCandidates=math.clamp(Cfg.RouteCandidateCount or 8,1,#profiles)
local routeDistance=(toPos-fromPos).Magnitude
if State.mobileLite then
maxCandidates=math.min(maxCandidates,routeDistance>180 and 1 or 2)
elseif Cfg.LowLag then
maxCandidates=math.min(maxCandidates,3)
elseif routeDistance>300 then
maxCandidates=math.min(maxCandidates,2)
elseif routeDistance>140 then
maxCandidates=math.min(maxCandidates,3)
end
local flat=Vector3.new(toPos.X-fromPos.X,0,toPos.Z-fromPos.Z)
local dir=flat.Magnitude>.05 and flat.Unit or Vector3.new(0,0,1)
local side=dir:Cross(Vector3.yAxis)
local bestPts,bestScore,bestKind=nil,math.huge,nil

for i=1,maxCandidates do
local pr=profiles[i]
local pts=nil
if pr.off~=0 and flat.Magnitude>16 then
local ratio=.5
if routeVariant>0 then ratio=.42+((routeVariant%3)*.08) end
local bias=fromPos+(toPos-fromPos)*ratio+side*pr.off
bias=snapToGround(bias)
if pointVolumeClear(bias,math.max(1.5,pr.r*.45)) then
local a=computePathOnce(fromPos,bias,pr.r,baseH,pr.w)
local b=a and computePathOnce(bias,toPos,pr.r,baseH,pr.w)
if a and b then
pts={}
for _,p in ipairs(a) do pts[#pts+1]=p end
for j=2,#b do pts[#pts+1]=b[j] end
end
end
else
pts=computePathOnce(fromPos,toPos,pr.r,baseH,pr.w)
end

if pts and #pts>=2 then
pts=adjustPathHeights(pts)
pts=smoothPath(pts)
pts=adjustPathHeights(pts)
local score=scorePath(pts,fromPos,toPos,pr.r)
if score<bestScore then
bestScore=score;bestPts=pts
bestKind=pr.off==0 and ("direct-r"..string.format("%.1f",pr.r)) or ("bias"..pr.off)
end
end
end

if bestPts then
if routeVariant==0 then
State.pathCache={target=toPos,from=fromPos,pts=bestPts,t=nowT,h=overrideAgentHeight,score=bestScore}
end
State.api.routeDebug(toPos,bestPts[math.min(2,#bestPts)],"Smart route • "..tostring(bestKind).." • score "..string.format("%.1f",bestScore),nil)
return bestPts,"smart"
end
return nil,"nopath"
end
local function goTo(target,flag,speed,overrideAgentHeight,firstVariant)
if not inMapRange(target) then GUI.setStatus("Target outside Map range");return false end
local hrp=getHRP();if not hrp then return false end
local finalPos=safeTargetHeight(target)
local maxRetries=math.max(1,Cfg.SmartRouteRetries or 4)
local baseVariant=firstVariant or 0
local routeOrigin=hrp.Position
local routeStarted=os.clock()
local bestRemaining=(finalPos-routeOrigin).Magnitude
local forcedUsed=false
for retry=0,maxRetries-1 do
if not flag() or State.dead then return false end
if not lockedDoorValid() then stopTween();State.pathCache={t=0};return false end
hrp=getHRP();if not hrp then return false end
if (finalPos-hrp.Position).Magnitude<=Cfg.ReachDist+1 then return true end
local variant=baseVariant+retry
State.pathCache={t=0}
if needs3DRoute(hrp.Position,finalPos) then
local airPts=compute3DPath(hrp.Position,finalPos,variant)
if airPts then
if Cfg.ShowTrajectory then showTrajectory(airPts,Color3.fromRGB(120,210,255)) end
local ok3d=followPointPath(airPts,flag,speed,true)
local h3=getHRP()
if ok3d and h3 and (finalPos-h3.Position).Magnitude<=Cfg.ReachDist+3 then return true end
end
end
hrp=getHRP();if not hrp then return false end
if lineSafe(hrp.Position,finalPos) and retry==0 then
if Cfg.ShowTrajectory then showTrajectory({hrp.Position,finalPos}) end
if moveToRaw(finalPos,flag,speed) then return true end
end
hrp=getHRP();if not hrp then return false end
local pts=computePathSmart(hrp.Position,finalPos,overrideAgentHeight,variant)
if pts then
if Cfg.ShowTrajectory then showTrajectory(pts) end
local pathOK=followPointPath(pts,flag,speed,false)
local h2=getHRP()
if h2 and (finalPos-h2.Position).Magnitude<=Cfg.ReachDist+3 then
if Cfg.ShowTrajectory then task.delay(0.8,clearTrajectory) end
return true
end
if pathOK and h2 and lineSafe(h2.Position,finalPos) and moveToRaw(finalPos,flag,speed) then return true end
end
stopTween();State.pathCache={t=0}
local wh=getHRP()
if wh then
local rem=(finalPos-wh.Position).Magnitude
if rem<bestRemaining then bestRemaining=rem end
if not forcedUsed and State.api.routeLoopWatch(routeOrigin,finalPos,routeStarted,bestRemaining) then
forcedUsed=true
local simpleOK=State.api.forcedSimpleRoute(finalPos,flag,speed)
if simpleOK then return true end
-- Reset the watchdog once after forced fallback so normal retries do not
-- instantly trigger it again.
routeOrigin=(getHRP() and getHRP().Position) or routeOrigin
routeStarted=os.clock()
bestRemaining=(finalPos-routeOrigin).Magnitude
end
end
task.wait(Cfg.SmartRouteRetryDelay or 0.08)
end
return false
end
local function doorSnapshot(model)
if not model or not model.Parent then return nil end
local part=getDoorPart(model)
local timer=doorTimer(model)
return {timer=timer,wasZero=timerZero(timer),parent=model.Parent,pos=part and part.Position or nil}
end
local function doorGone(model,snap)
if not snap then return false end
if not model or not model.Parent then return true end
if model.Parent~=snap.parent then return true end
if snap.wasZero and not timerZero(doorTimer(model)) then return true end
local part=getDoorPart(model)
if not part then return true end
if snap.pos and (part.Position-snap.pos).Magnitude>20 then return true end
return false
end
local function boostPrompt(p)
pcall(function() p.Enabled=true end)
pcall(function() p.MaxActivationDistance=math.max(p.MaxActivationDistance or 10,100) end)
pcall(function() p.RequiresLineOfSight=false end)
pcall(function() p.HoldDuration=0 end)
pcall(function() p.ClickablePrompt=true end)
end
local function promptKey(p)
local k=Enum.KeyCode.E
pcall(function()
if p.KeyboardKeyCode and p.KeyboardKeyCode~=Enum.KeyCode.Unknown then k=p.KeyboardKeyCode end
end)
return k
end
local function firePromptInstant(p)
if not p or not p.Parent or not p:IsA("ProximityPrompt") then return false end
local now=os.clock();local last=State.promptLast[p] or 0
if now-last<math.max(.05,Cfg.InteractRetryDelay*.4) then return false end
State.promptLast[p]=now;boostPrompt(p)
local fired=false
-- Executor API first, but never trust a successful pcall as proof that the prompt actually triggered.
if EXE.fireprompt then
local ok=pcall(function() EXE.fireprompt(p,0) end)
if not ok then ok=pcall(function() EXE.fireprompt(p) end) end
fired=fired or ok
end
-- Native prompt path works on some executors where fireproximityprompt is missing/no-op.
local okNative=pcall(function()
p.HoldDuration=0
p:InputHoldBegin()
task.wait(.025)
p:InputHoldEnd()
end)
fired=fired or okNative
-- Keyboard fallback for PC/mobile executors exposing VirtualInputManager.
if VIM then
local key=promptKey(p)
local okKey=pcall(function()
VIM:SendKeyEvent(true,key,false,game);task.wait(.03);VIM:SendKeyEvent(false,key,false,game)
end)
fired=fired or okKey
if key~=Enum.KeyCode.E then
local okE=pcall(function()
VIM:SendKeyEvent(true,Enum.KeyCode.E,false,game);task.wait(.03);VIM:SendKeyEvent(false,Enum.KeyCode.E,false,game)
end)
fired=fired or okE
end
end
return fired
end
local function collectPrompts(model)
local list={}
if not model then return list end
for _,p in ipairs(model:GetDescendants()) do
if p:IsA("ProximityPrompt") then list[#list+1]=p end
end
return list
end
local function interactUntilGone(model,maxSeconds)
maxSeconds=maxSeconds or Cfg.InteractTimeout
if State.afdActive then maxSeconds=math.min(maxSeconds,Cfg.FalseDoorTimeout) end
if not model or not model.Parent then return true end
local snap=doorSnapshot(model)
local prompts=collectPrompts(model)
local t0=os.clock()
while os.clock()-t0<maxSeconds do
if State.dead or not (State.flags.Farm or State.flags.Blatant) then return false end
if doorGone(model,snap) then return true end
if #prompts==0 then prompts=collectPrompts(model) end
for _,p in ipairs(prompts) do
if p and p.Parent then firePromptInstant(p) end
end
if doorGone(model,snap) then return true end
task.wait(Cfg.InteractRetryDelay)
end
task.wait(Cfg.DoorOpenCheckDelay or 0.18)
return doorGone(model,snap)
end
local function openDoor(d)
GUI.setStatus("Opening ("..tostring(d.Timer)..")...")
local gone=interactUntilGone(d.Model,Cfg.InteractTimeout)
if gone then coolSuccess(d.Part.Position);GUI.setStatus("Door used!");return true end
failDoor(d,true);GUI.setStatus("Failed to open");return false
end
local function blatantTween(pos,flag,isSky)
flag=flag or function() return State.flags.Blatant end
if isSky then
return goTo(pos,flag,Cfg.BlatantSpeed,Cfg.BlatantHeight)
end
return goTo(pos,flag,Cfg.BlatantSpeed,nil,0)
end
local function rotateFlat(v,deg)
local r=math.rad(deg)
local c,si=math.cos(r),math.sin(r)
return Vector3.new(v.X*c-v.Z*si,0,v.X*si+v.Z*c)
end
local function standPosRoute(d,dist,attempt)
local base=standPos(d,dist)
if not attempt or attempt<=1 then return base end
local part=d.Part
local v=Vector3.new(base.X-part.Position.X,0,base.Z-part.Position.Z)
if v.Magnitude<0.1 then v=doorNormal(part)*dist end
local angles={0,55,-55,110,-110,180}
local angle=angles[((attempt-1)%#angles)+1] or 0
local rv=rotateFlat(v.Unit,angle)*(dist+math.min((attempt-1)*0.5,2))
return Vector3.new(part.Position.X+rv.X,part.Position.Y,part.Position.Z+rv.Z)
end
function State.api.autoBlatantForward(d,attempt)
if not Cfg.BlatantAutoForward or not d or not d.Part then return Cfg.BlatantForward end
local hrp=getHRP();if not hrp then return Cfg.BlatantForward end
local a=standPosRoute(d,-5,attempt)
local b=standPosRoute(d,5,attempt)
local sa=(lineSafe(hrp.Position,a) and 0 or 1000)+(a-hrp.Position).Magnitude
local sb=(lineSafe(hrp.Position,b) and 0 or 1000)+(b-hrp.Position).Magnitude
local chosen
if math.abs(sa-sb)<1 then
chosen=((attempt or 1)%2==0) and -5 or 5
else
chosen=sa<sb and -5 or 5
end
Cfg.BlatantForward=chosen
State.api.routeDebug(d.Part.Position,chosen==-5 and a or b,"Blatant auto FWD "..chosen,nil)
return chosen
end
local function faceDoor(d)
local hrp=getHRP();if not hrp or not d then return end
local anchor=State.api.getBlatantDoorAnchor(d) or d.Part
if not anchor then return end
pcall(function()
local look=Vector3.new(anchor.Position.X,hrp.Position.Y,anchor.Position.Z)
if (look-hrp.Position).Magnitude>0.05 then hrp.CFrame=CFrame.lookAt(hrp.Position,look) end
hrp.AssemblyLinearVelocity=Vector3.zero
hrp.AssemblyAngularVelocity=Vector3.zero
end)
end
local function findBlatantSky(startPos,endPos)
local baseY=math.max(startPos.Y,endPos.Y)+(Cfg.BlatantHeight or 100)
local step=Cfg.BlatantExtraHeightStep or 35
local tries=Cfg.BlatantMaxHeightTries or 8
local bestY=baseY
for i=0,tries-1 do
local y=baseY+i*step
local a=Vector3.new(startPos.X,y,startPos.Z)
local b=Vector3.new(endPos.X,y,endPos.Z)
bestY=y
if lineSafe(a,b) then return y,a,b,true end
end
return nil,nil,nil,false
end
local function getNearbySkyObstacle(hrp,targetPos)
if not hrp or not hrp.Parent then return nil end
local radius=Cfg.BlatantSkyObstacleRadius or 14
local rp=makeRayParams()
local toTarget=targetPos-hrp.Position
if toTarget.Magnitude<.1 then return nil end
local dir=toTarget.Unit
local flat=Vector3.new(dir.X,0,dir.Z)
local side=flat.Magnitude>.05 and flat.Unit:Cross(Vector3.yAxis) or hrp.CFrame.RightVector
local checks={
dir*radius,
(dir+side*.22).Unit*radius,
(dir-side*.22).Unit*radius,
(dir+Vector3.new(0,.18,0)).Unit*radius,
(dir+Vector3.new(0,-.18,0)).Unit*radius,
}
local nearest,nearestDist=nil,math.huge
for _,vec in ipairs(checks) do
local hit=workspace:Raycast(hrp.Position,vec,rp)
if hit and hit.Instance and hit.Instance:IsA("BasePart") then
local dist=(hit.Position-hrp.Position).Magnitude
if dist<nearestDist then nearest=hit;nearestDist=dist end
end
end
if nearest then return nearest.Instance,nearest.Position,nearest.Normal,nearestDist end
return nil
end
local function blatantRouteShifted(routeStart,targetPos,lastPos)
local hrp=getHRP();if not hrp then return false end
local cur=hrp.Position
if not routeStart or not targetPos then return false end
local total=targetPos-routeStart
if total.Magnitude<1 then return false end
local dir=total.Unit
local rel=cur-routeStart
local progress=rel:Dot(dir)
local closest=routeStart+dir*math.clamp(progress,0,total.Magnitude)
local lateral=(cur-closest).Magnitude
local backwards=0
if lastPos then
local delta=cur-lastPos
backwards=math.max(0,-delta:Dot(dir))
end
return lateral>=(Cfg.BlatantUnexpectedShift or 32) or backwards>=(Cfg.BlatantBackwardShift or 18)
end
State.api.blatantMoveSegment=function(pos,flag,speed,mode)
flag=flag or function() return State.flags.Blatant end
local hrp=getHRP();if not hrp or not hrp.Parent then return false,"no hrp" end
local start=hrp.Position
local dist=(pos-start).Magnitude
if dist<=Cfg.ReachDist+2 then return true,"reached" end
speed=math.max(speed or Cfg.BlatantSpeed or 100,1)
if mode=="ground" then speed=State.api.doorSlowSpeed(speed) end
local dur=math.clamp(dist/speed,0.05,6)
local flat=Vector3.new(pos.X-start.X,0,pos.Z-start.Z)
local cf=(flat.Magnitude>.05) and CFrame.lookAt(pos,pos+flat) or CFrame.new(pos)
stopTween()
local tw=TweenService:Create(hrp,TweenInfo.new(dur,Enum.EasingStyle.Linear),{CFrame=cf})
State.activeTween=tw
local done=false
local conn=tw.Completed:Connect(function() done=true end)
tw:Play()
local t0=os.clock()
local lastCheck=t0
local lastPos=start
local lastObstacle=t0
local bestRemaining=dist
while not done and os.clock()-t0<dur+0.75 do
if State.dead or not flag() then
pcall(function() tw:Cancel() end)
pcall(function() conn:Disconnect() end)
if State.activeTween==tw then State.activeTween=nil end
return false,"canceled"
end
local ld=State.lockedDoor
if ld and (not ld.Model or not ld.Model.Parent) then
pcall(function() tw:Cancel() end)
pcall(function() conn:Disconnect() end)
if State.activeTween==tw then State.activeTween=nil end
return false,"door gone"
end
local cur=getHRP()
if not cur or cur~=hrp then
pcall(function() tw:Cancel() end)
pcall(function() conn:Disconnect() end)
if State.activeTween==tw then State.activeTween=nil end
return false,"character changed"
end
local now=os.clock()
local remaining=(pos-cur.Position).Magnitude
if remaining<bestRemaining then bestRemaining=remaining end
if now-lastCheck>=0.55 then
local moved=(cur.Position-lastPos).Magnitude
if moved<0.35 and remaining>Cfg.ReachDist+3 then
pcall(function() tw:Cancel() end)
pcall(function() conn:Disconnect() end)
if State.activeTween==tw then State.activeTween=nil end
return false,"stuck"
end
lastPos=cur.Position;lastCheck=now
end
if mode=="air" and now-lastObstacle>=(Cfg.BlatantSegmentCheckInterval or .14) and remaining>8 then
lastObstacle=now
local hit=volumeHit(cur.Position,pos,math.max(1.4,(Cfg.AirPathRadius or 2.4)*.75))
if hit and hit.Position then
local hitDist=(hit.Position-cur.Position).Magnitude
if hitDist<remaining-5 then
pcall(function() tw:Cancel() end)
pcall(function() conn:Disconnect() end)
if State.activeTween==tw then State.activeTween=nil end
return false,"blocked"
end
end
end
pcall(function()
cur.AssemblyLinearVelocity=Vector3.zero
cur.AssemblyAngularVelocity=Vector3.zero
end)
task.wait(Cfg.RuntimeTick or .02)
end
pcall(function() conn:Disconnect() end)
if State.activeTween==tw then State.activeTween=nil end
local h=getHRP()
if h and (h.Position-pos).Magnitude<=Cfg.ReachDist+4 then return true,"ok" end
return false,"incomplete"
end

State.api.followBlatantPoints=function(points,flag,speed)
if not points or #points<2 then return false,"no points" end
for i=2,#points do
if State.dead or not flag() then return false,"canceled" end
local p=points[i]
State.api.routeDebug(points[#points],p,"Blatant air waypoint "..i.."/"..#points,nil)
if Cfg.ShowTrajectory then showTrajectory(points,Color3.fromRGB(255,160,60)) end
local ok,why=State.api.blatantMoveSegment(p,flag,speed or Cfg.BlatantSpeed,"air")
if not ok then return false,why end
end
return true,"ok"
end

State.api.blatantRecover=function(targetPos,flag,reason)
local hrp=getHRP();if not hrp then return false end
local cur=hrp.Position
local toTarget=Vector3.new(targetPos.X-cur.X,0,targetPos.Z-cur.Z)
if toTarget.Magnitude<.1 then toTarget=Vector3.new(hrp.CFrame.LookVector.X,0,hrp.CFrame.LookVector.Z) end
if toTarget.Magnitude<.1 then toTarget=Vector3.new(0,0,1) end
local dir=toTarget.Unit
local side=dir:Cross(Vector3.yAxis)
local sideAmt=Cfg.BlatantRecoverySide or 16
local backAmt=Cfg.BlatantRecoveryBack or 12
local high=groundDistanceAt(cur,500)>(Cfg.AirGroundThreshold or 12)
local raw={
cur-dir*backAmt,
cur+side*sideAmt,
cur-side*sideAmt,
cur-dir*backAmt+side*(sideAmt*.65),
cur-dir*backAmt-side*(sideAmt*.65),
}
GUI.setStatus("Blatant: recovering route"..(reason and (" ("..tostring(reason)..")") or "").."...")
for _,candidate in ipairs(raw) do
if not high then candidate=snapToGround(candidate) end
if pointVolumeClear(candidate,math.max(1.4,Cfg.AgentRadius*.55)) and lineSafe(cur,candidate) then
local ok=State.api.blatantMoveSegment(candidate,flag,math.min(Cfg.BlatantSpeed,140),high and "air" or "ground")
if ok then State.pathCache={t=0};return true end
end
end
State.pathCache={t=0}
return false
end

State.api.moveBlatantSky=function(targetPos,flag)
local hrp=getHRP();if not hrp then return false,false,"no hrp" end
local deadline=os.clock()+math.max(5,Cfg.BlatantStageTimeout or 12)
local bestRemaining=(targetPos-hrp.Position).Magnitude
local lastProgress=os.clock()
local fails=0
local chunk=math.max(80,Cfg.BlatantLongRouteChunk or 180)
while flag() and not State.dead do
hrp=getHRP();if not hrp then return false,false,"no hrp" end
local delta=targetPos-hrp.Position
local remaining=delta.Magnitude
if remaining<=Cfg.ReachDist+3 then return true,false,"ok" end
if os.clock()>deadline then return false,false,"stage timeout" end
if remaining<bestRemaining-(Cfg.BlatantMinProgress or 1.25) then
bestRemaining=remaining;lastProgress=os.clock();fails=0
elseif os.clock()-lastProgress>(Cfg.BlatantProgressTimeout or 3.0) then
return false,false,"no progress"
end
local stepTarget=targetPos
if remaining>chunk then
stepTarget=hrp.Position+delta.Unit*chunk
State.api.routeDebug(targetPos,stepTarget,("Blatant rolling %.0f studs"):format(remaining),nil)
end
local moved=false
local why="blocked"
if lineSafe(hrp.Position,stepTarget) then
moved,why=State.api.blatantMoveSegment(stepTarget,flag,Cfg.BlatantSpeed,"air")
else
local pts=compute3DPath(hrp.Position,stepTarget,fails)
if pts then moved,why=State.api.followBlatantPoints(pts,flag,Cfg.BlatantSpeed) end
end
if moved then
fails=0
local now=getHRP()
if now then
local rem=(targetPos-now.Position).Magnitude
if rem<bestRemaining then bestRemaining=rem;lastProgress=os.clock() end
end
else
fails+=1
stopTween();State.pathCache={t=0}
if fails>=(Cfg.BlatantMaxSegmentFails or 3) then
return false,false,why or "segment failed"
end
State.api.blatantRecover(stepTarget,flag,why)
task.wait(Cfg.SmartRouteRetryDelay or .08)
end
end
return false,false,"stopped"
end

local function descentColumnClear(skyPos,groundPos)
local clearance=Cfg.BlatantDescentClearance or 4
local top=Vector3.new(groundPos.X,skyPos.Y,groundPos.Z)
local bottom=groundPos+Vector3.new(0,math.max(clearance,standHeight()+0.5),0)
local delta=bottom-top
if delta.Magnitude<1 then return true end
local rp=makeRayParams()
local radius=math.clamp(math.max(1.5,Cfg.AgentRadius*0.7),1.5,4)
local ok,hit=pcall(function() return workspace:Spherecast(top,radius,delta,rp) end)
if ok then return hit==nil end
return lineSafe(top,bottom)
end
local function findOpenDescentPoint(skyPos,finalPos,d)
local exactGround=snapToGround(finalPos)
if descentColumnClear(skyPos,exactGround) then
return Vector3.new(exactGround.X,skyPos.Y,exactGround.Z),exactGround,true
end
local maxR=Cfg.BlatantDescentSearchRadius or 60
local step=Cfg.BlatantDescentStep or 12
local back=nil
if d and d.Part then
local n=doorNormal(d.Part)
back=-n
end
local dirs
if back and back.Magnitude>.1 then
local side=back:Cross(Vector3.yAxis)
dirs={back,side,-side,(back+side).Unit,(back-side).Unit,-back,(-back+side).Unit,(-back-side).Unit}
else
dirs={
Vector3.new(1,0,0),Vector3.new(-1,0,0),Vector3.new(0,0,1),Vector3.new(0,0,-1),
Vector3.new(1,0,1).Unit,Vector3.new(-1,0,1).Unit,
Vector3.new(1,0,-1).Unit,Vector3.new(-1,0,-1).Unit,
}
end
local bestSky,bestGround,bestScore=nil,nil,math.huge
for r=step,maxR,step do
for index,dir in ipairs(dirs) do
local probe=finalPos+dir*r
if inMapRange(probe) then
local ground=snapToGround(probe)
local above=Vector3.new(ground.X,skyPos.Y,ground.Z)
if pointVolumeClear(above,math.max(1.4,Cfg.AgentRadius*.55)) and descentColumnClear(above,ground) then
local routeOK=lineSafe(ground,finalPos)
local score=r+(routeOK and 0 or 24)+(index-1)*.35
if score<bestScore then
bestScore=score;bestSky=above;bestGround=ground
if routeOK and r<=step*2 then return bestSky,bestGround,false end
end
end
end
end
if bestSky and r>=step*3 then break end
end
return bestSky,bestGround,false
end
State.api.smoothBlatantReturn=function(hrp,groundPos,flag)
if not hrp or not hrp.Parent then return false end
flag=flag or function() return true end
local start=hrp.Position
if (start-groundPos).Magnitude<2 then
return State.api.blatantMoveSegment(groundPos,flag,math.min(Cfg.BlatantSpeed,120),"air")
end
local above=Vector3.new(groundPos.X,start.Y,groundPos.Z)
if (above-start).Magnitude>Cfg.ReachDist+2 then
if not lineSafe(start,above) then return false end
local ok=State.api.blatantMoveSegment(above,flag,Cfg.BlatantSpeed,"air")
if not ok then return false end
end
local cur=getHRP();if not cur then return false end
if not descentColumnClear(cur.Position,groundPos) then return false end
GUI.setStatus("Blatant: descending...")
local height=math.abs(cur.Position.Y-groundPos.Y)
if Cfg.SmoothGroundReturn and height>30 then
local mid=Vector3.new(groundPos.X,groundPos.Y+math.max(10,height*.42),groundPos.Z)
if mid.Y<cur.Position.Y-4 and pointVolumeClear(mid,math.max(1.4,Cfg.AgentRadius*.55)) then
local ok=State.api.blatantMoveSegment(mid,flag,Cfg.BlatantSpeed,"air")
if not ok then return false end
end
end
local ok=State.api.blatantMoveSegment(groundPos,flag,math.min(Cfg.BlatantSpeed,130),"air")
local h=getHRP()
if ok and h then pcall(function() h.AssemblyLinearVelocity=Vector3.zero;h.AssemblyAngularVelocity=Vector3.zero end) end
return ok
end
function State.api.blatantVerticalClear(pos,skyY)
if not pos or not skyY or skyY<=pos.Y+2 then return true,nil end
local rp=makeRayParams()
local start=pos+Vector3.new(0,math.max(1,standHeight()*0.35),0)
local delta=Vector3.new(0,math.max(1,skyY-start.Y),0)
local radius=math.clamp(Cfg.BlatantCeilingProbeRadius or 3,1.25,5)
local ok,hit=pcall(function() return workspace:Spherecast(start,radius,delta,rp) end)
if ok then return hit==nil,hit end
local ray=workspace:Raycast(start,delta,rp)
return ray==nil,ray
end
function State.api.escapeBlatantCeiling(finalPos,flag)
if not Cfg.BlatantCeilingEscape then return true,nil end
local hrp=getHRP();if not hrp then return false,"no hrp" end
local targetSkyY=math.max(hrp.Position.Y,finalPos.Y)+(Cfg.BlatantHeight or 100)+(Cfg.BlatantCeilingClearance or 8)
local clear,hit=State.api.blatantVerticalClear(hrp.Position,targetSkyY)
if clear then return true,nil end
GUI.setStatus("Blatant: teto acima — procurando saída aberta...")
State.api.routeDebug(finalPos,hrp.Position,"Ceiling blocked: searching open column",hit and hit.Position or hrp.Position)
local base=hrp.Position
local toFinal=Vector3.new(finalPos.X-base.X,0,finalPos.Z-base.Z)
local forward=toFinal.Magnitude>.1 and toFinal.Unit or Vector3.new(hrp.CFrame.LookVector.X,0,hrp.CFrame.LookVector.Z)
if forward.Magnitude<.1 then forward=Vector3.new(0,0,1) else forward=forward.Unit end
local side=Vector3.new(-forward.Z,0,forward.X)
local dirs={forward,side,-side,-forward,(forward+side).Unit,(forward-side).Unit,(-forward+side).Unit,(-forward-side).Unit}
local step=math.max(6,Cfg.BlatantCeilingSearchStep or 12)
local maxR=math.max(step,Cfg.BlatantCeilingSearchRadius or 96)
local candidates={}
for r=step,maxR,step do
for _,dir in ipairs(dirs) do
local probe=base+dir*r
local open=State.api.blatantVerticalClear(probe,targetSkyY)
if open and pointVolumeClear(probe,math.max(1.5,Cfg.AgentRadius*.55)) then
local direct=lineSafe(base,probe)
local score=r+(direct and 0 or 30)+(probe-finalPos).Magnitude*.01
candidates[#candidates+1]={p=probe,score=score,direct=direct}
end
end
if #candidates>=6 then break end
end
table.sort(candidates,function(a,b) return a.score<b.score end)
for i=1,math.min(#candidates,10) do
if not flag() or State.dead then return false,"canceled" end
local c=candidates[i]
GUI.setStatus(("Blatant: saindo do teto %d/%d..."):format(i,math.min(#candidates,10)))
State.api.routeDebug(finalPos,c.p,"Ceiling escape",hit and hit.Position or nil)
State.pathCache={t=0}
local moved=false
if c.direct then
moved=select(1,State.api.blatantMoveSegment(c.p,flag,math.min(Cfg.BlatantSpeed,140),"air"))
else
local pts=compute3DPath(getHRP().Position,c.p,i-1)
if pts then moved=select(1,State.api.followBlatantPoints(pts,flag,Cfg.BlatantSpeed)) end
if not moved then moved=select(1,State.api.blatantMoveSegment(c.p,flag,math.min(Cfg.BlatantSpeed,140),"air")) end
end
local h=getHRP()
if moved and h then
local nowClear=State.api.blatantVerticalClear(h.Position,targetSkyY)
if nowClear then
GUI.setStatus("Blatant: área aberta encontrada — subindo...")
State.pathCache={t=0}
return true,c.p
end
end
end
return false,"no open ceiling exit"
end
function State.api.blatantDoorHeadroom(d,groundPos)
if not d or not d.Part or not groundPos then return false end
local rp=makeRayParams()
local need=math.max(standHeight()+2,Cfg.BlatantCeilingClearance or 8)
local start=groundPos+Vector3.new(0,.5,0)
local hit=workspace:Raycast(start,Vector3.new(0,need,0),rp)
if not hit then return true end
-- A low ceiling directly above the stand point means we must approach from ground,
-- not descend through the geometry.
return (hit.Position-start).Magnitude>=standHeight()+1
end
function State.api.blatantFinalGround(d,stand)
local ground=snapToGround(stand)
if not State.api.blatantDoorHeadroom(d,ground) then
-- Search a few nearby grounded stand points with headroom.
local base=ground
for r=3,12,3 do
for i=0,7 do
local a=(math.pi*2)*(i/8)
local p=snapToGround(base+Vector3.new(math.cos(a)*r,0,math.sin(a)*r))
if State.api.blatantDoorHeadroom(d,p) then return p end
end
end
end
return ground
end
function State.api.blatantDoorFront(d)
local geo=State.api.blatantDoorGeometry(d)
return geo and geo.Target or nil
end

function State.api.blatantExactDoorStand(d,flag)
flag=flag or function() return State.flags.Blatant and not State.dead end
local geo=State.api.blatantDoorGeometry(d)
if not geo then return false,"no union geometry" end
local target=geo.Target
local anchor=geo.Anchor
local hrp=getHRP();if not hrp then return false,"no hrp" end

local flatDelta=Vector3.new(target.X-hrp.Position.X,0,target.Z-hrp.Position.Z)
local yDelta=math.abs(target.Y-hrp.Position.Y)
local dist=(target-hrp.Position).Magnitude

-- Pathfinding/tweening may stop a little early. Correct only the final short,
-- clear segment to the exact 3-stud point.
if flatDelta.Magnitude>.30 or yDelta>.65 then
if dist>24 then return false,"final correction too far" end
if not lineSafe(hrp.Position,target) then return false,"final correction blocked" end

local lookAt=Vector3.new(anchor.Position.X,target.Y,anchor.Position.Z)
local goalCF=(lookAt-target).Magnitude>.05 and CFrame.lookAt(target,lookAt) or CFrame.new(target)
local duration=math.clamp(dist/math.max(90,Cfg.BlatantSpeed or 100),.04,.22)
stopTween()
local tw=TweenService:Create(hrp,TweenInfo.new(duration,Enum.EasingStyle.Linear),{CFrame=goalCF})
State.activeTween=tw
local done=false
local conn=tw.Completed:Connect(function() done=true end)
tw:Play()
local t0=os.clock()
while not done and os.clock()-t0<duration+.25 do
if State.dead or not flag() or not d.Model or not d.Model.Parent then
pcall(function() tw:Cancel() end)
pcall(function() conn:Disconnect() end)
if State.activeTween==tw then State.activeTween=nil end
return false,"final correction canceled"
end
task.wait(Cfg.RuntimeTick or .02)
end
pcall(function() conn:Disconnect() end)
if State.activeTween==tw then State.activeTween=nil end
end

hrp=getHRP();if not hrp then return false,"no hrp" end

-- Lock the final CFrame to remove tween/path precision drift.
local finalLook=Vector3.new(anchor.Position.X,target.Y,anchor.Position.Z)
pcall(function()
hrp.CFrame=(finalLook-target).Magnitude>.05 and CFrame.lookAt(target,finalLook) or CFrame.new(target)
hrp.AssemblyLinearVelocity=Vector3.zero
hrp.AssemblyAngularVelocity=Vector3.zero
end)

-- Validate against the Union FACE, not its center.
local posFlat=Vector3.new(hrp.Position.X,0,hrp.Position.Z)
local faceFlat=Vector3.new(geo.Face.X,0,geo.Face.Z)
local delta=posFlat-faceFlat
local along=delta:Dot(geo.Look)
local side=(delta-geo.Look*along).Magnitude

if math.abs(along-geo.StandDistance)>.75 or side>.75 then
return false,("front validation failed %.2f/%.2f"):format(along,side)
end
return true,"exact front"
end

function State.api.blatantRiseToSky(flag)
local hrp=getHRP();if not hrp then return false,"no hrp",nil end
local baseY=hrp.Position.Y+(Cfg.BlatantHeight or 100)
local dummy=hrp.Position+hrp.CFrame.LookVector*8

-- Never rise through a ceiling. If blocked, first move to a nearby column that is clear.
local clear=State.api.blatantVerticalClear(hrp.Position,baseY)
if not clear then
local escaped,why=State.api.escapeBlatantCeiling(dummy,flag)
if not escaped then return false,why or "ceiling blocked",nil end
hrp=getHRP();if not hrp then return false,"no hrp",nil end
baseY=hrp.Position.Y+(Cfg.BlatantHeight or 100)
clear=State.api.blatantVerticalClear(hrp.Position,baseY)
if not clear then return false,"rise column blocked",nil end
end

local sky=Vector3.new(hrp.Position.X,baseY,hrp.Position.Z)
GUI.setStatus("Blatant: rising...")
local ok,why=State.api.blatantMoveSegment(sky,flag,Cfg.BlatantSpeed,"air")
if not ok then return false,"rise: "..tostring(why),nil end
return true,"ok",sky.Y
end

function State.api.blatantDescendAtDoor(d,skyY,flag)
if not d or not d.Model or not d.Model.Parent then return false,"door gone" end
local front=State.api.blatantDoorFront(d)
if not front then return false,"no front point" end

local above=Vector3.new(front.X,skyY,front.Z)
local hrp=getHRP();if not hrp then return false,"no hrp" end

-- First align over the door-front point.
if (above-hrp.Position).Magnitude>Cfg.ReachDist+3 then
GUI.setStatus("Blatant: moving above door...")
local ok,shifted,why=State.api.moveBlatantSky(above,flag)
if not ok then return false,why or (shifted and "sky route shifted" or "sky route blocked") end
end

hrp=getHRP();if not hrp then return false,"no hrp" end
local headroom=State.api.blatantDoorHeadroom(d,front)
local directClear=headroom and descentColumnClear(hrp.Position,front)

if directClear then
GUI.setStatus("Blatant: descending in front of door...")
if not State.api.smoothBlatantReturn(hrp,front,flag) then return false,"door descent failed" end
else
-- Surface/roof below: retreat sideways/backward to a genuinely open vertical column,
-- descend there, then approach the door from ground level.
GUI.setStatus("Blatant: surface below • finding open side...")
State.api.routeDebug(front,hrp.Position,"Blocked below → open-side descent",hrp.Position)
local openSky,openGround=findOpenDescentPoint(hrp.Position,front,d)
if not openSky or not openGround then return false,"no open descent side" end

if (openSky-hrp.Position).Magnitude>Cfg.ReachDist+2 then
GUI.setStatus("Blatant: retreating to open side...")
local moved,_,why=State.api.moveBlatantSky(openSky,flag)
if not moved then return false,why or "open-side retreat failed" end
end

hrp=getHRP();if not hrp then return false,"no hrp" end
if not descentColumnClear(hrp.Position,openGround) then return false,"open-side column became blocked" end

GUI.setStatus("Blatant: open side found • descending...")
if not State.api.smoothBlatantReturn(hrp,openGround,flag) then return false,"open-side descent failed" end

-- Finish from the ground rather than clipping through the surface.
GUI.setStatus("Blatant: ground approach to door...")
State.pathCache={t=0}
local groundTarget=State.api.blatantFinalGround(d,front)
if not goTo(groundTarget,flag,math.min(Cfg.BlatantSpeed,120),nil,0) then
return false,"ground approach failed"
end
if (groundTarget-front).Magnitude>1.5 and lineSafe(groundTarget,front) and State.api.blatantDoorHeadroom(d,front) then
State.api.blatantMoveSegment(front,flag,math.min(Cfg.BlatantSpeed,100),"ground")
end
end

hrp=getHRP()
if not hrp then return false,"no hrp" end

GUI.setStatus("Blatant: correcting exact Union front • 3 studs...")
local exactOK,exactWhy=State.api.blatantExactDoorStand(d,flag)
if not exactOK then return false,exactWhy or "could not lock exact door front" end

faceDoor(d)
return true,"exact front"
end
local function blatantRoute(d,stand,routeAttempt)
local hrp=getHRP();if not hrp then return false,"no hrp",false end
local function flag() return State.flags.Blatant and d.Model and d.Model.Parent end

-- If we are not already high enough, rise first.
local groundDist=groundDistanceAt(hrp.Position,500)
local skyY=hrp.Position.Y
if groundDist<math.max(35,(Cfg.BlatantHeight or 100)*.25) then
local ok,why,newY=State.api.blatantRiseToSky(flag)
if not ok then return false,why,false end
skyY=newY
else
skyY=hrp.Position.Y
end

-- Door is chosen while already in the sky. Move directly over its front point,
-- then descend at that exact X/Z position.
local ok,why=State.api.blatantDescendAtDoor(d,skyY,flag)
if not ok then return false,why,false end
return true,"ok",false
end
local function doorOpened(d,snap)
if not d or not d.Model or not d.Model.Parent then return true end
task.wait(Cfg.DoorOpenCheckDelay or 0.18)
return doorGone(d.Model,snap)
end
local function collectDoorPrompts(d)
local prompts={}
local seen={}
if not d or not d.Model then return prompts end
local anchor=State.api.getBlatantDoorAnchor(d) or d.Part
local center=anchor and anchor.Position or (d.Part and d.Part.Position)

local function addFrom(root)
if not root then return end
for _,p in ipairs(root:GetDescendants()) do
if p:IsA("ProximityPrompt") and not seen[p] then
local holder=p.Parent
local pos=nil
if holder and holder:IsA("BasePart") then pos=holder.Position
elseif holder then pos=objectPos(holder) end
if not center or not pos or (pos-center).Magnitude<=18 then
seen[p]=true
prompts[#prompts+1]=p
end
end
end
end

addFrom(d.Model)
addFrom(d.Model.Parent)
return prompts
end

local function tryDoorInteraction(d,seconds)
if not d or not d.Model or not d.Model.Parent then return true end
local exactFlag=function()
return State.flags.Blatant and not State.dead and d.Model and d.Model.Parent
end

if State.flags.Blatant then
local exactOK=State.api.blatantExactDoorStand(d,exactFlag)
if not exactOK then
GUI.setStatus("Blatant: exact front lost")
return false
end
end

local snap=doorSnapshot(d.Model)
faceDoor(d)

local prompts=collectDoorPrompts(d)
local limit=seconds or Cfg.DoorInteractPerRoute or 1.4
local t0=os.clock()

while os.clock()-t0<limit do
if State.dead or (State.flags.Blatant and not exactFlag()) then return false end
if doorGone(d.Model,snap) then return true end

if #prompts==0 then prompts=collectDoorPrompts(d) end
for _,p in ipairs(prompts) do
if p and p.Parent then firePromptInstant(p) end
end

task.wait(math.max(.07,Cfg.InteractRetryDelay or .12))
if doorGone(d.Model,snap) then return true end
end

-- Keep the old generic interaction as a final fallback.
local gone=interactUntilGone(d.Model,math.min(1.0,limit))
if gone then return true end
return doorOpened(d,snap)
end
local function blatantDoOneDoor()
local function alive() return State.flags.Blatant and not State.dead end
if not alive() then return false,"stopped" end

-- Core mechanic:
-- 1) rise safely
-- 2) find door
-- 3) move above it
-- 4) descend in front
-- 5) open
-- 6) next loop repeats
local hrp=getHRP();if not hrp then return false,"no hrp" end
local groundDist=groundDistanceAt(hrp.Position,500)
local skyY=hrp.Position.Y
if groundDist<math.max(35,(Cfg.BlatantHeight or 100)*.25) then
local ok,why,newY=State.api.blatantRiseToSky(alive)
if not ok then return false,why end
skyY=newY
end

local d=nearestBlatantDoor()
if not d then return false,"no door" end
State.lockedDoor={Model=d.Model,StartPos=d.Part.Position}

local function flag()
return alive() and d.Model and d.Model.Parent
end

local candidates=State.api.blatantDoorCandidates(d)
if #candidates==0 then State.lockedDoor=nil;return false,"no door side" end

local lastWhy="door route failed"
for sideIndex,geo in ipairs(candidates) do
if not flag() then break end
d._BlatantGeo=geo
GUI.setStatus(("Blatant: door found • trying side %d/%d"):format(sideIndex,#candidates))

local front=geo.Target
local current=getHRP()
if not current then lastWhy="no hrp";break end
local currentSkyY=math.max(skyY,current.Position.Y)
local above=Vector3.new(front.X,currentSkyY,front.Z)

local skyOK,shifted,skyWhy=State.api.moveBlatantSky(above,flag)
if skyOK then
local downOK,downWhy=State.api.blatantDescendAtDoor(d,currentSkyY,flag)
if downOK then
GUI.setStatus("Blatant: opening door...")
local opened=tryDoorInteraction(d,Cfg.DoorInteractPerRoute)
if opened then
coolSuccess(d.Part.Position)
State.lockedDoor=nil
d._BlatantGeo=nil
return true,"ok"
end
lastWhy="door interaction failed"
else
lastWhy=downWhy or "descent failed"
end
else
lastWhy=skyWhy or (shifted and "sky shift" or "sky blocked")
end

-- Do not blacklist the door yet. Rise again and try the opposite side.
State.api.releaseCharacterControl("blatant-side-retry")
local h=getHRP()
if h and flag() then
local groundDist2=groundDistanceAt(h.Position,500)
if groundDist2<math.max(30,(Cfg.BlatantHeight or 100)*.22) then
local riseOK,_,newY=State.api.blatantRiseToSky(flag)
if riseOK and newY then skyY=newY end
end
end
task.wait(.05)
end

State.lockedDoor=nil
d._BlatantGeo=nil
failDoor(d,true)
return false,lastWhy
end
local function startBlatant()
if State.mobileLite then
Cfg.BlatantMode=false
State.flags.Blatant=false
GUI.setStatus("Blatant is PC only")
return
end
stopThread("Blatant");State.flags.Blatant=true
State.api.setState("Blatant");history("Blatant started");GUI.setStatus("Blatant: active")
State.threads.Blatant=task.spawn(function()
while State.flags.Blatant and not State.dead do
local pOk,ok,reason=pcall(blatantDoOneDoor)
if not pOk then
history("Blatant error: "..tostring(ok))
GUI.setStatus("Blatant: internal error — recovering...")
stopTween();State.pathCache={t=0};clearTrajectory();task.wait(.35)
elseif not ok then
State.api.releaseCharacterControl("blatant-wait")
GUI.setStatus("Blatant: "..tostring(reason))
task.wait(reason=="no door" and .35 or .16)
else
State.api.releaseCharacterControl("blatant-door-complete")
GUI.setStatus("Blatant: door used!")
task.wait(.06)
end
end
State.lockedDoor=nil
State.api.releaseCharacterControl("blatant-end")
State.api.setState("Idle")
GUI.setStatus("Idle")
end)
end
local function stopBlatant()
stopThread("Blatant");stopTween();clearTrajectory()
State.lockedDoor=nil
local hrp=getHRP()
if hrp then
local g=snapToGround(hrp.Position)
if hrp.Position.Y-g.Y>6 then
pcall(function() hrp.AssemblyLinearVelocity=Vector3.zero;hrp.AssemblyAngularVelocity=Vector3.zero end)
task.spawn(function() State.api.smoothBlatantReturn(hrp,g,function() return not State.dead end) end)
end
end
State.api.releaseCharacterControl("blatant-stop")
GUI.setStatus("Idle")
end
function State.api.otherPlayerRoots()
local roots={}
for _,p in ipairs(Players:GetPlayers()) do
if p~=LP then
local ch=p.Character
local hum=ch and ch:FindFirstChildOfClass("Humanoid")
local root=ch and ch:FindFirstChild("HumanoidRootPart")
if root and (not hum or hum.Health>0) then roots[#roots+1]=root end
end
end
return roots
end

function State.api.minPlayerDistance(pos)
local best=math.huge
for _,root in ipairs(State.api.otherPlayerRoots()) do
if root and root.Parent then
local d=(Vector3.new(root.Position.X,0,root.Position.Z)-Vector3.new(pos.X,0,pos.Z)).Magnitude
if d<best then best=d end
end
end
return best
end

function State.api.awayDirectionFromPlayers(origin)
local sum=Vector3.zero
local count=0
for _,root in ipairs(State.api.otherPlayerRoots()) do
if root and root.Parent then
local delta=Vector3.new(origin.X-root.Position.X,0,origin.Z-root.Position.Z)
local dist=delta.Magnitude
if dist>.1 then
sum=sum+delta.Unit*(1/math.max(20,dist))
count+=1
end
end
end
if sum.Magnitude>.01 then return sum.Unit end
local hrp=getHRP()
local f=hrp and Vector3.new(hrp.CFrame.LookVector.X,0,hrp.CFrame.LookVector.Z) or Vector3.new(0,0,-1)
if f.Magnitude<.1 then f=Vector3.new(0,0,-1) end
return f.Unit
end

function State.api.bestAwayPoint(origin,distance)
distance=math.max(50,distance or 450)
local base=State.api.awayDirectionFromPlayers(origin)
local function rot(v,deg)
local r=math.rad(deg)
local c,si=math.cos(r),math.sin(r)
return Vector3.new(v.X*c-v.Z*si,0,v.X*si+v.Z*c)
end
local angles={0,28,-28,52,-52,82,-82}
local best,bestScore=nil,-math.huge
for _,a in ipairs(angles) do
local dir=rot(base,a)
local p=origin+dir*distance
local score=State.api.minPlayerDistance(p)
if score==math.huge then score=distance end
if score>bestScore then bestScore=score;best=p end
end
return best or (origin+base*distance)
end

local function createSafePlatform()
if State.safePlatform and State.safePlatform.Parent then
local plat=State.safePlatform:FindFirstChild("SafePlatform")
if plat then Cfg.SafePlatformPos=plat.Position;return State.safePlatform end
end
if State.safePlatform then pcall(function() State.safePlatform:Destroy() end);State.safePlatform=nil end
local stale=workspace:FindFirstChild("JJS_SafePlatform")
if stale then pcall(function() stale:Destroy() end) end
local hrp=getHRP()
local basePos
if hrp then
local horizontal=hrp.Position
if Cfg.SafePlatformAwayFromPlayers then
horizontal=State.api.bestAwayPoint(hrp.Position,Cfg.SafePlatformAwayDistance or 450)
end
basePos=Vector3.new(horizontal.X,hrp.Position.Y+standHeight()+Cfg.SafePlatformHeight,horizontal.Z)
else
local cam=workspace.CurrentCamera
if cam then basePos=cam.CFrame.Position+Vector3.new(0,Cfg.SafePlatformHeight,0)
else basePos=Vector3.new(0,Cfg.SafePlatformHeight,0) end
end
Cfg.SafePlatformPos=basePos
local folder=Instance.new("Folder")
folder.Name="JJS_SafePlatform";folder.Parent=workspace
local plat=Instance.new("Part")
plat.Name="SafePlatform";plat.Size=Cfg.SafePlatformSize;plat.Position=basePos
plat.Anchored=true;plat.CanCollide=true;plat.Material=Enum.Material.Neon
plat.Color=Color3.fromRGB(20,20,40);plat.Transparency=0.4;plat.Parent=folder
local border=Instance.new("Part")
border.Name="Border";border.Size=Vector3.new(Cfg.SafePlatformSize.X+2,1,Cfg.SafePlatformSize.Z+2)
border.Position=basePos+Vector3.new(0,0.6,0);border.Anchored=true;border.CanCollide=false
border.Material=Enum.Material.Neon;border.Color=Color3.fromRGB(80,140,255)
border.Transparency=0.7;border.Parent=folder
State.safePlatform=folder
return folder
end
local function destroySafePlatform()
if State.safePlatform then pcall(function() State.safePlatform:Destroy() end);State.safePlatform=nil end
end
local function tweenHRPTo(hrp,target,duration,flag)
if not hrp or not hrp.Parent then return false end
local dist=(target-hrp.Position).Magnitude
if dist<=0.5 then return true end
local speed=math.max(1,dist/math.max(duration or .1,.05))
return moveTo(target,flag or function() return true end,speed)
end
local function safeFlightPoints(startPos,endPos)
local pts=computeItem3DPath(startPos,endPos,0)
if pts and #pts>=2 then return pts end
return compute3DPath(startPos,endPos,0)
end
local function goToSafePlatform(flag)
flag=flag or function() return Cfg.SafeMode and not State.dead end
if State.safeModeClimbing then return false end
local folder=createSafePlatform()
local plat=folder and folder:FindFirstChild("SafePlatform")
local hrp=getHRP()
if not plat or not hrp or not flag() then return false end
local target=Vector3.new(plat.Position.X,plat.Position.Y+plat.Size.Y/2+standHeight()+1.5,plat.Position.Z)
if (target-hrp.Position).Magnitude<=4 then
State.safeModeAtPlatform=true
return true
end
State.safeModeClimbing=true
State.safeModeAtPlatform=false
State.pathCache={t=0}
clearTrajectory()
GUI.setStatus("Safe Mode: pathfinding to sky platform...")
local speed=math.max(45,math.min(Cfg.BlatantSpeed or 120,140))
local success=goToItem3D(target,function()
return flag() and Cfg.SafeMode and not State.dead
end,speed,0)
local h=getHRP()
if success and h and (h.Position-target).Magnitude<=8 then
pcall(function()
h.CFrame=CFrame.new(target)*h.CFrame.Rotation
h.AssemblyLinearVelocity=Vector3.zero
h.AssemblyAngularVelocity=Vector3.zero
end)
State.safeModeAtPlatform=true
State.api.releaseCharacterControl("safe-platform-reached")
else
State.safeModeAtPlatform=false
end
State.safeModeClimbing=false
State.pathCache={t=0}
clearTrajectory()
GUI.setStatus(State.safeModeAtPlatform and "Safe Mode: platform reached" or "Safe Mode: recalculating route...")
return State.safeModeAtPlatform
end
local function isEventActive()
if countReadyDoors()>0 then return true end
if State.pumpkin.hasPumpkin then return true end
return false
end
local function runSafeModeLoop(flag)
State.safeModeActive=true
while flag() and not State.dead do
if not State.safePlatform or not State.safePlatform.Parent then createSafePlatform() end
local ready=countReadyDoors()
local hasPumpkinNow=State.pumpkin.hasPumpkin
if hasPumpkinNow and not State.safeModeAtPlatform and not State.safeModeClimbing then
GUI.setStatus("Safe Mode: pumpkin → subindo!")
goToSafePlatform(flag)
end
if ready==0 and not isEventActive() then
if not State.allDoorsDone then State.allDoorsDone=true;GUI.setStatus("Safe Mode: sem portas → subindo") end
local hrp=getHRP()
if hrp and State.safePlatform then
local plat=State.safePlatform:FindFirstChild("SafePlatform")
if plat then
local topPos=Vector3.new(plat.Position.X,plat.Position.Y+(Cfg.SafePlatformSize.Y/2)+standHeight()+1,plat.Position.Z)
local dist=(hrp.Position-topPos).Magnitude
if dist>5 and not State.safeModeClimbing then goToSafePlatform(flag)
else
State.safeModeAtPlatform=true
GUI.setStatus("Safe Mode: escondido no céu")
end
end
end
else
if State.allDoorsDone then State.allDoorsDone=false;GUI.setStatus("Safe Mode: evento → saindo") end
if State.safeModeAtPlatform and not hasPumpkinNow then State.safeModeAtPlatform=false end
task.wait(1)
end
task.wait(Cfg.SafeModeCheckInterval or 0.5)
end
State.safeModeActive=false
end
local function startSafeMode()
if Cfg.SafeMode and State.threads.SafeMode then return end
Cfg.SafeMode=true
State.api.setState("Safe Mode: Creating Platform")
history("Safe Mode: creating platform")
State.safeModeAtPlatform=false;State.safeModeClimbing=false
local folder=createSafePlatform()
if not folder then
GUI.setStatus("Safe Mode: failed to create platform")
Cfg.SafeMode=false
return
end
State.api.setState("Safe Mode: Pathfinding");history("Safe Mode: platform created");GUI.setStatus("Safe Mode: platform created")
State.threads.SafeMode=task.spawn(function()
State.api.setState("Safe Mode: Going Up")
pcall(function() goToSafePlatform(function() return Cfg.SafeMode and not State.dead end) end)
if State.safeModeAtPlatform then State.api.setState("Safe Mode: Safe");history("Safe Mode: safe") end
runSafeModeLoop(function() return Cfg.SafeMode end)
State.threads.SafeMode=nil
end)
end
local function stopSafeMode()
Cfg.SafeMode=false
State.safeModeActive=false;State.safeModeAtPlatform=false;State.safeModeClimbing=false
if State.threads.SafeMode then pcall(task.cancel,State.threads.SafeMode);State.threads.SafeMode=nil end
if not State.flags.Farm and not State.flags.Blatant and not State.flags.Pumpkin then stopTween() end
destroySafePlatform()
State.api.releaseCharacterControl("safe-mode-stop")
State.api.setState("Idle")
history("Safe Mode stopped")
end
local function farmStep()
if Cfg.SafeMode and State.allDoorsDone and countReadyDoors()==0 then task.wait(0.4);return end
local d=nearestDoor()
if not d then
State.lockedDoor=nil
local pending,pendingBest=nil,math.huge
local hrpNow=getHRP()
if hrpNow then
for _,dd in ipairs(allDoors()) do
if dd.Part and dd.Part.Parent and not State.doors.skip[dd.Model] and not isCooling(dd.Part.Position) and not skeletonNear(dd.Part.Position,Cfg.SkeletonDoorRadius) and not playerNearPart(dd.Part,Cfg.DoorPlayerCheckRadius) and not playerWithinRadius(dd.Part.Position,Cfg.WaitTimerRadius) then
local dist=(dd.Part.Position-hrpNow.Position).Magnitude
if dist<pendingBest then pendingBest=dist;pending=dd end
end
end
end
if pending and Cfg.WaitTimer then
local t0=os.clock();local interrupted=false
while State.flags.Farm and not State.dead and (os.clock()-t0)<Cfg.WaitTimerMaxSeconds do
if not pending.Model or not pending.Model.Parent then break end
if playerWithinRadius(pending.Part.Position,Cfg.WaitTimerRadius) then interrupted=true;break end
updateWaitCircle(pending.Part,true)
local cur=doorTimer(pending.Model)
GUI.setStatus("Waiting: "..cur)
if timerZero(cur) then break end
task.wait(0.15)
end
updateWaitCircle(nil,false)
if interrupted and pending.Model and pending.Model.Parent then
State.doors.skip[pending.Model]=os.clock()+Cfg.DoorSkipTime
elseif pending.Model and pending.Model.Parent and not timerZero(doorTimer(pending.Model)) then
State.doors.skip[pending.Model]=os.clock()+Cfg.DoorSkipTime
end
else
updateWaitCircle(nil,false)
if Cfg.SafeMode then
GUI.setStatus("No doors — Safe Platform")
goToSafePlatform(function() return State.flags.Farm end)
else
GUI.setStatus("No doors — safe point")
local hrpNow2=getHRP()
if hrpNow2 and (Cfg.SafePoint-hrpNow2.Position).Magnitude>8 then
goTo(Cfg.SafePoint,function() return State.flags.Farm end)
end
end
task.wait(0.4)
end
task.wait(0.2);return
end
updateWaitCircle(nil,false)
local hrp=getHRP();if not hrp then return end
State.lockedDoor={Model=d.Model,StartPos=d.Part.Position}
local routes=math.max(1,Cfg.DoorRouteRetries or 4)
if nearDoor(hrp,d.Part) then
GUI.setStatus("Checking nearest door...")
if tryDoorInteraction(d,Cfg.DoorInteractPerRoute) then
coolSuccess(d.Part.Position);State.lockedDoor=nil;return
end
end
for attempt=1,routes do
if not State.flags.Farm or State.dead then break end
if not d.Model or not d.Model.Parent then State.lockedDoor=nil;return end
local target=standPosRoute(d,Cfg.DoorStandoff,attempt)
GUI.setStatus("Going route "..attempt.."/"..routes.." ("..d.Distance.."m)...")
State.pathCache={t=0}
local ok=goTo(target,function() return State.flags.Farm and d.Model and d.Model.Parent end,Cfg.WalkSpeed,nil,attempt-1)
if ok and d.Model and d.Model.Parent then
GUI.setStatus("Checking door...")
if tryDoorInteraction(d,Cfg.DoorInteractPerRoute) then
coolSuccess(d.Part.Position);State.lockedDoor=nil;return
end
GUI.setStatus("Door did not open — new route...")
else
GUI.setStatus("Route blocked — recalculating...")
end
State.pathCache={t=0}
task.wait(Cfg.SmartRouteRetryDelay or 0.08)
end
State.lockedDoor=nil
if d.Model and d.Model.Parent then failDoor(d,true) end
GUI.setStatus("Door failed after alternate routes")
task.wait(0.2)
end
local function startFarm()
stopThread("Farm");State.flags.Farm=true
GUI.setStatus("Farm: searching...")
State.threads.Farm=task.spawn(function()
while State.flags.Farm and not State.dead do
local ok=pcall(farmStep)
State.api.releaseCharacterControl("farm-step")
if not ok then GUI.setStatus("Farm: error");task.wait(0.5) else task.wait(math.max(.03,Cfg.RuntimeTick or .02)) end
end
State.lockedDoor=nil
State.api.releaseCharacterControl("farm-end")
GUI.setStatus("Idle")
end)
end
local function stopFarm()
stopThread("Farm");stopTween();clearTrajectory()
State.lockedDoor=nil
updateWaitCircle(nil,false)
State.api.releaseCharacterControl("farm-stop")
GUI.setStatus("Idle")
end
local function updateTitle()
if not GUI.Title then return end
local parts={}
local n=#State.skel.list
if n>0 then parts[#parts+1]="💀"..n end
if State.pumpkin.active then parts[#parts+1]="🎃" end
if State.safeModeActive then parts[#parts+1]="🛡️" end
if State.candy.active then parts[#parts+1]="🍬" end
local txt=TITLE_BASE
if #parts>0 then txt=txt.."  "..table.concat(parts," ") end
if GUI.Title.Text~=txt then GUI.Title.Text=txt end
end
local function runAntiSkeleton(flag)
State.asRun=State.asRun+1
local myRun=State.asRun
State.asActive=true
local tracked={}
local function matches(model)
if not model or not model:IsA("Model") then return false end
if Players:GetPlayerFromCharacter(model) then return false end
local n=string.lower(model.Name)
for _,pat in ipairs(Cfg.SkeletonNames) do
if n:find(pat,1,true) then return true end
end
return false
end
local function consider(inst)
if inst:IsA("Humanoid") and matches(inst.Parent) then tracked[inst.Parent]=inst end
end
local scanRoots={workspace:FindFirstChild("Characters"),workspace:FindFirstChild("Effects"),workspace:FindFirstChild("Map")}
for _,root in ipairs(scanRoots) do
if root then for _,inst in ipairs(root:GetDescendants()) do consider(inst) end end
end
local conn=workspace.DescendantAdded:Connect(function(inst)
if inst:IsA("Humanoid") then task.defer(function() consider(inst) end) end
end)
State.conns.skel=conn
while flag() and not State.dead and State.asRun==myRun do
pcall(function()
local hrp=getHRP()
local list={}
for model,hum in pairs(tracked) do
if not model.Parent or not hum.Parent then tracked[model]=nil
elseif hum.Health>0 and hrp then
local root=model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart
if root then
local dist=(root.Position-hrp.Position).Magnitude
if dist<=Cfg.SkeletonRadius and inMapRange(root.Position) then list[#list+1]={Model=model,Root=root,Dist=dist,Hum=hum} end
end
end
end
State.skel.list=list
updateTitle()
end)
task.wait(State.mobileLite and .35 or .15)
end
pcall(function() conn:Disconnect() end)
if State.asRun==myRun then State.asActive=false;State.skel.list={};updateTitle() end
end
local function startAS()
State.flags.AS=true
task.spawn(function() runAntiSkeleton(function() return State.flags.AS end) end)
end
local function getFalseDoorTarget()
local chars=workspace:FindFirstChild("Characters")
if not chars then return nil end
local doorModel=chars:FindFirstChild("Door")
if not doorModel or not doorModel:IsA("Model") then return nil end
local halloween=doorModel:FindFirstChild("HalloweenDoor") or doorModel:FindFirstChildWhichIsA("Model")
if not halloween then return nil end
local part=getDoorPart(halloween) or halloween.PrimaryPart or halloween:FindFirstChildWhichIsA("BasePart",true)
if not part or not inMapRange(part.Position) then return nil end
return {Model=halloween,Root=part,Name="FalseDoor"}
end
local function orbitFalseDoor(target,flag)
local root=target.Root
if not root or not root.Parent then return false end
local hrp=getHRP();if not hrp then return false end
local dest=root.Position+(hrp.Position-root.Position).Unit*Cfg.OrbitRadius
dest=snapToGround(dest)
if not goTo(dest,flag,Cfg.WalkSpeed) then return false end
GUI.setStatus("Anti-FalseDoor: orbiting...")
local angle=0
local t0=os.clock()
while flag() and root.Parent and os.clock()-t0<Cfg.OrbitMaxTime do
local dt=task.wait(State.mobileLite and .05 or .03)
hrp=getHRP();if not hrp then break end
angle=angle+math.rad(Cfg.OrbitSpeed)*dt
local pos=Vector3.new(root.Position.X+math.cos(angle)*Cfg.OrbitRadius,root.Position.Y,root.Position.Z+math.sin(angle)*Cfg.OrbitRadius)
hrp.CFrame=CFrame.lookAt(pos,root.Position)
hrp.AssemblyLinearVelocity=Vector3.zero
hrp.AssemblyAngularVelocity=Vector3.zero
end
return true
end
local function runAntiFalseDoor(flag)
State.afdRun=State.afdRun+1
local myRun=State.afdRun
State.afdActive=true
while flag() and not State.dead and State.afdRun==myRun do
local ok,err=pcall(function()
local target=getFalseDoorTarget()
if not target then return end
if not State.falseDoors[target.Model] then
markFalseDoor(target.Model,"Characters/Door")
end
if State.flags.Farm or State.flags.Blatant or State.flags.Pumpkin then
State.pathCache={t=0}
if State.lockedDoor and State.lockedDoor.Model==target.Model then
State.lockedDoor=nil
stopTween()
end
return
end
local S=State.smart
if Cfg.SmartOrbit and not S.active and os.clock()>=S.nextAllowed then
S.active=true
local orbitOk=pcall(function()
orbitFalseDoor(target,function()
return flag() and State.afdRun==myRun and not State.dead
end)
end)
S.active=false
S.nextAllowed=os.clock()+Cfg.SmartCooldown
if not orbitOk then
State.pathCache={t=0}
end
end
end)
if not ok then
State.smart.active=false
State.pathCache={t=0}
end
task.wait(State.mobileLite and .65 or .4)
end
State.smart.active=false
if State.afdRun==myRun then State.afdActive=false end
end
local function startAFD()
State.flags.AFD=true
task.spawn(function() runAntiFalseDoor(function() return State.flags.AFD end) end)
end
local function hasPumpkinInCharacter(char)
if not char then return false end
for _,d in ipairs(char:GetDescendants()) do
if d:IsA("BasePart") or d:IsA("Model") then
local n=string.lower(d.Name)
for _,pat in ipairs(Cfg.PumpkinPartNames) do
if n:find(pat,1,true) then return true end
end
end
end
return false
end
local function findPumpkinTargets()
local list={}
local chars=workspace:FindFirstChild("Characters")
if not chars then return list end
for _,model in ipairs(chars:GetChildren()) do
if model:IsA("Model") and model.Name~=LP.Name then
if hasPumpkinInCharacter(model) then
local root=model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart
if root and inMapRange(root.Position) then list[#list+1]={Model=model,Root=root,Name=model.Name} end
end
end
end
return list
end
local function checkMyPumpkin()
local chars=workspace:FindFirstChild("Characters")
if chars then
local myModel=chars:FindFirstChild(LP.Name)
if myModel then return hasPumpkinInCharacter(myModel) end
end
return hasPumpkinInCharacter(LP.Character)
end
function State.api.pumpkinCloseRadius(root,hrp)
if not root or not hrp then return 2.25 end
local targetR=math.max(root.Size.X,root.Size.Z)*0.5
local myR=math.max(hrp.Size.X,hrp.Size.Z)*0.5
return math.max(1.75,targetR+myR+0.25)
end
function State.api.pumpkinSidePoint(root,hrp,radius)
local flat=Vector3.new(hrp.Position.X-root.Position.X,0,hrp.Position.Z-root.Position.Z)
if flat.Magnitude<0.1 then
flat=Vector3.new(root.CFrame.LookVector.X,0,root.CFrame.LookVector.Z)
if flat.Magnitude<0.1 then flat=Vector3.new(1,0,0) end
end
local p=root.Position+flat.Unit*radius
return Vector3.new(p.X,root.Position.Y,p.Z)
end
function State.api.pumpkinSafeOrbitPoint(root,hrp,angle,baseRadius)
local radii={baseRadius,baseRadius+0.6,baseRadius+1.2,baseRadius+2}
for _,r in ipairs(radii) do
local p=Vector3.new(root.Position.X+math.cos(angle)*r,root.Position.Y,root.Position.Z+math.sin(angle)*r)
if inMapRange(p) and volumeClear(hrp.Position,p,math.max(1.1,Cfg.AgentRadius*0.45)) then return p,r end
end
return nil,baseRadius
end
local PUMPKIN_KEYS={Enum.KeyCode.One,Enum.KeyCode.Two,Enum.KeyCode.Three,Enum.KeyCode.Four}
function State.api.pumpkinMyModel()
local chars=workspace:FindFirstChild("Characters")
return (chars and chars:FindFirstChild(LP.Name)) or LP.Character
end
function State.api.pumpkinMovesetValues()
local now=os.clock()
local combat=State.pumpkin.combat
if combat.moveset and now-(combat.movesetAt or 0)<0.5 then
local first=combat.moveset[1]
if #combat.moveset==0 or (first and first.Parent) then return combat.moveset end
end
local char=State.api.pumpkinMyModel()
local folder=char and char:FindFirstChild("Moveset")
local values={}
if folder then
for _,v in ipairs(folder:GetChildren()) do
if v:IsA("NumberValue") then values[#values+1]=v end
end
end
combat.moveset=values;combat.movesetAt=now
return values
end
function State.api.pumpkinPressKey(key)
if not key then return false end
if VIM then
local ok=pcall(function()
VIM:SendKeyEvent(true,key,false,game)
task.wait(0.025)
VIM:SendKeyEvent(false,key,false,game)
end)
if ok then return true end
end
return false
end
function State.api.pumpkinPressMobileSkill(skillName,slot)
local wanted=string.lower(tostring(skillName or ""))
local slotText=tostring(slot or "")
local best=nil
for _,g in ipairs(PGui:GetDescendants()) do
if g:IsA("GuiButton") and g.Visible then
local text=""
pcall(function() text=string.lower(tostring(g.Text or "")) end)
local name=string.lower(g.Name)
local match=(wanted~="" and (text:find(wanted,1,true) or name:find(wanted,1,true)))
if not match then
for _,d in ipairs(g:GetDescendants()) do
if d:IsA("TextLabel") or d:IsA("TextButton") then
local t=string.lower(tostring(d.Text or ""))
if wanted~="" and t:find(wanted,1,true) then match=true;break end
end
end
end
if match then best=g;break end
if not best and slotText~="" and (text==slotText or name==slotText) then best=g end
end
end
if not best then return false end
if EXE.firesignal then
local ok=pcall(function() EXE.firesignal(best.Activated) end)
if ok then return true end
ok=pcall(function() EXE.firesignal(best.MouseButton1Click) end)
if ok then return true end
end
return pcall(function() best:Activate() end)
end
function State.api.pumpkinPressM1()
local cam=workspace.CurrentCamera
local vp=cam and cam.ViewportSize or Vector2.new(800,600)
local pos=Vector2.new(vp.X*0.5,vp.Y*0.5)
if VIM then
local ok=pcall(function()
VIM:SendMouseButtonEvent(pos.X,pos.Y,0,true,game,0)
task.wait(0.02)
VIM:SendMouseButtonEvent(pos.X,pos.Y,0,false,game,0)
end)
if ok then return true end
end
if VU then
local ok=pcall(function()
VU:CaptureController()
VU:Button1Down(pos,cam and cam.CFrame or CFrame.new())
task.wait(0.02)
VU:Button1Up(pos,cam and cam.CFrame or CFrame.new())
end)
if ok then return true end
end
return false
end
function State.api.pumpkinAutoCombatTick(targetRoot)
if not Cfg.PumpkinAutoCombat or not State.flags.Pumpkin or not targetRoot or not targetRoot.Parent then return end
local hrp=getHRP();if not hrp then return end
local dist=(targetRoot.Position-hrp.Position).Magnitude
if dist>math.max(Cfg.PumpkinPathfindReach,55) then return end
local combat=State.pumpkin.combat
local now=os.clock()
if now-(combat.lastM1 or 0)>=Cfg.PumpkinM1Interval then
combat.lastM1=now
State.api.pumpkinPressM1()
end
local values=State.api.pumpkinMovesetValues()
for i=1,math.min(4,#values) do
local cd=values[i]
if cd and cd.Parent and tonumber(cd.Value) and cd.Value<=0 then
local last=combat.skillLast[cd] or 0
if now-last>=Cfg.PumpkinSkillRetry then
combat.skillLast[cd]=now
if not State.api.pumpkinPressKey(PUMPKIN_KEYS[i]) then
State.api.pumpkinPressMobileSkill(cd.Name,i)
end
end
end
end
end
local function pathfindToPumpkinTarget(target,flag)
if not target or not target.Root or not target.Root.Parent then return false end
local startT=os.clock()
local root=target.Root
while flag() and os.clock()-startT<Cfg.PumpkinPathfindTimeout do
local hrp=getHRP();if not hrp then return false end
if not root or not root.Parent then return false end
State.api.pumpkinAutoCombatTick(root)
local dist=(root.Position-hrp.Position).Magnitude
if dist<=Cfg.PumpkinPathfindReach then
local closeRadius=State.api.pumpkinCloseRadius(root,hrp)
if Cfg.PumpkinTeleportOnReach then
local side=State.api.pumpkinSidePoint(root,hrp,closeRadius)
goTo(side,flag,Cfg.BlatantSpeed,nil,0)
end
if Cfg.PumpkinOrbitAfterTeleport then
local h0=getHRP();if not h0 then return false end
local rel=h0.Position-root.Position
local angle=math.atan2(rel.Z,rel.X)
local orbitT=os.clock()
local orbitDir=1
while flag() and root.Parent and (os.clock()-orbitT)<Cfg.PumpkinOrbitTimeout do
local dt=task.wait(State.mobileLite and .05 or .03)
local h2=getHRP();if not h2 then return false end
State.api.pumpkinAutoCombatTick(root)
closeRadius=State.api.pumpkinCloseRadius(root,h2)
angle=angle+math.rad(Cfg.OrbitSpeed)*dt*orbitDir
local pos=select(1,State.api.pumpkinSafeOrbitPoint(root,h2,angle,closeRadius))
if not pos then
orbitDir=-orbitDir
angle=angle+math.rad(12)*orbitDir
pos=select(1,State.api.pumpkinSafeOrbitPoint(root,h2,angle,closeRadius))
end
if pos then
pcall(function()
h2.CFrame=CFrame.lookAt(pos,Vector3.new(root.Position.X,pos.Y,root.Position.Z))
h2.AssemblyLinearVelocity=Vector3.zero
h2.AssemblyAngularVelocity=Vector3.zero
end)
end
if checkMyPumpkin() then return true end
end
end
return checkMyPumpkin()
end
local closeRadius=State.api.pumpkinCloseRadius(root,hrp)
local side=State.api.pumpkinSidePoint(root,hrp,closeRadius)
if not goTo(side,flag,Cfg.WalkSpeed,nil,0) then task.wait(0.2) end
end
return checkMyPumpkin()
end
local function pumpkinEscapeAfterCollect(flag)
if not Cfg.PumpkinEscapeAfterCollect then
State.api.releaseCharacterControl("pumpkin-no-escape")
return true
end
local hrp=getHRP();if not hrp then return false end
local origin=hrp.Position
local total=math.max(500,Cfg.PumpkinEscapeDistance or 550)
local finalRaw=State.api.bestAwayPoint(origin,total)
local flat=Vector3.new(finalRaw.X-origin.X,0,finalRaw.Z-origin.Z)
if flat.Magnitude<1 then
flat=State.api.awayDirectionFromPlayers(origin)*total
end
local dir=flat.Unit
local side=Vector3.new(-dir.Z,0,dir.X)
local stages=math.max(2,math.floor(Cfg.PumpkinEscapeStages or 3))
if State.mobileLite then stages=math.min(stages,2) end
local jitter=math.clamp(Cfg.PumpkinEscapeJitter or 75,0,120)
local speed=math.max(60,Cfg.PumpkinEscapeSpeed or 135)

GUI.setStatus("Pumpkin: escaping 500+ studs...")
State.api.setState("Pumpkin Escape")

for i=1,stages do
if not flag() or State.dead then
State.api.releaseCharacterControl("pumpkin-escape-cancel")
return false
end
local frac=i/stages
local lateral=0
if i<stages then
lateral=((i%2==0) and 1 or -1)*jitter*(1-frac*.25)
end
local raw=origin+dir*(total*frac)+side*lateral

-- Prefer a real grounded waypoint. If no floor is found there, let the 3D
-- planner handle the raw point instead of repeatedly rescanning the world.
local probe=raw+Vector3.new(0,180,0)
local hit=workspace:Raycast(probe,Vector3.new(0,-520,0),makeRayParams())
local target=hit and (hit.Position+Vector3.new(0,standHeight(),0)) or raw

GUI.setStatus(("Pumpkin: escape route %d/%d"):format(i,stages))
State.pathCache={t=0}
local ok=goToItem3D(target,flag,speed,30+i)
if not ok then
local straight=origin+dir*(total*frac)
local h2=workspace:Raycast(straight+Vector3.new(0,180,0),Vector3.new(0,-520,0),makeRayParams())
if h2 then straight=h2.Position+Vector3.new(0,standHeight(),0) end
State.pathCache={t=0}
ok=goToItem3D(straight,flag,speed,40+i)
end
if not ok then
State.api.releaseCharacterControl("pumpkin-escape-failed")
GUI.setStatus("Pumpkin: escape route blocked")
return false
end
State.api.releaseCharacterControl("pumpkin-escape-stage")
end

local h=getHRP()
local traveled=h and (Vector3.new(h.Position.X,0,h.Position.Z)-Vector3.new(origin.X,0,origin.Z)).Magnitude or 0
State.api.releaseCharacterControl("pumpkin-escape-done")
GUI.setStatus(("Pumpkin: escaped • %d studs"):format(math.floor(traveled)))
return traveled>=math.min(500,total*.9)
end

local function runPumpkinMinigame(flag)
State.pumpkin.run=State.pumpkin.run+1
local myRun=State.pumpkin.run
while flag() and not State.dead and State.pumpkin.run==myRun do
local targets=findPumpkinTargets()
if #targets>0 then
local hrp=getHRP()
table.sort(targets,function(a,b)
if not hrp then return false end
return (a.Root.Position-hrp.Position).Magnitude<(b.Root.Position-hrp.Position).Magnitude
end)
local target=targets[1]
State.pumpkin.active=true;updateTitle()
GUI.setStatus("Pumpkin: pathfinding to "..target.Name)
if pathfindToPumpkinTarget(target,function() return flag() and State.pumpkin.run==myRun end) then
GUI.setStatus("Pumpkin: got it!")
State.pumpkin.hasPumpkin=true
local postFlag=function() return flag() and State.pumpkin.run==myRun and not State.dead end
if Cfg.SafeMode then
GUI.setStatus("Pumpkin: got it! Safe Mode → platform...")
createSafePlatform()
goToSafePlatform(postFlag)
State.api.releaseCharacterControl("pumpkin-safe")
else
pumpkinEscapeAfterCollect(postFlag)
end
State.pumpkin.hasPumpkin=false
State.api.releaseCharacterControl("pumpkin-complete")
end
State.pumpkin.active=false;updateTitle()
else
GUI.setStatus("Pumpkin: no targets")
task.wait(0.8)
end
task.wait(Cfg.PumpkinCheckInterval)
end
State.pumpkin.active=false;updateTitle()
end
local function startPumpkinGuard()
State.flags.Pumpkin=true
task.spawn(function() runPumpkinMinigame(function() return State.flags.Pumpkin end) end)
end
local function stopPumpkinGuard()
State.flags.Pumpkin=false
State.pumpkin.run=State.pumpkin.run+1
State.pumpkin.active=false
State.api.releaseCharacterControl("pumpkin-stop")
updateTitle();GUI.setStatus("Idle")
end
local function runAntiCandyScape(flag)
local nextAction=0
while flag() and not State.dead do
local ok,err=pcall(function()
if os.clock()<nextAction or State.candy.active then return end
local bullets=workspace:FindFirstChild("Bullets")
local hrp=getHRP()
if not bullets or not hrp then return end
local closest,nearest=nil,Cfg.CandyScapeRadius
for _,proj in ipairs(bullets:GetChildren()) do
if proj.Name=="PurpleProjectile" and proj:IsA("BasePart") then
local d=(proj.Position-hrp.Position).Magnitude
if d<nearest then closest,nearest=proj,d end
end
end
if not closest then return end
nextAction=os.clock()+math.max(1,Cfg.CandyCooldown)
State.candy.active=true;updateTitle()
local away=hrp.Position-closest.Position
local direction=away.Magnitude>0.5 and away.Unit or -hrp.CFrame.LookVector
local perpendicular=Vector3.new(-direction.Z,0,direction.X)
local candidatePositions={
hrp.Position+direction*math.min(30,Cfg.CandyScapeRadius*.65),
hrp.Position+perpendicular*20,
hrp.Position-perpendicular*20,
}
GUI.setStatus("Anti-Candy: procurando saida...")
for _,candidate in ipairs(candidatePositions) do
if not flag() or State.dead then break end
local here=getHRP();if not here then break end
candidate=snapToGround(candidate)
if (candidate-closest.Position).Magnitude>(here.Position-closest.Position).Magnitude then
if goTo(candidate,function() return flag() and not State.dead end,math.min(Cfg.WalkSpeed,55)) then break end
end
end
end)
State.candy.active=false;updateTitle()
if not ok then warn("[JJS Anti-Candy]",err);nextAction=os.clock()+3 end
task.wait(.25)
end
State.candy.active=false;updateTitle()
end
local function startAntiCandy()
if State.flags.Candy then return end
State.flags.Candy=true
State.threads.Candy=task.spawn(function()
runAntiCandyScape(function() return State.flags.Candy end)
State.threads.Candy=nil
end)
end
local function stopAntiCandy()
State.flags.Candy=false;State.candy.active=false
if State.threads.Candy then pcall(task.cancel,State.threads.Candy);State.threads.Candy=nil end
updateTitle()
end
function State.api.itemWithinMaxDistance(itemOrPos)
local pos=typeof(itemOrPos)=="Vector3" and itemOrPos or objectPos(itemOrPos)
local hrp=getHRP()
if not pos or not hrp then return false end
return (pos-hrp.Position).Magnitude<(Cfg.ItemMaxDistance or 10000)
end
function State.api.itemIsCarried(item)
if not item or not item.Parent then return false end
local ch=LP.Character
local bp=LP:FindFirstChildOfClass("Backpack")
if ch and item:IsDescendantOf(ch) then return true end
if bp and item:IsDescendantOf(bp) then return true end

local function partCarried(part)
if not part or not part:IsA("BasePart") then return false end
local root=part.AssemblyRootPart
if ch and root and root:IsDescendantOf(ch) then return true end
for _,joint in ipairs(part:GetJoints()) do
local p0,p1
pcall(function() p0=joint.Part0;p1=joint.Part1 end)
if ch and ((p0 and p0:IsDescendantOf(ch)) or (p1 and p1:IsDescendantOf(ch))) then
return true
end
end
return false
end

if item:IsA("BasePart") and partCarried(item) then return true end
if item:IsA("Model") then
for _,d in ipairs(item:GetDescendants()) do
if d:IsA("BasePart") and partCarried(d) then return true end
end
end
return false
end

function State.api.itemReallyCollectible(item)
if not item or not item.Parent then return false end
if State.api.itemIsCarried(item) then return false end
local folder=workspace:FindFirstChild("Items")
if not folder or not item:IsDescendantOf(folder) then return false end
return true
end
local function getItems()
local list={}
local folder=workspace:FindFirstChild("Items")
if not folder then return list end
for _,obj in ipairs(folder:GetChildren()) do
if (obj:IsA("BasePart") or obj:IsA("MeshPart") or obj:IsA("Model")) and State.api.itemReallyCollectible(obj) then
local p=objectPos(obj)
if p and State.api.itemWithinMaxDistance(p) then list[#list+1]=obj end
end
end
return list
end
function State.api.getMySetAssets()
local chars=workspace:FindFirstChild("Characters")
local myModel=chars and (chars:FindFirstChild(LP.Name) or chars:FindFirstChild(LP.DisplayName))
myModel=myModel or LP.Character
return myModel and myModel:FindFirstChild("SetAssets",true) or nil
end
function State.api.itemOwnedCount(itemName)
local wanted=string.lower(tostring(itemName or ""));if wanted=="" then return 0 end
local count,seen=0,{}
local function scan(root)
if not root then return end
for _,obj in ipairs(root:GetDescendants()) do
if not seen[obj] and string.lower(obj.Name)==wanted then seen[obj]=true;count=count+1 end
end
end
scan(State.api.getMySetAssets())
scan(LP:FindFirstChildOfClass("Backpack"))
-- Character is useful on games that equip/parent picked items directly to the player model.
local ch=LP.Character
if ch then
local setAssets=State.api.getMySetAssets()
for _,obj in ipairs(ch:GetDescendants()) do
if (not setAssets or not obj:IsDescendantOf(setAssets)) and not seen[obj] and string.lower(obj.Name)==wanted then seen[obj]=true;count=count+1 end
end
end
return count
end
function State.api.itemIsInSetAssets(itemName)
return State.api.itemOwnedCount(itemName)>0
end
function State.api.findLiveItem(itemName,nearPos)
local folder=workspace:FindFirstChild("Items")
if not folder then return nil end
local wanted=string.lower(tostring(itemName or ""));local best,bestD=nil,math.huge
local hrp=getHRP();nearPos=nearPos or (hrp and hrp.Position)
for _,obj in ipairs(folder:GetChildren()) do
if string.lower(obj.Name)==wanted and (obj:IsA("BasePart") or obj:IsA("MeshPart") or obj:IsA("Model")) and State.api.itemReallyCollectible(obj) then
local p=objectPos(obj)
if p and State.api.itemWithinMaxDistance(p) then
local d=nearPos and (p-nearPos).Magnitude or 0
if d<bestD then best,bestD=obj,d end
end
end
end
return best
end
function State.api.itemGoneFromWorld(item)
if not item or not item.Parent then return true end
if State.api.itemIsCarried(item) then return true end
local folder=workspace:FindFirstChild("Items")
return not folder or not item:IsDescendantOf(folder)
end
function State.api.verifyItemPickup(itemName,flag,worldItem,beforeCount)
beforeCount=beforeCount==nil and State.api.itemOwnedCount(itemName) or beforeCount
for i=1,8 do
if State.dead or (flag and not flag()) then return false end
if State.api.itemGoneFromWorld(worldItem) then return true end
if State.api.itemOwnedCount(itemName)>beforeCount then return true end
GUI.setStatus(("Checking %s (%d/8)..."):format(itemName,i))
task.wait(.12)
end
return State.api.itemGoneFromWorld(worldItem) or State.api.itemOwnedCount(itemName)>beforeCount
end
local function itemDropCurrent()
local function sendBackspace()
if not VIM then return false end
local ok=pcall(function()
VIM:SendKeyEvent(true,Enum.KeyCode.Backspace,false,game)
task.wait(0.05)
VIM:SendKeyEvent(false,Enum.KeyCode.Backspace,false,game)
end)
return ok
end
if not UserInputService.TouchEnabled then return sendBackspace() end
local function norm(v) return string.lower(tostring(v or '')):gsub('[%s_%-]+','') end
local wanted={drop=true,dropitem=true,soltar=true,soltaritem=true,largar=true,largaritem=true}
for _,obj in ipairs(PGui:GetDescendants()) do
if obj:IsA('GuiButton') and obj.Visible then
local n=norm(obj.Name)
local t=obj:IsA('TextButton') and norm(obj.Text) or ''
if wanted[n] or wanted[t] then
local ok=pcall(function() obj:Activate() end)
if ok then return true end
if EXE.firesignal then
local ok2=pcall(function() EXE.firesignal(obj.MouseButton1Click) end)
if ok2 then return true end
end
end
end
end
return sendBackspace()
end
local function itemReturnExact(returnCF,flag,speedOverride)
if not returnCF then return false end
flag=flag or function() return true end
local returnSpeed=math.max(speedOverride or Cfg.WalkSpeed,1)
local target=returnCF.Position
local maxTries=5

for attempt=1,maxTries do
if State.dead or not flag() then return false end
local h=getHRP();if not h then return false end
if (h.Position-target).Magnitude<=2 then break end

GUI.setStatus(("Returning to start • try %d/%d"):format(attempt,maxTries))
State.pathCache={t=0}

local ok=goToItem3D(target,flag,returnSpeed,attempt-1)
h=getHRP()
if ok and h and (h.Position-target).Magnitude<=3 then break end

if h and flag() then
local pts=computeItem3DPath(h.Position,target,attempt)
if pts and #pts>=2 then
followItem3DPath(pts,flag,returnSpeed)
end
end

h=getHRP()
if h and (h.Position-target).Magnitude<=3 then break end
task.wait(.08)
end

local h=getHRP()
if not h or not flag() then return false end

-- If five independent return calculations failed, use the exact route
-- recorded while advancing, in reverse.
if (h.Position-target).Magnitude>3 then
GUI.setStatus("Return fallback • reversing advance route")
State.pathCache={t=0}
local ok=traceReplayBack(flag,returnSpeed)
h=getHRP()
if not ok or not h then return false end
end

-- Final short correction only when the start point is directly reachable.
h=getHRP()
if h and flag() and (h.Position-target).Magnitude<=8 and lineSafe(h.Position,target) then
pcall(function()
h.CFrame=returnCF
h.AssemblyLinearVelocity=Vector3.zero
h.AssemblyAngularVelocity=Vector3.zero
end)
end

h=getHRP()
return h~=nil and (h.Position-target).Magnitude<=2
end
State.api.itemApproachPosition=function(item,fallback)
local hrp=getHRP()
if item and item.Parent then
local prompts=collectPrompts(item)
local best,bestD=nil,math.huge
for _,p in ipairs(prompts) do
local par=p.Parent
local pos=par and par:IsA("BasePart") and par.Position or objectPos(par)
if pos then
local d=hrp and (pos-hrp.Position).Magnitude or 0
if d<bestD then best,bestD=pos,d end
end
end
if best then return snapToGround(best) end
if item:IsA("Model") then
local bestPart,bpd=nil,math.huge
for _,d in ipairs(item:GetDescendants()) do
if d:IsA("BasePart") then
local dist=hrp and (d.Position-hrp.Position).Magnitude or 0
if dist<bpd then bestPart,bpd=d,dist end
end
end
if bestPart then return snapToGround(bestPart.Position) end
elseif item:IsA("BasePart") then
return snapToGround(item.Position)
end
end
return safeTargetHeight(fallback)
end
function State.api.tryPickupNearbyItem(liveItem,itemName,originPos,flag)
if not liveItem or not liveItem.Parent then return false end
local hrp=getHRP();if not hrp then return false end
local p=State.api.itemApproachPosition(liveItem,originPos or objectPos(liveItem))
if not p or (p-hrp.Position).Magnitude>(Cfg.ItemNearPickupRadius or 22) then return false end
local before=State.api.itemOwnedCount(itemName)
local prompts=collectPrompts(liveItem)
if #prompts==0 and liveItem.Parent then
local parent=liveItem.Parent
for _,pr in ipairs(parent:GetDescendants()) do
if pr:IsA("ProximityPrompt") then
local pp=pr.Parent;local ppPos=pp and pp:IsA("BasePart") and pp.Position or objectPos(pp)
if not ppPos or (ppPos-(originPos or objectPos(liveItem) or p)).Magnitude<=16 then prompts[#prompts+1]=pr end
end
end
end
if #prompts==0 then return false end
-- Being "near" is not enough on every executor/server. Move into real prompt range first.
hrp=getHRP()
if hrp and (p-hrp.Position).Magnitude>5.5 then
GUI.setStatus("Nearby item: approaching "..itemName)
State.pathCache={t=0}
goToItem3D(p,flag,math.min(Cfg.WalkSpeed,70),0)
end
GUI.setStatus("Nearby item: picking up "..itemName)
for press=1,6 do
if flag and not flag() then return false end
for _,pr in ipairs(prompts) do if pr and pr.Parent then firePromptInstant(pr) end end
task.wait(.09)
if State.api.itemGoneFromWorld(liveItem) or State.api.itemOwnedCount(itemName)>before then return true end
end
return State.api.verifyItemPickup(itemName,flag,liveItem,before)
end
function State.api.bringItemAndPickup(item,flag)
if State.mobileLite then return false,"PC only" end
if not item or not item.Parent or not State.api.itemReallyCollectible(item) then return false,"item unavailable" end
flag=flag or function() return true end
local hrp=getHRP();if not hrp then return false,"character unavailable" end
local itemName=item.Name
local ownedBefore=State.api.itemOwnedCount(itemName)
local originalPivot=nil
pcall(function()
if item:IsA("Model") then originalPivot=item:GetPivot()
elseif item:IsA("BasePart") then originalPivot=item.CFrame end
end)

local function moveItem(cf)
local ok=false
if item:IsA("Model") then
ok=pcall(function()
item:PivotTo(cf)
for _,d in ipairs(item:GetDescendants()) do
if d:IsA("BasePart") then
d.AssemblyLinearVelocity=Vector3.zero
d.AssemblyAngularVelocity=Vector3.zero
end
end
end)
elseif item:IsA("BasePart") then
ok=pcall(function()
item.CFrame=cf
item.AssemblyLinearVelocity=Vector3.zero
item.AssemblyAngularVelocity=Vector3.zero
end)
end
return ok
end

for attempt=1,math.max(1,Cfg.ItemBringAttempts or 3) do
if State.dead or not flag() or not item.Parent then return false,"canceled" end
hrp=getHRP();if not hrp then return false,"character unavailable" end
local dist=math.clamp(Cfg.ItemBringDistance or 4.5,2.5,8)
local targetCF=hrp.CFrame*CFrame.new(0,0,-dist)
GUI.setStatus(("Bring Item: %s • try %d"):format(itemName,attempt))
moveItem(targetCF)
task.wait(.05)
for _,pr in ipairs(collectPrompts(item)) do
if pr and pr.Parent then firePromptInstant(pr) end
end
task.wait(.12)
if State.api.verifyItemPickup(itemName,flag,item,ownedBefore) then
return true,"collected"
end
end

-- Avoid leaving a locally desynced object at the player if the server rejected it.
if item and item.Parent and originalPivot then
pcall(function()
if item:IsA("Model") then item:PivotTo(originalPivot)
elseif item:IsA("BasePart") then item.CFrame=originalPivot end
end)
end
return false,"server did not confirm pickup"
end

local function openItemsPanel()
if State.items.panel and State.items.panel.Parent then
State.items.panel.Visible=not State.items.panel.Visible
return
end
local panel=Instance.new("Frame",GUI.Gui)
responsivePanel(panel,UDim2.new(0,280,0,400),UDim2.new(0,660,0.15,0),540)
panel.BackgroundColor3=Color3.fromRGB(18,18,22);panel.BorderSizePixel=0;panel.Active=true
Instance.new("UICorner",panel).CornerRadius=UDim.new(0,10)
local stroke=Instance.new("UIStroke",panel)
stroke.Color=Color3.fromRGB(100,200,100);stroke.Thickness=2
local title=Instance.new("TextLabel",panel)
title.Size=UDim2.new(1,-50,0,32);title.Position=UDim2.new(0,12,0,0)
title.BackgroundTransparency=1;title.Text="📦 Items"
title.TextColor3=Color3.fromRGB(120,255,120);title.Font=Enum.Font.SourceSansBold
title.TextSize=15;title.TextXAlignment=Enum.TextXAlignment.Left
makeDraggable(panel,title)
local close=Instance.new("TextButton",panel)
close.Size=UDim2.new(0,28,0,28);close.Position=UDim2.new(1,-34,0,4)
close.BackgroundColor3=Color3.fromRGB(150,40,40);close.Text="✕"
close.TextColor3=Color3.fromRGB(255,255,255);close.Font=Enum.Font.SourceSansBold
close.TextSize=14
Instance.new("UICorner",close).CornerRadius=UDim.new(0,6)
bindClick(close,function() panel.Visible=false end)
local tabs=Instance.new("Frame",panel)
tabs.Size=UDim2.new(1,-20,0,32);tabs.Position=UDim2.new(0,10,0,36);tabs.BackgroundTransparency=1
local browseTab=Instance.new("TextButton",tabs)
local queueTab=Instance.new("TextButton",tabs)
local optionsTab=Instance.new("TextButton",tabs)
local tabButtons={browseTab,queueTab,optionsTab}
local tabNames={"Browse","Queue","Options"}
for i,b in ipairs(tabButtons) do
b.Size=UDim2.new(1/3,-4,1,0);b.Position=UDim2.new((i-1)/3,(i-1)*2,0,0)
b.BackgroundColor3=Color3.fromRGB(38,38,44);b.BorderSizePixel=0;b.Text=tabNames[i]
b.TextColor3=Color3.fromRGB(220,220,225);b.Font=Enum.Font.SourceSansBold;b.TextSize=11
Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
end
local content=Instance.new("Frame",panel)
content.Size=UDim2.new(1,-16,1,-118);content.Position=UDim2.new(0,8,0,72);content.BackgroundTransparency=1
local browseFrame=Instance.new("Frame",content);browseFrame.Size=UDim2.fromScale(1,1);browseFrame.BackgroundTransparency=1
local queueFrame=Instance.new("Frame",content);queueFrame.Size=UDim2.fromScale(1,1);queueFrame.BackgroundTransparency=1;queueFrame.Visible=false
local optionsFrame=Instance.new("Frame",content);optionsFrame.Size=UDim2.fromScale(1,1);optionsFrame.BackgroundTransparency=1;optionsFrame.Visible=false
local function showItemsTab(name)
browseFrame.Visible=name=="Browse";queueFrame.Visible=name=="Queue";optionsFrame.Visible=name=="Options"
for i,b in ipairs(tabButtons) do
b.BackgroundColor3=(tabNames[i]==name) and Color3.fromRGB(225,105,25) or Color3.fromRGB(45,25,58)
end
end
bindClick(browseTab,function() showItemsTab("Browse") end)
bindClick(queueTab,function() showItemsTab("Queue") end)
bindClick(optionsTab,function() showItemsTab("Options") end)
showItemsTab("Browse")
local queueTitle=Instance.new("TextLabel",queueFrame)
queueTitle.Size=UDim2.new(1,-12,0,28);queueTitle.Position=UDim2.new(0,6,0,4);queueTitle.BackgroundTransparency=1
queueTitle.Text="Collection Queue";queueTitle.TextColor3=Color3.fromRGB(120,255,160);queueTitle.Font=Enum.Font.SourceSansBold;queueTitle.TextSize=13;queueTitle.TextXAlignment=Enum.TextXAlignment.Left
local queueScroll=Instance.new("ScrollingFrame",queueFrame)
queueScroll.Size=UDim2.new(1,-8,1,-40);queueScroll.Position=UDim2.new(0,4,0,36);queueScroll.BackgroundColor3=Color3.fromRGB(24,24,30)
queueScroll.BackgroundTransparency=.12;queueScroll.BorderSizePixel=0;queueScroll.ScrollBarThickness=4;queueScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y;queueScroll.CanvasSize=UDim2.new()
Instance.new("UICorner",queueScroll).CornerRadius=UDim.new(0,7)
local queueLabel=Instance.new("TextLabel",queueScroll)
queueLabel.Size=UDim2.new(1,-16,0,0);queueLabel.AutomaticSize=Enum.AutomaticSize.Y;queueLabel.Position=UDim2.new(0,8,0,8)
queueLabel.BackgroundTransparency=1;queueLabel.Text="Queue empty";queueLabel.TextColor3=Color3.fromRGB(220,220,225)
queueLabel.Font=Enum.Font.SourceSans;queueLabel.TextSize=12;queueLabel.TextWrapped=true;queueLabel.TextXAlignment=Enum.TextXAlignment.Left;queueLabel.TextYAlignment=Enum.TextYAlignment.Top
State.control.queueLabel=queueLabel
local scroll=Instance.new("ScrollingFrame",browseFrame)
scroll.Size=UDim2.new(1,0,1,-40);scroll.Position=UDim2.new(0,0,0,40)
scroll.BackgroundTransparency=1;scroll.BorderSizePixel=0;scroll.ScrollBarThickness=5
scroll.ScrollBarImageColor3=Color3.fromRGB(100,200,100)
local backToggle=Instance.new("TextButton",optionsFrame)
backToggle.Size=UDim2.new(1,-12,0,38);backToggle.Position=UDim2.new(0,6,0,8)
backToggle.BackgroundColor3=Color3.fromRGB(42,25,49);backToggle.Text="";backToggle.ZIndex=5
Instance.new("UICorner",backToggle).CornerRadius=UDim.new(0,6)
local bdot=Instance.new("TextLabel",backToggle)
bdot.Size=UDim2.new(0,20,1,0);bdot.Position=UDim2.new(0,6,0,0)
bdot.BackgroundTransparency=1;bdot.Font=Enum.Font.SourceSansBold;bdot.TextSize=15;bdot.ZIndex=3
local blbl=Instance.new("TextLabel",backToggle)
blbl.Size=UDim2.new(1,-30,1,0);blbl.Position=UDim2.new(0,26,0,0)
blbl.BackgroundTransparency=1;blbl.TextColor3=Color3.fromRGB(255,255,255)
blbl.Font=Enum.Font.SourceSansSemibold;blbl.TextSize=12
blbl.TextXAlignment=Enum.TextXAlignment.Left;blbl.ZIndex=3
local bOn=Cfg.ItemsReturnBack
local function bRender()
if bOn then
bdot.Text="●";bdot.TextColor3=Color3.fromRGB(90,255,90)
blbl.Text="Return To Start: ON";backToggle.BackgroundColor3=Color3.fromRGB(180,70,0)
else
bdot.Text="○";bdot.TextColor3=Color3.fromRGB(160,160,160)
blbl.Text="Return To Start: OFF";backToggle.BackgroundColor3=Color3.fromRGB(42,25,49)
end
end
bindClick(backToggle,function()
bOn=not bOn
Cfg.ItemsReturnBack=bOn
bRender()
GUI.setStatus("Items: Return To Start "..(bOn and "ON" or "OFF"))
end)
bRender()
local autoRefresh=Instance.new("TextButton",optionsFrame)
autoRefresh.Size=UDim2.new(1,-12,0,36);autoRefresh.Position=UDim2.new(0,6,0,102);autoRefresh.BorderSizePixel=0
autoRefresh.TextColor3=Color3.new(1,1,1);autoRefresh.Font=Enum.Font.SourceSansSemibold;autoRefresh.TextSize=12
Instance.new("UICorner",autoRefresh).CornerRadius=UDim.new(0,6)
local function renderAutoRefresh()
autoRefresh.Text="Auto Refresh: "..(Cfg.ItemAutoRefresh and "ON" or "OFF")
autoRefresh.BackgroundColor3=Cfg.ItemAutoRefresh and Color3.fromRGB(205,88,25) or Color3.fromRGB(45,25,58)
end
bindClick(autoRefresh,function() Cfg.ItemAutoRefresh=not Cfg.ItemAutoRefresh;renderAutoRefresh() end);renderAutoRefresh()
local routeInfo=Instance.new("TextLabel",optionsFrame)
routeInfo.Size=UDim2.new(1,-12,0,46);routeInfo.Position=UDim2.new(0,6,0,146);routeInfo.BackgroundColor3=Color3.fromRGB(30,16,39)
routeInfo.BorderSizePixel=0;routeInfo.TextColor3=Color3.fromRGB(200,205,215);routeInfo.Font=Enum.Font.SourceSans;routeInfo.TextSize=11
routeInfo.TextWrapped=true;routeInfo.TextXAlignment=Enum.TextXAlignment.Left;routeInfo.TextYAlignment=Enum.TextYAlignment.Top
routeInfo.Text="Smart Path • Return To Start optional\nPC: Item Blatant + Bring Selected"
Instance.new("UICorner",routeInfo).CornerRadius=UDim.new(0,7)
local stopBtn=Instance.new("TextButton",optionsFrame)
stopBtn.Size=UDim2.new(0.5,-10,0,40);stopBtn.Position=UDim2.new(0,6,0,54)
stopBtn.BackgroundColor3=Color3.fromRGB(180,40,40);stopBtn.Text="Stop Action"
stopBtn.TextColor3=Color3.fromRGB(255,255,255);stopBtn.Font=Enum.Font.SourceSansSemibold
stopBtn.TextSize=12
Instance.new("UICorner",stopBtn).CornerRadius=UDim.new(0,6)
local backBtn=Instance.new("TextButton",optionsFrame)
backBtn.Size=UDim2.new(0.5,-10,0,40);backBtn.Position=UDim2.new(0.5,4,0,54)
backBtn.BackgroundColor3=Color3.fromRGB(145,70,200);backBtn.Text="Return to Start"
backBtn.TextColor3=Color3.fromRGB(255,255,255);backBtn.Font=Enum.Font.SourceSansSemibold
backBtn.TextSize=12
Instance.new("UICorner",backBtn).CornerRadius=UDim.new(0,6)
local collectBtn=Instance.new("TextButton",panel)
collectBtn.Size=UDim2.new(1,-20,0,40);collectBtn.Position=UDim2.new(0,10,1,-44)
collectBtn.BackgroundColor3=Color3.fromRGB(40,120,40);collectBtn.Text="Collect Selected"
collectBtn.TextColor3=Color3.fromRGB(255,255,255);collectBtn.Font=Enum.Font.SourceSansSemibold
collectBtn.TextSize=13
Instance.new("UICorner",collectBtn).CornerRadius=UDim.new(0,6)
local selected={}
State.items.selected=selected

local itemBlatantBtn=nil
local bringSelectedBtn=nil
if not State.mobileLite then
itemBlatantBtn=Instance.new("TextButton",optionsFrame)
itemBlatantBtn.Size=UDim2.new(.5,-9,0,36);itemBlatantBtn.Position=UDim2.new(0,6,0,198)
itemBlatantBtn.BorderSizePixel=0;itemBlatantBtn.TextColor3=Color3.new(1,1,1)
itemBlatantBtn.Font=Enum.Font.SourceSansBold;itemBlatantBtn.TextSize=11
Instance.new("UICorner",itemBlatantBtn).CornerRadius=UDim.new(0,6)
local function renderItemBlatant()
itemBlatantBtn.Text="Item Blatant: "..(Cfg.ItemBlatant and "ON" or "OFF")
itemBlatantBtn.BackgroundColor3=Cfg.ItemBlatant and Color3.fromRGB(225,105,25) or Color3.fromRGB(45,25,58)
end
bindClick(itemBlatantBtn,function()
Cfg.ItemBlatant=not Cfg.ItemBlatant
renderItemBlatant()
GUI.setStatus("Item Blatant: "..(Cfg.ItemBlatant and "ON" or "OFF"))
end)
renderItemBlatant()

bringSelectedBtn=Instance.new("TextButton",optionsFrame)
bringSelectedBtn.Size=UDim2.new(.5,-9,0,36);bringSelectedBtn.Position=UDim2.new(.5,3,0,198)
bringSelectedBtn.BorderSizePixel=0;bringSelectedBtn.BackgroundColor3=Color3.fromRGB(112,58,150)
bringSelectedBtn.Text="Bring Selected";bringSelectedBtn.TextColor3=Color3.new(1,1,1)
bringSelectedBtn.Font=Enum.Font.SourceSansBold;bringSelectedBtn.TextSize=11
Instance.new("UICorner",bringSelectedBtn).CornerRadius=UDim.new(0,6)
end

local refreshItems
local search=Instance.new("TextBox",browseFrame)
search.Name="ItemSearch";search.Size=UDim2.new(1,-12,0,32);search.Position=UDim2.new(0,6,0,4)
search.BackgroundColor3=Color3.fromRGB(32,32,38);search.TextColor3=Color3.new(1,1,1);search.PlaceholderText="Search items...";search.Text=""
search.Font=Enum.Font.SourceSansSemibold;search.TextSize=12;search.ClearTextOnFocus=false
Instance.new("UICorner",search).CornerRadius=UDim.new(0,6)
local selectVisible=Instance.new("TextButton",browseFrame)
selectVisible.Size=UDim2.new(.5,-9,0,28);selectVisible.Position=UDim2.new(0,6,0,38);selectVisible.Text="Select Visible"
selectVisible.BackgroundColor3=Color3.fromRGB(184,78,24);selectVisible.TextColor3=Color3.new(1,1,1);selectVisible.Font=Enum.Font.SourceSansBold;selectVisible.TextSize=10
Instance.new("UICorner",selectVisible).CornerRadius=UDim.new(0,6)
local clearSelected=Instance.new("TextButton",browseFrame)
clearSelected.Size=UDim2.new(.5,-9,0,28);clearSelected.Position=UDim2.new(.5,3,0,38);clearSelected.Text="Clear"
clearSelected.BackgroundColor3=Color3.fromRGB(112,48,88);clearSelected.TextColor3=Color3.new(1,1,1);clearSelected.Font=Enum.Font.SourceSansBold;clearSelected.TextSize=10
Instance.new("UICorner",clearSelected).CornerRadius=UDim.new(0,6)
scroll.Position=UDim2.new(0,0,0,70);scroll.Size=UDim2.new(1,0,1,-70)
search:GetPropertyChangedSignal("Text"):Connect(function() State.control.search=string.lower(search.Text or "");task.defer(refreshItems) end)
refreshItems=function()
for _,c in ipairs(scroll:GetChildren()) do
if c:IsA("Frame") or c:IsA("TextButton") then c:Destroy() end
end
State.control.itemCategories=State.control.itemCategories or {
["VERY CLOSE • 0-50 studs"]=true,
["NEAR • 51-150 studs"]=true,
["MEDIUM • 151-300 studs"]=true,
["FAR • 301+ studs"]=true,
}
local hrp=getHRP()
local groups={
["VERY CLOSE • 0-50 studs"]={},
["NEAR • 51-150 studs"]={},
["MEDIUM • 151-300 studs"]={},
["FAR • 301+ studs"]={},
}
local order={"VERY CLOSE • 0-50 studs","NEAR • 51-150 studs","MEDIUM • 151-300 studs","FAR • 301+ studs"}
local q=State.control.search or ""
for _,item in ipairs(getItems()) do
local p=objectPos(item)
local dist=(hrp and p) and (p-hrp.Position).Magnitude or math.huge
if dist<(Cfg.ItemMaxDistance or 10000) and (q=="" or string.find(string.lower(item.Name),q,1,true)) then
local cat=dist<=50 and order[1] or dist<=150 and order[2] or dist<=300 and order[3] or order[4]
groups[cat][#groups[cat]+1]={Item=item,Dist=dist,Fav=State.control.favorites[item.Name] and true or false}
end
end
for _,cat in ipairs(order) do
table.sort(groups[cat],function(a,b)
if a.Fav~=b.Fav then return a.Fav end
if a.Dist==b.Dist then return a.Item.Name:lower()<b.Item.Name:lower() end
return a.Dist<b.Dist
end)
end

local y=4
for _,category in ipairs(order) do
local entries=groups[category]
if #entries>0 then
local open=State.control.itemCategories[category]~=false
local header=Instance.new("TextButton",scroll)
header.Size=UDim2.new(1,-16,0,28);header.Position=UDim2.new(0,8,0,y)
header.BackgroundColor3=Color3.fromRGB(45,24,58);header.BorderSizePixel=0
header.Text=(open and "▼  " or "▶  ")..category.."  ("..#entries..")"
header.TextColor3=Color3.fromRGB(255,170,70);header.Font=Enum.Font.SourceSansBold
header.TextSize=11;header.TextXAlignment=Enum.TextXAlignment.Left
Instance.new("UICorner",header).CornerRadius=UDim.new(0,6)
bindClick(header,function()
State.control.itemCategories[category]=not (State.control.itemCategories[category]~=false)
task.defer(refreshItems)
end)
y+=32
if open then
for _,entry in ipairs(entries) do
local item,dist=entry.Item,entry.Dist
local row=Instance.new("TextButton",scroll)
row.Size=UDim2.new(1,-16,0,36);row.Position=UDim2.new(0,8,0,y)
row.BackgroundColor3=selected[item] and Color3.fromRGB(102,52,45) or Color3.fromRGB(34,18,42)
row.Text="";row.AutoButtonColor=true
Instance.new("UICorner",row).CornerRadius=UDim.new(0,5)
local star=Instance.new("TextButton",row)
star.Size=UDim2.new(0,24,1,0);star.Position=UDim2.new(0,2,0,0);star.BackgroundTransparency=1
star.Text=State.control.favorites[item.Name] and "★" or "☆";star.TextColor3=Color3.fromRGB(255,205,60)
star.Font=Enum.Font.SourceSansBold;star.TextSize=16
bindClick(star,function()
State.control.favorites[item.Name]=not State.control.favorites[item.Name]
task.defer(refreshItems)
end)
local check=Instance.new("TextLabel",row)
check.Size=UDim2.new(0,24,1,0);check.Position=UDim2.new(0,26,0,0)
check.BackgroundTransparency=1;check.Text=selected[item] and "☑" or "☐"
check.TextColor3=Color3.fromRGB(255,150,70);check.Font=Enum.Font.SourceSansBold;check.TextSize=16
local name=Instance.new("TextLabel",row)
name.Size=UDim2.new(1,-112,1,0);name.Position=UDim2.new(0,52,0,0)
name.BackgroundTransparency=1;name.Text=item.Name
name.TextColor3=Color3.fromRGB(230,230,230);name.Font=Enum.Font.SourceSans
name.TextSize=12;name.TextXAlignment=Enum.TextXAlignment.Left;name.TextTruncate=Enum.TextTruncate.AtEnd
local distance=Instance.new("TextLabel",row)
distance.Size=UDim2.new(0,58,1,0);distance.Position=UDim2.new(1,-64,0,0)
distance.BackgroundTransparency=1;distance.Text=dist<math.huge and (math.floor(dist).." studs") or "?"
distance.TextColor3=Color3.fromRGB(180,160,190);distance.Font=Enum.Font.SourceSansSemibold
distance.TextSize=11;distance.TextXAlignment=Enum.TextXAlignment.Right
bindClick(row,function()
selected[item]=not selected[item]
check.Text=selected[item] and "☑" or "☐"
row.BackgroundColor3=selected[item] and Color3.fromRGB(102,52,45) or Color3.fromRGB(34,18,42)
end)
y+=40
end
end
end
end
scroll.CanvasSize=UDim2.new(0,0,0,y+8)
end
bindClick(selectVisible,function()
local q=State.control.search or ""
for _,item in ipairs(getItems()) do
if q=="" or string.find(string.lower(item.Name),q,1,true) then selected[item]=true end
end
refreshItems()
end)
bindClick(clearSelected,function()
for item in pairs(selected) do selected[item]=nil end
refreshItems()
end)
if bringSelectedBtn then
bindClick(bringSelectedBtn,function()
if State.items.running then GUI.setStatus("Items already running");return end
local chosen=nil
local hrp=getHRP()
local best=math.huge
for item,on in pairs(selected) do
if on and item and item.Parent and State.api.itemReallyCollectible(item) then
local p=objectPos(item)
local d=(hrp and p) and (p-hrp.Position).Magnitude or math.huge
if d<best then best=d;chosen=item end
end
end
if not chosen then GUI.setStatus("Bring: select one available item");return end
State.items.runId=(State.items.runId or 0)+1
local run=State.items.runId
State.items.running=true;State.items.cancel=false
task.spawn(function()
local function flag() return State.items.runId==run and not State.items.cancel and not State.dead end
local ok,reason=State.api.bringItemAndPickup(chosen,flag)
if ok then
selected[chosen]=nil
State.items.recent[chosen]=os.clock()+Cfg.ItemRetryCooldown
State.api.queueSet(chosen,"Collected",1)
history("Bring collected "..chosen.Name)
GUI.setStatus("Bring confirmed: "..chosen.Name)
else
GUI.setStatus("Bring failed: "..tostring(reason))
end
State.items.running=false
task.defer(refreshItems)
end)
end)
end
bindClick(collectBtn,function()
if State.items.running then GUI.setStatus("Items already running");return end
local toCollect={}
local now=os.clock()
for item,on in pairs(selected) do
local recentT=State.items.recent[item]
local recentlyTried=recentT and recentT>now
local p=item.Parent and objectPos(item) or nil
if on and item.Parent and p and State.api.itemWithinMaxDistance(p) and not recentlyTried then toCollect[#toCollect+1]=item end
end
if #toCollect==0 then GUI.setStatus("No items to collect");return end
State.items.runId=(State.items.runId or 0)+1
local myRun=State.items.runId
State.items.running=true
State.items.cancel=false
local sortHrp=getHRP()
if sortHrp then
table.sort(toCollect,function(a,b)
local pa,pb=objectPos(a),objectPos(b)
local da=pa and (pa-sortHrp.Position).Magnitude or math.huge
local db=pb and (pb-sortHrp.Position).Magnitude or math.huge
return da<db
end)
end
State.api.queueClear()
for _,qitem in ipairs(toCollect) do State.api.queueSet(qitem,"Waiting",0) end
State.api.setState("Items")
history("Items queue started: "..#toCollect)
task.spawn(function()
local function itemFlag()
return State.items.runId==myRun and not State.items.cancel and not State.dead
end
traceClear();State.pathCache={t=0}
local startHrp=getHRP()
if not startHrp then
local t0=os.clock()
repeat task.wait() startHrp=getHRP() until startHrp or os.clock()-t0>2
end
local returnCF=(Cfg.ItemsReturnBack and startHrp) and startHrp.CFrame or nil
State.items.runOriginCF=returnCF
local multiSelected=#toCollect>1
for queueIndex,item in ipairs(toCollect) do
if not itemFlag() then break end
State.api.queueSet(item,"Going",0)
GUI.setStatus(("Items queue %d/%d: %s"):format(queueIndex,#toCollect,item.Name))
traceStart()
local itemStart=getHRP()
if itemStart then tracePush(itemStart.Position) end
local itemName=item.Name
local itemSpeed=(not State.mobileLite and Cfg.ItemBlatant) and math.max(Cfg.WalkSpeed,Cfg.ItemBlatantSpeed or 180) or Cfg.WalkSpeed
local originalPos=item:IsA("Model") and item:GetPivot().Position or item.Position
local verified=false
local ownedBefore=State.api.itemOwnedCount(itemName)
local attempt=0
while not verified and itemFlag() do
attempt=attempt+1
State.api.queueSet(item,"Going",attempt)
if attempt>(Cfg.ItemMaxAttempts or 8) then
GUI.setStatus("Retry later: "..itemName)
State.api.queueSet(item,"Retry Later",attempt)
State.control.retryQueue[#State.control.retryQueue+1]=item
break
end
local liveItem=(item.Parent and item) or State.api.findLiveItem(itemName,originalPos)
local pos=liveItem and (liveItem:IsA("Model") and liveItem:GetPivot().Position or liveItem.Position) or originalPos
local switchEvery=math.max(1,Cfg.HeightRouteFailSwitch or 2)
local routeVariant=math.floor((attempt-1)/switchEvery)
if routeVariant>0 then
GUI.setStatus(("Collecting: %s (try %d, route %d)"):format(itemName,attempt,routeVariant+1))
else
GUI.setStatus(("Collecting: %s (try %d)"):format(itemName,attempt))
end
local okCollect=false
local hrp=getHRP()
if hrp and liveItem then
verified=State.api.tryPickupNearbyItem(liveItem,itemName,pos,itemFlag)
if verified then okCollect=true end
end
if hrp and not verified then
local finalPos=State.api.itemApproachPosition(liveItem,pos)
okCollect=goToItem3D(finalPos,itemFlag,itemSpeed,routeVariant)
local reached=getHRP()
if okCollect and reached then tracePush(reached.Position) end
clearTrajectory()
end
if okCollect and not verified then
liveItem=(liveItem and liveItem.Parent and liveItem) or State.api.findLiveItem(itemName)
if liveItem then
local prompts=collectPrompts(liveItem)
if #prompts==0 and liveItem.Parent then
local parent=liveItem.Parent
for _,p in ipairs(parent:GetDescendants()) do
if p:IsA("ProximityPrompt") then
local pp=p.Parent
local ppos=pp and pp:IsA("BasePart") and pp.Position or objectPos(pp)
if not ppos or (ppos-pos).Magnitude<=12 then prompts[#prompts+1]=p end
end
end
end
for press=1,3 do
for _,p in ipairs(prompts) do
if p and p.Parent then firePromptInstant(p) end
end
task.wait(0.08)
end
end
task.wait(0.18)
verified=State.api.verifyItemPickup(itemName,itemFlag,liveItem,ownedBefore)
if not verified and itemFlag() then
GUI.setStatus("Item not confirmed, going back: "..itemName)
task.wait(0.2)
end
else
GUI.setStatus("Could not reach item, retrying: "..itemName)
task.wait(0.25)
end
end
if verified then
State.items.recent[item]=os.clock()+Cfg.ItemRetryCooldown
selected[item]=nil
if liveItem then selected[liveItem]=nil end
task.defer(function()
task.wait()
if refreshItems then refreshItems() end
end)
State.api.queueSet(item,"Collected",attempt)
history("Collected "..itemName)
GUI.setStatus("Confirmed: "..itemName)
if Cfg.ItemsReturnBack and itemFlag() and returnCF then
State.pathCache={t=0}
local backOK=itemReturnExact(returnCF,itemFlag,itemSpeed)
if backOK and multiSelected and itemFlag() then
GUI.setStatus("Dropping: "..itemName)
itemDropCurrent()
task.wait(0.18)
end
end
end
traceClear();State.pathCache={t=0}
task.wait(0.2)
end
local retryList=State.control.retryQueue;State.control.retryQueue={}
for _,item in ipairs(retryList) do
if not itemFlag() then break end
local itemName=item.Name
local retrySpeed=(not State.mobileLite and Cfg.ItemBlatant) and math.max(Cfg.WalkSpeed,Cfg.ItemBlatantSpeed or 180) or Cfg.WalkSpeed
local verified=false
local retryBefore=State.api.itemOwnedCount(itemName)
State.api.queueSet(item,"Retrying",1)
for extra=1,3 do
if verified or not itemFlag() then break end
local live=State.api.findLiveItem(itemName,objectPos(item))
if not live then break end
local p=State.api.itemApproachPosition(live,objectPos(live))
State.pathCache={t=0}
if goToItem3D(p,itemFlag,retrySpeed,extra+10) then
for _,pr in ipairs(collectPrompts(live)) do firePromptInstant(pr) end
task.wait(.15);verified=State.api.verifyItemPickup(itemName,itemFlag,live,retryBefore)
end
State.api.queueSet(item,verified and "Collected" or "Retrying",extra)
end
if verified then
selected[item]=nil
history("Collected on retry "..itemName)
if Cfg.ItemsReturnBack and itemFlag() and returnCF then
GUI.setStatus("Returning to start...")
State.pathCache={t=0}
itemReturnExact(returnCF,itemFlag,retrySpeed)
end
else
State.api.queueSet(item,"Failed",3)
history("Failed "..itemName)
end
end
traceClear();State.pathCache={t=0}
if State.items.runId==myRun then
State.items.running=false
State.items.runOriginCF=nil
State.api.setState("Idle")
history(State.items.cancel and "Items canceled" or "Items completed")
GUI.setStatus(State.items.cancel and "Canceled" or "Items collected")
refreshItems()
end
end)
end)
bindClick(stopBtn,function()
State.items.runId=(State.items.runId or 0)+1
State.items.cancel=true
State.items.running=false
State.items.runOriginCF=nil
stopTween();clearTrajectory();traceClear();State.pathCache={t=0}
GUI.setStatus("Items canceled")
end)
bindClick(backBtn,function()
State.items.runId=(State.items.runId or 0)+1
State.items.cancel=true
State.items.running=false
stopTween();clearTrajectory();State.pathCache={t=0}
task.spawn(function()
task.wait(0.2)
if #State.items.trace>1 then
GUI.setStatus("Voltando ao início...")
traceReplayBack(function() return true end,Cfg.WalkSpeed)
traceClear()
GUI.setStatus("Voltou")
end
end)
end)
refreshItems()
local qlines={}
for _,q in pairs(State.control.queue or {}) do qlines[#qlines+1]=(q.name.."  •  "..q.status..(q.attempt and q.attempt>0 and (" #"..q.attempt) or "")) end
table.sort(qlines);queueLabel.Text=#qlines>0 and table.concat(qlines,"\n") or "Queue empty"
State.items.panel=panel
local itemFolder=workspace:FindFirstChild("Items")
local refreshQueued=false
local function queueItemRefresh()
if refreshQueued or State.dead then return end
refreshQueued=true
task.delay(State.mobileLite and .30 or .15,function()
refreshQueued=false
if panel and panel.Parent and panel.Visible and Cfg.ItemAutoRefresh and not State.items.running then
pcall(refreshItems)
end
end)
end
if State.conns.itemAdded then pcall(function() State.conns.itemAdded:Disconnect() end) end
if State.conns.itemRemoved then pcall(function() State.conns.itemRemoved:Disconnect() end) end
if itemFolder then
State.conns.itemAdded=itemFolder.ChildAdded:Connect(queueItemRefresh)
State.conns.itemRemoved=itemFolder.ChildRemoved:Connect(queueItemRefresh)
end
task.spawn(function()
while panel and panel.Parent and not State.dead do
task.wait(Cfg.ItemPanelRefreshFallback or (State.mobileLite and 4.5 or 2))
if Cfg.ItemAutoRefresh and panel.Visible and not State.items.running then
pcall(refreshItems)
end
end
end)
end

local function chooseDeviceProfile()
local selected=nil
local sg=Instance.new("ScreenGui")
sg.Name="JJS_DeviceSelector";sg.ResetOnSpawn=false;sg.IgnoreGuiInset=true;sg.DisplayOrder=100000
pcall(function() sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling end)
local ok=pcall(function() sg.Parent=GUI_PARENT or PGui end)
if not ok or not sg.Parent then sg.Parent=PGui end

local shade=Instance.new("Frame",sg)
shade.Size=UDim2.fromScale(1,1);shade.BackgroundColor3=Color3.fromRGB(8,5,12);shade.BackgroundTransparency=.18
shade.BorderSizePixel=0

local card=Instance.new("Frame",shade)
local _cam=workspace.CurrentCamera
local _vp=_cam and _cam.ViewportSize or Vector2.new(720,480)
local _cardW=math.clamp(_vp.X-24,280,360)
card.Size=UDim2.fromOffset(_cardW,230);card.AnchorPoint=Vector2.new(.5,.5);card.Position=UDim2.fromScale(.5,.5)
card.BackgroundColor3=Color3.fromRGB(20,11,28);card.BorderSizePixel=0;card.Active=true
Instance.new("UICorner",card).CornerRadius=UDim.new(0,14)
local st=Instance.new("UIStroke",card);st.Color=Color3.fromRGB(235,105,20);st.Thickness=2

local title=Instance.new("TextLabel",card)
title.Size=UDim2.new(1,-24,0,54);title.Position=UDim2.fromOffset(12,14);title.BackgroundTransparency=1
title.Text="🎃 Choose your device\nQual dispositivo você está usando?"
title.TextColor3=Color3.fromRGB(255,175,75);title.Font=Enum.Font.SourceSansBold;title.TextSize=18
title.TextWrapped=true

local sub=Instance.new("TextLabel",card)
sub.Size=UDim2.new(1,-28,0,40);sub.Position=UDim2.fromOffset(14,70);sub.BackgroundTransparency=1
sub.Text="PC = full features  •  Mobile = stable & low lag\nPC = completo  •  Mobile = otimizado e estável"
sub.TextColor3=Color3.fromRGB(205,190,215);sub.Font=Enum.Font.SourceSans;sub.TextSize=12
sub.TextWrapped=true

local pc=Instance.new("TextButton",card)
pc.Size=UDim2.new(.5,-18,0,64);pc.Position=UDim2.new(0,12,0,124)
pc.BackgroundColor3=Color3.fromRGB(116,57,154);pc.BorderSizePixel=0
pc.Text="🖥️  PC\nFull / Completo";pc.TextColor3=Color3.new(1,1,1)
pc.Font=Enum.Font.SourceSansBold;pc.TextSize=15;pc.TextWrapped=true
Instance.new("UICorner",pc).CornerRadius=UDim.new(0,10)

local mobile=Instance.new("TextButton",card)
mobile.Size=UDim2.new(.5,-18,0,64);mobile.Position=UDim2.new(.5,6,0,124)
mobile.BackgroundColor3=Color3.fromRGB(220,92,22);mobile.BorderSizePixel=0
mobile.Text="📱  MOBILE\nLow Lag / Otimizado";mobile.TextColor3=Color3.new(1,1,1)
mobile.Font=Enum.Font.SourceSansBold;mobile.TextSize=15;mobile.TextWrapped=true
Instance.new("UICorner",mobile).CornerRadius=UDim.new(0,10)

local hint=Instance.new("TextLabel",card)
hint.Size=UDim2.new(1,-20,0,25);hint.Position=UDim2.new(0,10,1,-31);hint.BackgroundTransparency=1
hint.Text="You can still change settings later / Você ainda pode ajustar depois"
hint.TextColor3=Color3.fromRGB(150,135,165);hint.Font=Enum.Font.SourceSans;hint.TextSize=10

pc.MouseButton1Click:Connect(function() selected="PC" end)
mobile.MouseButton1Click:Connect(function() selected="Mobile" end)

while not selected and sg.Parent do task.wait(.03) end
pcall(function() sg:Destroy() end)
return selected or "Mobile"
end

local function applyDeviceProfile(profile)
State.deviceProfile=profile
State.mobileLite=(profile=="Mobile")
if State.mobileLite then
    Cfg.BlatantMode=false
    State.flags.Blatant=false
    Cfg.LowLag=true
    Cfg.RouteDebugger=false
    Cfg.ShowTrajectory=false
    Cfg.DoorESP=false
    Cfg.ItemESP=false
    Cfg.PlayerESP=false
    Cfg.ItemAutoRefresh=true
    Cfg.ItemBlatant=false
    Cfg.AntiFalseDoor=false
    Cfg.AntiSkeleton=false
    Cfg.SmartOrbit=false
    Cfg.SkeletonRadius=380

    Cfg.RuntimeTick=.035
    Cfg.RouteLoopTimeout=6.0
    Cfg.RouteLoopReturnRadius=14
    Cfg.RouteLoopMinProgress=10
    Cfg.SimpleRouteWaypointSpacing=16
    Cfg.SimpleRouteMaxAttempts=1
    Cfg.PhysicsParamsTTL=.42
    Cfg.OverlapMaxParts=16
    Cfg.ESPUpdateInterval=1.5
    Cfg.DoorRefreshInterval=1.10
    Cfg.DoorDeepScanInterval=8
    Cfg.ItemPanelRefreshFallback=4.5
    Cfg.ObstacleCheckInterval=.42
    Cfg.LockedDoorCheckInterval=.40
    Cfg.SafeRecheckDelay=1.5

    Cfg.RouteCandidateCount=2
    Cfg.RouteScoreSamples=3
    Cfg.SmartRouteRetries=2
    Cfg.PathLookAhead=5
    Cfg.PathLookAhead3D=6
    Cfg.AirPathMaxNodes=9
    Cfg.AirPathMaxDetours=3
    Cfg.Item3DQuickNodes=7
    Cfg.Item3DQuickDetours=2
    Cfg.Item3DRetries=2
    Cfg.ItemMaxPathCycles=14
    Cfg.Item3DChunk=180
    Cfg.LineSafeCacheTTL=.28
    Cfg.LineSafeCacheMax=90
    Cfg.SmallPartDetectRadius=12
    Cfg.TrajectoryMaxPoints=2
    Cfg.PumpkinCheckInterval=.60
    Cfg.PumpkinEscapeStages=2
    Cfg.PumpkinEscapeSpeed=105
    Cfg.ServerHopPages=2
    Cfg.InteractRetryDelay=.20
    Cfg.BlatantSegmentCheckInterval=.24
    Cfg.BlatantDescentSearchRadius=48
    Cfg.BlatantDescentStep=12

    State.smallParts.refreshInterval=1.6
else
    Cfg.LowLag=false
    Cfg.RouteDebugger=true
    Cfg.ShowTrajectory=false
    Cfg.DoorESP=true
    Cfg.ItemESP=false
    Cfg.PlayerESP=false

    Cfg.RuntimeTick=.02
    Cfg.RouteLoopTimeout=7.5
    Cfg.RouteLoopReturnRadius=12
    Cfg.RouteLoopMinProgress=14
    Cfg.SimpleRouteWaypointSpacing=14
    Cfg.SimpleRouteMaxAttempts=2
    Cfg.PhysicsParamsTTL=.22
    Cfg.OverlapMaxParts=32
    Cfg.ESPUpdateInterval=.50
    Cfg.DoorRefreshInterval=.65
    Cfg.DoorDeepScanInterval=5
    Cfg.ItemPanelRefreshFallback=2.0
    Cfg.ObstacleCheckInterval=.25
    Cfg.LockedDoorCheckInterval=.24

    Cfg.RouteCandidateCount=4
    Cfg.RouteScoreSamples=7
    Cfg.SmartRouteRetries=3
    Cfg.PathLookAhead=7
    Cfg.PathLookAhead3D=8
    Cfg.AirPathMaxNodes=14
    Cfg.AirPathMaxDetours=5
    Cfg.Item3DQuickNodes=11
    Cfg.Item3DQuickDetours=4
    Cfg.Item3DRetries=3
    Cfg.ItemMaxPathCycles=22
    Cfg.LineSafeCacheTTL=.12
    Cfg.LineSafeCacheMax=160
    Cfg.BlatantSegmentCheckInterval=.18
    Cfg.BlatantDescentSearchRadius=60
    Cfg.BlatantDescentStep=12
end
State.lineCache={data={},count=0}
State.pathCache={t=0}
State.physicsCache={ray=nil,rayAt=0,overlap=nil,overlapAt=0,char=nil,safePlatform=nil}
end

local SELECTED_DEVICE=chooseDeviceProfile()
applyDeviceProfile(SELECTED_DEVICE)
GUI=buildUI()
local compatName=EXE.Name
if EXE.Delta then compatName="Delta" elseif EXE.Solara then compatName="Solara" elseif EXE.Xeno then compatName="Xeno" end
GUI.setStatus("JJS v12.02 Route Watchdog | "..(State.deviceProfile or "PC").." | "..compatName.." | loaded");pcall(function() State.api.setState("Idle") end);history("JJS v12.02 Route Watchdog • "..(State.deviceProfile or "PC").." • "..compatName)
local guiGuardBusy=false
local function ensureGuiAlive()
if State.dead or guiGuardBusy or not GUI or not GUI.Gui then return end
guiGuardBusy=true
pcall(function()
GUI.Gui.ResetOnSpawn=false
GUI.Gui.Enabled=true
local target=GUI_PARENT or LP:FindFirstChildOfClass("PlayerGui") or PGui
if target and GUI.Gui.Parent~=target then GUI.Gui.Parent=target end
end)
guiGuardBusy=false
end
State.conns.guiAncestry=GUI.Gui.AncestryChanged:Connect(function(_,parent)
if State.dead or parent then return end
task.defer(function()
task.wait()
ensureGuiAlive()
end)
end)
local ADMIN_ID=10413099065
function State.api.showOwnerNotice()
return
end
local serverPanel
State.api.panelBase=function(name,title,size)
local panel=Instance.new("Frame")
panel.Name=name;panel.Size=size;panel.Position=UDim2.new(.5,-size.X.Offset/2,.5,-size.Y.Offset/2)
panel.BackgroundColor3=Color3.fromRGB(23,12,31);panel.BorderSizePixel=0
panel.Visible=false;panel.Active=true;panel.ZIndex=80;panel.Parent=GUI.Gui
responsivePanel(panel,size,UDim2.new(.5,-size.X.Offset/2,.5,-size.Y.Offset/2),size.Y.Offset)
Instance.new("UICorner",panel).CornerRadius=UDim.new(0,10)
local st=Instance.new("UIStroke",panel);st.Color=Color3.fromRGB(230,110,20);st.Thickness=2
local head=Instance.new("TextLabel",panel)
head.Size=UDim2.new(1,-55,0,38);head.Position=UDim2.fromOffset(12,2)
head.Text=title;head.BackgroundTransparency=1;head.Font=Enum.Font.SourceSansBold
head.TextSize=18;head.TextColor3=Color3.fromRGB(255,170,70);head.TextXAlignment=Enum.TextXAlignment.Left
local close=Instance.new("TextButton",panel)
close.Size=UDim2.fromOffset(32,28);close.Position=UDim2.new(1,-39,0,6)
close.BackgroundColor3=Color3.fromRGB(110,45,45);close.Text="X";close.TextColor3=Color3.new(1,1,1)
close.ZIndex=82;Instance.new("UICorner",close).CornerRadius=UDim.new(0,6)
bindClick(close,function() panel.Visible=false end)
makeDraggable(panel,head)
local status=Instance.new("TextLabel",panel)
status.Size=UDim2.new(1,-18,0,32);status.Position=UDim2.new(0,9,0,41)
status.Name="StatusLabel";status.ZIndex=82
status.BackgroundTransparency=1;status.TextColor3=Color3.fromRGB(205,205,210)
status.Font=Enum.Font.SourceSans;status.TextSize=12;status.TextWrapped=true
local list=Instance.new("ScrollingFrame",panel)
list.Size=UDim2.new(1,-16,1,-116);list.Position=UDim2.fromOffset(8,108)
list.Name="Entries";list.ZIndex=82
list.BorderSizePixel=0;list.BackgroundTransparency=1
list.AutomaticCanvasSize=Enum.AutomaticSize.Y;list.CanvasSize=UDim2.new()
list.ScrollBarThickness=4
local layout=Instance.new("UIListLayout",list);layout.Padding=UDim.new(0,6)
status.Text="Carregando..."
return panel,status,list
end
State.api.smallButton=function(parent,label,x,width,callback)
local b=Instance.new("TextButton",parent)
b.Size=UDim2.new(0,width,0,28);b.Position=UDim2.new(0,x,0,76)
b.BackgroundColor3=Color3.fromRGB(112,58,150);b.Text=label
b.TextColor3=Color3.new(1,1,1);b.Font=Enum.Font.SourceSansBold;b.TextSize=12;b.ZIndex=83
Instance.new("UICorner",b).CornerRadius=UDim.new(0,5)
bindClick(b,callback);return b
end
State.api.wipe=function(list)
for _,obj in ipairs(list:GetChildren()) do if not obj:IsA("UIListLayout") then obj:Destroy() end end
end
State.api.makeEntry=function(list,text,height)
local card=Instance.new("Frame",list);card.Size=UDim2.new(1,-7,0,height)
card.BackgroundColor3=Color3.fromRGB(34,18,42);card.BorderSizePixel=0;card.ZIndex=83
Instance.new("UICorner",card).CornerRadius=UDim.new(0,6)
local lbl=Instance.new("TextLabel",card)
lbl.Size=UDim2.new(1,-85,1,-5);lbl.Position=UDim2.new(0,7,0,3)
lbl.BackgroundTransparency=1;lbl.TextColor3=Color3.new(1,1,1)
lbl.Font=Enum.Font.SourceSans;lbl.TextSize=12;lbl.TextWrapped=true
lbl.TextXAlignment=Enum.TextXAlignment.Left;lbl.TextYAlignment=Enum.TextYAlignment.Center
lbl.Text=text;lbl.ZIndex=84
return card
end
State.api.actionButton=function(card,label,callback,color)
local b=Instance.new("TextButton",card)
b.Size=UDim2.new(0,75,0,28);b.Position=UDim2.new(1,-80,.5,-14)
b.Text=label;b.TextSize=12;b.Font=Enum.Font.SourceSansBold
b.TextColor3=Color3.new(1,1,1);b.BackgroundColor3=color or Color3.fromRGB(200,95,25);b.ZIndex=85
Instance.new("UICorner",b).CornerRadius=UDim.new(0,5)
bindClick(b,callback)
end
local serverHopBusy=false
State.api.serverResults={}
State.api.serverHopFetch=function()
if serverHopBusy then return State.api.serverResults end
serverHopBusy=true
local placeId=game.PlaceId
local results={}
local cursor=nil
local pages=0
local maxPages=math.clamp(math.floor(Cfg.ServerHopPages or 3),1,8)
repeat
pages=pages+1
local url=("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(placeId)
if cursor and cursor~="" then url=url.."&cursor="..HttpService:UrlEncode(cursor) end
local ok,res=pcall(function() return game:HttpGet(url) end)
if not ok or not res then break end
local ok2,data=pcall(function() return HttpService:JSONDecode(res) end)
if not ok2 or not data or not data.data then break end
for _,srv in ipairs(data.data) do
local playing=tonumber(srv.playing) or 0
local maxPlayers=tonumber(srv.maxPlayers) or 0
if srv.id~=game.JobId and maxPlayers>0 and playing<maxPlayers
and playing>=math.max(0,Cfg.ServerHopMinPlayers or 0)
and playing<=math.max(1,Cfg.ServerHopMaxPlayers or maxPlayers) then
local occupancy=playing/maxPlayers
results[#results+1]={
id=srv.id,playing=playing,maxPlayers=maxPlayers,
score=playing*10+occupancy*100,
}
end
end
cursor=data.nextPageCursor
task.wait(.05)
until State.dead or not cursor or cursor=="" or pages>=maxPages
table.sort(results,function(a,b)
if a.score==b.score then return a.playing<b.playing end
return a.score<b.score
end)
State.api.serverResults=results
serverHopBusy=false
return results
end
State.api.currentPing=function()
local ok,val=pcall(function()
local stats=game:GetService("Stats")
local item=stats.Network.ServerStatsItem:FindFirstChild("Data Ping")
if item then return math.floor(item:GetValue()) end
end)
return ok and val or nil
end
State.api.joinServer=function(server)
if not server or not server.id or State.dead then return false end
GUI.setStatus(("Server Hop: joining %d/%d players..."):format(server.playing or 0,server.maxPlayers or 0))
local ok=pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId,server.id,LP) end)
return ok
end
State.api.serverHopReal=function()
local results=State.api.serverHopFetch()
if results and results[1] then return State.api.joinServer(results[1]) end
GUI.setStatus("Server Hop: no matching servers")
return false
end
State.api.openServerHopPanel=function()
if State.dead or State.destroyed then return end
if serverPanel and serverPanel.Parent then
serverPanel.Visible=not serverPanel.Visible
return
end
local panel,status,list=State.api.panelBase("JJS_ServerHop","🎃 Server Hop",UDim2.fromOffset(390,520))
serverPanel=panel
panel.BackgroundColor3=Color3.fromRGB(23,12,31)
local cards=Instance.new("Frame",panel)
cards.Size=UDim2.new(1,-18,0,62);cards.Position=UDim2.new(0,9,0,72);cards.BackgroundTransparency=1
local function card(x,w,title)
local f=Instance.new("Frame",cards);f.Size=UDim2.new(w,-4,1,0);f.Position=UDim2.new(x,2,0,0)
f.BackgroundColor3=Color3.fromRGB(31,17,42);f.BorderSizePixel=0;Instance.new("UICorner",f).CornerRadius=UDim.new(0,8)
local t=Instance.new("TextLabel",f);t.Size=UDim2.new(1,-10,0,18);t.Position=UDim2.fromOffset(6,4);t.BackgroundTransparency=1
t.Text=title;t.TextColor3=Color3.fromRGB(180,145,210);t.Font=Enum.Font.SourceSansBold;t.TextSize=9;t.TextXAlignment=Enum.TextXAlignment.Left
local v=Instance.new("TextLabel",f);v.Size=UDim2.new(1,-10,0,28);v.Position=UDim2.fromOffset(6,24);v.BackgroundTransparency=1
v.TextColor3=Color3.fromRGB(255,170,70);v.Font=Enum.Font.SourceSansBold;v.TextSize=13;v.TextXAlignment=Enum.TextXAlignment.Left
return v
end
local curPlayers=card(0,.34,"PLAYERS")
local curPing=card(.34,.33,"CURRENT PING")
local pagesCard=card(.67,.33,"SCAN PAGES")
curPlayers.Text=("%d/%d"):format(#Players:GetPlayers(),Players.MaxPlayers)
local ping=State.api.currentPing();curPing.Text=ping and (ping.." ms") or "N/A"
pagesCard.Text=tostring(Cfg.ServerHopPages or 3)
status.Position=UDim2.new(0,9,0,138);status.Size=UDim2.new(1,-18,0,28);status.Text="Ready to scan"
list.Position=UDim2.fromOffset(8,214);list.Size=UDim2.new(1,-16,1,-222)
local joinBest=State.api.smallButton(panel,"🚀 Join Best",9,115,function()
local r=State.api.serverResults
if not r or #r==0 then r=State.api.serverHopFetch() end
if r and r[1] then State.api.joinServer(r[1]) else status.Text="No matching server" end
end)
joinBest.Position=UDim2.new(0,9,0,172);joinBest.BackgroundColor3=Color3.fromRGB(226,99,20)
local scan=State.api.smallButton(panel,"🔍 Scan",132,82,function()
status.Text="Scanning..."
task.spawn(function()
local r=State.api.serverHopFetch()
if not panel.Parent then return end
State.api.wipe(list)
if not r or #r==0 then
status.Text="No matching servers"
State.api.makeEntry(list,"Try increasing Max Players or Pages to scan.",48)
return
end
status.Text=("Found %d servers • sorted by lowest load"):format(#r)
for i,srv in ipairs(r) do
if i>30 then break end
local occupancy=math.floor((srv.playing/srv.maxPlayers)*100+.5)
local cardObj=State.api.makeEntry(list,("🎃 %d/%d players\nLoad: %d%%"):format(srv.playing,srv.maxPlayers,occupancy),54)
State.api.actionButton(cardObj,"Join",function() State.api.joinServer(srv) end,Color3.fromRGB(210,88,22))
end
end)
end)
scan.Position=UDim2.new(0,132,0,172);scan.BackgroundColor3=Color3.fromRGB(90,48,128)
local rules=State.api.smallButton(panel,"⚙ Filters",222,92,function()
GUI.CfgPanel.Visible=true
panel.Visible=false
end)
rules.Position=UDim2.new(0,222,0,172);rules.BackgroundColor3=Color3.fromRGB(112,58,150)
local refreshPing=State.api.smallButton(panel,"↻",322,48,function()
local p=State.api.currentPing();curPing.Text=p and (p.." ms") or "N/A"
curPlayers.Text=("%d/%d"):format(#Players:GetPlayers(),Players.MaxPlayers)
pagesCard.Text=tostring(Cfg.ServerHopPages or 3)
end)
refreshPing.Position=UDim2.new(0,322,0,172);refreshPing.BackgroundColor3=Color3.fromRGB(75,42,95)
panel.Visible=true
task.spawn(function()
while panel and panel.Parent and panel.Visible and not State.dead do
local p=State.api.currentPing()
curPing.Text=p and (p.." ms") or "N/A"
curPlayers.Text=("%d/%d"):format(#Players:GetPlayers(),Players.MaxPlayers)
pagesCard.Text=tostring(Cfg.ServerHopPages or 3)
task.wait(.5)
end
end)
end
local ownerTagEnabled = false
local ownerBillboard = nil
local ownerTagToggle = nil
local ownerCharConnection = nil
function State.api.clearOwnerTag()
if ownerBillboard then ownerBillboard:Destroy();ownerBillboard=nil end
end
function State.api.drawOwnerTag()
State.api.clearOwnerTag()
if not ownerTagEnabled then return end
local owner=Players:GetPlayerByUserId(ADMIN_ID)
local head=owner and owner.Character and owner.Character:FindFirstChild("Head")
if not head or not GUI.Gui or not GUI.Gui.Parent then return end
local gui=Instance.new("BillboardGui")
gui.Name="JJS_OwnerClientTag";gui.Adornee=head
gui.Size=UDim2.fromOffset(170,40);gui.StudsOffsetWorldSpace=Vector3.new(0,2.8,0)
gui.AlwaysOnTop=true;gui.MaxDistance=150;gui.ResetOnSpawn=false
gui.Parent=PGui
local label=Instance.new("TextLabel",gui)
label.Size=UDim2.fromScale(1,1);label.BackgroundTransparency=1
label.Font=Enum.Font.GothamBlack;label.Text="★ OWNER ★";label.TextScaled=true
label.TextColor3=Color3.new(1,1,1);label.TextStrokeColor3=Color3.new(0,0,0)
label.TextStrokeTransparency=0.18
local gradient=Instance.new("UIGradient",label)
gradient.Color=ColorSequence.new({
ColorSequenceKeypoint.new(0,Color3.fromRGB(255,60,70)),
ColorSequenceKeypoint.new(.2,Color3.fromRGB(255,190,50)),
ColorSequenceKeypoint.new(.4,Color3.fromRGB(80,255,130)),
ColorSequenceKeypoint.new(.6,Color3.fromRGB(50,205,255)),
ColorSequenceKeypoint.new(.8,Color3.fromRGB(200,105,255)),
ColorSequenceKeypoint.new(1,Color3.fromRGB(255,60,70))
})
TweenService:Create(gradient,TweenInfo.new(5,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut,-1,true),{Rotation=180}):Play()
ownerBillboard=gui
end
function State.api.setOwnerTagLocal(value)
value=value==true
if ownerTagEnabled~=value then ownerTagEnabled=value;State.api.drawOwnerTag()
elseif ownerTagEnabled and (not ownerBillboard or not ownerBillboard.Parent) then State.api.drawOwnerTag() end
if ownerTagToggle then
ownerTagToggle.Text=ownerTagEnabled and "OWNER Tag: ON" or "OWNER Tag: OFF"
ownerTagToggle.BackgroundColor3=ownerTagEnabled and Color3.fromRGB(40,135,74) or Color3.fromRGB(95,66,109)
end
end
function State.api.hookOwnerCharacter(player)
if ownerCharConnection then ownerCharConnection:Disconnect();ownerCharConnection=nil end
if player and player.UserId==ADMIN_ID then
ownerCharConnection=player.CharacterAdded:Connect(function()
task.wait(.35)
State.api.drawOwnerTag()
end)
State.api.drawOwnerTag()
end
end
Players.PlayerAdded:Connect(function(p) if p.UserId==ADMIN_ID then pcall(State.api.hookOwnerCharacter,p) end end)
Players.PlayerRemoving:Connect(function(p) if p.UserId==ADMIN_ID then pcall(State.api.clearOwnerTag);pcall(State.api.hookOwnerCharacter,nil) end end)
pcall(State.api.hookOwnerCharacter,Players:GetPlayerByUserId(ADMIN_ID))
Players.PlayerAdded:Connect(function(p)
end)
State.conns.esp=RunService.Heartbeat:Connect(function()
if State.dead then return end
if State.mobileLite and not Cfg.DoorESP and not Cfg.ItemESP and not Cfg.PlayerESP then return end
local now=os.clock()
if now-State.lastESPDraw<Cfg.ESPUpdateInterval then return end
State.lastESPDraw=now
pcall(function()
if Cfg.DoorESP then
local d=espNearestDoor()
if d and d.Model and d.Part then
if State.esp.Door~=d.Model or not State.esp.HL or not State.esp.HL.Parent then
if State.esp.HL then State.esp.HL:Destroy() end
if State.esp.BB then State.esp.BB:Destroy() end
local hl=Instance.new("Highlight")
hl.Adornee=d.Model;hl.Enabled=Cfg.DoorESPHighlight;hl.FillColor=Color3.fromRGB(255,140,0)
hl.FillTransparency=0.45;hl.OutlineColor=Color3.fromRGB(255,200,50)
hl.OutlineTransparency=0;hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
hl.Parent=ESP_F
local bb=Instance.new("BillboardGui")
bb.Adornee=d.Part;bb.Size=UDim2.new(0,220,0,55)
bb.StudsOffset=Vector3.new(0,7,0);bb.AlwaysOnTop=true
bb.MaxDistance=2000;bb.Parent=ESP_F
local l=Instance.new("TextLabel",bb)
l.Size=UDim2.new(1,0,1,0);l.BackgroundTransparency=1
l.TextColor3=Color3.fromRGB(255,180,50);l.TextStrokeTransparency=0
l.TextStrokeColor3=Color3.fromRGB(0,0,0);l.Font=Enum.Font.SourceSansBold
l.TextSize=16;l.TextWrapped=true
State.esp.HL=hl;State.esp.BB=bb;State.esp.L=l;State.esp.Door=d.Model
end
State.esp.HL.Adornee=d.Model
State.esp.BB.Adornee=d.Part
local timerTxt=doorTimer(d.Model)
State.esp.L.Text=string.format("[DOOR] %s\n%d m",timerTxt,d.Distance)
else
if State.esp.HL then State.esp.HL:Destroy();State.esp.HL=nil end
if State.esp.BB then State.esp.BB:Destroy();State.esp.BB=nil end
State.esp.L=nil;State.esp.Door=nil
end
else
if State.esp.HL then State.esp.HL:Destroy();State.esp.HL=nil end
if State.esp.BB then State.esp.BB:Destroy();State.esp.BB=nil end
State.esp.L=nil;State.esp.Door=nil
end
if Cfg.ItemESP then
State.esp.Items=State.esp.Items or {}
local myHrp=getHRP()
local alive={}
for _,item in ipairs(getItems()) do
if item and item.Parent then
alive[item]=true
local root=item:IsA("BasePart") and item or (item:IsA("Model") and (item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart",true)) or nil)
if root then
local entry=State.esp.Items[item]
if not entry or not entry.HL or not entry.HL.Parent or not entry.BB or not entry.BB.Parent then
if entry then
pcall(function() if entry.HL then entry.HL:Destroy() end end)
pcall(function() if entry.BB then entry.BB:Destroy() end end)
end
local hl=Instance.new("Highlight")
hl.Adornee=item;hl.FillColor=Color3.fromRGB(255,140,0)
hl.FillTransparency=0.45;hl.OutlineColor=Color3.fromRGB(255,200,50)
hl.OutlineTransparency=0;hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
hl.Parent=ESP_F
local bb=Instance.new("BillboardGui")
bb.Size=UDim2.new(0,220,0,48);bb.StudsOffset=Vector3.new(0,3.2,0)
bb.AlwaysOnTop=true;bb.MaxDistance=Cfg.ItemESPMaxDistance or 100000;bb.Parent=ESP_F
local lbl=Instance.new("TextLabel",bb)
lbl.Size=UDim2.new(1,0,1,0);lbl.BackgroundTransparency=1
lbl.TextColor3=Color3.fromRGB(120,255,150);lbl.TextStrokeTransparency=0
lbl.TextStrokeColor3=Color3.fromRGB(0,0,0);lbl.Font=Enum.Font.SourceSansBold
lbl.TextSize=14;lbl.TextWrapped=true
entry={HL=hl,BB=bb,L=lbl}
State.esp.Items[item]=entry
end
entry.HL.Adornee=item;entry.HL.Enabled=Cfg.ItemESPHighlight
entry.BB.Adornee=root
local dist=myHrp and math.floor((root.Position-myHrp.Position).Magnitude) or 0
local ibits={}
if Cfg.ItemESPName then ibits[#ibits+1]=item.Name end
if Cfg.ItemESPDistance then ibits[#ibits+1]=dist.."m" end
entry.L.Text=table.concat(ibits,"\n")
end
end
end
for item,entry in pairs(State.esp.Items) do
if not alive[item] or not item.Parent then
pcall(function() if entry.HL then entry.HL:Destroy() end end)
pcall(function() if entry.BB then entry.BB:Destroy() end end)
State.esp.Items[item]=nil
end
end
else
if State.esp.Items then
for item,entry in pairs(State.esp.Items) do
pcall(function() if entry.HL then entry.HL:Destroy() end end)
pcall(function() if entry.BB then entry.BB:Destroy() end end)
State.esp.Items[item]=nil
end
end
end
if Cfg.PlayerESP then
State.esp.Players=State.esp.Players or {}
local myHrp=getHRP()
for _,p in ipairs(Players:GetPlayers()) do
if p~=LP and p.Character then
local entry=State.esp.Players[p]
if not entry or not entry.HL or not entry.HL.Parent then
local hl=Instance.new("Highlight")
hl.FillColor=Color3.fromRGB(255,0,0);hl.FillTransparency=0.4
hl.OutlineColor=Color3.fromRGB(255,255,255);hl.OutlineTransparency=0
hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop;hl.Parent=ESP_F
local bb=Instance.new("BillboardGui")
bb.Size=UDim2.new(0,200,0,40);bb.StudsOffset=Vector3.new(0,3,0)
bb.AlwaysOnTop=true;bb.MaxDistance=Cfg.PlayerESPMaxDistance;bb.Parent=ESP_F
local lbl=Instance.new("TextLabel",bb)
lbl.Size=UDim2.new(1,0,1,0);lbl.BackgroundTransparency=1
lbl.TextColor3=Color3.fromRGB(255,80,80);lbl.TextStrokeTransparency=0
lbl.TextStrokeColor3=Color3.fromRGB(0,0,0);lbl.Font=Enum.Font.SourceSansBold
lbl.TextSize=14;lbl.TextWrapped=true
entry={HL=hl,BB=bb,L=lbl}
State.esp.Players[p]=entry
end
entry.HL.Adornee=p.Character;entry.HL.Enabled=Cfg.PlayerESPHighlight
local head=p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")
entry.BB.Adornee=head
local parts={}
if Cfg.PlayerESPName then parts[#parts+1]=p.Name end
if Cfg.PlayerESPDistance and myHrp and head then
local d=math.floor((head.Position-myHrp.Position).Magnitude)
parts[#parts+1]=d.."m"
end
entry.L.Text=table.concat(parts," | ")
end
end
if State.esp.Players then
for p,entry in pairs(State.esp.Players) do
if not p.Parent or not p.Character then
pcall(function() entry.HL:Destroy() end)
pcall(function() entry.BB:Destroy() end)
State.esp.Players[p]=nil
end
end
end
else
if State.esp.Players then
for _,entry in pairs(State.esp.Players) do
pcall(function() entry.HL:Destroy() end)
pcall(function() entry.BB:Destroy() end)
end
State.esp.Players={}
end
end
end)
end)
State.conns.char=LP.CharacterAdded:Connect(function()
stopTween();clearTrajectory()
State.pathCache={t=0};State.cachedHRP=nil;State.lastHRPTime=0
State.lockedDoor=nil
State.safeModeAtPlatform=false;State.safeModeClimbing=false
State.items.cancel=true;State.items.running=false
State.items.runToken=(State.items.runToken or 0)+1
traceClear()
task.defer(function()
task.wait(.15)
ensureGuiAlive()
pcall(function() LP:SetAttribute("JJS_User", true) end)
if Cfg.SafeMode and not State.dead then
pcall(function()
createSafePlatform()
if not State.threads.SafeMode then startSafeMode() end
end)
end
task.wait(.35)
pcall(drawOwnerTag)
ensureGuiAlive()
end)
end)
State.api.destroyAll=function()
if State.destroyed then return end
State.destroyed=true;State.dead=true
State.api.stopAntiAFK()
State.items.runId=(State.items.runId or 0)+1
State.items.runToken=(State.items.runToken or 0)+1
State.items.cancel=true;State.items.running=false
for k in pairs(State.flags) do State.flags[k]=false end
for k,t in pairs(State.threads) do
if t then pcall(task.cancel,t) end
State.threads[k]=nil
end
stopTween();clearTrajectory();updateWaitCircle(nil,false);traceClear()
destroySafePlatform()
State.lockedDoor=nil;State.pathCache={t=0}
for k,c in pairs(State.conns) do
pcall(function() if c then c:Disconnect() end end)
State.conns[k]=nil
end
if State.esp then
for _,bucket in pairs(State.esp) do
if typeof(bucket)=="Instance" then pcall(function() bucket:Destroy() end)
elseif type(bucket)=="table" then
for _,entry in pairs(bucket) do
if typeof(entry)=="Instance" then pcall(function() entry:Destroy() end)
elseif type(entry)=="table" then
for _,obj in pairs(entry) do if typeof(obj)=="Instance" then pcall(function() obj:Destroy() end) end end
end
end
end
end
end
if State.items.panel then pcall(function() State.items.panel:Destroy() end);State.items.panel=nil end
if serverPanel and serverPanel.Parent then pcall(function() serverPanel:Destroy() end) end
if ownerCharConnection then pcall(function() ownerCharConnection:Disconnect() end);ownerCharConnection=nil end
pcall(function() if State.api.clearOwnerTag then State.api.clearOwnerTag() end end)
for _,folder in ipairs({ESP_F,NODE_F,TRAJ_F,OBS_F}) do
if folder and folder.Parent then pcall(function() folder:Destroy() end) end
end
pcall(function() LP:SetAttribute("JJS_User",nil) end)
if GUI and GUI.Gui and GUI.Gui.Parent then pcall(function() GUI.Gui:Destroy() end) end
pcall(function() if _G.JJS and _G.JJS.State==State then _G.JJS=nil end end)
end
State.api.toggleAllPanels=function()
State.panelsHidden=not State.panelsHidden
local hide=State.panelsHidden
GUI.Main.Visible=not hide
if GUI.Compact then GUI.Compact.Visible=hide and Cfg.CompactMinimize end
GUI.CfgPanel.Visible=(not hide) and GUI.CfgPanel.Visible or false
if State.items.panel and State.items.panel.Parent then
State.items.panel.Visible=(not hide) and State.items.panel.Visible or false
end
GUI.FloatBtn.Text=hide and "🎃" or "🎃"
end
bindClick(GUI.FloatBtn,function()
State.api.toggleAllPanels()
end)
local BY=4
State.control.panel=nil;State.control.historyLabel=nil;State.control.routeLabel=nil;State.control.queueLabel=nil;State.control.stateLabel=nil
State.api.BT=function(label,init,fn)
local _,set=makeToggle(GUI.List,label,BY,init,fn)
BY=BY+(UserInputService.TouchEnabled and 40 or 34)
return set
end
State.api.BB=function(text,color,fn)
makeButton(GUI.List,text,BY,color,fn);BY=BY+(UserInputService.TouchEnabled and 40 or 34)
end
State.api.HB=function(textA,colorA,fnA,textB,colorB,fnB)
makeHalfButtons(GUI.List,BY,textA,colorA,fnA,textB,colorB,fnB);BY=BY+(UserInputService.TouchEnabled and 40 or 34)
end
local setFarmT,setBlatantT,setPumpkinT
setFarmT=State.api.BT("Auto Farm",false,function(on)
Cfg.AutoFarm=on
if on then
if setBlatantT then setBlatantT(false) end
if setPumpkinT then setPumpkinT(false) end
State.api.releaseCharacterControl("switch-to-farm")
startFarm()
else
stopFarm()
end
end)
if not State.mobileLite then
setBlatantT=State.api.BT("Blatant Mode",false,function(on)
Cfg.BlatantMode=on
if on then
if setFarmT then setFarmT(false) end
if setPumpkinT then setPumpkinT(false) end
State.api.releaseCharacterControl("switch-to-blatant")
startBlatant()
else
stopBlatant()
end
end)
end
State.api.setFarm=setFarmT
State.api.setBlatant=setBlatantT
if not State.mobileLite then
State.api.BT("Blatant Auto FWD ±5",true,function(on) Cfg.BlatantAutoForward=on end)
State.api.HB("Blatant Fwd -5",Color3.fromRGB(80,40,40),function() adjustBlatantForward(-Cfg.BlatantForwardStep) end,
"Blatant Fwd +5",Color3.fromRGB(40,80,40),function() adjustBlatantForward(Cfg.BlatantForwardStep) end)
State.api.BT("Smart Orbit",true,function(on) Cfg.SmartOrbit=on end)
State.api.BT("Anti False Door",true,function(on)
Cfg.AntiFalseDoor=on;State.flags.AFD=on
if on then startAFD() end
end)
State.api.BT("Anti Skeleton",true,function(on)
Cfg.AntiSkeleton=on;State.flags.AS=on
if on then startAS() end
end)
else
State.api.BT("Anti False Door + Skeleton",false,function(on)
Cfg.AntiFalseDoor=on
Cfg.AntiSkeleton=on
State.flags.AFD=on
State.flags.AS=on
if on then
startAFD()
startAS()
GUI.setStatus("Mobile Protection 2-in-1: ON")
else
State.afdRun=State.afdRun+1
State.asRun=State.asRun+1
State.afdActive=false
State.asActive=false
State.skel.list={}
if State.conns.skel then
pcall(function() State.conns.skel:Disconnect() end)
State.conns.skel=nil
end
GUI.setStatus("Mobile Protection 2-in-1: OFF")
end
end)
end

setPumpkinT=State.api.BT("Win Pumpkin Minigame",false,function(on)
Cfg.PumpkinMinigame=on
if on then
if setFarmT then setFarmT(false) end
if setBlatantT then setBlatantT(false) end
State.api.releaseCharacterControl("switch-to-pumpkin")
startPumpkinGuard()
else
stopPumpkinGuard()
end
end)
State.api.setPumpkin=setPumpkinT

local setPumpkinCombatT
setPumpkinCombatT=State.api.BT("AutoM1/AutoSkill",false,function(on)
Cfg.PumpkinAutoCombat=on
if not on then
State.pumpkin.combat.lastM1=0
State.pumpkin.combat.skillLast={}
end
end)
State.api.setPumpkinCombat=setPumpkinCombatT

State.api.BT("Safe Mode (Sky Platform)",false,function(on)
if on then startSafeMode() else stopSafeMode() end
end)
State.api.BT("Safe Platform Away From Players",Cfg.SafePlatformAwayFromPlayers,function(on)
Cfg.SafePlatformAwayFromPlayers=on
if State.safePlatform then destroySafePlatform() end
if Cfg.SafeMode then
createSafePlatform()
GUI.setStatus(on and "Safe Platform: away from players" or "Safe Platform: above current area")
end
end)
State.api.BT("Pumpkin Escape 500+ Studs",Cfg.PumpkinEscapeAfterCollect,function(on)
Cfg.PumpkinEscapeAfterCollect=on
end)

if not State.mobileLite then
State.api.BT("Anti-Candy Scape",false,function(on) Cfg.AntiCandyScape=on;if on then startAntiCandy() else stopAntiCandy() end end)
State.api.BT("Safe/Idle Point",false,function(on) Cfg.SafeIdlePoint=on end)
State.api.BB("Set Point (current pos)",Color3.fromRGB(145,70,200),function()
local hrp=getHRP()
if hrp then Cfg.SafePoint=hrp.Position;GUI.setStatus("Safe Point set!") end
end)
end

State.api.BT("Wait Timer",true,function(on) Cfg.WaitTimer=on end)
State.api.BT("Anti-AFK",false,function(on)
if on then
State.api.startAntiAFK()
GUI.setStatus("Anti-AFK: ON")
else
State.api.stopAntiAFK()
GUI.setStatus("Anti-AFK: OFF")
end
end)

if State.mobileLite then
State.api.BT("Door ESP",false,function(on) Cfg.DoorESP=on end)
else
State.api.BT("Door ESP",Cfg.DoorESP,function(on) Cfg.DoorESP=on end)
State.api.BT("Item ESP",Cfg.ItemESP,function(on) Cfg.ItemESP=on end)
State.api.BT("Player ESP",Cfg.PlayerESP,function(on) Cfg.PlayerESP=on end)
State.api.BT("Door: Name",true,function(on) Cfg.DoorESPName=on end)
State.api.BT("Door: Distance",true,function(on) Cfg.DoorESPDistance=on end)
State.api.BT("Door: Highlight",true,function(on) Cfg.DoorESPHighlight=on end)
State.api.BT("Item: Name",true,function(on) Cfg.ItemESPName=on end)
State.api.BT("Item: Distance",true,function(on) Cfg.ItemESPDistance=on end)
State.api.BT("Item: Highlight",true,function(on) Cfg.ItemESPHighlight=on end)
State.api.BT("Player: Name",true,function(on) Cfg.PlayerESPName=on end)
State.api.BT("Player: Distance",true,function(on) Cfg.PlayerESPDistance=on end)
State.api.BT("Player: Highlight",true,function(on) Cfg.PlayerESPHighlight=on end)
State.api.BT("Auto Refresh Items",Cfg.ItemAutoRefresh,function(on) Cfg.ItemAutoRefresh=on end)
State.api.BT("Low Lag Mode",false,function(on) Cfg.LowLag=on;Cfg.ESPUpdateInterval=on and .8 or .25;if on then Cfg.ShowTrajectory=false end end)
State.api.BT("Show Trajectory",false,function(on) Cfg.ShowTrajectory=on;if not on then clearTrajectory() end end)
State.api.BT("Ignore Door w/ Players (15 studs)",false,function(on) Cfg.IgnoreDoorWithPlayers=on end)
end
BY=BY+6
State.api.BB("Items",Color3.fromRGB(40,140,40),openItemsPanel)
State.api.BB("Config",Color3.fromRGB(145,70,200),function() GUI.CfgPanel.Visible=not GUI.CfgPanel.Visible end)
State.api.BB("Server Hop",Color3.fromRGB(145,70,200),State.api.openServerHopPanel)
if not State.mobileLite then
State.api.BB("Discord",Color3.fromRGB(88,101,242),function()
local link="https://discord.gg/QGDQjGMcu"
GUI.setStatus("Link: "..tostring(link))
GUI.setStatus("Link copied")
end)
end
BY=BY+6
function State.api.emergencyStop()
State.items.runId=(State.items.runId or 0)+1;State.items.cancel=true;State.items.running=false
stopTween();clearTrajectory();State.pathCache={t=0};traceClear()
State.api.stopAntiAFK()
stopFarm();stopBlatant();stopPumpkinGuard();stopAntiCandy();State.flags.AFD=false;State.flags.AS=false;stopSafeMode()
Cfg.AutoFarm=false;Cfg.BlatantMode=false;Cfg.PumpkinMinigame=false;Cfg.PumpkinAutoCombat=false;Cfg.AntiCandyScape=false
if setFarmT then setFarmT(false,true) end;if setBlatantT then setBlatantT(false,true) end;if setPumpkinT then setPumpkinT(false,true) end;if setPumpkinCombatT then setPumpkinCombatT(false,true) end
State.api.releaseCharacterControl("emergency-stop");State.api.queueClear();State.api.setState("STOPPED");history("Emergency Stop")
GUI.setStatus("EMERGENCY STOP")
end
State.api.BB("STOP (halt everything)",Color3.fromRGB(200,40,40),function()
State.api.stopAntiAFK()
stopFarm();stopBlatant();stopPumpkinGuard();stopAntiCandy()
State.flags.AFD=false;State.flags.AS=false
stopSafeMode()
Cfg.AutoFarm=false;Cfg.BlatantMode=false
Cfg.PumpkinMinigame=false;Cfg.PumpkinAutoCombat=false;Cfg.AntiCandyScape=false
if setFarmT then setFarmT(false,true) end
if setBlatantT then setBlatantT(false,true) end
if setPumpkinT then setPumpkinT(false,true) end
if setPumpkinCombatT then setPumpkinCombatT(false,true) end
clearTrajectory();updateWaitCircle(nil,false)
State.api.releaseCharacterControl("stop-all")
GUI.setStatus("STOPPED")
end)
State.api.BB("Destroy Script",Color3.fromRGB(150,40,40),State.api.destroyAll)
GUI.List.CanvasSize=UDim2.new(0,0,0,BY+8)
local CY=4
State.api.CTX=function(label,init,fn) makeTextBox(GUI.CfgList,label,init,CY,fn);CY=CY+30 end
State.api.CAT=function(name) CY=makeCategory(GUI.CfgList,name,CY) end
if State.mobileLite then
State.api.CAT("── Mobile Essentials ──")
State.api.CTX("Walk Speed:",Cfg.WalkSpeed,function(v) Cfg.WalkSpeed=math.clamp(v,35,120) end)
State.api.CTX("Time Lapse:",Cfg.TweenTimeLapse,function(v) Cfg.TweenTimeLapse=math.clamp(v,.3,2.5) end)
State.api.CTX("Path Ground/Y5 (0/1):",Cfg.PathTravelMode=="Y5" and 1 or 0,function(v) Cfg.PathTravelMode=v>0 and "Y5" or "Ground" end)
State.api.CTX("Path Y Height:",Cfg.PathTravelY,function(v) Cfg.PathTravelY=math.clamp(v,0,12) end)
State.api.CTX("Door Slowdown (1/0):",Cfg.DoorSlowdown and 1 or 0,function(v) Cfg.DoorSlowdown=v>0 end)
State.api.CTX("Slowdown Distance:",Cfg.DoorSlowdownDistance,function(v) Cfg.DoorSlowdownDistance=math.clamp(v,20,100) end)
State.api.CTX("Slowdown Min Speed:",Cfg.DoorSlowdownMinSpeed,function(v) Cfg.DoorSlowdownMinSpeed=math.clamp(v,10,80) end)
State.api.CTX("Blatant Height:",Cfg.BlatantHeight,function(v) Cfg.BlatantHeight=math.clamp(v,100,300) end)
State.api.CTX("Blatant Speed:",Cfg.BlatantSpeed,function(v) Cfg.BlatantSpeed=math.clamp(v,80,180) end)
State.api.CTX("Item Max Distance:",Cfg.ItemMaxDistance,function(v) Cfg.ItemMaxDistance=math.clamp(v,300,10000) end)
State.api.CTX("3D Far Start:",Cfg.Item3DFastDistance,function(v) Cfg.Item3DFastDistance=math.clamp(v,150,500) end)
State.api.CTX("3D Chunk:",Cfg.Item3DChunk,function(v) Cfg.Item3DChunk=math.clamp(v,120,220) end)
State.api.CTX("Anti-AFK Interval:",Cfg.AntiAFKInterval,function(v) Cfg.AntiAFKInterval=math.clamp(v,30,90) end)
State.api.CTX("Server Hop Pages:",Cfg.ServerHopPages,function(v) Cfg.ServerHopPages=math.clamp(math.floor(v),1,3) end)
State.api.CTX("Pumpkin Escape Distance:",Cfg.PumpkinEscapeDistance,function(v) Cfg.PumpkinEscapeDistance=math.clamp(v,500,900) end)
State.api.CTX("Safe Platform Away Distance:",Cfg.SafePlatformAwayDistance,function(v) Cfg.SafePlatformAwayDistance=math.clamp(v,200,800) end)
GUI.CfgList.CanvasSize=UDim2.new(0,0,0,CY+12)
else
State.api.CAT("── General ──")
State.api.CTX("Anti-AFK Interval:",Cfg.AntiAFKInterval,function(v) Cfg.AntiAFKInterval=math.clamp(v,25,90) end)
State.api.CAT("── Movement ──")
State.api.CTX("Walk Speed:",Cfg.WalkSpeed,function(v) Cfg.WalkSpeed=math.max(v,1) end)
State.api.CTX("Time Lapse:",Cfg.TweenTimeLapse,function(v) Cfg.TweenTimeLapse=math.clamp(v,.15,4) end)
State.api.CTX("Path Ground/Y5 (0/1):",Cfg.PathTravelMode=="Y5" and 1 or 0,function(v) Cfg.PathTravelMode=v>0 and "Y5" or "Ground" end)
State.api.CTX("Path Y Height:",Cfg.PathTravelY,function(v) Cfg.PathTravelY=math.clamp(v,0,20) end)
State.api.CTX("Agent Radius:",Cfg.AgentRadius,function(v) Cfg.AgentRadius=math.max(v,1) end)
State.api.CTX("Agent Height:",Cfg.AgentHeight,function(v) Cfg.AgentHeight=math.max(v,2) end)
State.api.CTX("Y Offset:",Cfg.YOffset,function(v) Cfg.YOffset=math.max(v,0) end)
State.api.CTX("Reach Dist:",Cfg.ReachDist,function(v) Cfg.ReachDist=math.max(v,0.5) end)
State.api.CTX("Waypoint Spacing:",Cfg.WaypointSpacing,function(v) Cfg.WaypointSpacing=math.max(v,1) end)
State.api.CTX("Move Timeout:",Cfg.MoveTimeout,function(v) Cfg.MoveTimeout=math.max(v,0.5) end)
State.api.CTX("PathCache Duration:",Cfg.PathCacheDuration,function(v) Cfg.PathCacheDuration=math.max(v,0) end)
State.api.CTX("PathCache Tolerance:",Cfg.PathCacheMoveTolerance,function(v) Cfg.PathCacheMoveTolerance=math.max(v,0.1) end)
State.api.CTX("Stuck Window (s):",Cfg.StuckWindow,function(v) Cfg.StuckWindow=math.max(v,0.3) end)
State.api.CTX("Stuck Min Dist:",Cfg.StuckMinDist,function(v) Cfg.StuckMinDist=math.max(v,0.5) end)
State.api.CTX("Stuck Max Retries:",Cfg.StuckMaxRetries,function(v) Cfg.StuckMaxRetries=math.max(v,1) end)
State.api.CTX("Locked Door Check (s):",Cfg.LockedDoorCheckInterval,function(v) Cfg.LockedDoorCheckInterval=math.max(v,0.05) end)
State.api.CTX("Locked Door Max Drift:",Cfg.LockedDoorMaxDrift,function(v) Cfg.LockedDoorMaxDrift=math.max(v,1) end)
State.api.CAT("── Small Parts (Avoid) ──")
State.api.CTX("Avoid Small Parts (1/0):",Cfg.AvoidSmallParts and 1 or 0,function(v) Cfg.AvoidSmallParts=v>0 end)
State.api.CTX("Small Part Max Size:",Cfg.SmallPartMaxSize,function(v) Cfg.SmallPartMaxSize=math.max(v,1) end)
State.api.CTX("Small Part Max Height:",Cfg.SmallPartMaxHeight,function(v) Cfg.SmallPartMaxHeight=math.max(v,1) end)
State.api.CTX("Small Part Detect Radius:",Cfg.SmallPartDetectRadius,function(v) Cfg.SmallPartDetectRadius=math.max(v,1) end)
State.api.CTX("Small Part Padding:",Cfg.SmallPartPadding,function(v) Cfg.SmallPartPadding=math.max(v,1) end)
State.api.CAT("── Route Scoring ──")
State.api.CTX("Route Scoring (1/0):",Cfg.RouteScoring and 1 or 0,function(v) Cfg.RouteScoring=v>0 end)
State.api.CTX("Route Candidates:",Cfg.RouteCandidateCount,function(v) Cfg.RouteCandidateCount=math.clamp(math.floor(v),2,8) end)
State.api.CTX("Open Clearance:",Cfg.RouteOpenClearance,function(v) Cfg.RouteOpenClearance=math.clamp(v,3,12) end)
State.api.CTX("Open Route Weight:",Cfg.RouteOpenPenalty,function(v) Cfg.RouteOpenPenalty=math.clamp(v,0,20) end)
State.api.CTX("Blocked Penalty:",Cfg.RouteScoreBlockedPenalty,function(v) Cfg.RouteScoreBlockedPenalty=math.max(v,0) end)
State.api.CTX("Small Obs Penalty:",Cfg.RouteScoreSmallObsPenalty,function(v) Cfg.RouteScoreSmallObsPenalty=math.max(v,0) end)
State.api.CTX("Length Penalty:",Cfg.RouteScoreLengthPenalty,function(v) Cfg.RouteScoreLengthPenalty=math.max(v,0) end)
State.api.CTX("Waypoint Penalty:",Cfg.RouteScoreWaypointPenalty,function(v) Cfg.RouteScoreWaypointPenalty=math.max(v,0) end)
State.api.CTX("Detour Penalty:",Cfg.RouteScoreDetourPenalty,function(v) Cfg.RouteScoreDetourPenalty=math.max(v,0) end)
State.api.CAT("── Cooldowns ──")
State.api.CTX("Cooldown Radius:",Cfg.CooldownRadius,function(v) Cfg.CooldownRadius=math.max(v,1) end)
State.api.CTX("Cooldown Success:",Cfg.CooldownSuccess,function(v) Cfg.CooldownSuccess=math.max(v,0.1) end)
State.api.CAT("── Doors ──")
State.api.CTX("Door Standoff:",Cfg.DoorStandoff,function(v) Cfg.DoorStandoff=math.clamp(v,1,15) end)
State.api.CTX("Door Slowdown (1/0):",Cfg.DoorSlowdown and 1 or 0,function(v) Cfg.DoorSlowdown=v>0 end)
State.api.CTX("Slowdown Distance:",Cfg.DoorSlowdownDistance,function(v) Cfg.DoorSlowdownDistance=math.clamp(v,10,150) end)
State.api.CTX("Slowdown Min Speed:",Cfg.DoorSlowdownMinSpeed,function(v) Cfg.DoorSlowdownMinSpeed=math.clamp(v,5,200) end)
State.api.CTX("Slowdown Curve:",Cfg.DoorSlowdownCurve,function(v) Cfg.DoorSlowdownCurve=math.clamp(v,.25,4) end)
State.api.CTX("Door Skip Time:",Cfg.DoorSkipTime,function(v) Cfg.DoorSkipTime=math.max(v,1) end)
State.api.CTX("Door Retry Cooldown:",Cfg.DoorRetryCooldown,function(v) Cfg.DoorRetryCooldown=math.max(v,1) end)
State.api.CTX("Door Refresh Interval:",Cfg.DoorRefreshInterval,function(v) Cfg.DoorRefreshInterval=math.max(v,0.05) end)
State.api.CTX("Door Player Radius:",Cfg.DoorPlayerCheckRadius,function(v) Cfg.DoorPlayerCheckRadius=math.max(v,1) end)
State.api.CTX("Wait Timer Radius:",Cfg.WaitTimerRadius,function(v) Cfg.WaitTimerRadius=math.max(v,1) end)
State.api.CTX("Interact Timeout:",Cfg.InteractTimeout,function(v) Cfg.InteractTimeout=math.max(v,5) end)
State.api.CTX("Interact Retry Delay:",Cfg.InteractRetryDelay,function(v) Cfg.InteractRetryDelay=math.max(v,0.01) end)
State.api.CTX("Wait Timer Max (s):",Cfg.WaitTimerMaxSeconds,function(v) Cfg.WaitTimerMaxSeconds=math.max(v,1) end)
State.api.CAT("── Server Hop ──")
State.api.CTX("Pages to Scan:",Cfg.ServerHopPages,function(v) Cfg.ServerHopPages=math.clamp(math.floor(v),1,8) end)
State.api.CTX("Min Players:",Cfg.ServerHopMinPlayers,function(v) Cfg.ServerHopMinPlayers=math.max(0,math.floor(v)) end)
State.api.CTX("Max Players:",Cfg.ServerHopMaxPlayers,function(v) Cfg.ServerHopMaxPlayers=math.max(1,math.floor(v)) end)
State.api.CAT("── Blatant ──")
State.api.CTX("Blatant Height (100-300):",Cfg.BlatantHeight,function(v) Cfg.BlatantHeight=math.clamp(v,100,300) end)
State.api.CTX("Blatant Speed (100-300):",Cfg.BlatantSpeed,function(v) Cfg.BlatantSpeed=math.clamp(v,100,300) end)
State.api.CTX("Blatant Forward:",Cfg.BlatantForward,function(v) Cfg.BlatantForward=v end)
State.api.CTX("Blatant Fwd Step:",Cfg.BlatantForwardStep,function(v) Cfg.BlatantForwardStep=math.max(v,1) end)
State.api.CTX("Blatant Step Delay:",Cfg.BlatantStepDelay,function(v) Cfg.BlatantStepDelay=math.max(v,0) end)
State.api.CTX("Blatant Recalc Chunk:",Cfg.BlatantLongRouteChunk,function(v) Cfg.BlatantLongRouteChunk=math.max(v,80) end)
State.api.CTX("Blatant Recede:",Cfg.BlatantRouteRecede,function(v) Cfg.BlatantRouteRecede=math.max(v,5) end)
State.api.CTX("Route Fails Before Recede:",Cfg.BlatantRouteFailBeforeRecede,function(v) Cfg.BlatantRouteFailBeforeRecede=math.max(1,math.floor(v)) end)
State.api.CTX("Stage Timeout (s):",Cfg.BlatantStageTimeout,function(v) Cfg.BlatantStageTimeout=math.clamp(v,5,30) end)
State.api.CTX("No Progress Timeout:",Cfg.BlatantProgressTimeout,function(v) Cfg.BlatantProgressTimeout=math.clamp(v,1,8) end)
State.api.CTX("Max Segment Fails:",Cfg.BlatantMaxSegmentFails,function(v) Cfg.BlatantMaxSegmentFails=math.clamp(math.floor(v),1,8) end)
State.api.CTX("Min Route Progress:",Cfg.BlatantMinProgress,function(v) Cfg.BlatantMinProgress=math.clamp(v,.25,5) end)
State.api.CTX("Recovery Side:",Cfg.BlatantRecoverySide,function(v) Cfg.BlatantRecoverySide=math.clamp(v,6,40) end)
State.api.CTX("Recovery Back:",Cfg.BlatantRecoveryBack,function(v) Cfg.BlatantRecoveryBack=math.clamp(v,4,30) end)
State.api.CAT("── Safe Mode ──")
State.api.CTX("Safe Platform Height:",Cfg.SafePlatformHeight,function(v) Cfg.SafePlatformHeight=math.max(v,10) end)
State.api.CTX("Safe Platform Size X:",Cfg.SafePlatformSize.X,function(v) Cfg.SafePlatformSize=Vector3.new(math.max(v,4),Cfg.SafePlatformSize.Y,Cfg.SafePlatformSize.Z) end)
State.api.CTX("Safe Platform Size Y:",Cfg.SafePlatformSize.Y,function(v) Cfg.SafePlatformSize=Vector3.new(Cfg.SafePlatformSize.X,math.max(v,1),Cfg.SafePlatformSize.Z) end)
State.api.CTX("Safe Platform Size Z:",Cfg.SafePlatformSize.Z,function(v) Cfg.SafePlatformSize=Vector3.new(Cfg.SafePlatformSize.X,Cfg.SafePlatformSize.Y,math.max(v,4)) end)
State.api.CTX("Safe Climb Duration (s):",Cfg.SafeClimbDuration,function(v) Cfg.SafeClimbDuration=math.max(v,0.5) end)
State.api.CTX("Safe Mode Check Interval:",Cfg.SafeModeCheckInterval,function(v) Cfg.SafeModeCheckInterval=math.max(v,0.1) end)
State.api.CTX("Safe Point X:",Cfg.SafePoint.X,function(v) Cfg.SafePoint=Vector3.new(v,Cfg.SafePoint.Y,Cfg.SafePoint.Z) end)
State.api.CTX("Safe Point Y:",Cfg.SafePoint.Y,function(v) Cfg.SafePoint=Vector3.new(Cfg.SafePoint.X,v,Cfg.SafePoint.Z) end)
State.api.CTX("Safe Point Z:",Cfg.SafePoint.Z,function(v) Cfg.SafePoint=Vector3.new(Cfg.SafePoint.X,Cfg.SafePoint.Y,v) end)
State.api.CAT("── ESP ──")
State.api.CTX("ESP Max Distance:",Cfg.PlayerESPMaxDistance,function(v) Cfg.PlayerESPMaxDistance=math.max(v,10) end)
State.api.CTX("Item ESP Max Distance:",Cfg.ItemESPMaxDistance,function(v) Cfg.ItemESPMaxDistance=math.max(v,100) end)
State.api.CTX("Item Max Distance:",Cfg.ItemMaxDistance,function(v) Cfg.ItemMaxDistance=math.max(v,100) end)
State.api.CTX("Item Long Route Chunk:",Cfg.ItemLongRouteChunk,function(v) Cfg.ItemLongRouteChunk=math.clamp(v,80,240) end)
State.api.CTX("ESP Update Interval:",Cfg.ESPUpdateInterval,function(v) Cfg.ESPUpdateInterval=math.max(v,0.05) end)
State.api.CTX("Trajectory Max Points:",Cfg.TrajectoryMaxPoints,function(v) Cfg.TrajectoryMaxPoints=math.max(v,2) end)
State.api.CAT("── Items ──")
if not State.mobileLite then
State.api.CTX("Item Blatant Speed:",Cfg.ItemBlatantSpeed,function(v) Cfg.ItemBlatantSpeed=math.clamp(v,80,300) end)
State.api.CTX("Bring Distance:",Cfg.ItemBringDistance,function(v) Cfg.ItemBringDistance=math.clamp(v,2.5,8) end)
end
State.api.CTX("3D Fast (1/0):",Cfg.Item3DFast and 1 or 0,function(v) Cfg.Item3DFast=v>0 end)
State.api.CTX("3D Far Start:",Cfg.Item3DFastDistance,function(v) Cfg.Item3DFastDistance=math.clamp(v,120,600) end)
State.api.CTX("3D Chunk:",Cfg.Item3DChunk,function(v) Cfg.Item3DChunk=math.clamp(v,100,240) end)
State.api.CTX("3D Quick Nodes:",Cfg.Item3DQuickNodes,function(v) Cfg.Item3DQuickNodes=math.clamp(math.floor(v),8,28) end)
State.api.CTX("Items Trace Min Dist:",Cfg.ItemsTraceMinDist,function(v) Cfg.ItemsTraceMinDist=math.max(v,0.5) end)
State.api.CTX("Item Retry Cooldown:",Cfg.ItemRetryCooldown,function(v) Cfg.ItemRetryCooldown=math.max(v,1) end)
State.api.CAT("── Anti FalseDoor ──")
State.api.CTX("FalseDoor Fails:",Cfg.FalseDoorFails,function(v) Cfg.FalseDoorFails=math.max(v,1) end)
State.api.CTX("FalseDoor Timeout:",Cfg.FalseDoorTimeout,function(v) Cfg.FalseDoorTimeout=math.max(v,1) end)
State.api.CTX("Orbit Radius:",Cfg.OrbitRadius,function(v) Cfg.OrbitRadius=math.max(v,2) end)
State.api.CTX("Orbit Speed:",Cfg.OrbitSpeed,function(v) Cfg.OrbitSpeed=math.max(v,10) end)
State.api.CTX("Orbit Max Time:",Cfg.OrbitMaxTime,function(v) Cfg.OrbitMaxTime=math.max(v,1) end)
State.api.CTX("Smart Cooldown:",Cfg.SmartCooldown,function(v) Cfg.SmartCooldown=math.max(v,0) end)
State.api.CTX("Resume Delay:",Cfg.ResumeDelay,function(v) Cfg.ResumeDelay=math.max(v,0) end)
State.api.CTX("Skeleton Door Radius:",Cfg.SkeletonDoorRadius,function(v) Cfg.SkeletonDoorRadius=math.max(v,1) end)
State.api.CAT("── Anti Skeleton ──")
State.api.CTX("Skeleton Radius:",Cfg.SkeletonRadius,function(v) Cfg.SkeletonRadius=math.max(v,1) end)
State.api.CAT("── Pumpkin ──")
State.api.CTX("Escape Distance:",Cfg.PumpkinEscapeDistance,function(v) Cfg.PumpkinEscapeDistance=math.clamp(v,500,1200) end)
State.api.CTX("Escape Speed:",Cfg.PumpkinEscapeSpeed,function(v) Cfg.PumpkinEscapeSpeed=math.clamp(v,60,220) end)
State.api.CTX("Escape Stages:",Cfg.PumpkinEscapeStages,function(v) Cfg.PumpkinEscapeStages=math.clamp(math.floor(v),2,6) end)
State.api.CTX("Safe Platform Away Dist:",Cfg.SafePlatformAwayDistance,function(v) Cfg.SafePlatformAwayDistance=math.clamp(v,200,1000) end)
State.api.CTX("Orbit Radius:",Cfg.PumpkinOrbitRadius,function(v) Cfg.PumpkinOrbitRadius=math.max(v,2) end)
State.api.CTX("Orbit Timeout:",Cfg.PumpkinOrbitTimeout,function(v) Cfg.PumpkinOrbitTimeout=math.max(v,1) end)
State.api.CTX("Check Interval:",Cfg.PumpkinCheckInterval,function(v) Cfg.PumpkinCheckInterval=math.max(v,0.05) end)
State.api.CTX("Pathfind Reach (studs):",Cfg.PumpkinPathfindReach,function(v) Cfg.PumpkinPathfindReach=math.max(v,5) end)
State.api.CTX("Pathfind Timeout:",Cfg.PumpkinPathfindTimeout,function(v) Cfg.PumpkinPathfindTimeout=math.max(v,2) end)
State.api.CAT("── Anti Candy ──")
State.api.CTX("Candy Radius:",Cfg.CandyScapeRadius,function(v) Cfg.CandyScapeRadius=math.max(v,10) end)
State.api.CTX("Candy Time (s):",Cfg.CandyScapeTime,function(v) Cfg.CandyScapeTime=math.max(v,1) end)
GUI.CfgList.CanvasSize=UDim2.new(0,0,0,CY+12)
end
if not State.mobileLite then
startAFD()
startAS()
end
pcall(function()
_G.JJS={Cfg=Cfg,State=State,Version="12.02 Route Watchdog",Device=State.deviceProfile}
end)
