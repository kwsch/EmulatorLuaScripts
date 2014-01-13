local natureorder={"Atk","Def","Spd","SpAtk","SpDef"}
local naturename={
 "Hardy","Lonely","Brave","Adamant","Naughty",
 "Bold","Docile","Relaxed","Impish","Lax",
 "Timid","Hasty","Serious","Jolly","Naive",
 "Modest","Mild","Quiet","Bashful","Rash",
 "Calm","Gentle","Sassy","Careful","Quirky"}
local typeorder={
 "Fighting","Flying","Poison","Ground",
 "Rock","Bug","Ghost","Steel",
 "Fire","Water","Grass","Electric",
 "Psychic","Ice","Dragon","Dark"}

local start=0x0202402C
local nullframes=0
local personality
local trainerid
local magicword
local growthoffset
local miscoffset
local i

local species
local ivs
local hpiv
local atkiv
local defiv
local spdiv
local spatkiv
local spdefiv
local nature
local natinc
local natdec
local hidpowbase
local hidpowtype
local rshift,lshift,wd,ww,wb,md,mw,mb,gt,sf,mf,ts,ti,tc=bit.rshift,bit.lshift,memory.writedword,memory.writeword,memory.writebyte,memory.readdwordunsigned,memory.readwordunsigned,memory.readbyteunsigned,gui.text,string.format,math.floor,table.sort,table.insert,table.concat

function displaypkm(start,arg,partyn)
personality=memory.readdwordunsigned(start)
 trainerid=memory.readdwordunsigned(start+4)
 magicword=bit.bxor(personality, trainerid)
 
 if arg==1 then
	text="Opponent 1"
	elseif arg==2 then
	text="Party 1"
	elseif arg==3 then
	text="Party "..partyn
end
 
 i=personality%24
 
 if i<=5 then
  growthoffset=0
 elseif i%6<=1 then
  growthoffset=12
 elseif i%2==0 then
  growthoffset=24
 else
  growthoffset=36
 end

 if i>=18 then
  miscoffset=0
 elseif i%6>=4 then
  miscoffset=12
 elseif i%2==1 then
  miscoffset=24
 else
  miscoffset=36
 end

 species=bit.band(bit.bxor(memory.readdwordunsigned(start+32+growthoffset),magicword),0xFFF)

 ivs=bit.bxor(memory.readdwordunsigned(start+32+miscoffset+4),magicword)
 
 hpiv=bit.band(ivs,0x1F)
 atkiv=bit.band(ivs,0x1F*0x20)/0x20
 defiv=bit.band(ivs,0x1F*0x400)/0x400
 spdiv=bit.band(ivs,0x1F*0x8000)/0x8000
 spatkiv=bit.band(ivs,0x1F*0x100000)/0x100000
 spdefiv=bit.band(ivs,0x1F*0x2000000)/0x2000000
 
 nature=personality%25
 natinc=math.floor(nature/5)
 natdec=nature%5
 
 hidpowtype=math.floor(((hpiv%2 + 2*(atkiv%2) + 4*(defiv%2) + 8*(spdiv%2) + 16*(spatkiv%2) + 32*(spdefiv%2))*15)/63)
 hidpowbase=math.floor(((bit.band(hpiv,2)/2 + bit.band(atkiv,2) + 2*bit.band(defiv,2) + 4*bit.band(spdiv,2) + 8*bit.band(spatkiv,2) + 16*bit.band(spdefiv,2))*40)/63 + 30)
 
 gui.text(1,0,"Stats")
 gui.text(30,0,"HP  "..memory.readwordunsigned(start+86))
 gui.text(65,0,"Atk "..memory.readwordunsigned(start+90))
 gui.text(99,0,"Def "..memory.readwordunsigned(start+92))
 gui.text(133,0,"SpA "..memory.readwordunsigned(start+96))
 gui.text(167,0,"SpD "..memory.readwordunsigned(start+98))
 gui.text(201,0,"Spe "..memory.readwordunsigned(start+94))

 gui.text(1,8,"IVs")
 gui.text(30,8,"HP  "..hpiv)
 gui.text(65,8,"Atk "..atkiv)
 gui.text(99,8,"Def "..defiv)
 gui.text(133,8,"SpA "..spatkiv)
 gui.text(167,8,"SpD "..spdefiv)
 gui.text(201,8,"Spe "..spdiv)

 gui.text(1,28,"PID:  "..string.format("%08X", personality))
 gui.text(60,28,"IVs: "..string.format("%08X", ivs))
 gui.text(1,38,"Nature: "..naturename[nature+1])
 gui.text(1,48,natureorder[natinc+1].."+ "..natureorder[natdec+1].."-")
 gui.text(167,15,"HP "..typeorder[hidpowtype+1].." "..hidpowbase)
 
 gt(1,58,text,"orange")
end

function main()
	table=joypad.get(1)						-- Detect Keypresses on the current frame.
		
	-- Seed Display
	if mw(0x02020000)==0x0 then
		-- Initial Seed not yet set!
		gt(1,143,sf("No Initial Seed Yet"))
		gt(1,153,sf("Timer1: %04X",mw(0x04000104)))
	else 
		gt(1,123,sf("VBA Frame: %d", vba.framecount()))
		gt(1,143,sf("Initial Seed: %08X",mw(0x02020000)))
		seed=memory.readdwordunsigned(0x03005000)
		gt(1,153,sf("Current Seed: %08X", seed))
 print("Seed: "..string.format("%08X", seed))
	end
	
	-- Trainer Information Display
	gt(199,143,sf("TID: %05d",mw(md(0x0300500C)+0xA)))
	gt(199,153,sf("SID: %05d",mw(md(0x0300500C)+0xC)))
	
	-- Display Party# PKM Data if pressed.
	if (table.R and table.L) then	
		partyn=2 					-- Enter Party # if custom slot is desired.
		displaypkm(0x02024284+0x64*(partyn-1),3,partyn)
		
		elseif (table.L) then	-- Display Party1 PKM Data if pressed.
		displaypkm(0x02024284,2)
		
		elseif (table.R) then	-- Display Opponent1 PKM Data if pressed.
		displaypkm(start,1)
	end
end

gui.register(main)