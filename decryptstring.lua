local rshift,lshift,wd,ww,wb,rd,rw,rb,gt,sf,mf,ts,ti,tc=bit.rshift,bit.lshift,memory.writedword,memory.writeword,memory.writebyte,memory.readdwordunsigned,memory.readwordunsigned,memory.readbyteunsigned,gui.text,string.format,math.floor,table.sort,table.insert,table.concat
local on,enbl,display,sdec,rdec,shlog,pdata,speedlist,speed,Apkms,Bpkms=0,1,1,{},{},{},{},{},{},{},{}

local newcs={0,0,0,0,0,0}
local updatetimer=0.5
local i,j,x,t=1,1,1,{}

s="30 9E AB E4 47 D3 DE 9D EE 40 DB 1D C1 E1 AF EF A0 C5 35 A5 51 A5 34 52 78 73 F1 E8 B1 CD 68 DB F7 BD 88 BC A2 32 23 4F B0 1E 77 0C A7 23 78 C2 15 1D 42 0A 45 4F 5D 11 B0 5F BB 14 A1 75 91 0A 37 D2 83 E0 9B CB B9 75 CC 3B D1 A4 D2 CC CC 57 7B D5 71 50 4C E4 B0 19 9C B5 0F 0B F9 CD 26 75 EF 24 B5 86 C6 18 E1 4B 1B 34 92 E5 63 CE FE CC D0 17 FD 37 EE FA 91 8C 49 39 B8 D6 50 AC 99 71 83 F4 78 1D 30 B8 20 9E 59 68 A4 49 74 79 9E B5 1C E7 5D 81 F7 04 9C 25 5C DC BE 46 79 F5 9A 54 07 3C 64 DB C5 02 33 DB BD CE 30 58 54 D8 7D 2B 41 EF 4A 7D 14 DF B5 4A 43 8D 69 7E 8A ED 1B 81 DC 8A 52 4F 2C 15 1B 24 DB C3 9E 34 6B FC AD DE 7E 55 BF 9C 4B 81 FD 1B 13 09 44 85 D7 87 4D 78 E0 D0 5B F0 D5 42 1A 5C B8 D4 97 2E 7B 50 7D 25 4F 88 F3 00 E0 6E D4 83 10 A8 16 D7 F6 B6 A0 E9 2E 2F D9 AD B8 92 B1 38 F9 9A 05 52 9F E2 80 0C 72 0F 60 0B 59 06 DB 46 20 31 EA F3 BC BC C6 C2 25 C8 25 7F FB 0E AB 51 8B 80 11 F7 99 BB 85 66 F2 5B BF ED 39 D1 F3 13 13 A8 08 F0 3E 7A B0 3F 5F 8F D4 F4 FB 14 EA 30 DB 95 23 52 77 28 9F DC DF 97 09 3A 49 D5 3E 94 EC 1D F9 03 D0 BF 8E FA BC 19 45 C6 67 A5 CF 62 96 60 CC 03 D6 10 1E FE E3 76 76 72 0A E2 1D 7B 01 81 85 1C 08 9D D2 FB 57 6D 0D 64 1A B4 CF 85 20 AB 3A A9 5C 41 82 50 AC 05 80 99 43 E3 30 96 DD 6C B7 6A BB B0 2D CA 8E D1 C7 86 49 78 AD 5A 42 57 5A 6B 80 BE CF 5F 39 7A E0 C1 B8 2F 58 DD 4D FA D7 F3 FD 78 8F 7A FF 9E 4C BF 4A BC 68 D4 CC 28 A0 8F F7 13 E4 CD C5 03 8F 9E 6E D9 B6 82 C4 08 7C 7F"
local magic=0x86E2

--Remove spaces from string
s = string.gsub (s, " ", "")

--Break up string into a table
while i<=string.len(s) do
	t[j] ="0x"..string.sub(s,i,i+1)
	j=j+1
	i=i+2
end

function rand(seed) 		-- LCRNG 32bit for Decryption
	return (0x4e6d*(seed%65536)+((0x41c6*(seed%65536)+0x4e6d*mf(seed/65536))%65536)*65536+0x6073)%4294967296 
end

function decrypt(input)
--print(input)
	for i=1,tablelength(input),2 do	-- Use the PRNG to decrypt the main body of data, seeded via the magic checksum
		next=rand(magic)
		if i<4 then print(next) print(input[i]+input[i+1]*0x100) end
		decval=bit.bxor(rshift(next,16),input[i]+input[i+1]*0x100)
		if i<4 then print(decval) end
		sdec[i]=decval%0x100
		sdec[i+1]=rshift(decval,8)
		magic=next
	end

	return sdec
end
function string.fromhex(str)-- Conversion of Data for Snag Machine
    return (str:gsub('..', function (cc)
        return string.char(tonumber(cc,16))
    end))
end
function string.tohex(str)	-- Conversion of Data for Snag Machine
    return (str:gsub('.', function (c)
        return string.format('%02X',string.byte(c))
    end))
end
function currDir()			-- Cache the current directory so that the user knows where Snags will be stored.
  os.execute("cd > cd.tmp")			-- Open up a temporary file
  local f = io.open("cd.tmp", r)	-- Internalize the temp file
  local cwd = f:read("*a")			-- Get Directory
  f:close()							-- Close temp file
  os.remove("cd.tmp")				-- Remove temp file
  return cwd
end
function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end


print("~~STORING SNAGS IN: "..currDir())

function main()				-- Do work, son.
	table=joypad.get(1)						-- Detect Keypresses.
	
	if (table.L and table.R) then			-- Set up and cache data.
          gt(0,0,"Manual Update of PKMs")
                enbl=0
		else
		
		if enbl==0 then 
		on=(on+1)%2 enbl=1  -- Enable and do the Data Parsing, clear any pre-existing snag data


		data=decrypt(t)
			datfield=string.format("")		-- Initialize a string for the PKM data stream.
				for j=1,tablelength(data) do 						-- Convert byte table into a long string of hex for later writing.
					datfield=datfield..string.format("%02X",data[j])
				end
				print(datfield)


		snagemrdy=0
		if (snagemrdy==0) then 	-- SNAG EM ALL!
				
				local f,err = io.open(sf("decryptdump.bin"),"wb+")
				if not f then return print(err) end
				x=(datfield):fromhex()
				f:write(x)
				f:close()

			snagemrdy=1 				-- PKMs ripped. Don't let ripping happen until LR is pressed again.
		end
	end
end
end
gui.register(main)			-- End Script.