-- Generator Script by Kaphotics
-- Run in Lua, don't have to have a ROM running.

-- // Setup // --
local rs,ls=bit.rshift, bit.lshift
local sf=string.format
local i,j,x,pkm=1,1,1,{}
local go=1

-- Load your base PKM from a hex editor and replace below.
pk="EC 65 84 9B 00 00 88 D7 47 01 00 00 C5 78 A8 86 00 00 00 00 78 14 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 AB 01 C4 00 60 01 E2 00 14 0F 14 28 00 00 00 00 FF FF FF 3F 00 00 00 00 00 13 00 00 00 00 00 00 53 00 70 00 69 00 6E 00 64 00 61 00 FF FF 00 00 00 00 00 00 FF FF 00 14 00 00 00 00 00 00 00 00 41 00 72 00 65 00 73 00 FF FF 00 00 00 00 00 00 0B 0A 16 0B 0A 16 62 EA 10 00 00 04 01 00 00 00"
-- Currently a Spinda OT Ares (dewey911)
-- // Conversion of Input to a table // --
--Remove spaces from pkstring so that we can add the script in
  s = string.gsub (pk, " ", "")
--Break up eventscript string into a table
while i<=string.len(s) do
	pkm[j] ="0x"..string.sub(s,i,i+1)
	j=j+1
	i=i+2
end
-- variable 'pkm' now stores a table of the PKM.

-- Conversion of Data to write tablehex to actual Hex
function string.fromhex(str)
    return (str:gsub('..', function (cc)
        return string.char(tonumber(cc,16))
    end))
end

function writepkm(pkm,name)				
	local f,err = io.open(sf(name..".pkm"),"wb+")
	if not f then return print(err) end
	x=(pkm):fromhex()
	f:write(x)
	f:close()
end

-- // Notify Storage Location // --
function currDir()			-- Cache the current directory so that the user knows where Snags will be stored.
	os.execute("cd > cd.tmp")	-- Open up a temporary file
	local f = io.open("cd.tmp", r)	-- Internalize the temp file
	local cwd = f:read("*a")	-- Get Directory
	f:close()			-- Close temp file
	os.remove("cd.tmp")		-- Remove temp file
	return cwd
end
print("~~STORING GENS IN: "..currDir())

-- // Start Script // --
print("~~Press L&R to start Generation")
timestamp=sf(os.date("%M%S"))
function main()
if go==1 then
	resultstring="TID,PID,Met,Egg\n"
	print("Go!")
for i=1,30 do

-- Replace Origin Game
	pkm[0x5F+1]=24

--Replace PID
	PID=0xFFFFFFFF-(i-1) -- Small offset
	pkm[0x00+1]=rs(ls(PID,24),24)
	pkm[0x01+1]=rs(ls(PID,16),24)
	pkm[0x02+1]=rs(ls(PID,8),24)
	pkm[0x03+1]=rs(PID,24)
	
--Replace Met Location
	metlocation=00000+i -- x0000
	pkm[0x80+1]=metlocation%256
	pkm[0x81+1]=rs(metlocation,8)

-- Replace Egg Location (comment out if undesired)
	egglocation=40000+i
	pkm[0x7E+1]=egglocation%256
	pkm[0x7F+1]=rs(egglocation,8)
	
-- Replace TID for Cataloguing
	tid=timestamp+i
	pkm[0x0C+1]=tid%256
	pkm[0x0D+1]=rs(tid,8)
	
-- Calculate new Checksum
	checksum=0
	for c=0,63 do
		checksum=checksum+pkm[8+1+2*c]+pkm[9+1+2*c]*0x100
	end
	checksum=checksum%65536
	pkm[0x06+1]=checksum%256
	pkm[0x07+1]=rs(checksum,8)
	
-- PKM Is correct now. Write PKM.
	name=sf("Gen_Spinda "..tid)
	pkstring=string.format("")
	for j=1,136 do 	-- Convert byte table into a long string of hex for later writing.
		pkstring=pkstring..string.format("%02X",pkm[j])
	end
	writepkm(pkstring,name)

	resultstring=sf(resultstring..tid..",=dec2hex("..PID.."),"..metlocation..","..egglocation.."\n")
end 			-- End Loop

-- Write CSV log
	io.output(io.open("Generation Log "..os.date("%a@%I;%M %p")..".csv","w"))	
	io.write(resultstring)
	io.close()
go=0 			-- Don't go again.
print("Finished!")	-- Notify Finished.
end 			-- End Go If
end 			-- End Function
gui.register(main)