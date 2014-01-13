local mf=math.floor
local rshift, lshift=bit.rshift, bit.lshift
local naturetable={"Hardy","Lonely","Brave","Adamant","Naughty","Bold","Docile","Relaxed","Impish","Lax","Timid","Hasty","Serious","Jolly","Naive","Modest","Mild","Quiet","Bashful","Rash","Calm","Gentle","Sassy","Careful","Quirky"}
local typeorder={"Fighting","Flying","Poison","Ground","Rock","Bug","Ghost","Steel","Fire","Water","Grass","Electric","Psychic","Ice","Dragon","Dark"}
local failedPIDs={0,0,0,0,0}

min_HP=30
min_Atk=2
min_Def=30
min_SpA=30
min_SpD=30
min_Spe=30

max_HP=31
max_Atk=31
max_Def=31
max_SpA=31
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
NatureLocks={18,6,24}
GenderCheck={0,0,1} -- 0 for female, 1 for male, 2 for none
GenderVal={128,128,64} -- Threshold (if F must <; if M must >=)

NatureLocks={}

--Count up the amount of locks that are present
nltotal=table.getn(NatureLocks) 
-- Gender lock checking is OFF (0)
GLOFF=1

-- Previous shadow mons before target
previousshadows=1

go=0

function gethiddenpower(testHP,testAtk,testDef,testSpe,testSpA,testSpD)
			hidpowtype=typeorder[1+math.floor(((testHP%2 + 2*(testAtk%2) + 4*(testDef%2) + 8*(testSpe%2) + 16*(testSpA%2) + 32*(testSpD%2))*15)/63)]
			hidpowbase=math.floor(((bit.band(testHP,2)/2 + bit.band(testAtk,2) + 2*bit.band(testDef,2) + 4*bit.band(testSpe,2) + 8*bit.band(testSpA,2) + 16*bit.band(testSpD,2))*40)/63 + 30)
			move="Hidden Power ["..hidpowtype.." "..hidpowbase.."]"
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

function currDir()			-- Cache the current directory so that the user knows where Snags will be stored.
  os.execute("cd > cd.tmp")			-- Open up a temporary file
  local f = io.open("cd.tmp", r)	-- Internalize the temp file
  local cwd = f:read("*a")			-- Get Directory
  f:close()							-- Close temp file
  os.remove("cd.tmp")				-- Remove temp file
  return cwd
end

function main()
if go==0 then
io.output(io.open("LTR.txt","w"))
go=1
print("")
print("Results will be stored in:  "..currDir().."LTR.txt")
print("Wait until the window says 'Done Searching' before stopping the script and opening the results file.")
print("")

io.write("Criterion: \n")
io.write("Min: "..string.format("%2d/%2d/%2d/%2d/%2d/%2d\n", min_HP,min_Atk,min_Def,min_SpA,min_SpD,min_Spe))
io.write("Max: "..string.format("%2d/%2d/%2d/%2d/%2d/%2d\n\n", max_HP,max_Atk,max_Def,max_SpA,max_SpD,max_Spe))
	-- Test every IV combination to find a possible origin seed.
	for testHP=min_HP,max_HP do
		for testAtk=min_Atk,max_Atk do
			for testDef=min_Def,max_Def do
				for testSpA=min_SpA,max_SpA do
					for testSpD=min_SpD,max_SpD do
						for testSpe=min_Spe,max_Spe do
						failedPIDs={0,0,0,0,0}
						errors=0
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
										if testnature*searchall==targetnature*searchall then
										--We have a desired Nature PKM within our IV ranges; need to check nature locks.
										--Find the seed that pre-generates our shadow 'mon
										originseed=prevseed(tempseed,4)
											if nltotal>0 then
												-- Check to see if the spread satisfies the first NG lock
												preshadow=rshift(prevseed(originseed,1),16)*0x10000+rshift(originseed,16)
												currentseed=prevseed(originseed,5)
												if previousshadows~=0 then
														currentseed=prevseed(currentseed,7*previousshadows)
												end
												
												if (preshadow%25==NatureLocks[1]) then
												-- Passes the Nature Lock
												preshadowgend=preshadow%256														
													if (GenderCheck[1]==0 and preshadowgend<GenderVal[1]) or (GenderCheck[1]==1 and preshadowgend>= GenderVal[1]) or (GenderCheck[1]==2) or (GLOFF==0) then
														-- Passes the Gender Lock
														if nltotal>1 then
															for cl=2,nltotal do
																currentseed=prevseed(currentseed,2)
																suckyPID=rshift(currentseed,16)*0x10000+rshift(nextseed(currentseed,1),16)
																suckyGen=suckyPID%256

																while (suckyPID%25~=NatureLocks[cl] and not ((GenderCheck[cl]==0 and suckyGen<GenderVal[cl]) or (GenderCheck[cl]==1 and preshadowgend>= GenderVal[cl]) or (GenderCheck[cl]==2))) do
																	suckyPID=rshift(currentseed,16)*0x10000+rshift(nextseed(currentseed,1),16)
																	currentseed=prevseed(currentseed,2)
																	suckyGen=suckyPID%256
																	failedPIDs[cl]=failedPIDs[cl]+1
																end
																-- PID Lock Obtained For current criterion. Checking forward to see if the subsequent lock is shorted.
																if failedPIDs[cl]>0 then 
																	failseed=currentseed+0
																	for iter=0,failedPIDs[cl] do
																		suckyPID=rshift(currentseed,16)*0x10000+rshift(nextseed(currentseed,1),16)
																		if (suckyPID%25==NatureLocks[cl] and ((GenderCheck[cl]==0 and suckyGen<GenderVal[cl]) or (GenderCheck[cl]==1 and preshadowgend>= GenderVal[cl]) or (GenderCheck[cl]==2))) then
																			errors=errors+1
																		end
																	end
																end
																if errors==0 then
																		-- print("Fr1 Seed: "..string.format("%8X", nextseed(originseed,2)))
																		-- print("PKM PID: "..string.format("%8X - %s", testPID, naturetable[testnature+1]))
																		-- print("ShinyRoll: "..string.format("%8X - %s", shinyPID, naturetable[shinyPID%25+1]))
																		-- print(string.format("%2d/%2d/%2d/%2d/%2d/%2d", testHP,testAtk,testDef,testSpA,testSpD,testSpe))
																		-- print(gethiddenpower(testHP,testAtk,testDef,testSpe,testSpA,testSpD))
																		-- print("")
																		-- print("NonShadow 1: "..string.format("%8X", preshadow))
																		-- print("Nature: "..string.format("%s", naturetable[preshadow%25+1]))
																		-- print("-----------------------")
																		
																		io.write("Fr1 Seed: "..string.format("%8X\n", nextseed(originseed,2)))
																		io.write("PKM PID: "..string.format("%8X - %s\n", testPID, naturetable[testnature+1]))
																		io.write("ShinyRoll: "..string.format("%8X - %s\n", shinyPID, naturetable[shinyPID%25+1]))
																		io.write(string.format("%2d/%2d/%2d/%2d/%2d/%2d\n", testHP,testAtk,testDef,testSpA,testSpD,testSpe))
																		io.write(gethiddenpower(testHP,testAtk,testDef,testSpe,testSpA,testSpD).."\n")
																		io.write("LockPID: "..string.format("%8X\n", preshadow))
																		io.write("Nature: "..string.format("%s\n", naturetable[preshadow%25+1]))
																		io.write("-----------------------\n")
																		
																end
															end
														else
														-- No more than 1 lock, print stuff
														-- print("Fr1 Seed: "..string.format("%8X", nextseed(originseed,2)))
														-- print("PKM PID: "..string.format("%8X - %s", testPID, naturetable[testnature+1]))
														-- print("ShinyRoll: "..string.format("%8X - %s", shinyPID, naturetable[shinyPID%25+1]))
														-- print(string.format("%2d/%2d/%2d/%2d/%2d/%2d", testHP,testAtk,testDef,testSpA,testSpD,testSpe))
														-- print(gethiddenpower(testHP,testAtk,testDef,testSpe,testSpA,testSpD))
														-- print("")
														-- print("NonShadow 1: "..string.format("%8X", preshadow))
														-- print("Nature: "..string.format("%s", naturetable[preshadow%25+1]))
														-- print("-----------------------")
														
														
														io.write("Fr1 Seed: "..string.format("%8X\n", nextseed(originseed,2)))
														io.write("PKM PID: "..string.format("%8X - %s\n", testPID, naturetable[testnature+1]))
														io.write("ShinyRoll: "..string.format("%8X - %s\n", shinyPID, naturetable[shinyPID%25+1]))
														io.write(string.format("%2d/%2d/%2d/%2d/%2d/%2d\n", testHP,testAtk,testDef,testSpA,testSpD,testSpe))
														io.write(gethiddenpower(testHP,testAtk,testDef,testSpe,testSpA,testSpD).."\n")
														io.write("LockPID: "..string.format("%8X\n", preshadow))
														io.write("Nature: "..string.format("%s\n", naturetable[preshadow%25+1]))
														io.write("-----------------------\n")
														end
													end
												end
											else
											-- No locks, just print the result
											preshadow=rshift(prevseed(originseed,1),16)*0x10000+rshift(originseed,16)
												currentseed=prevseed(originseed,5)
														-- print("Fr1 Seed: "..string.format("%8X", nextseed(originseed,2)))
														-- print("PKM PID: "..string.format("%8X - %s", testPID, naturetable[testnature+1]))
														-- print("ShinyRoll: "..string.format("%8X - %s", shinyPID, naturetable[shinyPID%25+1]))
														-- print(string.format("%2d/%2d/%2d/%2d/%2d/%2d", testHP,testAtk,testDef,testSpA,testSpD,testSpe))
														-- print(gethiddenpower(testHP,testAtk,testDef,testSpe,testSpA,testSpD))
														-- print("")
														-- print("LockPID: "..string.format("%8X", preshadow))
														-- print("Nature: "..string.format("%s", naturetable[preshadow%25+1]))
														-- print("-----------------------")
														
														
														io.write("Fr1 Seed: "..string.format("%8X\n", nextseed(originseed,2)))
														io.write("PKM PID: "..string.format("%8X - %s\n", testPID, naturetable[testnature+1]))
														io.write("ShinyRoll: "..string.format("%8X - %s\n", shinyPID, naturetable[shinyPID%25+1]))
														io.write(string.format("%2d/%2d/%2d/%2d/%2d/%2d\n", testHP,testAtk,testDef,testSpA,testSpD,testSpe))
														io.write(gethiddenpower(testHP,testAtk,testDef,testSpe,testSpA,testSpD).."\n")
														io.write("LockPID: "..string.format("%8X\n", preshadow))
														io.write("Nature: "..string.format("%s\n", naturetable[preshadow%25+1]))
														io.write("-----------------------\n")
															
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
	
	print("Done Searching.")
	io.close()
end

end
gui.register(main)