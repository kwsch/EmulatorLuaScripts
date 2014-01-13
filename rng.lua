local game=6 --see below
local startvalue=0x00001337 --insert the first value of RNG

-- These are all the possible key names: [keys]
-- backspace, tab, enter, shift, control, alt, pause, capslock, escape,
-- space, pageup, pagedown, end, home, left, up, right, down, insert, delete,
-- 0 .. 9, A .. Z, numpad0 .. numpad9, numpad*, numpad+, numpad-, numpad., numpad/,
-- F1 .. F24, numlock, scrolllock, semicolon, plus, comma, minus, period, slash, tilde,
-- leftbracket, backslash, rightbracket, quote.
-- [/keys]
-- Key names must be in quotes.
-- Key names are case sensitive.
local key={"9", "8", "7"}

-- It is not necessary to change anything beyond this point.

--for different display modes
local status=1
local substatus={1,1,1}

local tabl={}
local prev={}

local xfix=0 --x position of display handle
local yfix=60 --y position of display handle
local k 



--for different game versions
--1: Ruby/Sapphire U
--2: Emerald U
--3: FireRed/LeafGreen U
--4: Ruby/Sapphire J
--5: Emerald J (TODO)
--6: FireRed/LeafGreen J (1360)

local gamename={"Ruby/Sapphire U", "Emerald U", "FireRed/LeafGreen U", "Ruby/Sapphire J", "Emerald J", "FireRed/LeafGreen J (1360)"}

local pstats={0x3004360, 0x20244EC, 0x2024284, 0x3004290, 0x2024190, 0x20241E4}
local estats={0x30045C0, 0x2024744, 0x202402C, 0x30044F0, 0x0000000, 0x2023F8C}
local rng   ={0x3004818, 0x3005D80, 0x3005000, 0x3004748, 0x0000000, 0x3005040} --0X3004FA0
local rng2  ={0x0000000, 0x0000000, 0x20386D0, 0x0000000, 0x0000000, 0x203861C}

--HP, Atk, Def, Spd, SpAtk, SpDef
local statcolor = {"yellow", "red", "blue", "green", "magenta", "cyan"}

local flag=0
local i,j
local last=0
local cur
local test
local test2
local counter=0
local indexfind
local index
local clr
local randvalue
local prev
local tid
local modd

local start

local personality
local trainerid
local magicword
local growthoffset
local miscoffset
local effortoffset
local i
local species
local holditem
local pokerus
local ivs
local evs1
local evs2
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

local bnd,br,bxr=bit.band,bit.bor,bit.bxor
local rshift, lshift=bit.rshift, bit.lshift
local mdword=memory.readdwordunsigned
local mword=memory.readwordunsigned
local mbyte=memory.readbyteunsigned

--these 32-value tables are for fast indexing of RNG values
--the RNG is a linear congruential generator with modulus 2^32
--x<-0x41C64E6D*x+0x6073
--because the modulus is a power of two
--it is very easy to find the index
--only takes O(log n) time
--in general, it is unreasonable to calculate the index of an RNG without lookup tables
--one can use lookup tables to find indices in O(1) time
--however for this RNG, it takes up way too much space (16GB)

local multspa={
 0x41C64E6D, 0xC2A29A69, 0xEE067F11, 0xCFDDDF21,
 0x5F748241, 0x8B2E1481, 0x76006901, 0x1711D201,
 0xBE67A401, 0xDDDF4801, 0x3FFE9001, 0x90FD2001,
 0x65FA4001, 0xDBF48001, 0xF7E90001, 0xEFD20001,
 0xDFA40001, 0xBF480001, 0x7E900001, 0xFD200001,
 0xFA400001, 0xF4800001, 0xE9000001, 0xD2000001,
 0xA4000001, 0x48000001, 0x90000001, 0x20000001,
 0x40000001, 0x80000001, 0x00000001, 0x00000001}

local multspb={
 0x00006073, 0xE97E7B6A, 0x31B0DDE4, 0x67DBB608,
 0xCBA72510, 0x1D29AE20, 0xBA84EC40, 0x79F01880,
 0x08793100, 0x6B566200, 0x803CC400, 0xA6B98800,
 0xE6731000, 0x30E62000, 0xF1CC4000, 0x23988000,
 0x47310000, 0x8E620000, 0x1CC40000, 0x39880000,
 0x73100000, 0xE6200000, 0xCC400000, 0x98800000,
 0x31000000, 0x62000000, 0xC4000000, 0x88000000,
 0x10000000, 0x20000000, 0x40000000, 0x80000000}

local multspc={
 0x00003039, 0xD3DC167E, 0xD6651C2C, 0xCD1DCF18,
 0x65136930, 0x642B7E60, 0x1935ACC0, 0xB6461980,
 0x1EF73300, 0x1F9A6600, 0x85E4CC00, 0x26899800,
 0xB8133000, 0x1C266000, 0xE84CC000, 0x90998000,
 0x21330000, 0x42660000, 0x84CC0000, 0x09980000,
 0x13300000, 0x26600000, 0x4CC00000, 0x99800000,
 0x33000000, 0x66000000, 0xCC000000, 0x98000000,
 0x30000000, 0x60000000, 0xC0000000, 0x80000000}

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

--a 32-bit, b bit position bottom, d size
function getbits(a,b,d)
 return rshift(a,b)%lshift(1,d)
end


function gettop(a)
 return(rshift(a,16))
end


--does 32-bit multiplication
--necessary because Lua does not allow 32-bit integer definitions
--so one cannot do 32-bit arithmetic
--furthermore, precision loss occurs at around 10^10
--so numbers must be broken into parts
--may be improved using bitop library exclusively
function mult32(a,b)
 local c=rshift(a,16)
 local d=a%0x10000
 local e=rshift(b,16)
 local f=b%0x10000
 local g=(c*f+d*e)%0x10000
 local h=d*f
 local i=g*0x10000+h
 return i
end

-- draws a 3x3 square with x position a, y position b, and color c
function drawsquare(a,b,c)
 gui.box(a,b,a+2,b+2,c)
end

-- draws a down arrow, x position a, y position b, and color c
-- this arrow marks the square for the current RNG value
function drawarrow(a,b,c)
 gui.line(a,b,a-2,b-2,c)
 gui.line(a,b,a+2,b-2,c)
 gui.line(a,b,a,b-6,c)
end




--a press is when input is registered on one frame but not on the previous
--that's why the previous input is used as well
prev=input.get()
function fn()
--*********
 tabl=input.get()

 if tabl[key[1]] and not prev[key[1]] then
  status=status+1
  if status==4 then
   status=1
  end
 end

 if tabl[key[2]] and not prev[key[2]] then
  substatus[status]=substatus[status]+1
  if substatus[status]==9 then
   substatus[status]=1
  end
 end

 if tabl[key[3]] and not prev[key[3]] then
  substatus[status]=substatus[status]-1
  if substatus[status]==0 then
   substatus[status]=8
  end
 end

 gui.text(200,0,status)
 gui.text(200,10,substatus[1])

 gui.text(200,20,substatus[2])
 gui.text(200,30,substatus[3])

 prev=tabl

-- now for display
 if status==1 or status==2 then --status 1 or 2

    if status==1 then
      start=pstats[game]+100*(substatus[1]-1)
    else
     start=estats[game]+100*(substatus[2]-1)
    end

    personality=mdword(start)
    trainerid=mdword(start+4)
    magicword=bxr(personality, trainerid)

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

    if i>=12 and i<=17 then
     effortoffset=0
    elseif i==2 or i==3 or i==8 or i==9 or i==22 or i==23 then
     effortoffset=12
    elseif i==0 or i==5 or i==6 or i==11 or i==19 or i==21 then
     effortoffset=24
    else
     effortoffset=36
    end

    species=getbits(bxr(mdword(start+32+growthoffset),magicword),0,16)

    holditem=getbits(bxr(mdword(start+32+growthoffset),magicword),16,16)

    pokerus=getbits(bxr(mdword(start+32+miscoffset),magicword),0,8)

    ivs=bxr(mdword(start+32+miscoffset+4),magicword)

    evs1=bxr(mdword(start+32+effortoffset),magicword)
    evs2=bxr(mdword(start+32+effortoffset+4),magicword)

    hpiv=getbits(ivs,0,5)
    atkiv=getbits(ivs,5,5)
    defiv=getbits(ivs,10,5)
    spdiv=getbits(ivs,15,5)
    spatkiv=getbits(ivs,20,5)
    spdefiv=getbits(ivs,25,5)

    nature=personality%25
    natinc=math.floor(nature/5)
    natdec=nature%5

    hidpowtype=math.floor(((hpiv%2 + 2*(atkiv%2) + 4*(defiv%2) + 8*(spdiv%2) + 16*(spatkiv%2) + 32*(spdefiv%2))*15)/63)
    hidpowbase=math.floor((( getbits(hpiv,1,1) + 2*getbits(atkiv,1,1) + 4*getbits(defiv,1,1) + 8*getbits(spdiv,1,1) + 16*getbits(spatkiv,1,1) + 32*getbits(spdefiv,1,1))*40)/63 + 30)

    gui.text(xfix+15,yfix-8, "Stat")
    gui.text(xfix+40,yfix-8, "IV")
    gui.text(xfix+60,yfix-8, "EV")
    gui.text(xfix+80,yfix-8, "Nat")

    gui.text(xfix,yfix-16, "CurHP: "..mword(start+86).."/"..mword(start+88), "yellow")
    if status==2 then
     gui.text(xfix,yfix-24, "Enemy "..substatus[2])
    elseif status==1 then
     gui.text(xfix,yfix-24, "Player "..substatus[1])
    end

    gui.text(xfix,yfix+0,"HPT", "yellow")
    gui.text(xfix,yfix+8,"ATK", "red")
    gui.text(xfix,yfix+16,"DEF", "blue")
    gui.text(xfix,yfix+24,"SPE", "green")
    gui.text(xfix,yfix+32,"SAT", "magenta")
    gui.text(xfix,yfix+40,"SDF", "cyan")

    gui.text(xfix+20,yfix, mword(start+88), "yellow")
    gui.text(xfix+20,yfix+8, mword(start+90), "red")
    gui.text(xfix+20,yfix+16, mword(start+92), "blue")
    gui.text(xfix+20,yfix+24, mword(start+94), "green")
    gui.text(xfix+20,yfix+32, mword(start+96), "magenta")
    gui.text(xfix+20,yfix+40, mword(start+98), "cyan")

    gui.text(xfix+40,yfix, hpiv, "yellow")
    gui.text(xfix+40,yfix+8, atkiv, "red")
    gui.text(xfix+40,yfix+16, defiv, "blue")
    gui.text(xfix+40,yfix+24, spdiv, "green")
    gui.text(xfix+40,yfix+32, spatkiv, "magenta")
    gui.text(xfix+40,yfix+40, spdefiv, "cyan")

    gui.text(xfix+60,yfix, getbits(evs1, 0, 8), "yellow")
    gui.text(xfix+60,yfix+8, getbits(evs1, 8, 8), "red")
    gui.text(xfix+60,yfix+16, getbits(evs1, 16, 8), "blue")
    gui.text(xfix+60,yfix+24, getbits(evs1, 24, 8), "green")
    gui.text(xfix+60,yfix+32, getbits(evs2, 0, 8), "magenta")
    gui.text(xfix+60,yfix+40, getbits(evs2, 8, 8), "cyan")

    if natinc~=natdec then
     gui.text(xfix+80,yfix+8*(natinc+1), "+", statcolor[natinc+2])
     gui.text(xfix+80,yfix+8*(natdec+1), "-", statcolor[natdec+2])
    else
     gui.text(xfix+80,yfix+8*(natinc+1), "+-", "grey")
    end
 end --status 1 or 2

 --gui.text(0,30,"Species "..species)
 --gui.text(0,40,"Nature: "..naturename[nature+1])
 --gui.text(0,50,natureorder[natinc+1].."+ "..natureorder[natdec+1].."-")
 --gui.text(0,60,"Hidden Power: "..typeorder[hidpowtype+1].." "..hidpowbase)
 --gui.text(0,70,"Hold Item "..holditem)
 --gui.text(0,80,"Pokerus Status "..pokerus)
 if status==3 then
    i=0
    cur=memory.readdword(rng[game])
    test=last
    while bit.tohex(cur)~=bit.tohex(test) and i<=100 do
     test=mult32(test,0x41C64E6D) + 0x6073
     i=i+1
    end
    gui.text(120,20,"Last RNG value: "..bit.tohex(last))
    last=cur
    gui.text(120,0,"Current RNG value: "..bit.tohex(cur))
    if i<=100 then
     gui.text(120,10,"RNG distance since last: "..i)
    else
     gui.text(120,10,"RNG distance since last: >100")
    end
    

    
    
    --math
    indexfind=startvalue
    index=0
    for j=0,31,1 do
     if getbits(cur,j,1)~=getbits(indexfind,j,1) then
      indexfind=mult32(indexfind,multspa[j+1])+multspb[j+1]
      index=index+bit.lshift(1,j)
      if j==31 then
       index=index+0x100000000
      end
     end
    end
    gui.text(120,30,index)
    
    
	if substatus[3]>=5 and substatus[3]<=8 then
	 modd=2
	else
	 modd=3
	end
	
    if i>modd and i<=100 then
	 gui.box(3,30,17,44, "red")
	 gui.box(5,32,15,42, "black")
    end
	
	if substatus[3]%4==1 then
	   gui.text(10,45, "Critical Hit/Max Damage")
	elseif substatus[3]%4==2 then
       gui.text(10,45, "Move Miss (95%)")
	elseif substatus[3]%4==3 then
       gui.text(10,45, "Move Miss (90%)")
	else
       gui.text(10,45, "Quick Claw")
	end
	   
	  
    drawarrow(3,52, "#FF0000FF")
    test=cur
    -- i row j column
    for i=0,13,1 do
     for j=0,17,1 do
      if j%modd==1 then
       clr="#C0C0C0FF"
      else
       clr="#808080FF"
      end
      randvalue=gettop(test)
      if substatus[3]%4==1 then
       if randvalue%16==0 then
        test2=test
        for k=1,10,1 do
         test2=mult32(test2,0x41C64E6D) + 0x6073
        end
		clr={r=255, g=0x10*(gettop(test2)%16), b=0, a=255}
       end
      end
	  
	  if substatus[3]%4==2 then
	   if randvalue%100>=95 then
	    clr="#0000FFFF"
	   end
	  end
	  
	  if substatus[3]%4==3 then
	   if randvalue%100>=90 then
	    clr="#000080FF"
	   end
	  end

	  if substatus[3]%4==0 then
	   if randvalue<0x3333 then
	    clr="#00FF00FF"
	   end
	  end	  
	  
      drawsquare(2+4*j,54+4*i, clr)
    

      test=mult32(test,0x41C64E6D) + 0x6073
     end
    end
    
    
    
 end
    
    
--*********
end
gui.register(fn)