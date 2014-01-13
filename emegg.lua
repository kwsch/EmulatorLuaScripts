local rng
local timer
local offset 
local pidpointer=0x0203BC78
local pidoffset
local pid
local iter=0
local base=0
local a
local timerseed=0
local stepcounter
local nature
local ids
local tid
local sid
local lpid
local hpid
local naturename={
 "Hardy","Lonely","Brave","Adamant","Naughty",
 "Bold","Docile","Relaxed","Impish","Lax",
 "Timid","Hasty","Serious","Jolly","Naive",
 "Modest","Mild","Quiet","Bashful","Rash",
 "Calm","Gentle","Sassy","Careful","Quirky"}

while true do 	

	a=memory.readdwordunsigned(0x03005D84)
	rng = memory.readwordunsigned(0x020249C0)
	timer = memory.readwordunsigned(0x030022E4)
	offset = math.floor(rng - timer)
	pidoffset = math.floor(memory.readdwordunsigned(pidpointer) + 0x988)
	pid = memory.readdwordunsigned(pidoffset)
	nature = math.floor(pid % 0x19)
	stepcounter = memory.readbyteunsigned(math.floor(pidoffset - 0x4,2))
	ids = memory.readdwordunsigned(0x020244F0)
	sid = ids / 65536
	tid = ids % 0x10000
	hpid = pid / 65536
	lpid = pid % 0x10000
	shiny = bit.bxor(bit.bxor(tid,sid),bit.bxor(lpid,hpid))

	gui.text(199,140, string.format("TID: %d", tid))
	gui.text(199,150,string.format("SID: %d", sid))
	gui.text(1,1, string.format("RNG Information:"))
	gui.text(1, 10, string.format("RNG Frame   -  %d", memory.readword(0x020249C0))) 
	gui.text(1, 19, string.format("Timer Value -  %d", memory.readword(0x030022E4)))
	gui.text(1, 28, string.format("Difference  -  %d", offset))
	gui.text(1, 46, string.format("tRNG %08X", memory.readdwordunsigned(0x03005D84)))
	gui.text(1, 55, string.format("pRNG %08X", memory.readdwordunsigned(0x03005D80)))

	if a == 0 then 
		base = offset
		iter = 0 
	elseif a > 0 then 
		if base == base then
			iter = math.floor(offset - base - 5) 
		else 
			base = offset
		end
	end
	
	if a == 0 then
		if pid == 0 then
			gui.text(1, 73, string.format("No Egg."))
		else
			gui.text(1, 73, string.format("PID %08X", pid))
			gui.text(1, 82,"Nature: "..naturename[nature+1])
		end

	elseif a < 65536 or math.floor(memory.readdwordunsigned(0x03007D98)/65536) == math.floor(a/65536) then
		gui.text(1, 73, string.format("Egg Generating... please advance another frame!"))
		gui.text(1, 82, string.format("TempPID %08X", memory.readdwordunsigned(0x03007D98)))

	else
		gui.text(1, 73, string.format("PID %08X", pid))
--		gui.text(1, 91, string.format("loc %08X", pidoffset))

 		gui.text(1, 82,"Nature: "..naturename[nature+1])
		if shiny < 8 then
			gui.text(1, 64, string.format("SHINY!!!"))
		end 

		if iter > 1 then
			gui.text(1, 110, string.format("stone worked!"))
			gui.text(1, 100, string.format("approx iter: %d", iter))
		else
			gui.text(1, 110, string.format("stone failed?"))
			gui.text(1, 100, string.format("first egg PID result"))
		end
	end

		gui.text(1,130,string.format("Step Counter: %02X", stepcounter))
	if pid > 0 then
		gui.text(1,140,string.format("Egg Generated, go get it!"))
	elseif stepcounter == 254 then
		gui.text(1,140,string.format("Next Step might generate an egg!"))
	elseif stepcounter == 255 then
		gui.text(1,140,string.format("255th Step Taken."))
	else
		gui.text(1,140,string.format("Keep on steppin'"))
	end

	emu.frameadvance() 
end