local pid=0x436115F0
local mf=math.floor
local high=math.floor(pid/65536)
local low=pid%65536


--LCRNG
--(seed * 0x41c64e6d + 0x00006073) & 0xffffffff +
--(seed * 0xeeb9eb65 + 0x0a3561a1) & 0xffffffff -
--XDRNG
--(seed * 0x000343FD + 0x00269EC3) & 0xffffffff +
--(seed * 0xB9B33155 + 0xA170F641) & 0xffffffff -
--ERNG
--(seed * 0x41c64e6d + 0x00003079) & 0xffffffff +
--(seed * 0xEEB9EB65 + 0xFC77A683) & 0xffffffff -
--ARNG
--(seed * 0x6C078965 + 0x00000001) & 0xffffffff +
--(seed * 0x9638806D + 0x69C77F93) & 0xffffffff -
--GRNG
--(seed * 0x00000045 + 0x00001111) & 0xffffffff +
--(seed * 0x233F128D + 0x789467A3) & 0xffffffff -

	r_a={0x000041C6,0x0000EEB9,0x00000003,0x0000B9B3,0x000041C6,0x0000EEB9,0x00006C07,0x00009638,0x00000000,0x0000233F}
	r_b={0x00004e6d,0x0000eb65,0x000043FD,0x00003155,0x00004e6D,0x0000EB65,0x00008965,0x0000806D,0x00000045,0x0000128D}
	r_c={0x00006073,0x0a3561a1,0x00269EC3,0xA170F641,0x00003079,0xFC77A683,0x00000001,0x69C77F93,0x00001111,0x789467A3}
	r_d={1,1,1,1,1,1,1,1,2,2}
	rng={"LCRNG","LCRNG [R]","XDRNG","XDRNG [R]","ERNG","ERNG [R]","ARNG","ARNG [R]","GRNG","GRNG [R]"} 

go=0
print("PID: "..string.format("%8X", pid))

function rand(seed,m)
	return (r_b[m]*(seed%65536)+((r_a[m]*(seed%65536)+r_b[m]*mf(seed/65536))%65536)*65536+r_c[m])%(4294967296/r_d[m])
end

function main()
if go==0 then
	for m=1,10 do
	print(string.format("Checking Method: %s",rng[m]))
	for i=0,65535 do
		tempseed=high*0x10000+i
		nextseed=rand(tempseed,m)
		if math.floor(nextseed/65536)==low then
			print(string.format("Origin Seed %08X for PID: %08X",tempseed,pid))
			print("Projecting Forward IVs: Shift")
				iv={} ivseed=nextseed+0
				for cki=1,10 do
					ivseed=rand(ivseed,m-(m+1)%2)
					iv[cki]=mf(ivseed/134217728)
				end
				print(iv)	
			print("Projecting Backwards IVs: Shift")
				iv={} ivseed=nextseed+0
				for cki=1,10 do
					ivseed=rand(ivseed,m+(m)%2)
					iv[cki]=mf(ivseed/134217728)
				end
				print(iv)	
				
			print("Projecting Forward IVs: Modulo")
				iv={} ivseed=nextseed+0
				for cki=1,10 do
					ivseed=rand(ivseed,m-(m+1)%2)
					iv[cki]=mf(ivseed/65536)%32
				end
				print(iv)	
			print("Projecting Backwards IVs: Modulo")
				iv={} ivseed=nextseed+0
				for cki=1,10 do
					ivseed=rand(ivseed,m+(m)%2)
					iv[cki]=mf(ivseed/65536)%32
				end
				print(iv)

			print("Projecting Forward IVs: Triblock")
				iv={} ivseed=nextseed+0
				for cki=1,10 do
					ivseed=rand(ivseed,m-(m+1)%2)
					bks=mf(ivseed/65536)
					iv[cki]={mf(bks/1024)%32,mf(bks/32)%32,bks%32}
				end
				print(iv)	
			print("Projecting Backwards IVs: Triblock")
				iv={} ivseed=nextseed+0
				for cki=1,10 do
					ivseed=rand(ivseed,m+(m)%2)
					bks=mf(ivseed/65536)
					iv[cki]={mf(bks/1024)%32,mf(bks/32)%32,bks%32}
				end
				print(iv)	
				
		end
	end
	print()
	end
go=1
print("Finished With Stage 1/2!")

print() print("Starting Stage 2")
for m=1,9,2 do
nextseed=pid+0
print(string.format("PID Seeded %s",rng[m]))
print(string.format("Origin Seed %08X for PID: %08X",tempseed,pid))
			print("Projecting Forward IVs: Shift")
				iv={} ivseed=nextseed+0
				for cki=1,10 do
					ivseed=rand(ivseed,m-(m+1)%2)
					iv[cki]=mf(ivseed/134217728)
				end
				print(iv)	
			print("Projecting Backwards IVs: Shift")
				iv={} ivseed=nextseed+0
				for cki=1,10 do
					ivseed=rand(ivseed,m+(m)%2)
					iv[cki]=mf(ivseed/134217728)
				end
				print(iv)	
				
			print("Projecting Forward IVs: Modulo")
				iv={} ivseed=nextseed+0
				for cki=1,10 do
					ivseed=rand(ivseed,m-(m+1)%2)
					iv[cki]=mf(ivseed/65536)%32
				end
				print(iv)	
			print("Projecting Backwards IVs: Modulo")
				iv={} ivseed=nextseed+0
				for cki=1,10 do
					ivseed=rand(ivseed,m+(m)%2)
					iv[cki]=mf(ivseed/65536)%32
				end
				print(iv)

			print("Projecting Forward IVs: Triblock")
				iv={} ivseed=nextseed+0
				for cki=1,10 do
					ivseed=rand(ivseed,m-(m+1)%2)
					bks=mf(ivseed/65536)
					iv[cki]={mf(bks/1024)%32,mf(bks/32)%32,bks%32}
				end
				print(iv)	
			print("Projecting Backwards IVs: Triblock")
				iv={} ivseed=nextseed+0
				for cki=1,10 do
					ivseed=rand(ivseed,m+(m)%2)
					bks=mf(ivseed/65536)
					iv[cki]={mf(bks/1024)%32,mf(bks/32)%32,bks%32}
				end
				print(iv)
print()


end

end
end
gui.register(main)