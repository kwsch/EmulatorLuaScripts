local rshift, lshift=bit.rshift, bit.lshift
local md,mw,mb=memory.readdwordunsigned,memory.readwordunsigned,memory.readbyteunsigned
local gt,sf=gui.text,string.format
local table={}
local on,enbl=0,1

local pos_m=0x0223ADE4             --at game_data.c
local zds=0x02246190

if md(0x023FFE0C)==0x4A455249 then
        game='Black2 JP'
        gi=0
	g=0
   elseif md(0x023FFE0C)==0x4F455249 then
	game='Black2 U'
	gi=1
	g=0
   elseif md(0x023FFE0C)==0x4F445249 then
	gi=1
        game='White2 U'
        g=0x20
   else game='White2 JP' g=0x20 gi=0
end

if gi==1 then zds=0x02246810 pos_m=0x0223B464 end
 
function main()
        table=joypad.get(1)
        if table.L then
                gt(0,0, "Toggling Display")
                enbl=0
        else
                if enbl==0 then on=(on+1)%2 enbl=1 end
        end
        if on==0 then
		bike=rshift(mw(zds+g+2*15),10)%2
		fly=rshift(mw(zds+g+2*15),13)%2
                if bike==1 then
                        gt(159,110,sf("Bike - Enabled")) else
                        gt(159,110,sf("Bike - Disabled")) end
                if fly==1 then
                        gt(159,120,sf("Fly  - Enabled")) else
                        gt(159,120,sf("Fly  - Disabled")) end
       
                                                gt(1,35,sf("Active Zonedata for Location (%s)",game)) 
                gt(1,50,sf("00-01: %04x",mw(zds+g+2*0)))        gt(80,50,sf("10-11: %04x",mw(zds+g+2*8)))       gt(159,50,sf("20-21: %04x",mw(zds+g+2*16)))
                gt(1,60,sf("02-03: %04x",mw(zds+g+2*1)))        gt(80,60,sf("12-13: %04x",mw(zds+g+2*9)))       gt(159,60,sf("22-23: %04x",mw(zds+g+2*17)))
                gt(1,70,sf("04-05: %04x",mw(zds+g+2*2)))        gt(80,70,sf("14-15: %04x",mw(zds+g+2*10)))      gt(159,70,sf("24-27: %08x",md(zds+g+2*18)))
                gt(1,80,sf("06-07: %04x",mw(zds+g+2*3)))        gt(80,80,sf("16-17: %04x",mw(zds+g+2*11)))      gt(159,80,sf("28-2B: %08x",md(zds+g+2*20)))
                gt(1,90,sf("08-09: %04x",mw(zds+g+2*4)))        gt(80,90,sf("18-19: %04x",mw(zds+g+2*12)))      gt(159,90,sf("2C-2F: %08x",md(zds+g+2*22)))
                gt(1,100,sf("0A-0B: %04x",mw(zds+g+2*5)))       gt(80,100,sf("1A-1B: %04x",mw(zds+g+2*13)))
                gt(1,110,sf("0C-0D: %04x",mw(zds+g+2*6)))       gt(80,110,sf("1C-1D: %04x",mw(zds+g+2*14)))
                gt(1,120,sf("0E-0F: %04x",mw(zds+g+2*7)))       gt(80,120,sf("1E-1F: %04x",mw(zds+g+2*15)))    
       
        end

	gt(160,145,sf("Overworld: %5d",mw(zds+g+2*11)))
        gt(160,155,sf("Script: %8d",mw(zds+g+2*3)))
	gt(160,165,sf("Text: %10d",mw(zds+g+2*5)))
	
	flyx=md(zds+g+2*18)
	flyy=md(zds+g+2*22)
	flyz=md(zds+g+2*20)
	if (flyx==5 and flyy==4 and flyz==0) or (flyx==13 and flyy==0 and flyz==5) then
	gt(149,174,sf("Can't Fly to here.")) else
	gt(185,174,sf("FlyTo (XYZ)"))
	gt(185,184,sf("%d,%d,%d",flyx,flyy,flyz)) end

	gt(1,145, sf("SubMap of Map: %3d",mw(zds+g+2*12)))
        if mw(zds+g+2*10)%256<255 then
                gt(1,155,sf("Slot Location: %d",mw(zds+g+2*10)%256)) else gt(1,155,sf("No Encounters Here!")) end
 
        gt(1,165, sf("Current Position"))
        gt(2,175, sf("M: %3d, X: %3d", mw(pos_m+g), mw(pos_m+0x6+g)))
	gt(2,184, sf("Y: %3d, Z: %3d", mw(pos_m+0xE+g), mw(pos_m+0xA+g)))
end
 

gui.register(main)