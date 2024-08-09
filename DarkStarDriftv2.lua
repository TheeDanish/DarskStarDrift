local d=ac.getDriverName()
local A=ac.getDriverName(0)
local m=80
local I=5
local g=0
local T={}
local _=nil
local q=nil
local e=300
local o=0
function script.prepare(e)
d=ac.getDriverName()
ac.debug("speed",ac.getCarState(1).speedKmh)
return ac.getCarState(1).speedKmh>60
end
local z=0
local t=0
local e=1
local s=0
local i=0
local w=0
local p={}
local y=0
local R=ac.getCarState(1)
local u={}
local l={}
local n=0
local r=0
local j=30
local f=1
local H=2
local c=0
local v=200
local U=5
local b=0
local h=vec2(50,50)
local x=false
local C="HEADER-TITLE"
local D=true
local a="http://195.201.111.252/graphics/icon-arrow.png"
local a="http://195.201.111.252/graphics/icon-arrow.png"
local a="http://195.201.111.252/graphics/icon-arrow.png"
local L="http://195.201.111.252/graphics/header.png"
local E = "http://195.201.111.252/update_score.php"
local k = "http://195.201.111.252/get_leaderboard_position.php"
local O={"Nice Cut!","Smooth Move!","Great Overtake!","Well Done!"}
local N={"That was close!","Phew, almost hit!","Watch out!","Narrow escape!"}
local S={"Crash!","Oops!","Oh no!","Collision!"}
u.playerscore=ac.storage('playerscore',i)
i=u.playerscore:get()
function parseValue(t,e)
local a=t:sub(e,e)
if a=='{'then
return parseObject(t,e)
elseif a=='['then
return parseArray(t,e)
elseif a=='"'then
local a=t:find('"',e+1)
return t:sub(e+1,a-1),a+1
else
local a=t:find('[,}%]]',e)
local e=tonumber(t:sub(e,a-1))
return e,a
end
end
function parseObject(t,e)
local o={}
e=e+1
while true do
while t:sub(e,e):match("%s")do
e=e+1
end
if t:sub(e,e)=='}'then
return o,e+1
end
local i
i,e=parseValue(t,e)
while t:sub(e,e):match("%s")or t:sub(e,e)==':'do
e=e+1
end
local a
a,e=parseValue(t,e)
o[i]=a
while t:sub(e,e):match("%s")or t:sub(e,e)==','do
e=e+1
end
end
end
function parseArray(t,e)
local a={}
e=e+1
while true do
while t:sub(e,e):match("%s")do
e=e+1
end
if t:sub(e,e)==']'then
return a,e+1
end
local o
o,e=parseValue(t,e)
table.insert(a,o)
while t:sub(e,e):match("%s")or t:sub(e,e)==','do
e=e+1
end
end
end
function parseJSON(e)
local e,t=parseValue(e,1)
return e
end
function getPlayerLeaderboardPosition(e,t)
local e=k.."?steam64id="..e
print("Fetching URL: "..e)
web.get(e,function(e,a)
if e then
print("Error fetching leaderboard position: "..e)
t(e,nil)
return
end
print("Response received: "..a.body)
local e=parseJSON(a.body)
if e and e.status=="success"then
q=e.rank
t(nil,e)
else
t(e and e.message or"Unknown error",nil)
end
end)
end
function Json_encode(i)
local function t(e)
if type(e)=="string"then
return'"'..e:gsub('"','\"')..'"'
elseif type(e)=="number"then
return tostring(e)
elseif type(e)=="table"then
local a={}
for o,e in pairs(e)do
a[#a+1]=t(tostring(o))..":"..t(e)
end
return"{"..table.concat(a,",").."}"
else
error("Unsupported type: "..type(e))
end
end
return t(i)
end
function SendData(t,e)
local e={
highestScore=t,
steam64id=A,
driverName=e
}
local e=Json_encode(e)
print(e)
web.post(E,{
["Content-Type"]="application/json",
["Accept"]="application/json"
},e,function(e,t)
if e then
print("Error sending data: "..e)
else
print("Data sent successfully")
end
end)
end
function handleUIPosition()
if ui.keyPressed(ui.Key.Left)then
h=h-vec2(10,0)
end
if ui.keyPressed(ui.Key.Right)then
h=h+vec2(10,0)
end
if ui.keyPressed(ui.Key.Up)then
h=h-vec2(0,10)
end
if ui.keyPressed(ui.Key.Down)then
h=h+vec2(0,10)
end
end
function checkAIStatus()
for e=1,ac.getSimState().carsCount do
local t=ac.getCarState(e)
local t=t.speedKmh<170 or t.speedKmh>340
T[e]=t
end
end
local function E(e)
if e<n then
l[e]=l[n]
end
n=n-1
end
local function k(e)
return e[math.random(#e)]
end
local function M()
local o=ac.getCarState(1)
local e=0
for t=1,ac.getSimState().carsCount do
if t~=1 then
local a=ac.getCarState(t)
if not T[t]and a.speedKmh~=0 then
if a.pos:closerToThan(o.pos,100)then
e=e+1
end
else
end
end
end
if e>0 then
f=e*5
else
f=1
end
return e>0
end
function script.update(a)
o=o+a
if o>=60 then
getPlayerLeaderboardPosition(A,function(t,e)
if t then
print("Error: "..t)
else
print("Player position: "..e.position)
print("Highest score: "..e.highestScore)
_=e.position
i=e.highestScore
q=e.rank
end
end)
o=0
end
if c>0 then
c=c-a
end
local o=ac.getCarState(1)
b=b+a
if b>=U then
checkAIStatus()
b=0
end
if M()then
multiplierColor=rgbm(0,1,0,1)
else
multiplierColor=rgbm(.4,.4,.4,1)
end
if o.engineLifeLeft<1 then
if t>i then
i=math.floor(t)
u.playerscore:set(i)
if r<=0 then
ac.sendChatMessage(d.." reached a new Highscore of "..t.." points.")
r=j
end
SendData(i,d)
end
t=0
e=1
return
end
if r>0 then
r=r-a
end
z=z+a
local h=(o.speedKmh or 0)/10
local n=.5*math.lerp(1,.1,math.lerpInvSat(o.speedKmh,80,200))+o.wheelsOutside
e=math.max(1,e-a*n)
local n=ac.getSimState()
while n.carsCount>#p do
p[#p+1]={}
end
if y>0 then
y=y-a
elseif o.wheelsOutside>0 then
addMessage("Car is outside",-1)
y=60
end
if o.speedKmh<m then
if w>3 then
if t>i then
i=math.floor(t)
u.playerscore:set(i)
if r<=0 then
ac.sendChatMessage(d.." reached a new Highscore of "..t.." points.")
r=j
end
SendData(i,d)
end
end
t=0
e=1
addMessage("Too slow!",-1)
w=w+a
e=1
return
else
w=0
end
if g>0 then
g=g-a
elseif o.brake>0 then
e=e/1.25
g=I
addMessage("NO FULL SEND ?",-1)
end
for a=1,ac.getSimState().carsCount do
local n=ac.getCarState(a)
local a=p[a]
if n.pos:closerToThan(o.pos,10)then
local l=math.dot(n.look,o.look)>.2
if not l then
a.drivingAlong=false
if not a.nearMiss and n.pos:closerToThan(o.pos,3)then
a.nearMiss=true
e=math.min(e+1,v)
addMessage("Nearly crashed!",1)
end
end
if n.collidedWith==0 then
a.collided=true
if t>i then
i=math.floor(t)
u.playerscore:set(i)
if r<=0 then
ac.sendChatMessage(d.." reached a new Highscore of "..t.." points.")
r=j
end
SendData(i,d)
end
t=0
e=1
addMessage(k(S),-1)
end
local i=false
if R.isDriftValid then
local a=math.ceil(.1*h+.1*e)
t=t+a*f
e=math.min(e+.02,v)
s=s+5
if not i then
addMessage("Drift Score: "..t,1)
i=true
end
else
i=false
end
if not a.overtaken and not a.collided and a.drivingAlong then
local i=(n.pos-o.pos):normalize()
local i=math.dot(i,n.look)
a.maxPosDot=math.max(a.maxPosDot,i)
if i<-.5 and a.maxPosDot>.5 then
local i=math.ceil(10*h+10*e)
t=t+i*f
e=math.min(e+1,v)
s=s+10
a.overtaken=true
if n.pos:closerToThan(o.pos,3)then
addMessage(k(N),1)
else
addMessage(k(O),0)
end
end
end
else
a.maxPosDot=-1
a.overtaken=false
a.collided=false
a.drivingAlong=true
a.nearMiss=false
end
end
if o.speedKmh>225 then
addMessage("Keep your Speed!",1)
end
end
local a={}
local function d(t)
for a,e in ipairs(a)do
if e.text==t then
return true
end
end
return false
end
local u=10
local r=30
function addMessage(t,o)
if t:find("Drift Score")then
if x then
for e=#a,1,-1 do
if a[e].text:find("Drift Score")then
table.remove(a,e)
break
end
end
end
x=true
end
if not d(t)then
if#a>=u then
table.remove(a,#a)
end
for e=math.min(#a+1,4),2,-1 do
a[e]=a[e-1]
a[e].targetPos=e
end
a[1]={
text=t,
age=0,
targetPos=1,
currentPos=1,
mood=o
}
if o==1 and c<=0 then
local e=25
for e=1,60 do
if n>=r then break end
local e=vec2(math.random()-.5,math.random()-.5)
n=n+1
l[n]={
color=rgbm.new(hsv(math.random()*360,1,1):rgb(),1),
pos=h+vec2(80,140)+e*vec2(40,20),
velocity=e:scale(.2+math.random()),
life=.5+.5*math.random()
}
end
c=H
end
end
end
local d=5
local function u(o)
if e>0 then
local e=math.min(e/v,1)
s=s+o*10*e
else
s=0
end
if s>360 then
s=s-360
end
local t=1
while t<=#a do
local e=a[t]
e.age=e.age+o
e.currentPos=math.applyLag(e.currentPos,e.targetPos,.8,o)
if e.age>=d then
if e.text:find("Drift Score")then
x=false
end
table.remove(a,t)
else
t=t+1
end
end
for t=n,1,-1 do
local e=l[t]
e.pos:add(e.velocity)
e.velocity.y=e.velocity.y+.02
e.life=e.life-o
e.color.mult=math.saturate(e.life*4)
if e.life<0 then
E(t)
end
end
while n>r do
E(n)
end
if e>10 and math.random()>.98 then
for e=1,math.floor(e)do
if n>=r then break end
local e=vec2(math.random()-.5,math.random()-.5)
n=n+1
l[n]={
color=rgbm.new(hsv(math.random()*360,1,1):rgb(),1),
pos=vec2(195,75)+e*vec2(40,20),
velocity=e:normalize():scale(.2+math.random()),
life=.5+.5*math.random()
}
end
end
end
local o=0
function script.drawUI()
local o=ac.getUiState()
u(o.dt)
handleUIPosition()
local r=math.saturate(math.floor(ac.getCarState(1).speedKmh)/m)
local o=rgbm(.1,.1,.1,1)
local c=rgbm(.331,.331,.331,1)
local u=rgbm.new(hsv(r*120,1,1):rgb(),1)
local d=rgbm.new(hsv(s,math.saturate(e/10),1):rgb(),math.saturate(e/4))
local w=(ac.getCarState(1).speedKmh or 0)/10
local function s(e,i,a,n,t)
local o=ui.getCursor()
ui.setCursor(o+vec2(a,a))
ui.textColored(e,n,t)
ui.setCursor(o)
ui.textColored(e,i,t)
end
local function r(a,o,n,t,e,i)
ui.drawLine(a+vec2(e,e),o+vec2(e,e),i,t)
ui.drawLine(a,o,n,t)
end
ui.beginTransparentWindow("Szeiy-Scripts",h,vec2(420,600))
ui.beginOutline()
if D then
ui.sameLine(45)
ui.image(L,vec2(200,100))
else
ui.pushFont(ui.Font.Huge)
s(C,rgbm(1,.5,0,1),2,o,ui.Alignment.Center)
ui.setNextTextBold()
end
ui.offsetCursorY(1)
ui.newLine()
ui.sameLine(110)
ui.pushFont(ui.Font.Main)
s("Rank: "..(q or"N/A"),rgbm(1,.5,0,1),2,o,ui.Alignment.Center)
ui.offsetCursorY()
ui.drawLine(ui.getCursor()+vec2(0,0),ui.getCursor()+vec2(260,0),rgbm(0,0,0,1),3)
ui.drawLine(ui.getCursor()+vec2(0,0),ui.getCursor()+vec2(260,0),rgbm(.3,.3,.3,1),1)
ui.offsetCursorY(10)
local function h(e,a,i)
ui.pushStyleColor(ui.StyleColor.FrameBg,rgbm(.2,.2,.2,1))
ui.pushStyleColor(ui.StyleColor.Border,rgbm(.5,.2,.5,1))
ui.pushStyleVar(ui.StyleVar.FrameRounding,5.)
ui.pushStyleVar(ui.StyleVar.FramePadding,vec2(8,8))
ui.pushStyleVar(ui.StyleVar.ItemSpacing,vec2(6,6))
ui.beginChild(e,vec2(100,60),false,ui.WindowFlags.NoInputs)
s(e,rgbm(1,1,1,1),1,o)
ui.pushFont(ui.Font.Title)
local e=ui.getCursor()
local t=e+vec2(65,0)
r(e,t,rgbm(0,0,0,1),1,1,o)
s(a,i,1,o)
e=ui.getCursor()
t=e+vec2(65,0)
r(e,t,rgbm(0,0,0,1),1,1,o)
ui.endChild()
ui.popStyleVar(3)
ui.popStyleColor(2)
end
ui.pushFont(ui.Font.Main)
ui.setNextTextBold()
h("   POINTS"," "..t,d)
ui.sameLine(120)
ui.pushFont(ui.Font.Main)
ui.setNextTextBold()
h(" POSITION","  #"..string.format("%03d",_ or 0),rgbm(1,1,1,1))
ui.sameLine(215)
ui.pushFont(ui.Font.Main)
ui.setNextTextBold()
h("HIGHSCORE",i.."",rgbm(1,1,1,1))
if e>20 then
ui.endRotation(math.sin(e/180*3141.5)*3*math.lerpInvSat(e,20,30)+90)
end
for e=1,n do
local e=l[e]
if e~=nil then
ui.drawLine(e.pos,e.pos+e.velocity*4,e.color,2)
end
end
ui.offsetCursorY(5)
ui.drawLine(ui.getCursor()+vec2(0,0),ui.getCursor()+vec2(260,0),rgbm(0,0,0,1),3)
ui.drawLine(ui.getCursor()+vec2(0,0),ui.getCursor()+vec2(260,0),rgbm(.3,.3,.3,1),1)
ui.offsetCursorY(15)
local function t(e,i,a)
ui.pushStyleColor(ui.StyleColor.FrameBg,rgbm(.2,.2,.2,1))
ui.pushStyleColor(ui.StyleColor.Border,rgbm(.5,.2,.5,1))
ui.pushStyleVar(ui.StyleVar.FrameRounding,5.)
ui.pushStyleVar(ui.StyleVar.FramePadding,vec2(8,8))
ui.pushStyleVar(ui.StyleVar.ItemSpacing,vec2(5,5))
ui.beginChild(e,vec2(100,60),false,ui.WindowFlags.NoInputs)
s(e,rgbm(1,1,1,1),1,o)
ui.pushFont(ui.Font.Title)
local e=ui.getCursor()
local t=e+vec2(55,0)
r(e,t,rgbm(0,0,0,1),1,1,o)
s(string.format(" %.1fx",i),a,1,o)
e=ui.getCursor()
t=e+vec2(55,0)
r(e,t,rgbm(0,0,0,1),1,1,o)
ui.endChild()
ui.popStyleVar(3)
ui.popStyleColor(2)
end
ui.pushFont(ui.Font.Main)
ui.setNextTextBold()
t(" COMBO",e,d)
ui.sameLine(120)
ui.pushFont(ui.Font.Main)
ui.setNextTextBold()
t("  SPEED",w,u)
ui.sameLine(220)
ui.pushFont(ui.Font.Main)
ui.setNextTextBold()
t("PLAYERS",f,rgbm(.9,.7,.1,1))
ui.offsetCursorY(2)
ui.drawLine(ui.getCursor()+vec2(0,0),ui.getCursor()+vec2(260,0),rgbm(0,0,0,1),3)
ui.drawLine(ui.getCursor()+vec2(0,0),ui.getCursor()+vec2(260,0),rgbm(.3,.3,.3,1),1)
ui.offsetCursorY(15)
local h=260
local p=260
local l="Keep your Speed above "..m.." km/h"
local e=ui.measureText(l)
local t=(h-e.x)/2+15
local w=15
local f=3
local function y(n,d)
local i=ui.getCursor()
ui.setCursor(i+vec2(t+n,0))
ui.pushFont(ui.Font.Main)
ui.setNextTextBold()
s(l,rgbm(1,1,1,1),1,o)
local a=(h-e.x)/2
ui.setCursor(i+vec2(-a+n,e.y+d))
local function s(a)
ui.drawRectFilled(a+vec2(-t,e.y+2),a+vec2(h-t,e.y+12),o,1)
r(a+vec2(-t,e.y+2),a+vec2(-t,e.y+12),c,1,1,o)
r(a+vec2(-t+m,e.y+2),a+vec2(-t+m,e.y+12),c,1,1,o)
local i=math.min(ac.getCarState(1).speedKmh,p)
if i>1 then
r(a+vec2(-t,e.y+7),a+vec2(-t+i,e.y+7),u,6,1,o)
end
end
s(i+vec2(n,d))
end
y(w,f)
ui.newLine()
ui.offsetCursorY(1)
ui.drawLine(ui.getCursor()+vec2(0,0),ui.getCursor()+vec2(260,0),rgbm(0,0,0,1),3)
ui.drawLine(ui.getCursor()+vec2(0,0),ui.getCursor()+vec2(260,0),rgbm(.3,.3,.3,1),1)
ui.offsetCursorY(5)
ui.pushFont(ui.Font.Title)
ui.setNextTextBold()
local i=ui.getCursor()
for e=1,#a do
local e=a[e]
local t=math.saturate(4-e.currentPos)*math.saturate(8-e.age)
local a=math.saturate(1-e.age*5)^2*50+5
ui.setCursor(i+vec2(a,(e.currentPos-1)*15))
s(e.text,e.mood==1 and rgbm(0,1,0,t)or e.mood==-1 and rgbm(1,0,0,t)or rgbm(1,1,1,t),1,o)
end
ui.endOutline()
ui.endTransparentWindow()
end
