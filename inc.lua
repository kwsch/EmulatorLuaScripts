local d=0
local rshift, lshift=bit.rshift, bit.lshift
local md,mw,mb=memory.readdwordunsigned,memory.readwordunsigned,memory.readbyteunsigned
local wd,ww,wb=memory.writedword,memory.writeword,memory.writebyte
local gt,sf=gui.text,string.format
local table={}
local on,enbl=0,1
local z=md(0x0225855C)
local x=4

function main()
        table=joypad.get(1)
        if table.L then
                gt(0,0, "Toggling")
		enbl=0
        elseif table.R then z=0 enbl=2
	else
		if enbl==0 then on=(on+1)%2 z=md(0x0225855C)+d d=1 enbl=1 end
		if enbl==2 then on=(on+1)%2 x=x+1 enbl=1 end
        end

wb(0x0225855C,z)
wd(0x02258560,x)
gt(10,10,sf("Currently 0x%X",x%0x2C))
end
 
gui.register(main)