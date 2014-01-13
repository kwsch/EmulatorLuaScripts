local rshift, lshift=bit.rshift, bit.lshift
local md,mw,mb=memory.readdwordunsigned,memory.readwordunsigned,memory.readbyteunsigned
local gt,sf=gui.text,string.format
local table={}
local on,enbl,overprint,enblo=1,1,1,1

if mb(0x023FFE09)==0x00 then		-- Not "2" ~ Not B2/W2
	  pos_m=md(0x02000024)+0x3461C
	    zds=md(0x02000024)+0x3DFAC
	owstart=md(0x02000024)+0x34E04
	game=1
else
	  pos_m=md(0x02000024)+0x36780
	    zds=md(0x02000024)+0x41B2C
	owstart=md(0x02000024)+0x36BE8
	game=2
end

function main()
        table=joypad.get(1)
        if table.L then
                gt(0,0, "Toggling Display")
                enbl=0
        else
                if enbl==0 then on=(on+1)%2 enbl=1 end
        end

        if table.R then
                gt(0,0, "Printout")
                enblo=0
        else
                if enblo==0 then overprint=(overprint+1)%2 enblo=1 end
        end

        if on==0 then

		
		if game==2 then
			bike=rshift(mw(zds+2*15),10)%2
			 fly=rshift(mw(zds+2*15),13)%2
		else 
			bike=rshift(mb(zds+0x1F),2)%2
			 fly=rshift(mb(zds+0x1F),5)%2
	end



                if bike==1 then
                        gt(159,110,sf("Bike - Enabled")) else
                        gt(159,110,sf("Bike - Disabled")) end
                if fly==1 then
                        gt(159,120,sf("Fly  - Enabled")) else
                        gt(159,120,sf("Fly  - Disabled")) end
        
                gt(1,50,sf("00-01: %04x",mw(zds+2*0)))        gt(80,50,sf("10-11: %04x",mw(zds+2*8)))       gt(159,50,sf("20-21: %04x",mw(zds+2*16)))
                gt(1,60,sf("02-03: %04x",mw(zds+2*1)))        gt(80,60,sf("12-13: %04x",mw(zds+2*9)))       gt(159,60,sf("22-23: %04x",mw(zds+2*17)))
                gt(1,70,sf("04-05: %04x",mw(zds+2*2)))        gt(80,70,sf("14-15: %04x",mw(zds+2*10)))      gt(159,70,sf("24-27: %08x",md(zds+2*18)))
                gt(1,80,sf("06-07: %04x",mw(zds+2*3)))        gt(80,80,sf("16-17: %04x",mw(zds+2*11)))      gt(159,80,sf("28-2B: %08x",md(zds+2*20)))
                gt(1,90,sf("08-09: %04x",mw(zds+2*4)))        gt(80,90,sf("18-19: %04x",mw(zds+2*12)))      gt(159,90,sf("2C-2F: %08x",md(zds+2*22)))
                gt(1,100,sf("0A-0B: %04x",mw(zds+2*5)))       gt(80,100,sf("1A-1B: %04x",mw(zds+2*13)))
                gt(1,110,sf("0C-0D: %04x",mw(zds+2*6)))       gt(80,110,sf("1C-1D: %04x",mw(zds+2*14)))
                gt(1,120,sf("0E-0F: %04x",mw(zds+2*7)))       gt(80,120,sf("1E-1F: %04x",mw(zds+2*15)))    
        end

	if overprint==0 then 
		fcount=mb(0x4+owstart) ncount=mb(0x5+owstart) wcount=mb(0x6+owstart) tcount=mb(0x7+owstart)
		furnstart=0x8
		furnend=furnstart+0x14*fcount-1
		 npcstart=0x08+mb(0x04+owstart)*0x14
		 npcend= npcstart+0x24*ncount-1
		warpstart=0x08+mb(0x04+owstart)*0x14+mb(0x05+owstart)*0x24
		warpend=warpstart+0x14*wcount-1
		trigstart=0x08+mb(0x04+owstart)*0x14+mb(0x05+owstart)*0x24+mb(0x06+owstart)*0x14
		trigend=trigstart+0x16*tcount-1


		print(sf("Overworld Data [%d] @ 0x%08X",mw(zds+2*11),owstart))
		if fcount>0 then
			print(sf("[%d] Furniture Range: 0x%04X-0x%04X",fcount,furnstart,furnend)) else print(sf("[%d] No Furniture",fcount))
		end
		if ncount>0 then
			print(sf("[%d] NPC Range: 0x%04X-0x%04X",ncount,npcstart,npcend)) else print(sf("[%d] No NPCs",ncount))
		end
		if wcount>0 then
			print(sf("[%d] Warp Range: 0x%04X-0x%04X",wcount,warpstart,warpend)) else print(sf("[%d] No Warps",wcount))
		end
		if tcount>0 then
			print(sf("[%d] Trigger Range: 0x%04X-0x%04X",tcount,trigstart,trigend)) else print(sf("[%d] No Triggers",tcount))
		end
		if md(owstart)~=trigend-3 then print("Error in parsing, please be in game.") else print("Successful Parse!") end
		print("") print("")
	overprint=1
	end
	gt(160,145,sf("Overworld: %5d",mw(zds+2*11)))
    gt(160,155,sf("Script: %8d",mw(zds+2*3)))
	gt(160,165,sf("Text: %10d",mw(zds+2*5)))
	
	flyx=md(zds+2*18)
	flyy=md(zds+2*22)
	flyz=md(zds+2*20)
	if (flyx==5 and flyy==4 and flyz==0) or (flyx==13 and flyy==0 and flyz==5) then
	gt(149,174,sf("Can't Fly to here.")) else
	gt(185,174,sf("FlyTo (XYZ)"))
	gt(185,184,sf("%d,%d,%d",flyx,flyy,flyz)) end

	gt(1,145, sf("SubMap of Map: %3d",mw(zds+2*12)))
        if mw(zds+2*10)%256<255 then
                gt(1,155,sf("Slot Location: %d",mw(zds+2*10)%256)) else gt(1,155,sf("No Encounters Here!")) end
 
        gt(1,165, sf("Current Position"))
        gt(2,175, sf("M: %3d, X: %3X", mw(pos_m), mw(pos_m+0x6)))
	gt(2,184, sf("Y: %3X, Z: %3X", mw(pos_m+0xE), mw(pos_m+0xA)))
end
 

gui.register(main)