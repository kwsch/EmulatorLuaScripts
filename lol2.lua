local rng
local timer
local offset 
local pidoffset=0x0203BC78
local pid

while true do 	
	gui.text(1, 1, string.format("RNG: %d, Timer: %d", memory.readword(0x020249C0), memory.readword(0x030022E4))) 	

	rng = memory.readwordunsigned(0x020249C0)
	timer = memory.readwordunsigned(0x030022E4)
	offset = math.floor(rng - timer)
	pid = math.floor(memory.readdwordunsigned(pidoffset) + 0x988)
	gui.text(1, 10, string.format("offset: %d", offset))
	gui.text(1, 20, string.format("tRNG %08X", memory.readdwordunsigned(0x03005D84)))
	gui.text(1, 30, string.format("pRNG %08X", memory.readdwordunsigned(0x03005D80)))
	gui.text(1, 70, string.format("PIDstore %08X", memory.readdwordunsigned(pid)))
	gui.text(1, 60, string.format("PIDloc %08X", pid))
	
	emu.frameadvance() 
end
