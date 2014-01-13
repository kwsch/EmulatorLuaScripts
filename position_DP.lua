
while true do
	gui.text(0,0, string.format("X: %d, Y: %d", memory.readword(0x02291D68,2), memory.readword(0x0226E728,2)))
	emu.frameadvance()
end