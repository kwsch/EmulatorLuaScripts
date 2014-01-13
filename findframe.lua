local seed=0xD7470942
local mf=math.floor

go=0
print("Origin: "..string.format("%8X", seed))

function rand(seed)
	return (0xeb65*(seed%65536)+((0xEEB9*(seed%65536)+0xeb65*mf(seed/65536))%65536)*65536+0x0a3561a1)%(4294967296)
end

function main()
tempseed=seed+0
if go==0 then
	iter=0
	while tempseed~=0 do
		tempseed=rand(tempseed)
		iter=iter+1
	end
	go=1
	print("Emerald Frame: "..iter)
		
end
end
gui.register(main)