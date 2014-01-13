local rshift, lshift=bit.rshift, bit.lshift
local wd,ww,wb=memory.writedword,memory.writeword,memory.writebyte
local rd,rw,rb=memory.readdwordunsigned,memory.readwordunsigned,memory.readbyteunsigned
mb=function(x) return rb(x) 							end
mw=function(x) return rb(x)+rb(x+1)*0x100 					end
md=function(x) return rb(x)+rb(x+1)*0x100+rb(x+2)*0x10000+rb(x+3)*0x1000000 	end
local gt,sf=gui.text,string.format

if mb(0x023FFE09)==0x00 then		-- Not "2" ~ Not B2/W2
	  pos_m=md(0x02000024)+0x3461C
	    zds=md(0x02000024)+0x3DFAC
	owstart=md(0x02000024)+0x34E04
	game=1
else
	  pos_m=md(0x02000024)+0x36780
	    zds=md(0x02000024)+0x41B2C
	owstart=md(0x02000024)+0x36BE8
	game=2
end

local useupper=true
local L8=0x01
local U8=0x00
local edit="NPC"

local mapexit=1
local offset=0x0A



function main()
--L8=math.random(500)
--mapexit=math.random(6)

if edit=="Furniture" then mode=1 
	mult=0x14 
	editat=0x08+owstart
elseif edit=="NPC" then 
	mode=2
	mult=0x24 
	editat=0x08+mb(0x04+owstart)*0x14+owstart
elseif edit=="Warp" then 
	mode=3
	mult=0x14 
	editat=0x08+mb(0x04+owstart)*0x14+mb(0x05+owstart)*0x24+owstart
elseif edit=="Trigger" then 
	mode=4 
	mult=0x16 
	editat=0x08+mb(0x04+owstart)*0x14+mb(0x05+owstart)*0x24+mb(0x06+owstart)*0x14+owstart end
count=mb(owstart+3+mode)

--word editing mode
	if useupper==true then
	if mw(editat+offset)~=(L8+U8*0x100) then i=0
	   gt(1,00,sf("Map is Switching!"))
		while i<count do
			insert=(L8+U8*0x100)
			if mode==3 then ww(i*mult+offset+editat+4,mapexit) end
			ww(i*mult+offset+editat,insert)
			i=i+1
		end
	end end

--byte editing mode
	if useupper==false then 
	if mb(editat+offset)~=(L8) then i=0
	   gt(1,00,sf("Map is Switching!"))
		while i<count do
			insert=(L8)
			if mode==3 then ww(i*mult+offset+editat+4,mapexit) end
			wb(i*mult+offset+editat,insert)
			i=i+1
		end
	end end

--Debug
gt(1,10,sf("OW Data Start: %08X",owstart))
gt(1,20,sf("Desired Count: %d",count))
gt(1,30,sf("Start of Desired Data: %08X",editat))
gt(1,40,sf("Mode: %s",edit))

end
gui.register(main)