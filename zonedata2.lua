local bnd,br,bxr=bit.band,bit.bor,bit.bxor
local rshift, lshift=bit.rshift, bit.lshift
local mdword=memory.readdwordunsigned
local mword=memory.readwordunsigned
local mbyte=memory.readbyteunsigned
local wdword=memory.writedword
local pos_m=0x0223ADC4+0x20		--at game_data.c
local table={}
local on=0
local enbl=1

if mdword(0x023FFE0C)==0x4A455249 then
	game='Black'
	g=0
   else
	game='White'
	g=1
end

while true do
table=joypad.get(1)
   if table.L then
    gui.text(0,0, "Toggling Display")
	enbl=0
    else
     if enbl==0 then on=(on+1)%2 enbl=1 end

   end
if on==0 then
	if rshift(mbyte(0x022592BB+0x20*g),2)%2==1 then
		gui.text(159,110,string.format("Bike - Enabled"))
	else
		gui.text(159,110,string.format("Bike - Disabled")) end
	if rshift(mbyte(0x022592BB+0x20*g),5)%2==1 then
		gui.text(159,120,string.format("Fly  - Enabled"))
	else
		gui.text(159,120,string.format("Fly  - Disabled")) end
	
						gui.text(1,35,string.format("Active Zonedata for Location (%s)",game))	
	gui.text(1,50,string.format("00-01: %04x",mword(0x02246190+g*0x20+2*0)))	gui.text(80,50,string.format("10-11: %04x",mword(0x02246190+g*0x20+2*8)))	gui.text(159,50,string.format("20-21: %04x",mword(0x02246190+g*0x20+2*16)))
	gui.text(1,60,string.format("02-03: %04x",mword(0x02246190+g*0x20+2*1)))	gui.text(80,60,string.format("12-13: %04x",mword(0x02246190+g*0x20+2*9)))	gui.text(159,60,string.format("22-23: %04x",mword(0x02246190+g*0x20+2*17)))
	gui.text(1,70,string.format("04-05: %04x",mword(0x02246190+g*0x20+2*2)))	gui.text(80,70,string.format("14-15: %04x",mword(0x02246190+g*0x20+2*10)))	gui.text(159,70,string.format("24-27: %08x",mdword(0x02246190+g*0x20+2*18)))
	gui.text(1,80,string.format("06-07: %04x",mword(0x02246190+g*0x20+2*3)))	gui.text(80,80,string.format("16-17: %04x",mword(0x02246190+g*0x20+2*11)))	gui.text(159,80,string.format("28-2B: %08x",mdword(0x02246190+g*0x20+2*20)))
	gui.text(1,90,string.format("08-09: %04x",mword(0x02246190+g*0x20+2*4)))	gui.text(80,90,string.format("18-19: %04x",mword(0x02246190+g*0x20+2*12)))	gui.text(159,90,string.format("2C-2F: %08x",mdword(0x02246190+g*0x20+2*22)))
	gui.text(1,100,string.format("0A-0B: %04x",mword(0x02246190+g*0x20+2*5)))	gui.text(80,100,string.format("1A-1B: %04x",mword(0x02246190+g*0x20+2*13)))
	gui.text(1,110,string.format("0C-0D: %04x",mword(0x02246190+g*0x20+2*6)))	gui.text(80,110,string.format("1C-1D: %04x",mword(0x02246190+g*0x20+2*14)))
	gui.text(1,120,string.format("0E-0F: %04x",mword(0x02246190+g*0x20+2*7)))	gui.text(80,120,string.format("1E-1F: %04x",mword(0x02246190+g*0x20+2*15)))	
	
	gui.text(1,135,string.format("FlyTo: X %d, Y %d, Z %d",mdword(0x02246190+g*0x20+2*18),mdword(0x02246190+g*0x20+2*22),mdword(0x02246190+g*0x20+2*20)))
end
	gui.text(1,145, string.format("SubMap of Map: %d",mword(0x02246190+g*0x20+2*12)))
	gui.text(150,145, string.format("Script File: %d",mword(0x02246190+g*0x20+2*5)))
	if mword(0x02246190+g*0x20+2*10)%256<255 then
	gui.text(1,155,string.format("Slot Location: %d",mword(0x02246190+g*0x20+2*10)%256)) else gui.text(1,155,string.format("No Encounters")) end

	gui.text(40,165, string.format("Current Overworld Position"))
	gui.text(40,175, string.format("M: %d, X: %d, Y: %d, Z: %d", mword(pos_m+0x20*g), mword(pos_m+0x6+0x20*g), mword(pos_m+0xE+0x20*g), mword(pos_m+0xA+0x20*g)))
	
	emu.frameadvance() 
end