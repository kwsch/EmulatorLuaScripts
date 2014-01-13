local rshift, lshift=bit.rshift, bit.lshift
local wd,ww,wb=memory.writedword,memory.writeword,memory.writebyte
local md,mw,mb=memory.readdwordunsigned,memory.readwordunsigned,memory.readbyteunsigned
local gt,sf=gui.text,string.format
-- paste in script here
local table={}
local start=md(md(0x02000024)+0x459A4)+md(0x02000024)+0x0459A8
local a=0x0
local b=0x0
local enblb=1

local on,enbl=0,1

function main()
        table=joypad.get(1)
        if table.A then
                gt(0,0, "Incrementing A")
                enbl=0
	
        else
                if enbl==0 then on=(on+1)%2 enbl=1 a=a+1 end
        end
        if table.B then
                gt(0,0, "Incrementing B")
                enblb=0
	
        else
                if enblb==0 then on=(on+1)%2 enblb=1 b=b+1 end
        end
            
wb(start+0, 0x2E)
wb(start+1, 0x00)
wb(start+2, 0x23)
wb(start+3, 0x00)
wb(start+4, 0x70)
wb(start+5, 0x0A)
wb(start+6, 0x2F)
wb(start+7, 0x00)
wb(start+8, 0x02)
wb(start+9, 0x00)
wb(start+10,0x00)
wb(start+11,0x00)
wb(start+12,0x00)
wb(start+13,0x00)
wb(start+14,0x00)
wb(start+15,0x00)
wb(start+16,0x00)
wb(start+17,0x00)
wb(0x224A7E4,0x8B+b)
gt(1,10,sf("00%02X",b))
end
gui.register(main)