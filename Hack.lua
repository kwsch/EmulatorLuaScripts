local rshift, lshift=bit.rshift, bit.lshift
local wd,ww,wb=memory.writedword,memory.writeword,memory.writebyte
local md,mw,mb=memory.readdwordunsigned,memory.readwordunsigned,memory.readbyteunsigned
local gt,sf=gui.text,string.format
-- paste in script here
local table={}
local start=0x02293600
local a=0x0
local b=0x0
local enblb=1

local on,enbl=0,1
while true do
if md(start+9000*8)>0 and a<9000 then
wd(start+a, 0x00)
else end
a=a+1
end