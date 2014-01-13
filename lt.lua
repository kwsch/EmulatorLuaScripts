local mf=math.floor
local rshift, lshift=bit.rshift, bit.lshift
local naturetable={"Hardy","Lonely","Brave","Adamant","Naughty","Bold","Docile","Relaxed","Impish","Lax","Timid","Hasty","Serious","Jolly","Naive","Modest","Mild","Quiet","Bashful","Rash","Calm","Gentle","Sassy","Careful","Quirky"}
local typeorder={"Fighting","Flying","Poison","Ground","Rock","Bug","Ghost","Steel","Fire","Water","Grass","Electric","Psychic","Ice","Dragon","Dark"}

min_HP=30
min_Atk=26
min_Def=31
min_SpA=26
min_SpD=31
min_Spe=0

max_HP=30
max_Atk=26
max_Def=31
max_SpA=26
max_SpD=31
max_Spe=31

searchall=0 -- Search every nature (0 - True | 1 - Search Target Nature Only)
targetnature=3

	  --  // 0 Hardy   1 Lonely   2 Brave    3 Adamant  4 Naughty 
	  --  // 5 Bold    6 Docile   7 Relaxed  8 Impish   9 Lax 
	  --  // 10 Timid  11 Hasty  12 Serious 13 Jolly   14 Naive 
	  --  // 15 Modest 16 Mild   17 Quiet   18 Bashful 19 Rash 
	  --  // 20 Calm   21 Gentle 22 Sassy   23 Careful 24 Quirky 

--List Locks in Reverse order ~ closest to nonshadow first
NatureLocks={24,0,18}
GenderCheck={1,0,1} -- 0 for female, 1 for male, 2 for none
GenderVal={128,128,128} -- Threshold (if F must <; if M must >=)


-- Previous shadow mons before target
previousshadows=0

--Count up the amount of locks that are present
nltotal,go=table.getn(NatureLocks),0

function spitmaincsv(originseed,testPID,testnature,shinyPID,testHP,testAtk,testDef,testSpA,testSpD,testSpe,preshadow)
	io.write("=dec2hex("..nextseed(originseed,2).."),")
	io.write("=dec2hex("..testPID.."),")
	io.write(naturetable[testnature+1]..",")
	io.write("=dec2hex("..shinyPID.."),")
	io.write(naturetable[shinyPID%25+1]..",")
	io.write(testHP..",")
	io.write(testAtk..",")
	io.write(testDef..",")
	io.write(testSpA..",")
	io.write(testSpD..",")
	io.write(testSpe..",")
	io.write(gethiddenpower(testHP,testAtk,testDef,testSpe,testSpA,testSpD)..",")
	io.write(string.format("%8X", preshadow)..",")
	io.write(naturetable[preshadow%25+1].."\n")
end

function genPID(seed)
	return rshift(prevseed(seed,1),16)*0x10000+rshift(seed,16)
end

function displayprogress(testHP,testAtk,testDef,testSpA,testSpD,testSpe)
	gui.text(0,0,string.format(" HP: %d",testHP))
	gui.text(0,10,string.format("Atk: %d",testAtk))
	gui.text(0,20,string.format("Def: %d",testDef))
	gui.text(0,30,string.format("SpA: %d",testSpA))
	gui.text(0,40,string.format("SpD: %d",testSpD))
	gui.text(0,50,string.format("Spe: %d",testSpe))
end
function gethiddenpower(testHP,testAtk,testDef,testSpe,testSpA,testSpD)
			hidpowtype=typeorder[1+math.floor(((testHP%2 + 2*(testAtk%2) + 4*(testDef%2) + 8*(testSpe%2) + 16*(testSpA%2) + 32*(testSpD%2))*15)/63)]
			hidpowbase=math.floor(((bit.band(testHP,2)/2 + bit.band(testAtk,2) + 2*bit.band(testDef,2) + 4*bit.band(testSpe,2) + 8*bit.band(testSpA,2) + 16*bit.band(testSpD,2))*40)/63 + 30)
			move=hidpowtype..","..hidpowbase
			return move
end
function nextseed(seed,i)
	for iter=1,i do
	seed=(0x000043FD*(seed%65536)+((0x00000003*(seed%65536)+0x000043FD*mf(seed/65536))%65536)*65536+0x00269EC3)%(4294967296)
	end
	return seed
end
function prevseed(seed,i)
	for iter=1,i do
	seed=(0x00003155*(seed%65536)+((0x0000B9B3*(seed%65536)+0x00003155*mf(seed/65536))%65536)*65536+0xA170F641)%(4294967296)
	end
	return seed
end
function currDir()
  os.execute("cd > cd.tmp")			-- Open up a temporary file
  local f = io.open("cd.tmp", r)	-- Internalize the temp file
  local cwd = f:read("*a")			-- Get Directory
  f:close()							-- Close temp file
  os.remove("cd.tmp")				-- Remove temp file
  return cwd
end
function verifyPID(suckyPID,suckyGen,cl)
	if suckyPID%25==NatureLocks[cl] then
		if GenderCheck[cl]==0 and suckyGen<GenderVal[cl] then
			result=0
		elseif (GenderCheck[cl]==1 and suckyGen>= GenderVal[cl]) then
			result=0
		elseif (GenderCheck[cl]==2) then
			result=0
		else
			result=1
		end
	else
		result=1
	end
	return result
end
function preparecsvheader()

-- Prepare first row of output
print("")
print("Results will be stored in:  "..currDir().."\\".."LTR "..os.date("%a@%I;%M %p")..".csv")
print("Wait until the window says 'Done Searching' before stopping the script and opening the results file.")
print("")

io.write("Origin Seed,")
io.write("PID,")
io.write("Nature,")
io.write("AntiShinyPID,")
io.write("Anti-Nature,")
io.write("HP,")
io.write("Atk,")
io.write("Def,")
io.write("SpA,")
io.write("SpD,")
io.write("Spe,")
io.write("HP Type,")
io.write("Power,")

	io.write("First Locked PID,")
	io.write("Nature")
io.write("\n")
end
function main()
if go==0 then

printvar=0
results=0
note=0

io.output(io.open("LTR "..os.date("%a@%I;%M %p")..".csv","w"))	

preparecsvheader()

	-- Test every IV combination to find a possible origin seed.
	for testHP=min_HP,max_HP do
		for testAtk=min_Atk,max_Atk do
			for testDef=min_Def,max_Def do
				for testSpA=min_SpA,max_SpA do
					for testSpD=min_SpD,max_SpD do
						for testSpe=min_Spe,max_Spe do
						IV1=testHP+testAtk*32+testDef*1024
						IV2=testSpe+testSpA*32+testSpD*1024
						
							for topbit=0,1 do -- check for both instances of the unused topbit
								testIV2=(IV2+32768*topbit)*0x10000
								for lowtrash=0,65535 do
									tempseed=testIV2+lowtrash
									if (rshift(prevseed(tempseed,1),16))%0x8000==IV1 then
										testPID=rshift(nextseed(tempseed,2),16)*0x10000+rshift(nextseed(tempseed,3),16)
										shinyPID=rshift(nextseed(tempseed,4),16)*0x10000+rshift(nextseed(tempseed,5),16)
										testnature=testPID%0x19
										if testnature*searchall==targetnature*searchall then	--if searchall=0, returns true!
										--We have a desired Nature PKM within our IV ranges; need to check nature locks.
										--Find the seed that pre-generates our shadow 'mon
										originseed=prevseed(tempseed,4)
										currentseed=originseed*1
										
											if previousshadows~=0 then
													currentseed=prevseed(currentseed,7*previousshadows) -- Unroll past the previous shadow if one is specified
											end	
											
											preshadow=genPID(currentseed)
											
											if nltotal>0 then	-- Check to see if it satisfies the lock						
												if verifyPID(preshadow,preshadow%256,1)==0  then
														-- Passes the Gender Lock
														spitmaincsv(originseed,testPID,testnature,shinyPID,testHP,testAtk,testDef,testSpA,testSpD,testSpe,preshadow)
														results=results+1
												end
											else
												-- No locks at all; spit result
												spitmaincsv(originseed,testPID,testnature,shinyPID,testHP,testAtk,testDef,testSpA,testSpD,testSpe,preshadow)
												results=results+1	
											end
										
										
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
	
	go=1
	if printvar==0 then
	print("Done Searching.")
	if note==1 then print("Too many locks detected. Please verify these results with Forward Searching.") end
	printvar=1
	print("Valid Results: "..results)
	print("")
	io.close()
	end
	
end

end
gui.register(main)