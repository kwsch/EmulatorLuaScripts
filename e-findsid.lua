local pid=0x436115F0
local mf=math.floor
local high=math.floor(pid/65536)
local low=pid%65536

local gt,mf,sf,md,mw,mb=gui.text,math.floor,string.format,memory.readdwordunsigned,memory.readwordunsigned,memory.readbyteunsigned
local tidoff=0x02020000
local rngoff=0x03005D80

print("PID: "..string.format("%8X", pid))

function rand(seed)
	return (0x4e6d*(seed%65536)+((0x41c6*(seed%65536)+0x4e6d*mf(seed/65536))%65536)*65536+0x6073)%4294967296 
end

function main()

if md(tidoff)~=0 then
	tid=mw(tidoff)
	gsid=mf(bit.bxor(bit.bxor(high, tid),low)/8)
	fsid=1
	iter=0
	temp=md(rngoff)
	while fsid==1 do
		temp=rand(temp)
		iter=iter+1
		if gsid==mf(temp/(65536*8)) then
			fsid=0
			sid=mf(temp/65536)
			cur=md(rngoff)
			sidf=temp+0
		end
	end
	gt(0,00,sf("Trainer ID Obtained: %d", tid))
	gt(0,10,sf("Target SID to get: %d",sid))
	gt(0,20,sf("Current Seed: %08X", cur))
	gt(0,30,sf("Frames until Shiny SID: %d", iter))
	gt(0,40,sf("SID Seed needing to hit: %08X", sidf))

else gt(0,00,sf("Please confirm your player name."))
end


end --end function

gui.register(main)