local rshift, lshift=bit.rshift, bit.lshift
local md,mw,mb=memory.readdwordunsigned,memory.readwordunsigned,memory.readbyteunsigned
local gt,sf=gui.text,string.format
local pos_m=0x0227F3E8
function main()
        gt(1,165, sf("Current Position"))
        gt(2,175, sf("M: %3d, X: %3d", mw(pos_m), mw(pos_m+0x8)))
	gt(2,184, sf("Y: %3d, Z: %3d", mw(pos_m+0xC), mw(pos_m+0xA)))
end
 
gui.register(main)