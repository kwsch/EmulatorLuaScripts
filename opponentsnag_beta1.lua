local rshift,lshift,wd,ww,wb,rd,rw,rb,gt,sf,mf,ts,ti,tc=bit.rshift,bit.lshift,memory.writedword,memory.writeword,memory.writebyte,memory.readdwordunsigned,memory.readwordunsigned,memory.readbyteunsigned,gui.text,string.format,math.floor,table.sort,table.insert,table.concat
local on,enbl,display,sdec,rdec,shlog,pdata,speedlist,speed,Apkms,Bpkms=0,1,1,{},{},{},{},{},{},{},{}

local newcs={0,0,0,0,0,0}
local updatetimer=0.5

function mb(x) 				-- Read u8  properly (for prose)
	return rb(x)
end
function mw(x) 				-- Read u16 properly
	return rb(x)+rb(x+1)*0x100
end
function md(x) 				-- Read u32 properly
	return rb(x)+rb(x+1)*0x100+rb(x+2)*0x10000+rb(x+3)*0x1000000
end
function rand(seed) 		-- LCRNG 32bit for Decryption
	return (0x4e6d*(seed%65536)+((0x41c6*(seed%65536)+0x4e6d*mf(seed/65536))%65536)*65536+0x6073)%4294967296 
end
function getpkm(pkm) -- Get data for a player's PKM as a table of bytes from [0,219]

	start=Apkms[pkm]
	pid=md(start) checksum=mw(start+6)	-- Initialize basic numbers.
	magic=checksum	pmagic=pid			-- Initialize PRNG starting seeds.

	shufflenum=bit.band(rshift(pid,0xD),0x1F)%24	-- Get shuffle logic to unshuffle the PKM.
	aloc={0,0,0,0,0,0,1,1,2,3,2,3,1,1,2,3,2,3,1,1,2,3,2,3} shlog[0]=aloc[shufflenum+1]
	bloc={1,1,2,3,2,3,0,0,0,0,0,0,2,3,1,1,3,2,2,3,1,1,3,2} shlog[1]=bloc[shufflenum+1]
	cloc={2,3,1,1,3,2,2,3,1,1,3,2,0,0,0,0,0,0,3,2,3,2,1,1} shlog[2]=cloc[shufflenum+1]
	dloc={3,2,3,2,1,1,3,2,3,2,1,1,3,2,3,2,1,1,0,0,0,0,0,0} shlog[3]=dloc[shufflenum+1]

	-- Fill a table with a decrypted shuffled PKM.
	for i=0,7 do		-- Read out the Unencrypted PID & Checksum and put in table.
		sdec[i]=mb(start+i)
	end
	for i=8,135,2 do	-- Use the PRNG to decrypt the main body of data, seeded via the magic checksum
		next=rand(magic)
		decval=bit.bxor(rshift(next,16),mw(start+i))
		sdec[i]=decval%0x100
		sdec[i+1]=rshift(decval,8)
		magic=next
	end
	for i=136,219,2 do	-- Use another PRNG to decrypt the party stats, seeded via the magic PID**
		next=rand(pmagic)
		decval=bit.bxor(rshift(next,16),mw(start+i))
		sdec[i]=decval%0x100
		sdec[i+1]=rshift(decval,8)
		pmagic=next
	end

    -- Unshuffle Data to Final Form.
	for i=0,7 do 		-- PID area isnt shuffled, so straight copy it.
		rdec[i]=sdec[i]
	end
	for b=0,3 do		-- Block Unshuffling, copy smartly per block and its position.
	  for i=0,31 do		-- Place all contents of the block in its proper position in the decrypted PKM.
		rdec[i+8+0x20*b]=sdec[i+0x20*shlog[b]+8]
	  end
	end	
	for i=136,219 do	-- Party Stats aren't shuffled, so straight copy.
		rdec[i]=sdec[i]
	end

	return rdec			-- Return rectified (unshuffled) decrypted PKM as a table of bytes.
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


-- Initialize Game Data
if md(0x023FFE0C)==0x4A455249 then			-- Get Version / Language
					game="Black2 JP"
					gameconst=0x540D0
			   elseif md(0x023FFE0C)==0x4F455249 then
					game="Black2 U"
					gameconst=0x540D0
			   elseif md(0x023FFE0C)==0x4F445249 then
					game="White2 U"
					gameconst=0x540D0
			   else game="White2 JP"
					gameconst=0x540D0
			end
print("~~STORING SNAGS IN: "..currDir())

function main()				-- Do work, son.
	table=joypad.get(1)						-- Detect Keypresses.
	
	if (table.L and table.R) then			-- Set up and cache data.
          gt(0,0,"Manual Update of PKMs")
                enbl=0
		elseif md(0x02FFFC3C)%(60*updatetimer)==0 then
			for i=1,6 do
				newcs[i]=mw(md(0x02000024)+gameconst+0xDC*(i-1)+6)
				
				if newcs[i]~=mw(0x02000100+2*(i-1)+2*6) then
					csupdate=0
				end
			end
				if  csupdate==0 then
					enbl=0
					csupdate=1
					print("Changed!")
					for i=1,6 do
						ww(0x02000100+2*(i-1)+2*6,newcs[i])
					end
				end
		else
		
		if enbl==0 then 
		on=(on+1)%2 enbl=1  -- Enable and do the Data Parsing, clear any pre-existing snag data

		for i=1,6 do								-- Set up the offsets table for PKM reading.
				Apkms[i]=md(0x02000024)+gameconst+0xDC*(i-1)
		end
				datfield={}							-- 136~PKM data storage (string of hex)
				snag=0								-- Snaggable 'Monz Count
				snagemrdy=0

		for i=1,6 do
			Apkm=getpkm(i)
			datfield[i]=string.format("")		-- Initialize a string for the PKM data stream.
				for j=0,219 do 						-- Convert byte table into a long string of hex for later writing.
					datfield[i]=datfield[i]..string.format("%02X",Apkm[j])
				end
			end
		end
		
		if (snagemrdy==0) then 	-- SNAG EM ALL!
			for i=1,6 do 					--Snag PKMs
				local f,err = io.open(sf("opp%d.pkm",i),"wb+")
				if not f then return print(err) end
				x=(datfield[i]):fromhex()
				f:write(x)
				f:close()
			end
			snagemrdy=1 				-- PKMs ripped. Don't let ripping happen until LR is pressed again.
		end
	end
end
gui.register(main)			-- End Script.