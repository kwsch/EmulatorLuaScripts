-- List the desired PIDs and Origin Seeds of your Shadow Mon
local desiredPID=0x318faafb
local originseed=0x99a26368

	  --  // 0 Hardy   1 Lonely   2 Brave    3 Adamant  4 Naughty 
	  --  // 5 Bold    6 Docile   7 Relaxed  8 Impish   9 Lax 
	  --  // 10 Timid  11 Hasty  12 Serious 13 Jolly   14 Naive 
	  --  // 15 Modest 16 Mild   17 Quiet   18 Bashful 19 Rash 
	  --  // 20 Calm   21 Gentle 22 Sassy   23 Careful 24 Quirky 

-- Enter the details of the trainer, stopping at the desired shadow mon.
local trainerteam={51,51,51,51,666}			-- Use the index number, 666 for shadow mons lol
local shadstatus={1,1,1,1,0}		-- Each PKM -- Shadow = 0 // Nonshadow = 1
local naturestats={0,18,6,12,25}					-- Nature Locks, enter anything for Shadow
local genderstats={"M","M","F","M","A"}			-- Gender Locks, ("M" "F" "A") enter anything for Shadow 

local searchtolerance=500							-- Frames to search
local extendtolerance=0
go=0
local mf=math.floor
local rshift, lshift=bit.rshift, bit.lshift
local naturetable={"Hardy","Lonely","Brave","Adamant","Naughty","Bold","Docile","Relaxed","Impish","Lax","Timid","Hasty","Serious","Jolly","Naive","Modest","Mild","Quiet","Bashful","Rash","Calm","Gentle","Sassy","Careful","Quirky"}
local genderthresh={32,32,32,32,32,32,32,32,32,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,256,256,256,0,0,0,192,192,192,192,192,192,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,64,64,128,128,128,64,64,64,64,64,64,128,128,128,128,128,128,128,128,128,128,128,128,0,0,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,0,0,128,128,128,128,0,0,128,128,128,128,128,256,128,256,128,128,128,128,0,0,128,128,256,64,64,128,0,128,128,128,0,32,32,32,32,0,32,32,32,32,32,32,0,0,0,128,128,128,0,0,32,32,32,32,32,32,32,32,32,128,128,128,128,128,128,128,128,128,128,128,128,192,192,32,32,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,32,32,128,128,128,0,128,128,128,128,128,128,128,192,192,128,128,128,128,128,128,128,128,128,128,128,192,128,128,128,128,128,128,128,128,128,128,0,128,128,0,0,256,64,64,256,256,0,0,0,128,128,128,0,0,0,32,32,32,32,32,32,32,32,32,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,0,128,128,128,64,64,192,128,192,192,128,128,128,128,128,128,128,128,128,128,128,0,256,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,0,0,128,128,128,128,0,0,32,32,32,32,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,32,192,128,128,128,0,0,0,0,0,0,256,0,0,0,0,0,0,32,32,32,32,32,32,32,32,32,128,128,128,128,128,128,128,128,128,128,128,128,32,32,32,32,128,256,0,32,256,128,128,128,128,128,128,128,128,128,128,128,128,128,128,192,192,128,128,128,0,0,128,128,256,128,128,128,128,128,32,32,32,128,128,128,128,128,128,128,128,128,128,128,128,128,0,128,128,128,64,64,32,128,32,32,128,128,0,0,128,128,256,0,0,0,0,0,0,128,0,0,256,0,0,0,0,0,0,32,32,32,32,32,32,32,32,32,128,128,128,128,128,128,128,32,32,32,32,32,32,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,64,64,64,128,128,128,0,0,128,128,128,128,128,128,128,128,256,256,128,128,128,128,128,128,128,128,128,128,128,128,128,128,32,32,32,32,128,128,32,32,192,192,192,192,192,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,0,0,0,128,128,128,128,128,128,128,128,128,128,128,128,128,0,128,128,128,128,128,128,0,0,128,128,128,0,0,256,256,128,128,128,128,128,128,128,0,0,0,0,0,0,0,0,0,0,0,0}

function setup()
	
	gv={0,0,0,0,0,0}
	finalPID={0,0,0,0,0,0}
	finalNature={0,0,0,0,0,0}
	finalIterations={0,0,0,0,0,0}
	print("Starting Verification")
	-- 0	Male Only
	-- 1	Female Only
	-- 2	Genderless
	-- 3	87.5% Male
	-- 4	75% Male
	-- 5	50-50
	-- 6	75% Female
	
	-- Populate list of gender thresholds 
	
	searchnumber=0
	validframes=0

	
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
function verifyPID(PID,slot)
	if PID%25==naturestats[slot] then
		if genderstats[slot]=="F" and PID%256<gv[slot] then
			result=0
		elseif (genderstats[slot]=="M" and PID%256>=gv[slot]) then
			result=0
		elseif (genderstats[slot]=="A") then
			result=0
		else
			result=1
		end
	else
		result=1
	end
	return result
end
function genPID(seed)
	return rshift(prevseed(seed,1),16)*0x10000+rshift(seed,16)
end
function main()
if go==0 then 

	setup()
	startingseed=prevseed(originseed,searchtolerance+extendtolerance)

	for i=1,table.getn(trainerteam) do
		if trainerteam[i]==666 then gv[i]=0 
		else	gv[i]=genderthresh[trainerteam[i]]
		end
	end
		
	for s=1,searchtolerance do 
	
		-- Generate the Trainer
		TID=math.floor(nextseed(startingseed,1)/0x10000)
		SID=math.floor(nextseed(startingseed,2)/0x10000)
		currentseed=nextseed(startingseed,2)
		-- Generate the Team
		iterations=2
		for i=1,table.getn(trainerteam) do
		if iterations<searchtolerance*2 then
			if shadstatus[i]==1 then	-- Nonshadow Pokemon must be generated
				-- Generate Faux PID and null middle
				currentseed=nextseed(currentseed,3)
				currentseed=nextseed(currentseed,2)
				PID=genPID(currentseed)
				verizult=verifyPID(PID,i)	-- Check to see if PID is valid
				iterations=iterations+5
				
				while verizult==1 do		-- While PID is not valid, generate PIDs
					currentseed=nextseed(currentseed,2)
					PID=genPID(currentseed)
					verizult=verifyPID(PID,i)
					iterations=iterations+2
				end
				
				-- Take note of what PID we got.
				finalPID[i]=PID
				finalNature[i]=naturetable[PID%25+1]
				finalIterations[i]=iterations-4
				
				-- Now that we have a valid PID that satisfies the current Nature Lock, we can move on to the next (if any).
				
			else	-- Shadow Pokemon is to be generated.
				currentseed=nextseed(currentseed,7)
				PID=genPID(currentseed)	
				iterations=iterations+7

					-- Store what we got.
					
				finalPID[i]=PID
				finalNature[i]=naturetable[PID%25+1]
				finalIterations[i]=iterations-4
				
				-- Now we can move to the next.
				
			end
			
		end
		end
			
		-- Since our team is generated, time to check if the starting mon is as desired
		if finalPID[table.getn(trainerteam)]==desiredPID then 
			print(string.format("%03d V %08X [%04X%04X] (%03d) %08X | (%03d) %08X | (%03d) %08X | (%03d) %08X",s-1,startingseed,SID,TID,finalIterations[1],finalPID[1],finalIterations[2],finalPID[2],finalIterations[3],finalPID[3],finalIterations[4],finalPID[4]))
			validframes=validframes+1
			if validframes==1 then
				firstvalidrow=s-1
				firstvalidseed=startingseed+0
			end
		else	
			print(string.format("%03d - %08X [%04X%04X] (%03d) %08X | (%03d) %08X | (%03d) %08X | (%03d) %08X",s-1,startingseed,SID,TID,finalIterations[1],finalPID[1],finalIterations[2],finalPID[2],finalIterations[3],finalPID[3],finalIterations[4],finalPID[4]))
			
		end
		
	searchnumber=searchnumber+1
	
	startingseed=nextseed(startingseed,1) -- Advance the starting seed once for the next loop
	go=1
	end
	print("")
	print("Done Searching. Valid Frames: "..validframes)
	if validframes ~=0 then
	print("First Row/Seed to produce a Valid Result:"..firstvalidrow.." - "..string.format("%08X",firstvalidseed))
	print("Difficulty Rating: "..string.format("%d%%",1000/validframes))
	else
	print("Spread can not be obtained..")
	end
	print("")
	end
	
end
gui.register(main)