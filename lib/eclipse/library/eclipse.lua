---@diagnostic disable: lowercase-global
---@meta

---@alias pointer number

---@type fun(str: string)
function print(str) end

---------------------------------------------------------------------------
---@class Vec2
---@field x number
---@field y number

-- Can also + - * / with others of this type

---@type fun(x:number, y:number) : Vec2
Vec2 = {}

---------------------------------------------------------------------------
---@class Vec4
---@field x number
---@field y number
---@field z number
---@field w number

-- Can also + - * / with others of this type

---@type fun(x:number, y:number, z:number, w:number) : Vec4
Vec4 = {}

---------------------------------------------------------------------------
---@class Vector
---@field x number
---@field y number
---@field z number

-- Can also + - * / with others of this type

---@type fun(x:number, y:number, z:number) : Vector
Vector = {}

---@type fun() : number
function Vector:length() end

---@type fun() : number
function Vector:length2D() end

---@type fun(other:Vector) : number
function Vector:distTo() end


---------------------------------------------------------------------------
---@class Color
---@field value Vec4

---@type fun(r:number, g:number, b:number, a:number)
Color = {}

---------------------------------------------------------------------------
---@class QAngle
---@field x number
---@field y number
---@field z number

---@type fun(x:number, y:number, z:number) : QAngle
QAngle = {}

---@type fun() : number
function Vector:length() end

---------------------------------------------------------------------------
---@class UserCmd
---@field commandnumber number
---@field tickcount number
---@field viewangles QAngle
---@field aimdirection QAngle
---@field forwardmove number
---@field sidemove number
---@field upmove number
---@field mousedx number
---@field mousedy number
---@field hasbeenpredicted boolean
---@field headangles QAngle
---@field headoffset Vector
UserCmd = {}

---------------------------------------------------------------------------
---@class Entity
Entity = {}

---@type fun() : pointer
function Entity:ffiPtr() end

---@type fun() : boolean
function Entity:alive() end

---@type fun() : boolean
function Entity:exists() end

---@type fun() : boolean
function Entity:dormant() end

---@type fun() : boolean
function Entity:sane() end

---@type fun() : boolean
function Entity:onground() end

---@type fun() : number
function Entity:movetype() end

---@type fun() : number
function Entity:index() end

---@type fun() : Vector
function Entity:origin() end

---@type fun() : Vector
function Entity:velocity() end

---@type fun() : number
function Entity:classID() end

---@type fun() : string
function Entity:networkName() end

---@type fun() : Vec4
function Entity:getBBox() end

---@type fun(mins:Vector) : string
function Entity:setMins(mins) end

---@type fun(maxs:Vector) : string
function Entity:setMaxs(maxs) end

---@type fun() : Vector
function Entity:getMins() end

---@type fun() : Vector
function Entity:getMaxs() end

---@type fun(updateType:number)
function Entity:onPreDataChanged(updateType) end

---@type fun(updateType:number)
function Entity:onDataChanged(updateType) end

---@type fun(updateType:number)
function Entity:preDataUpdate(updateType) end

---@type fun(updateType:number)
function Entity:postDataUpdate(updateType) end

---@type fun() : boolean
function Entity:teammate() end


---@type fun(table:string, var:string) : boolean
function Entity:getPropBool(table, var) end

---@type fun(table:string, var:string) : number
function Entity:getPropInt(table, var) end

---@type fun(table:string, var:string) : number
function Entity:getPropFloat(table, var) end

---@type fun(table:string, var:string) : number
function Entity:getPropPtr(table, var) end

---@type fun(table:string, var:string) : QAngle
function Entity:getPropQAngle(table, var) end

---@type fun(table:string, var:string) : Vector
function Entity:getPropVector(table, var) end

---@type fun(table:string, var:string) : string
function Entity:getPropStr(table, var) end


---@type fun(table:string, var:string, val:boolean)
function Entity:setPropBool(table, var, val) end

---@type fun(table:string, var:string, val:number)
function Entity:setPropInt(table, var, val) end

---@type fun(table:string, var:string, val:number)
function Entity:setPropFloat(table, var, val) end

---@type fun(table:string, var:string, val:number)
function Entity:setPropPtr(table, var, val) end

---@type fun(table:string, var:string, val:QAngle)
function Entity:setPropQAngle(table, var, val) end

---@type fun(table:string, var:string, val:Vector)
function Entity:setPropVector(table, var, val) end

---@type fun(table:string, var:string, val:string)
function Entity:setPropStr(table, var, val) end

---------------------------------------------------------------------------
---@class ClientClass
ClientClass = {}

---@type fun() : boolean
function ClientClass:exists() end

---@type fun(entNum:number, serialNum:number) : Entity
function ClientClass:create(entNum, serialNum) end

---@type fun() : string
function ClientClass:name() end

---@type fun() : ClientClass
function ClientClass:next() end

---------------------------------------------------------------------------
---@class Convar
Convar = {}

---@type fun() : pointer
function Convar:ffiPtr() end

---@type fun() : number
function Convar:getFloat() end

---@type fun() : number
function Convar:getInt() end

---@type fun(val:string)
function Convar:setStr(val) end

---@type fun(val:number)
function Convar:setFloat(val) end

---@type fun(val:number)
function Convar:setInt(val) end

---------------------------------------------------------------------------
---@class GameEvent
GameEvent = {}

---@type fun() : pointer
function GameEvent:ffiPtr() end

---@type fun() : boolean
function GameEvent:getBool() end

---@type fun() : number
function GameEvent:getFloat() end

---@type fun() : number
function GameEvent:getInt() end

---@type fun() : string
function GameEvent:getName() end

---@type fun() : number
function GameEvent:getPtr() end

---@type fun() : string
function GameEvent:getString() end

---@type fun() : number
function GameEvent:getUint64() end

---@type fun() : string
function GameEvent:getWString() end

---------------------------------------------------------------------------
eclipse = {}

---@type fun(hookName:string, hook:function)
function eclipse.registerHook(hookName, hook) end

---@type fun(cmd:UserCmd)
function eclipse.setCmd(cmd) end

---@type fun(convar:string) : Convar
function eclipse.getConvar(convar) end

---@type fun(name:string, type:string, material:string)
function eclipse.addMaterial(name, type, material) end

---@type fun(name:string)
function eclipse.removeMaterial(name) end

---@type fun(pos:Vector) : Vec2
function eclipse.worldToScreen(pos) end

---@type fun() : ClientClass
function eclipse.getAllClientClasses() end

---@type fun(name:string, serverside:boolean) : ClientClass
function eclipse.addEventListener(name, serverside) end

---@type fun(command:string)
function eclipse.clientCmd(name, serverside) end

---@type fun() : boolean
function eclipse.isInGame() end

---@type fun(cmd:UserCmd)
function eclipse.startMovementFix(cmd) end

---@type fun(cmd:UserCmd)
function eclipse.endMovementFix(cmd) end

---@type fun(angle:QAngle)
function eclipse.setViewAngles(angle) end

---@type fun(angle:QAngle) : Vector
function eclipse.angleVector(angle) end

---------------------------------------------------------------------------
memory = {}

---@type fun(lib:string, interface:string) : pointer
function memory.getInterface(lib, interface) end

---@type fun(ptr:number, offset:number, size:number) : pointer
function memory.getAbsoluteAddress(ptr, offset, size) end

---@type fun(lib:number, pattern:string) : pointer
function memory.patternScan(ptr, offset, size) end

---------------------------------------------------------------------------
prediction = {}

---@type fun(cmd:UserCmd)
function memory.start(cmd) end

---@type fun()
function memory.end_() end

---@type fun(frame:number)
function memory.restoreToFrame(frame) end

---@type fun() : number
function memory.commandsPredicted() end

---------------------------------------------------------------------------
beam = {}

---@type fun(start:Vector, end_:Vector, modelName:string, color:Color, life:number, width:number, amplitude:number)
function beam.createBeam(start, end_, modelName, color, life, width, amplitude) end

---@type fun(center:Vector, ringStartRadius:number, ringEndRadius:number, modelName:string, color:Color, life:number, width:number)
function beam.ringBeam(center, ringStartRadius, ringEndRadius, modelName, color, life, width) end

---------------------------------------------------------------------------
entitylist = {}

---@type fun(index:number) : Entity
function entitylist.getEntity(index) end

---@type fun() : Entity[]
function entitylist.getEntities() end

---@type fun(classId:number) : Entity[]
function entitylist.getEntitiesByClassID(classId) end

---@type fun() : number
function entitylist.getLocalPlayer() end

---@type fun(userId:number) : number
function entitylist.getIndexForUserID(userId) end

---------------------------------------------------------------------------
trace = {}

---@class trace.TraceResult
---@field contents number
---@field entityHit Entity
---@field fraction number
---@field hitbox number
---@field hitgroup number
---@field surfaceName string
---@field slopeAngle number
trace.TraceResult = {}

---@type fun(begin:Vector, end_:Vector, entitySkip:Entity, mask:number) : trace.TraceResult
function trace.trace(begin, end_, entitySkip, mask) end

---@type fun(begin:Vector, end_:Vector) : trace.TraceResult
function trace.traceSimple(begin, end_) end

---@type fun(begin:Vector, end_:Vector, min:Vector, max:Vector, entitySkip:Entity, mask:number) : trace.TraceResult
function trace.traceHull(begin, end_, min, max, entitySkip, mask) end

---@type fun(begin:Vector, end_:Vector, min:Vector, max:Vector) : trace.TraceResult
function trace.traceHullSimple(begin, end_, min, max) end

---------------------------------------------------------------------------
panorama = {}

---@type fun(script:string, panel:string)
function panorama.executeScript(script, panel) end

---------------------------------------------------------------------------
glow = {}

---@type fun(entity:Entity, color:Color, style:number)
function glow.glowEntity(entity, color, style) end

---@type fun(origin:Vector, index:number, life:number, color:Color, radius:number, decay:number)
function glow.createDlight() end

---------------------------------------------------------------------------
ui = {}

---@type fun() : Vec2
function ui.getMenuPos() end

---@type fun() : Vec2
function ui.getMenuSize() end

---@type fun() : Vec2
function ui.getCurrentWindowPos() end

---@type fun() : Vec2
function ui.getCurrentWindowSize() end

---@type fun(size:Vec2)
function ui.setNextWindowSize(size) end

---@type fun() : Vec2
function ui.getMousePos() end

---@type fun() : number[]
function ui.getKeysPressed() end

---@type fun() : number
function ui.getMousePressed() end

---@type fun() : number
function ui.getMouseWheel() end

---@type fun() : boolean
function ui.isMenuOpen() end

---@type fun(name:string) : boolean
function ui.getConfigBool(name) end

---@type fun(name:string, value:boolean)
function ui.setConfigBool(name, value) end

---@deprecated
---@type fun(name:string) : number
function ui.getConfigFloat(name) end

---@deprecated
---@type fun(name:string, value:number)
function ui.setConfigFloat(name, value) end

---@type fun(name:string) : number
function ui.getConfigNumber(name) end

---@type fun(name:string, value:number)
function ui.setConfigNumber(name, value) end

---@type fun(name:string) : string
function ui.getConfigStr(name) end

---@type fun(name:string, value:string)
function ui.setConfigStr(name, value) end

---@type fun(name:string) : Color
function ui.getConfigCol(name) end

---@type fun(name:string, value:Color)
function ui.setConfigCol(name, value) end

---@type fun(title:string)
function ui.beginWindow(title) end

---@type fun(title:string, flags:number)
function ui.beginComplexWindow(title, flags) end

---@type fun()
function ui.sameLine() end

---@type fun(count:number, border:boolean)
function ui.columns(count, border) end

---@type fun()
function ui.nextColumn() end

---@type fun()
function ui.separator() end

---@type fun(label:string)
function ui.label(label) end

---@type fun(label:string, varName:string)
function ui.checkbox(text, varName) end

---@type fun(label:string)
function ui.button(text) end

---@type fun(label:string, varName:string)
function ui.colorPicker(text, varName) end

---@type fun(label:string, varName:string)
function ui.colorPicker(text, varName) end

---@type fun(label:string, varName:string)
function ui.textInput(text, varName) end

---@type fun(label:string, varName:string, height:number)
function ui.textInputMultiline(text, varName, height) end

---@type fun(label:string, varName:string, min:number, max:number, format:string)
function ui.sliderInt(text, varName, min, max, format) end

---@type fun(label:string, varName:string, min:number, max:number, format:string)
function ui.sliderFloat(text, varName, min, max, format) end

---@type fun(label:string, varName:string)
function ui.keybinder(text, varName) end

---@type fun(varName:string) : boolean
function ui.isKeybinderDown(varName) end

---@type fun(label:string, varName:string, items:string[])
function ui.comboBox(label, varName, items) end

---------------------------------------------------------------------------
draw = {}

---@type fun(min:Vec2, max:Vec2, color:Color, thickness:number)
function draw.rectangle(min, max, color, thickness) end

---@type fun(min:Vec2, max:Vec2, color:Color, thickness:number, rounding:number)
function draw.rectangleRounded(min, max, color, thickness, rounding) end

---@type fun(min:Vec2, max:Vec2, color:Color)
function draw.filledRectangle(min, max, color) end

---@type fun(min:Vec2, max:Vec2, color:Color, rounding:number)
function draw.filledRectangleRounded(min, max, color, rounding) end

---@type fun(min:Vec2, max:Vec2, tl:Color, trColor, bl:Color, br:Color)
function draw.gradientFilledRectangle(min, max, tl, tr, bl, br) end

---@type fun(p1:Vec2, p2:Vec2, color:Color, thickness:number)
function draw.line(p1, p2, color, thickness) end

---@type fun(p1:Vec2, radius:number, color:Color, thickness:number)
function draw.circle(pos, radius, color, thickness) end

---@type fun(p1:Vec2, radius:number, color:Color)
function draw.filledCircle(pos, radius, color) end

---@type fun(text:string) : Vec2
function draw.calcTextSize(text) end

---@type fun(pos:Vec2, color:Color, text:string)
function draw.text(pos, color, text) end

---@type fun(pos:Vec2, color:Color, text:string)
function draw.shadowText(pos, color, text) end

---@type fun(pos:Vec2, color:Color, text:string)
function draw.outlineText(pos, color, text) end

---@type fun() : Vec2
function draw.getScreenSize() end

---@type fun() : number
function draw.deltaTime() end

---@type fun(font:number) : number
function draw.pushFont(font) end

---@type fun()
function draw.popFont() end

---@type fun(filename:string, size:number, hinting:boolean) : number
function draw.loadFont(filename, size, hinting) end

---@class draw.Image
---@field image number
---@field width number
---@field height number
draw.Image = {}

---@type fun(filename:string) : draw.Image
function draw.loadImage(filename) end

---@type fun(image:draw.Image, min:Vec2, max:Vec2)
function draw.drawImage(image, min, max) end