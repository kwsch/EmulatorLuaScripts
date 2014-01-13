--memory operations
mdword=memory.readdwordunsigned
mword=memory.readwordunsigned
mbyte=memory.readbyteunsigned
wdword=memory.writedword
local bnd,br,bxr=bit.band,bit.bor,bit.bxor
local rshift, lshift=bit.rshift, bit.lshift
--seed
useed=0
lseed=0
--frame counters, PID will start at 1, IV will be advanced correctly
pidrngframe=1
ivrngframe=0
--display toggle variables
local table={}
local on=0
local edbA=1
 
--debugging flags
debugSeed    = 1
debugAdvance = 1

--Game Detection
if mdword(0x02FFFE0C)==0x4A455249 then
	game='Black'
	g=1
   else
	game='White'
	g=0
end
 
--functions
function increasePIDCount()
        pidrngframe = pidrngframe + 1
        if debugAdvance then print(string.format("Increasing pidrngframe to: %d", pidrngframe)) end
end
 
function increaseIVCount()
        ivrngframe = ivrngframe + 1
        if debugAdvance then print(string.format("Increasing ivrngframe to: %d", ivrngframe)) end
end
 
function drawInfo()
        gui.text(0,0,string.format("Initial Seed: %08x%08x",useed,lseed))
        gui.text(0,10,string.format("PIDRNG frame: %d", pidrngframe))
        gui.text(0,20,string.format("IVRNG  frame: %d", ivrngframe))
	timehex=mdword(0x02FFFDEC)
	datehex=mdword(0x02FFFDE8)
	hour=string.format("%02X",(timehex%0x100)%0x40)		
	minute=string.format("%02X",(rshift(timehex%0x10000,8)))
	second=string.format("%02X",(mbyte(0x02FFFDEE)))
	year=string.format("%02X",(mbyte(0x02FFFDE8)))
	month=string.format("%02X",(mbyte(0x02FFFDE9)))
	day=string.format("%02X",(mbyte(0x02FFFDEA)))
	gui.text(200,1,string.format("%d/%d/%d",month,day,2000+year))				-- Display Date
	gui.text(200,10,string.format("%02d:%02d:%02d",hour,minute,second,delay))		-- Display Time
	gui.text(40,175, string.format("M: %d, X: %d, Y: %d, Z: %d", mword(0x0223AE04-0x20*g), mword(0x0223AE04+0x6-0x20*g), mword(0x0223AE04+0xE-0x20*g), mword(0x0223AE04+0xA-0x20*g)))
end
 
--main loading
emu.reset()
 
--get the seed
while mdword(0x021FF5DC-0x20*g) == 0x0 and mdword(0x021FF5D8-0x20*g) == 0 do
	pidrngframe=1
	ivrngframe=0
        emu.frameadvance()
end

--store the seed
useed = mdword(0x021FF5DC-0x20*g)
lseed = mdword(0x021FF5D8-0x20*g)
if debugSeed then print(string.format("Initial Seed: %08x%08x",useed,lseed)) end
 
--setup memory watches
memory.registerwrite(0x021FF5D8-0x20*g, increasePIDCount)
memory.registerwrite(0x021FF0A8-0x20*g, increaseIVCount)
 
--start the main loop
gui.register(drawInfo)