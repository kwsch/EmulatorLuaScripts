local rshift,lshift,wd,ww,wb,rd,rw,rb,gt,sf,mf,ts,ti,tc=bit.rshift,bit.lshift,memory.writedword,memory.writeword,memory.writebyte,memory.readdwordunsigned,memory.readwordunsigned,memory.readbyteunsigned,gui.text,string.format,math.floor,table.sort,table.insert,table.concat


local highseed=0x123
local lowseed =0x20000020


function rand16(seed)
return (CoL*(seed%65536)+((CoU*(seed%65536)+CoL*mf(seed/65536))%65536)*65536+0x6073)%2^32
end

function rand32(seed)
	return 0x41c64e6d*seed+0x6073
end


function nexthigh(highseed,lowseed)
	c=rshift(0x8965*rshift(lowseed,16)+0x6C07*lowseed%2^16,16)
	print(sf("C=%08X",c))
	d=0x6C07*mf(rshift(lowseed,16))+c
	print(sf("D=%08X",d))

--c returns the additive from the lowest portion

	part1=bs(highseed)
	print(sf("Part 1: %08X",part1))
	part2=ad(lowseed)
	print(sf("Part 2: %08X",part2))
	--print(sf("RETURNADD: %08X",part1+part2))
	return (part1+part2+d)



end

function bs(highseed)
	local CoLU64 = 0x6C07
	local CoLL64 = 0x8965
	fuckyou = (CoLL64*(highseed%2^16)+((CoLU64*(highseed%2^16)+CoLL64*mf(rshift(highseed,16)))%2^16)*2^16)%2^32
	return fuckyou
end

function ad(lowseed)
	local CoUU64 = 0x5D58
	local CoUL64 = 0x8B65
	fuckyou2  = (CoUL64*(lowseed%65536)+((CoUU64*(lowseed%2^16)+CoUL64*mf(rshift(lowseed,16)))%2^16)*2^16)%2^32
	return fuckyou2
end


local on=0

function main()	
	if on==0 then 
		print("test")
		print(sf("Rand64: %16X",nexthigh(highseed,lowseed)))
 		on=1 
		--shit=0xFFFFFFF0*0xFFFFFFFF
		--print(sf("%08X",shit))
		--if shit%2^32 ==shit  then print("add none") else print("add one") print(sf("%08X",shit/0xFFFFFFFF)) end
	end
end
gui.register(main)