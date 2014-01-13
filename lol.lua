local rng
local timer
local offset 
while true do 	
	gui.text(1, 1, string.format("RNG: %d, Timer: %d", memory.readword(0x020249C0), memory.readword(0x030022E4))) 	

	rng = memory.readwordunsigned(0x020249C0)
	timer = memory.readwordunsigned(0x030022E4)
	offset = math.floor(rng - timer)
	gui.text(1, 10, string.format("offset: %d", offset))
	emu.frameadvance() 
end