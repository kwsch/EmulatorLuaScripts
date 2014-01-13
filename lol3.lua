local rng
local timer
local offset 
local pidoffset=0x0203BC78
local pid
local iter
local base=0
local a

while true do 	
	gui.text(1, 1, string.format("RNG: %d, Timer: %d", memory.readword(0x020249C0), memory.readword(0x030022E4))) 	
	
	a=memory.readdwordunsigned(0x03005D84)

	rng = memory.readwordunsigned(0x020249C0)
	timer = memory.readwordunsigned(0x030022E4)
	offset = math.floor(rng - timer)
	pid = math.floor(memory.readdwordunsigned(pidoffset) + 0x988)
	gui.text(1, 10, string.format("offset: %d", offset))
	gui.text(1, 20, string.format("tRNG %08X", memory.readdwordunsigned(0x03005D84)))
	gui.text(1, 30, string.format("pRNG %08X", memory.readdwordunsigned(0x03005D80)))


	if a < 65536 and a > 0 then
		timerseed = a
	end


		if a == 0 then 
			base = offset
			iter = 0 
		elseif a > 0 then 
			iter = math.floor(offset - base - 5) 
		end


	if a == 0 then
		gui.text(1, 80, string.format("No Egg"))
	else

		gui.text(1, 50, string.format("PID %08X", memory.readdwordunsigned(pid)))
		gui.text(1, 60, string.format("loc %08X", pid))
		gui.text(1, 70, string.format("loc %08X", timerseed))
		if iter > 0 then
		gui.text(1, 80, string.format("iter: %d", iter))
		else
		gui.text(1, 80, string.format("everstone failed, first egg PID result"))
		end
	end

	gui.text(1, 90, string.format("a: %08X", a))

	
	emu.frameadvance() 
end
