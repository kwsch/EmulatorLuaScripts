local rshift, lshift=bit.rshift, bit.lshift
local wd,ww,wb=memory.writedword,memory.writeword,memory.writebyte
local rd,rw,rb=memory.readdwordunsigned,memory.readwordunsigned,memory.readbyteunsigned
mb=function(SRP)
return rb(SRP) 
end
mw=function(SRP)
return rb(SRP)+rb(SRP+1)*0x100 
end
md=function(SRP)
return rb(SRP)+rb(SRP+1)*0x100+rb(SRP+2)*0x10000+rb(SRP+3)*0x1000000
end
local gt,sf=gui.text,string.format
local table={}
local start=md(0x02000024)+0x459A4
local startscr=md(md(0x02000024)+0x459A4)+md(0x02000024)+0x0459A8
local SRP=start
local goscrp=0
local iterhead=0
local iterscr=0
local scrt={}
local scrnum=0
local scrindex=mw(md(0x02000024)+0x41B32)
local printiter=0
local catcherror=1
local itercatch=90000
local goextra=1
local table={}

function main()
--Notify when analysis is starting:
		if SRP==start then	
			print(""..string.format("~Script File %d~",scrindex))
		end

	while goscrp==0 and mw(SRP)~=0xFD13 and mw(SRP)~=0x18D8 and iterhead<900 do 
		readval=md(SRP)
		scrt[scrnum] = readval
		if md(start) > 65535 then 
			print(""..sf("~Error Catch, Start Read Error~",curscr))
			goscrp=-1 end
		SRP=SRP+4
		scrnum=scrnum+1
		if readval==md(SRP)+4 then 
			--do nothing		
		else
		scrnum=scrnum+1 end
		if scrnum>1 then if scrt[scrnum-1]==scrt[scrnum-2]-0x4 then 
			--print(""..sf("Use Previous")) 
			scrnum=scrnum-2
		else
		scrnum=scrnum-1
		print(""..sf("Script %d: %08X",scrnum,readval)) end end
		iterhead=iterhead+1
	end

--Notify that Lua is ready to parse the script data
	if (mw(SRP)==0xFD13 or md(SRP-4)~=0x18D8) and goscrp==0 then
		---print(""..sf("Finished Offset Parse")) 
		goscrp=1					--proceed to next phase
		SRP=SRP+2
		curscr=1

		print(""..sf("~~~~~Script %d~~~~~~",curscr))
		end

--Begin 
	while (goscrp==1 and scrnum>=curscr and catcherror==1 and iterscr<300) or goextra==0 do
			printiter=printiter+1
			if printiter>500 and goextra==0 then SRP=SRP+2 printiter=0 iterscr=0 break end
			if printiter>500 or iterscr>itercatch then 
				print(""..sf("~Error Catch A, Command Read Error~",curscr))
				
				print(""..sf("priter=%d     iterscr=%d          curcmd=%04X nxcmd=%04X",printiter,iterscr,cmd,mw(SRP)))
			if md(SRP-2)==0x2 then print(""..sf("Appears as if there are no more scripts!!\n Check @ 0x%08X",SRP)) end
			catcherror=0
			break 
		end

			iterscr=1
			done=0
		while (done==0 and md(SRP-2)~=0x0002 and (mw(SRP)~=0x5544 or mw(SRP)~=0x0000 or mw(SRP)~=0x4652) and iterscr<300) or goextra==0 do
		if printiter>900 or iterscr>itercatch then 
			
			print(""..sf("~Error Catch B, Command Read Error~",curscr))
			catcherror=0
			break 
		end
			if (md(SRP+4)==0xFE or md(SRP+4)==0x00010FE) then crap=md(SRP) crap2=md(SRP+4) print(""..sf("////////////Unknown Crap %08X %08X",crap,crap2)) SRP=SRP+8
			
			else
			cmd=mw(SRP)
			SRP=SRP+2

			if cmd==0x02 then 
				print(""..sf("End (0x0002)"))
				
				if (mw(SRP)==0x0000 or 0x5544 or 0x0044) then
				curscr=curscr+1
					if scrnum>=curscr then print(""..sf("~~~~~Script %d~~~~~~",curscr)) 
					if (md(SRP+4)==0xFE or md(SRP+4)==0x00010FE) then crap=md(SRP) crap2=md(SRP+4) print(""..sf("////////////Unknown Crap %08X %08X",crap,crap2)) SRP=SRP+8 end
					if (md(SRP+6)==0xFE or md(SRP+6)==0x00010FE) then crap=md(SRP) crap2=md(SRP+4) print(""..sf("////////////Unknown Crap %08X %08X",crap,crap2)) SRP=SRP+10 end
					if (md(SRP+8)==0xFE or md(SRP+8)==0x00010FE) then crap=md(SRP) crap2=md(SRP+4) print(""..sf("////////////Unknown Crap %08X %08X",crap,crap2)) SRP=SRP+11 end
					if (md(SRP+7)==0xFE or md(SRP+7)==0x00010FE) then crap=md(SRP) crap2=md(SRP+4) print(""..sf("////////////Unknown Crap %08X %08X",crap,crap2)) SRP=SRP+9 end
					--printiter=printiter+1
					else done=1 goextra=1
					end 
				end
				
			elseif cmd==0x03 then
				rt=mw(SRP) SRP=SRP+2
				print(""..sf("           ReturnAfterDelay (0x0003) 0x%04X",rt))

			elseif cmd==0x04 then
				rt=md(SRP) SRP=SRP+4
				print(""..sf("CallRoutine (0x0004) 0x%08X",rt))

			elseif cmd==0x05 then 
				print(""..sf("EndSub (0x0005)")) 

			elseif cmd==0x06 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("Logic06 (0x0006)  %s%02X",fa,u16a))  
				
			elseif cmd==0x07 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("****07 (0x0007) %s%d",fa,u16a)) 

			elseif cmd==0x08 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("Logic08 (0x0008)  %s%d",fa,u16a))

			elseif cmd==0x09 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("Logic09 (0x0009)  %s%d",fa,u16a)) 

			elseif cmd==0x0A then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("ClearVar (0x000A)  %s%02X",fa,u16a))  

			elseif cmd==0x0B then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("Logic0B (0x000B)  %s%02X",fa,u16a))  				

			elseif cmd==0x0C then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("Logic0C (0x000C)  %s%02X",fa,u16a))  

			elseif cmd==0x0D then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("Logic0D (0x000D)  %s%02X",fa,u16a))  
			elseif cmd==0x0E then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("Logic0E (0x000E)  %s%02X",fa,u16a))  
			elseif cmd==0x0F then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("Logic0F (0x000F)  %s%02X",fa,u16a))  				
				
				
				
			elseif cmd==0x10 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("Readflag (0x0010)  %s%d",fa,u16a)) 

			elseif cmd==0x11 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("Condition (0x0011)  %s%d",fa,u16a)) 

			elseif cmd==0x19 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("CompareAtoB (0x0019) A=%s%d B=%s%d",fa,u16a,fb,u16b))


				
				
				
			elseif cmd==0x1C then
				std=mw(SRP) SRP=SRP+2
				print(""..sf("CallStd (0x001C) 0x%04X",std))

			elseif cmd==0x1D then
				std=mb(SRP) SRP=SRP+0
				print(""..sf("EndStdReturn[**] (0x001D)"))

			elseif cmd==0x1E then
				jump=md(SRP) SRP=SRP+4
				print(""..sf("GoTo (0x001E) jump=0x%08X",jump))

			elseif cmd==0x1F then
				logic=mb(SRP) SRP=SRP+1
				jump=md(SRP) SRP=SRP+4
				print(""..sf("IfThenGoTo (0x001F) 0x%02X jump=0x%08X",logic,jump))
				
				

			elseif cmd==0x21 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("????21 (0x0021)  %s%d",fa,u16a)) 

			elseif cmd==0x22 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("????22 (0x0022)  %s%d",fa,u16a)) 

			elseif cmd==0x23 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("SetFlag (0x0023)  %s%d",fa,u16a))  

			elseif cmd==0x24 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("ClearFlag (0x0023)  %s%d",fa,u16a)) 
				
			elseif cmd==0x25 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("SetVarEq25 (0x0025) %s%d %s%d",fa,u16a,fb,u16b)) 

			elseif cmd==0x26 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("SetVarEqCont (0x0028) %s%d %s%d",fa,u16a,fb,u16b)) 

			elseif cmd==0x27 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("SetVar27 (0x0027) %s%d %s%d",fa,u16a,fb,u16b)) 

			elseif cmd==0x28 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("SetVarEqVal (0x0028) %s%d %s%d",fa,u16a,fb,u16b)) 

			elseif cmd==0x29 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("SetVar29 (0x0029) %s%d %s%d",fa,u16a,fb,u16b)) 

			elseif cmd==0x2A then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("SetVarEq2A (0x002A) %s%d %s%d",fa,u16a,fb,u16b)) 

			elseif cmd==0x2B then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("SetVarEq2B (0x002B) %s%d %s%d",fa,u16a,fb,u16b)) 

			elseif cmd==0x2E then 
				print(""..sf("LockAll (0x002E)"))  

			elseif cmd==0x2F then 
				print(""..sf("UnlockAll (0x002F)"))

			elseif cmd==0x30 then 
				print(""..sf("WaitMoment (0x0030)"))
				
			elseif cmd==0x31 then 
				print(""..sf("WaitFewSeconds [UNUSED]! (0x0031)"))
		
			elseif cmd==0x32 then 
				print(""..sf("WaitKeyPress (0x0032)"))

			elseif cmd==0x33 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("EventMessage (0x0033) id=%s%d",fa,u16a))

			elseif cmd==0x34 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("GreyMessage (0x0034) id=%s%d view=%s%d",fa,u16a,fb,u16b))

			elseif cmd==0x35 then 
				print(""..sf("CloseEventMessage (0x0035)"))

			elseif cmd==0x36 then 
				print(""..sf("CloseGreyMessage (0x0036)"))

			elseif cmd==0x38 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u8a=mb(SRP) SRP=SRP+1
					if u8a/0x8000>=1 then fb="Var_" u8a=u8a%0x4000
					elseif u8a/0x4000>=1 then fb="Cont_" u8a=u8a%0x4000
					else fb="Num_"
					end
				print(""..sf("BubbleMessage (0x0038) %s%d %s%d",fa,u16a,fb,u8a)) 

			elseif cmd==0x39 then 
				print(""..sf("CloseBubbleMessage (0x0039)"))

			elseif cmd==0x3C then
				u8a=mb(SRP) SRP=SRP+1
				u8b=mb(SRP) SRP=SRP+1
				mid=mw(SRP)  SRP=SRP+2
					if mid/0x8000>=1 then fm="Var_" mid=mid%0x4000
					elseif mid/0x4000>=1 then fm="Cont_" mid=mid%0x4000
					else fm="Num_"
					end
				npc=mw(SRP) SRP=SRP+2
				view=mw(SRP) SRP=SRP+2
				type=mw(SRP) SRP=SRP+2
				print(""..sf("Message1 (0x003C) MID=%s%X NPC=%d",fm,mid,npc))

			elseif cmd==0x3D then
				u8a=mb(SRP) SRP=SRP+1
				u8b=mb(SRP) SRP=SRP+1
				mid=mw(SRP)  SRP=SRP+2
					if mid/0x8000>=1 then fm="Var_" mid=mid%0x4000
					elseif mid/0x4000>=1 then fm="Cont_" mid=mid%0x4000
					else fm="Num_"
					end
				view=mw(SRP) SRP=SRP+2
				type=mw(SRP) SRP=SRP+2
				print(""..sf("Message2 (0x003D) 0x%X 0x%X mid=%s%X view=%d type=%d",u8a,u8b,fm,mid,view,type))

			elseif cmd==0x3E then 
				print(""..sf("CloseMessage (0x003E)"))

			elseif cmd==0x3F then 
				print(""..sf("CloseMessage2[*] (0x003F)"))

			elseif cmd==0x40 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("PopMoneyBox (0x0027) X=%s%d Y=%s%d",fa,u16a,fb,u16b)) 

			elseif cmd==0x41 then 
				print(""..sf("CloseMoneyBox (0x0041)"))

			elseif cmd==0x42 then 
				print(""..sf("UpdateMoneyBox (0x0042)"))

			elseif cmd==0x43 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("BorderMessage (0x0028) id=%s%d color=%s%d",fa,u16a,fb,u16b)) 

			elseif cmd==0x44 then 
				print(""..sf("CloseBorderMessage (0x0044)")) 

			elseif cmd==0x47 then
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("PopYesNoVar (0x0047) %s%d",fa,u16a))


			elseif cmd==0x48 then 
				u8a=mw(SRP) SRP=SRP+1
					if 	u8a/0x8000>=1 then 	f1="Var_"  u8a=u8a%0x4000
					elseif 	u8a/0x4000>=1 then 	f1="Cont_" u8a=u8a%0x4000
					else 				f1=""
					end
				u8b=mw(SRP) SRP=SRP+1
					if 	u8b/0x8000>=1 then 	f2="Var_"  u8b=u8b%0x4000
					elseif 	u8b/0x4000>=1 then 	f2="Cont_" u8b=u8b%0x4000
					else 				f2=""
					end
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa=""
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb=""
					end
				u16c=mw(SRP) SRP=SRP+2
					if 	u16c/0x8000>=1 then 	fc="Var_"  u16c=u16c%0x4000
					elseif 	u16c/0x4000>=1 then 	fc="Cont_" u16c=u16c%0x4000
					else 				fc=""
					end
				u16d=mw(SRP) SRP=SRP+2
					if 	u16d/0x8000>=1 then 	fd="Var_"  u16d=u16d%0x4000
					elseif 	u16d/0x4000>=1 then 	fd="Cont_" u16d=u16d%0x4000
					else 				fd=""
					end
				u16e=mw(SRP) SRP=SRP+2
					if 	u16e/0x8000>=1 then 	fe="Var_"  u16e=u16e%0x4000
					elseif 	u16e/0x4000>=1 then 	fe="Cont_" u16e=u16e%0x4000
					else 				fe=""
					end
				print(""..sf("Message3 (0x0048) %s0x%d %s0x%d %s%d %s%d %s%d %s%d %s%d",f1,u8a,f2,u8b,fa,u16a,fb,u16b,fc,u16c,fd,u16d,fe,u16e))

			elseif cmd==0x49 then 
				u8a=mw(SRP) SRP=SRP+1
					if 	u8a/0x8000>=1 then 	f1="Var_"  u8a=u8a%0x4000
					elseif 	u8a/0x4000>=1 then 	f1="Cont_" u8a=u8a%0x4000
					else 				f1=""
					end
				u8b=mw(SRP) SRP=SRP+1
					if 	u8b/0x8000>=1 then 	f2="Var_"  u8b=u8b%0x4000
					elseif 	u8b/0x4000>=1 then 	f2="Cont_" u8b=u8b%0x4000
					else 				f2=""
					end
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa=""
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb=""
					end
				u16c=mw(SRP) SRP=SRP+2
					if 	u16c/0x8000>=1 then 	fc="Var_"  u16c=u16c%0x4000
					elseif 	u16c/0x4000>=1 then 	fc="Cont_" u16c=u16c%0x4000
					else 				fc=""
					end
				u16d=mw(SRP) SRP=SRP+2
					if 	u16d/0x8000>=1 then 	fd="Var_"  u16d=u16d%0x4000
					elseif 	u16d/0x4000>=1 then 	fd="Cont_" u16d=u16d%0x4000
					else 				fd=""
					end
				u16e=mw(SRP) SRP=SRP+2
					if 	u16e/0x8000>=1 then 	fe="Var_"  u16e=u16e%0x4000
					elseif 	u16e/0x4000>=1 then 	fe="Cont_" u16e=u16e%0x4000
					else 				fe=""
					end
				print(""..sf("VersionMessage (0x0049) %s%d %s%d bmid=%s%d wmid=%s%d npc=%s%d view=%s%d type=%s%d",f1,u8a,f2,u8b,fa,u16a,fb,u16b,fc,u16c,fd,u16d,fe,u16e))

			elseif cmd==0x4A then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u8a=mw(SRP) SRP=SRP+1
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("AngryMessage (0x004A) NPC=%s%d unk=0x%X view=%s%d",fa,u16a,u8a,fb,u16b))

			elseif cmd==0x4B then 
				print(""..sf("CloseAnyMessage (0x004B)"))

			elseif cmd==0x4C then 
				u8a=mb(SRP) SRP=SRP+1
				print(""..sf("???? (0x004C), 0x%02X",u8a))

			elseif cmd==0x4D then 
				u8a=mb(SRP) SRP=SRP+1
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("StoreVarTextItem (0x004D) unk1=0x%X %s%d",u8a,fa,u16a)) 


			elseif cmd==0x4E then 
				u8a=mb(SRP) SRP=SRP+1
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				u8b=mb(SRP) SRP=SRP+1
				print(""..sf("???? (0x004E) unk1=0x%X A=%s%d B=%s%d unk2=0x%X",u8a,fa,u16a,fb,u16b,u8b)) 

			elseif cmd==0x4F then 
				u8a=mb(SRP) SRP=SRP+1
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				u8b=mb(SRP) SRP=SRP+1
				u16c=mw(SRP) SRP=SRP+2
					if 	u16c/0x8000>=1 then 	fc="Var_"  u16c=u16c%0x4000
					elseif 	u16c/0x4000>=1 then 	fc="Cont_" u16c=u16c%0x4000
					else 				fc=""
					end
				print(""..sf("???? (0x004F) unk1=0x%X A=%s%d B=%s%d unk2=0x%X C=%s%d",u8a,fa,u16a,fb,u16b,u8b,fc,u16c)) 
				
				
			elseif cmd==0x51 then 
				u8a=mb(SRP) SRP=SRP+1
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
			print(""..sf("SetVarMove (0x0051) unk=0x%X A=%s%d",u8a,fa,u16a))				
				
			elseif cmd==0x52 then 
				u8a=mb(SRP) SRP=SRP+1
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
			print(""..sf("SetVarBag (0x0052) unk=0x%X A=%s%d",u8a,fa,u16a))

			elseif cmd==0x53 then 
				u8a=mb(SRP) SRP=SRP+1
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
			print(""..sf("SetVarPartyPKM (0x0053) unk=0x%X A=%s%d",u8a,fa,u16a))

			elseif cmd==0x54 then 
				u8a=mb(SRP) SRP=SRP+1
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
			print(""..sf("SetVarPartyPKM2 (0x0054) unk=0x%X A=%s%d",u8a,fa,u16a))

			elseif cmd==0x55 then 
				u8a=mb(SRP) SRP=SRP+1
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
			print(""..sf("SetVarType (0x0055) unk=0x%X A=%s%d",u8a,fa,u16a))

			elseif cmd==0x56 then 
				u8a=mb(SRP) SRP=SRP+1
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
			print(""..sf("SetVarType (0x0056) unk=0x%X A=%s%d",u8a,fa,u16a))

			elseif cmd==0x57 then 
				u8a=mb(SRP) SRP=SRP+1
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
			print(""..sf("SetVar???? (0x0057) unk=0x%X A=%s%d",u8a,fa,u16a))

			elseif cmd==0x58 then 
				u8a=mb(SRP) SRP=SRP+1
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
			print(""..sf("SetVar???? (0x0058) unk=0x%X A=%s%d",u8a,fa,u16a))

			elseif cmd==0x59 then 
				u8a=mb(SRP) SRP=SRP+1
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
			print(""..sf("SetVar???? (0x0059) unk=0x%X A=%s%d",u8a,fa,u16a))
			
			elseif cmd==0x5B then 
				u8a=mb(SRP) SRP=SRP+1
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
			print(""..sf("SetVar???? (0x005B) unk=0x%X A=%s%d",u8a,fa,u16a))			

			elseif cmd==0x5C then 
				u8a=mb(SRP) SRP=SRP+1
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("SetVar??? (0x005C) unk=0x%02X A=%s%d B=%s%d",u8a,fa,u16a,fb,u16b)) 
			
			elseif cmd==0x5D then 		
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("SetVarMusicInfo?? (0x005D) X=%s%d  Z=%s%d",fa,u16a,fb,u16b))				
			
			
			elseif cmd==0x5E then 				
				u8a=mb(SRP) SRP=SRP+1
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("SetVar?? (0x005E) unk=0x%X A=%s%d ",u8a,fa,u16a))

			elseif cmd==0x5F then 				
				u8a=mb(SRP) SRP=SRP+1
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("SetVar?? (0x005F) unk=0x%X A=%s%d ",u8a,fa,u16a))				
			
			elseif cmd==0x60 then 				
				u8a=mb(SRP) SRP=SRP+1
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("SetVar?? (0x0060) unk=0x%X A=%s%d ",u8a,fa,u16a))
			
			elseif cmd==0x61 then 
				u8a=mb(SRP) SRP=SRP+1
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
			print(""..sf("SetVar???? (0x0058) unk=0x%X A=%s%d",u8a,fa,u16a))

			elseif cmd==0x62 then 				
				u8a=mb(SRP) SRP=SRP+1
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("SetVar?? (0x0062) unk=0x%X A=%s%d ",u8a,fa,u16a))			
			
			elseif cmd==0x63 then 				
				u8a=mb(SRP) SRP=SRP+1
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("SetVar?? (0x0063) unk=0x%X A=%s%d ",u8a,fa,u16a))			
			
			elseif cmd==0x64 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u32a=md(SRP) SRP=SRP+4
				print(""..sf("Movement[***] (0x0064) A=%s%d B=%08X",fa,u16a,u32a)) 

			elseif cmd==0x65 then 
				print(""..sf("WaitMovement (0x0065)"))
				
			elseif cmd==0x66 then 		
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("StoreHeroPosition (0x0066) X=%s%d  Z=%s%d",fa,u16a,fb,u16b))				

			elseif cmd==0x67 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa=""
					end
					varct67=0
				while mw(SRP)>=0x8000 do
					varct67=varct67+1
					SRP=SRP+2 end
				print(""..sf("MultiVar???? (0x0067)  %s%d vars total=%d",fa,u16a,varct67)) 

			elseif cmd==0x68 then 		
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("StoreHeroPosition (0x0068) X=%s%d  Z=%s%d",fa,u16a,fb,u16b))

			elseif cmd==0x69 then
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb="Num_"
					end
				u16c=mw(SRP) SRP=SRP+2
					if 	u16c/0x8000>=1 then 	fc="Var_"  u16c=u16c%0x4000
					elseif 	u16c/0x4000>=1 then 	fc="Cont_" u16c=u16c%0x4000
					else 				fc="Num_"
					end
				print(""..sf("StoreNPCPosition (0x0069) NPC=%s%d X=%s%d Z=%s%d",fa,u16a,fb,u16b,fc,u16c))

			elseif cmd==0x6A then 		
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("????? (0x006A) X=%s%d  Z=%s%d",fa,u16a,fb,u16b))
				
			elseif cmd==0x6B then
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("AddNPC (0x06B) %s%d",fa,u16a))

			elseif cmd==0x6C then
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("RemoveNPC (0x06C) %s%d",fa,u16a))

			elseif cmd==0x6D then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa=""
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb=""
					end
				u16c=mw(SRP) SRP=SRP+2
					if u16c/0x8000>=1 then fc="Var_" u16c=u16c%0x4000
					elseif u16c/0x4000>=1 then fc="Cont_" u16c=u16c%0x4000
					else fc=""
					end
				u16d=mw(SRP) SRP=SRP+2
					if u16d/0x8000>=1 then fd="Var_" u16d=u16d%0x4000
					elseif u16d/0x4000>=1 then fd="Cont_" u16d=u16d%0x4000
					else fd=""
					end
				u16e=mw(SRP) SRP=SRP+2
					if u16e/0x8000>=1 then fe="Var_" u16e=u16e%0x4000
					elseif u16e/0x4000>=1 then fe="Cont_" u16e=u16e%0x4000
					else fe=""
					end
				print(""..sf("SetOWPos (0x006D) npc=%s%d x=%s%d y=%s%d z=%s%d dir=%s%d",fa,u16a,fb,u16b,fc,u16c,fd,u16d,fe,u16e))  

			elseif cmd==0x6F then
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("???6F (0x06F) %s%d",fa,u16a))				
				
			elseif cmd==0x6E then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("???? (0x006E)  %s%d",fa,u16a)) 
				
			elseif cmd==0x70 then 
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa=""
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb=""
					end
				u16c=mw(SRP) SRP=SRP+2
					if 	u16c/0x8000>=1 then 	fc="Var_"  u16c=u16c%0x4000
					elseif 	u16c/0x4000>=1 then 	fc="Cont_" u16c=u16c%0x4000
					else 				fc=""
					end
				u16d=mw(SRP) SRP=SRP+2
					if 	u16d/0x8000>=1 then 	fd="Var_"  u16d=u16d%0x4000
					elseif 	u16d/0x4000>=1 then 	fd="Cont_" u16d=u16d%0x4000
					else 				fd=""
					end
				u16e=mw(SRP) SRP=SRP+2
					if 	u16e/0x8000>=1 then 	fe="Var_"  u16e=u16e%0x4000
					elseif 	u16e/0x4000>=1 then 	fe="Cont_" u16e=u16e%0x4000
					else 				fe=""
					end
				print(""..sf("???? (0x0070)  %s%d %s%d %s%d %s%d %s%d",fa,u16a,fb,u16b,fc,u16c,fd,u16d,fe,u16e))
				

			elseif cmd==0x71 then
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb="Num_"
					end
				u16c=mw(SRP) SRP=SRP+2
					if 	u16c/0x8000>=1 then 	fc="Var_"  u16c=u16c%0x4000
					elseif 	u16c/0x4000>=1 then 	fc="Cont_" u16c=u16c%0x4000
					else 				fc="Num_"
					end
				print(""..sf("?TriVar? (0x0071) A=%s%d B=%s%d C=%s%d",fa,u16a,fb,u16b,fc,u16c))
				
			elseif cmd==0x72 then
				u16p=mb(SRP) SRP=SRP+2
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb="Num_"
					end
				u16c=mw(SRP) SRP=SRP+2
					if 	u16c/0x8000>=1 then 	fc="Var_"  u16c=u16c%0x4000
					elseif 	u16c/0x4000>=1 then 	fc="Cont_" u16c=u16c%0x4000
					else 				fc="Num_"
					end
				print(""..sf("?TriVar2? (0x0072) unk=0x%04X A=%s%d B=%s%d C=%s%d",u16p,fa,u16a,fb,u16b,fc,u16c))

			elseif cmd==0x73 then 		
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("???????? (0x0073) X=%s%d  Z=%s%d",fa,u16a,fb,u16b))
				
			elseif cmd==0x74 then
				print(""..sf("FacePlayer"))

			elseif cmd==0x75 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("?ReleaseNPC? (0x0075)  %s%02X",fa,u16a)) 

			elseif cmd==0x7F then 		
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("???????? (0x007F) X=%s%d  Z=%s%d",fa,u16a,fb,u16b))

			elseif cmd==0xB0 then 
				print(""..sf("???? (0x0077)"))

			elseif cmd==0x78 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("Lock78 (0x0078)  %s%02X",fa,u16a)) 
				
			elseif cmd==0x7B then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa=""
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb=""
					end
				u16c=mw(SRP) SRP=SRP+2
					if u16c/0x8000>=1 then fc="Var_" u16c=u16c%0x4000
					elseif u16c/0x4000>=1 then fc="Cont_" u16c=u16c%0x4000
					else fc=""
					end
				u16d=mw(SRP) SRP=SRP+2
					if u16d/0x8000>=1 then fd="Var_" u16d=u16d%0x4000
					elseif u16d/0x4000>=1 then fd="Cont_" u16d=u16d%0x4000
					else fd=""
					end
				print(""..sf("RelocateNPC (0x007B) npc=%s%d X=%s%d Y=%s%d Z=%s%d",fa,u16a,fb,u16b,fc,u16c,fd,u16d))  
				

			elseif cmd==0x7C then
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb="Num_"
					end
				u16c=mw(SRP) SRP=SRP+2
					if 	u16c/0x8000>=1 then 	fc="Var_"  u16c=u16c%0x4000
					elseif 	u16c/0x4000>=1 then 	fc="Cont_" u16c=u16c%0x4000
					else 				fc="Num_"
					end
				print(""..sf("?????????? (0x007C) A=%s%d B=%s%d C=%s%d",fa,u16a,fb,u16b,fc,u16c))

			elseif cmd==0x82 then 		
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("???????? (0x0082) X=%s%d  Z=%s%d",fa,u16a,fb,u16b))				

			elseif cmd==0x83 then
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("????SetVar??? (0x0083) %s%d",fa,u16a))
				
			elseif cmd==0x84 then
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("????SetVar??? (0x0084) %s%d",fa,u16a))

			elseif cmd==0x85 then
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb="Num_"
					end
				u16c=mw(SRP) SRP=SRP+2
					if 	u16c/0x8000>=1 then 	fc="Var_"  u16c=u16c%0x4000
					elseif 	u16c/0x4000>=1 then 	fc="Cont_" u16c=u16c%0x4000
					else 				fc="Num_"
					end
				print(""..sf("TrBattle (0x0085) Opp1=%s%d Opp2=%s%d Logic=%s%d",fa,u16a,fb,u16b,fc,u16c))
				
			elseif cmd==0x86 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa=""
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb=""
					end
				u16c=mw(SRP) SRP=SRP+2
					if u16c/0x8000>=1 then fc="Var_" u16c=u16c%0x4000
					elseif u16c/0x4000>=1 then fc="Cont_" u16c=u16c%0x4000
					else fc=""
					end
				u16d=mw(SRP) SRP=SRP+2
					if u16d/0x8000>=1 then fd="Var_" u16d=u16d%0x4000
					elseif u16d/0x4000>=1 then fd="Cont_" u16d=u16d%0x4000
					else fd=""
					end
				print(""..sf("DoubleBattle (0x0086) ally=%s%d opp1=%s%d opp2=%s%d logic=%s%d",fa,u16a,fb,u16b,fc,u16c,fd,u16d))  
				
				
			elseif cmd==0x87 then
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb="Num_"
					end
				u16c=mw(SRP) SRP=SRP+2
					if 	u16c/0x8000>=1 then 	fc="Var_"  u16c=u16c%0x4000
					elseif 	u16c/0x4000>=1 then 	fc="Cont_" u16c=u16c%0x4000
					else 				fc="Num_"
					end
				print(""..sf("??TRIVAR?? (0x0087) A=%s%d B=%s%d C=%s%d",fa,u16a,fb,u16b,fc,u16c))
				
			elseif cmd==0x88 then
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb="Num_"
					end
				u16c=mw(SRP) SRP=SRP+2
					if 	u16c/0x8000>=1 then 	fc="Var_"  u16c=u16c%0x4000
					elseif 	u16c/0x4000>=1 then 	fc="Cont_" u16c=u16c%0x4000
					else 				fc="Num_"
					end
				print(""..sf("??TRIVAR?? (0x0088) A=%s%d B=%s%d C=%s%d",fa,u16a,fb,u16b,fc,u16c))
				
				
			elseif cmd==0x8A then
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb="Num_"
					end
				print(""..sf("???? (0x008A) A=%s%d B=%s%d",fa,u16a,fb,u16b))

			elseif cmd==0x8B then
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("SetVarTrMusic (0x008B) %s%d",fa,u16a))				

			elseif cmd==0x8C then 
				print(""..sf("EndBattle (0x008C)")) 

			elseif cmd==0x8D then
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("SetVarBattleResult (0x008D) %s%d",fa,u16a))

			elseif cmd==0x8E then 
				print(""..sf("DisableTrainer (0x008E)")) 
				
			elseif cmd==0x92 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("**DualVars?** (0x0092) A=%s%d B=%s%d",fa,u16a,fb,u16b))	

			elseif cmd==0x93 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("**DualVars?** (0x0093) A=%s%d B=%s%d",fa,u16a,fb,u16b))					
				
			elseif cmd==0x95 then
				u16a=mw(SRP) SRP=SRP+2
				print(""..sf("???? (0x0095) id=0x%X",u16a))				
				
			elseif cmd==0x97 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("??? (0x0097) A=%s%d B=%s%d",fa,u16a,fb,u16b))				

			elseif cmd==0x98 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa=""
					end
				print(""..sf("ChangeMusicTo (0x0098) %s0x%0X",fa,u16a)) 

			elseif cmd==0x9E then 
				print(""..sf("????? (0x009E)"))

			elseif cmd==0xA6 then
				u16a=mw(SRP) SRP=SRP+2
				print(""..sf("PlaySound (0x00A6) id=0x%X",u16a))
				
			elseif cmd==0xA7 then 
				print(""..sf("WaitSound[**] (0x00AC)")) 				

			elseif cmd==0xA8 then 
				print(""..sf("StopSound[**] (0x00AC)")) 

			elseif cmd==0xA9 then
				u16a=mw(SRP) SRP=SRP+2
				print(""..sf("Fanfare (0x00A9) id=0x%X",u16a))

			elseif cmd==0xAA then
				print(""..sf("WaitFanfare (0x00AA)"))

			elseif cmd==0xAB then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("PlayCry (0x00AB) dexID=%s%d strain=%s%d",fa,u16a,fb,u16b)) 

			elseif cmd==0xAC then 
				print(""..sf("Waitcry (0x00AC)")) 

			elseif cmd==0xAF then
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb="Num_"
					end
				u16c=mw(SRP) SRP=SRP+2
					if 	u16c/0x8000>=1 then 	fc="Var_"  u16c=u16c%0x4000
					elseif 	u16c/0x4000>=1 then 	fc="Cont_" u16c=u16c%0x4000
					else 				fc="Num_"
					end
				print(""..sf("ScriptText??? (0x00AF) A=%s%d B=%s%d C=%s%d",fa,u16a,fb,u16b,fc,u16c))

			elseif cmd==0xB0 then 
				print(""..sf("CloseMulti (0x00B0)"))

			elseif cmd==0xB2 then 
				u8a=mw(SRP) SRP=SRP+1
				u8b=mw(SRP) SRP=SRP+1
				u8c=mw(SRP) SRP=SRP+1
				u8d=mw(SRP) SRP=SRP+1
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa=""
					end
				u8e=mw(SRP) SRP=SRP+1
				print(""..sf("?????Multi2 (0x00B2) A=0x%X B=0x%X C=0x%X D=0x%X 16=%s0x%X E=%d",u8a,u8b,u8c,u8d,fa,u16a,u8e))  

			elseif cmd==0xB3 then 
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa=""
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb=""
					end
				u16c=mw(SRP) SRP=SRP+2
					if 	u16c/0x8000>=1 then 	fc="Var_"  u16c=u16c%0x4000
					elseif 	u16c/0x4000>=1 then 	fc="Cont_" u16c=u16c%0x4000
					else 				fc=""
					end
				u16d=mw(SRP) SRP=SRP+2
					if 	u16d/0x8000>=1 then 	fd="Var_"  u16d=u16d%0x4000
					elseif 	u16d/0x4000>=1 then 	fd="Cont_" u16d=u16d%0x4000
					else 				fd=""
					end
				print(""..sf("????? (0x00B3) A=%s%d B=%s%d C=%s%d D=%s%d",fa,u16a,fb,u16b,fc,u16c,fd,u16d))

			elseif cmd==0xB4 then 
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa=""
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb=""
					end
				u16c=mw(SRP) SRP=SRP+2
					if 	u16c/0x8000>=1 then 	fc="Var_"  u16c=u16c%0x4000
					elseif 	u16c/0x4000>=1 then 	fc="Cont_" u16c=u16c%0x4000
					else 				fc=""
					end
				print(""..sf("????? (0x00B4) A=%s%d B=%s%d C=%s%d D=%s%d",fa,u16a,fb,u16b,fc,u16c,fd,u16d))

			elseif cmd==0xB5 then 
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb="Num_"
					end
				u16c=mw(SRP) SRP=SRP+2
					if 	u16c/0x8000>=1 then 	fc="Var_"  u16c=u16c%0x4000
					elseif 	u16c/0x4000>=1 then 	fc="Cont_" u16c=u16c%0x4000
					else 				fc="Num_"
					end
				print(""..sf("???? (0x00B5) A=%s%d B=%s%d C=%s%d",fa,u16a,fb,u16b,fc,u16c))
				

			elseif cmd==0xB6 then 
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa=""
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb=""
					end
				u16c=mw(SRP) SRP=SRP+2
					if 	u16c/0x8000>=1 then 	fc="Var_"  u16c=u16c%0x4000
					elseif 	u16c/0x4000>=1 then 	fc="Cont_" u16c=u16c%0x4000
					else 				fc=""
					end
				u16d=mw(SRP) SRP=SRP+2
					if 	u16d/0x8000>=1 then 	fd="Var_"  u16d=u16d%0x4000
					elseif 	u16d/0x4000>=1 then 	fd="Cont_" u16d=u16d%0x4000
					else 				fd=""
					end
				print(""..sf("????? (0x00B6) A=%s%d B=%s%d C=%s%d D=%s%d",fa,u16a,fb,u16b,fc,u16c,fd,u16d))


			elseif cmd==0xB7 then
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb="Num_"
					end
				u16c=mw(SRP) SRP=SRP+2
					if 	u16c/0x8000>=1 then 	fc="Var_"  u16c=u16c%0x4000
					elseif 	u16c/0x4000>=1 then 	fc="Cont_" u16c=u16c%0x4000
					else 				fc="Num_"
					end
				print(""..sf("?????? (0x00B7) A=%s%d B=%s%d C=%s%d",fa,u16a,fb,u16b,fc,u16c))


			elseif cmd==0xB8 then 
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb="Num_"
					end
				u16c=mw(SRP) SRP=SRP+2
					if 	u16c/0x8000>=1 then 	fc="Var_"  u16c=u16c%0x4000
					elseif 	u16c/0x4000>=1 then 	fc="Cont_" u16c=u16c%0x4000
					else 				fc="Num_"
					end
				print(""..sf("StoreVarBattle (0x00B8) A=%s%d B=%s%d C=%s%d",fa,u16a,fb,u16b,fc,u16c))

			elseif cmd==0xBA then 
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb="Num_"
					end
				print(""..sf("???? (0x00BA) A=%s%d B=%s%d",fa,u16a,fb,u16b))
				
			elseif cmd==0xBB then 
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb="Num_"
					end
				print(""..sf("???? (0x00BB) V1=%s%d V2=%s%d",fa,u16a,fb,u16b))				

			elseif cmd==0xBC then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("?????? (0x00BC) V=%s%d",fa,u16a)) 				
				
				
			elseif cmd==0xBF then 
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa=""
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb=""
					end
				u16c=mw(SRP) SRP=SRP+2
					if 	u16c/0x8000>=1 then 	fc="Var_"  u16c=u16c%0x4000
					elseif 	u16c/0x4000>=1 then 	fc="Cont_" u16c=u16c%0x4000
					else 				fc=""
					end
				u16d=mw(SRP) SRP=SRP+2
					if 	u16d/0x8000>=1 then 	fd="Var_"  u16d=u16d%0x4000
					elseif 	u16d/0x4000>=1 then 	fd="Cont_" u16d=u16d%0x4000
					else 				fd=""
					end
				print(""..sf("WarpSpin (0x00BF) Map=%s%d X=%s%d Y=%s%d Z=%s%d",fa,u16a,fb,u16b,fc,u16c,fd,u16d))


			elseif cmd==0xC2 then 
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa=""
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb=""
					end
				u16c=mw(SRP) SRP=SRP+2
					if 	u16c/0x8000>=1 then 	fc="Var_"  u16c=u16c%0x4000
					elseif 	u16c/0x4000>=1 then 	fc="Cont_" u16c=u16c%0x4000
					else 				fc=""
					end
				u16d=mw(SRP) SRP=SRP+2
					if 	u16d/0x8000>=1 then 	fd="Var_"  u16d=u16d%0x4000
					elseif 	u16d/0x4000>=1 then 	fd="Cont_" u16d=u16d%0x4000
					else 				fd=""
					end
				print(""..sf("TeleportWarpC2 (0x00C2) Map=%s%d X=%s%d Z=%s%d Face=%s%d",fa,u16a,fb,u16b,fc,u16c,fd,u16d))

			elseif cmd==0xC3 then 
				print(""..sf("WarpUnion (0x00C3)")) 					
				
			elseif cmd==0xC4 then 
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa=""
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb=""
					end
				u16c=mw(SRP) SRP=SRP+2
					if 	u16c/0x8000>=1 then 	fc="Var_"  u16c=u16c%0x4000
					elseif 	u16c/0x4000>=1 then 	fc="Cont_" u16c=u16c%0x4000
					else 				fc=""
					end
				u16d=mw(SRP) SRP=SRP+2
					if 	u16d/0x8000>=1 then 	fd="Var_"  u16d=u16d%0x4000
					elseif 	u16d/0x4000>=1 then 	fd="Cont_" u16d=u16d%0x4000
					else 				fd=""
					end
				u16e=mw(SRP) SRP=SRP+2
					if 	u16e/0x8000>=1 then 	fe="Var_"  u16e=u16e%0x4000
					elseif 	u16e/0x4000>=1 then 	fe="Cont_" u16e=u16e%0x4000
					else 				fe=""
					end
				print(""..sf("WarpC4 (0x00C4) Map=%s%d X=%s%d Y=%s%d Z=%s%d Face=%s%d",fa,u16a,fb,u16b,fc,u16c,fd,u16d,fe,u16e))

				
				
			elseif cmd==0xC5 then 
				print(""..sf("AnimSurf (0x00C5)")) 				
				
			elseif cmd==0xC6 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("Anim1 (0x00C6) A=%s%d",fa,u16a)) 				
				
			elseif cmd==0xC7 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("Anim2 (0x00C7) A=%s%d B=%s%d",fa,u16a,fb,u16b)) 
				
			elseif cmd==0xC8 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("Anim3-CALL? (0x00C7) A=%s%d B=%s%d",fa,u16a,fb,u16b)) 				

			elseif cmd==0xCB then
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
				print(""..sf("StoreRand (0x00CB) %s%d rand(0x%X)",fa,u16a,u16b)) 


			elseif cmd==0xCC then
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("SetVarQualItem (0x00CC) %s%d",fa,u16a))

			elseif cmd==0xCD then
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("SetVarQual???? (0x00CD) %s%d",fa,u16a))

			elseif cmd==0xCE then
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("SetVarQual???? (0x00CE) %s%d",fa,u16a))

			elseif cmd==0xCF then
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("SetVarQual???? (0x00CF) %s%d",fa,u16a))

			elseif cmd==0xD0 then
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb="Num_"
					end
				print(""..sf("??VARONLY?? (0x00D0) A=%s%d B=%s%d",fa,u16a,fb,u16b))

			elseif cmd==0xD1 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("?????? (0x00D1) A=%s%d B=%s%d",fa,u16a,fb,u16b)) 

			elseif cmd==0xD2 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("?????? (0x00D2) A=%s%d",fa,u16a)) 
				
			elseif cmd==0xD3 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("?????? (0x00D3) A=%s%d",fa,u16a)) 
				
			elseif cmd==0xD4 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb=""
					end
				print(""..sf("StoreVar???? (0x00D4) %s%d badge=%s%d",fa,u16a,fb,u16b))				

			elseif cmd==0xD5 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb=""
					end
				print(""..sf("StoreVarBadge (0x00D5) %s%d badge=%s%d",fa,u16a,fb,u16b))

			elseif cmd==0xD7 then
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("BadgeVar?? (0x0D7) %s%d",fa,u16a))
				
			elseif cmd==0xDD then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb=""
					end
				print(""..sf("StoreVar??/ (0x00DD) unk=%s%d A=%s%d",fa,u16a,fb,u16b))				

			elseif cmd==0xE0 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("SetVarE0 (0x00E0)  %s%02X",fa,u16a))

			elseif cmd==0xE1 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("SetVarE1 (0x00E1)  %s%02X",fa,u16a))    
				
			elseif cmd==0xE5 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb=""
					end
				print(""..sf("StoreVarE5 (0x00E5) %s%d badge=%s%d",fa,u16a,fb,u16b))					
				
			elseif cmd==0xEA then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("SetVarEA (0x00EA)  %s%02X",fa,u16a))   

			elseif cmd==0xEB then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("SetVarEB (0x00EB)  %s%02X",fa,u16a))	
				
			elseif cmd==0xEC then 
				print(""..sf("??EC (0x00EC)"))

			elseif cmd==0xED then 
				print(""..sf("??ED (0x00ED)"))				

			elseif cmd==0xEE then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("SetVarEF (0x00EE)  %s%02X",fa,u16a))					
				
			elseif cmd==0xEF then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("SetVarEF (0x00EF)  %s%02X",fa,u16a))	

			elseif cmd==0xF1 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("SetVarF1 (0x00F1)  V1=%s%02X",fa,u16a))					
				
			elseif cmd==0xF2 then
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb="Num_"
					end
				print(""..sf("??VARONLY?? (0x00F2) V1=%s%d V2=%s%d",fa,u16a,fb,u16b))
				
			elseif cmd==0xF3 then
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb="Num_"
					end
				print(""..sf("??VARONLY?? (0x00F3) V1=%s%d V2=%s%d",fa,u16a,fb,u16b))			

			elseif cmd==0xF4 then
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb="Num_"
					end
				print(""..sf("??VARONLY?? (0x00F4) V1=%s%d V2=%s%d",fa,u16a,fb,u16b))					

			elseif cmd==0xF5 then
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb="Num_"
					end
				print(""..sf("??VARONLY?? (0x00F5) V1=%s%d V2=%s%d",fa,u16a,fb,u16b))

			elseif cmd==0xF6 then
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb="Num_"
					end
				print(""..sf("??VARONLY?? (0x00F6) V1=%s%d V2=%s%d",fa,u16a,fb,u16b))	

			elseif cmd==0xF8 then
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb="Num_"
					end
				print(""..sf("??VARONLY?? (0x00F8) V1=%s%d V2=%s%d",fa,u16a,fb,u16b))					
				
			elseif cmd==0xF9 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("????F9 (0x00F9)  %s%02X",fa,u16a))	
				

			elseif cmd==0xFA then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("DoMathVarFA (0x00FA)  %s%02X",fa,u16a)) 

			elseif cmd==0xFB then
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb="Num_"
					end
				print(""..sf("??VARONLY?? (0x00FB) A=%s%d B=%s%d",fa,u16a,fb,u16b))

			elseif cmd==0xFC then
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb="Num_"
					end
				print(""..sf("??VARONLY2?? (0x00FC) A=%s%d B=%s%d",fa,u16a,fb,u16b))
				
			elseif cmd==0xFE then
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb="Num_"
					end
				print(""..sf("??VARONLY2?? (0x00FE) A=%s%d B=%s%d",fa,u16a,fb,u16b))				
				
			elseif cmd==0xFF then
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb="Num_"
					end
				print(""..sf("??VARONLY2?? (0x00FF) A=%s%d B=%s%d",fa,u16a,fb,u16b))				

			elseif cmd==0xFD then
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb="Num_"
					end
				u16c=mw(SRP) SRP=SRP+2
					if 	u16c/0x8000>=1 then 	fc="Var_"  u16c=u16c%0x4000
					elseif 	u16c/0x4000>=1 then 	fc="Cont_" u16c=u16c%0x4000
					else 				fc="Num_"
					end
				print(""..sf("?????? (0x00FD) A=%s%d B=%s%d C=%s%d",fa,u16a,fb,u16b,fc,u16c))	

			elseif cmd==0x101 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("?????? (0x0101) V1=%s%d V2=%s%d",fa,u16a,fb,u16b)) 				
				
			elseif cmd==0x102 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("?????? (0x0102) A=%s%d %s%d",fa,u16a,fb,u16b)) 
				
			elseif cmd==0x103 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("ShowPokemonParty (0x0103) A=%s%d %s%d",fa,u16a,fb,u16b)) 
				
			elseif cmd==0x104 then 
				print(""..sf("???? (0x0104)"))						
				
			elseif cmd==0x105 then
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb="Num_"
					end
				u16c=mw(SRP) SRP=SRP+2
					if 	u16c/0x8000>=1 then 	fc="Var_"  u16c=u16c%0x4000
					elseif 	u16c/0x4000>=1 then 	fc="Cont_" u16c=u16c%0x4000
					else 				fc="Num_"
					end
				print(""..sf("?????? (0x0105zz) A=%s%d B=%s%d C=%s%d",fa,u16a,fb,u16b,fc,u16c))	
				

			elseif cmd==0x107 then
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa=""
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb=""
					end
				u16c=mw(SRP) SRP=SRP+2
					if 	u16c/0x8000>=1 then 	fc="Var_"  u16c=u16c%0x4000
					elseif 	u16c/0x4000>=1 then 	fc="Cont_" u16c=u16c%0x4000
					else 				fc=""
					end
				u16d=mw(SRP) SRP=SRP+2
					if 	u16d/0x8000>=1 then 	fd="Var_"  u16d=u16d%0x4000
					elseif 	u16d/0x4000>=1 then 	fd="Cont_" u16d=u16d%0x4000
					else 				fd=""
					end
				print(""..sf("???? (0x0107) A=%s%d B=%s%d C=%s%d D=%s%d",fa,u16a,fb,u16b,fc,u16c,fd,u16d))

			elseif cmd==0x108 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("?????? (0x0108) V1=%s%d V2=%s%d",fa,u16a,fb,u16b)) 				

			elseif cmd==0x109 then
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa=""
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb=""
					end
				u16c=mw(SRP) SRP=SRP+2
					if 	u16c/0x8000>=1 then 	fc="Var_"  u16c=u16c%0x4000
					elseif 	u16c/0x4000>=1 then 	fc="Cont_" u16c=u16c%0x4000
					else 				fc=""
					end
				u16d=mw(SRP) SRP=SRP+2
					if 	u16d/0x8000>=1 then 	fd="Var_"  u16d=u16d%0x4000
					elseif 	u16d/0x4000>=1 then 	fd="Cont_" u16d=u16d%0x4000
					else 				fd=""
					end
				print(""..sf("???? (0x0109) V1=%s%d V2=%s%d V3=%s%d V4=%s%d",fa,u16a,fb,u16b,fc,u16c,fd,u16d))
				
				
			elseif cmd==0x10A then
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb="Num_"
					end
				u16c=mw(SRP) SRP=SRP+2
					if 	u16c/0x8000>=1 then 	fc="Var_"  u16c=u16c%0x4000
					elseif 	u16c/0x4000>=1 then 	fc="Cont_" u16c=u16c%0x4000
					else 				fc="Num_"
					end
				print(""..sf("?????? (0x010A) V1=%s%d V2=%s%d V3=%s%d",fa,u16a,fb,u16b,fc,u16c))	
				
			elseif cmd==0x10B then
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb="Num_"
					end
				u16c=mw(SRP) SRP=SRP+2
					if 	u16c/0x8000>=1 then 	fc="Var_"  u16c=u16c%0x4000
					elseif 	u16c/0x4000>=1 then 	fc="Cont_" u16c=u16c%0x4000
					else 				fc="Num_"
					end
				print(""..sf("?????? (0x010B) V1=%s%d V2=%s%d V3=%s%d",fa,u16a,fb,u16b,fc,u16c))					
				
			elseif cmd==0x10D then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("??StorePKM?? (0x010D) A=%s%d %s%d",fa,u16a,fb,u16b)) 

			elseif cmd==0x110 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("ShowPokemonParty (0x0110) A=%s%d %s%d",fa,u16a,fb,u16b)) 

			elseif cmd==0x115 then
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb="Num_"
					end
				u16c=mw(SRP) SRP=SRP+2
					if 	u16c/0x8000>=1 then 	fc="Var_"  u16c=u16c%0x4000
					elseif 	u16c/0x4000>=1 then 	fc="Cont_" u16c=u16c%0x4000
					else 				fc="Num_"
					end
				print(""..sf("?????? (0x0115) V1=%s%d C1=%s%d C2=%s%d",fa,u16a,fb,u16b,fc,u16c))					

			elseif cmd==0x116 then
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb="Num_"
					end
				print(""..sf("??????? (0x0116) A=%s%d B=%s%d",fa,u16a,fb,u16b))






			elseif cmd==0x11F then
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa="Num_"
					end
				u8a=mb(SRP) SRP=SRP+1
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb="Num_"
					end
				print(""..sf("??????? (0x011F) A=%s%d unk=%d C=%s%d",fa,u16a,u8a,fb,u16b))
				
			elseif cmd==0x120 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("????? (0x0120) V1=%s%d a=%s%d",fa,u16a,fb,u16b))
				

			elseif cmd==0x127 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("????? (0x0127) A=%s%d %s%d",fa,u16a,fb,u16b))

			elseif cmd==0x128 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("????? (0x0128) A=%s%d",fa,u16a))  

			elseif cmd==0x129 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("????? (0x0129) A=%s%d %s%d",fa,u16a,fb,u16b))

			elseif cmd==0x12A then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("???????? (0x012A) A=%s%d",fa,u16a))  
				
			elseif cmd==0x12C then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("???????? (0x012C) A=%s%d",fa,u16a))  				
				
			--elseif cmd==0x12D then 
			--	print(""..sf("?????? (0x012D)"))

			elseif cmd==0x130 then 
				print(""..sf("BootPCSound (0x0130)"))
				
			elseif cmd==0x132 then 		--PC Related?
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("???????? (0x0132) A=%s%d",fa,u16a))  
				
			elseif cmd==0x13B then 		--PC Related?
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("???????? (0x013B) V1=%s%d",fa,u16a))  				
				
			elseif cmd==0x147 then 		
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("CAM???????? (0x0147) A=%s%d",fa,u16a))

			elseif cmd==0x14B then
				print(""..sf("Restart Game (0x14B)"))
				
			elseif cmd==0x14D then
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb="Num_"
					end
				print(""..sf("??????? (0x014D) a=%s%d V1=%s%d",fa,u16a,fb,u16b))
				
			elseif cmd==0x14F then
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb="Num_"
					end
				print(""..sf("??????? (0x014F) V1=%s%d a=%s%d",fa,u16a,fb,u16b))				

			elseif cmd==0x150 then 		
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("CAM???????? (0x0147) A=%s%d",fa,u16a))				
				
			elseif cmd==0x155 then
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb="Num_"
					end
				print(""..sf("??????? (0x0155) A=%s%d B=%s%d",fa,u16a,fb,u16b))

			elseif cmd==0x16D then 
				print(""..sf("?????? (0x016D)"))
				
			elseif cmd==0x174 then
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa=""
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb=""
					end
				u16c=mw(SRP) SRP=SRP+2
					if 	u16c/0x8000>=1 then 	fc="Var_"  u16c=u16c%0x4000
					elseif 	u16c/0x4000>=1 then 	fc="Cont_" u16c=u16c%0x4000
					else 				fc=""
					end
				print(""..sf("WildEncounter (0x0174) DEX=%s%d LVL=%s%d Unk=%s%d",fa,u16a,fb,u16b,fc,u16c))
				
			elseif cmd==0x175 then 
				print(""..sf("?????? (0x0175)"))	

			elseif cmd==0x176 then 
				print(""..sf("?????? (0x0176)"))				
				
			elseif cmd==0x177 then
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("StoreVarWildEncounterResult (0x0177) %s0x%X",fa,u16a))		

			elseif cmd==0x178 then
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("StoreVar????WB (0x0178) %s0x%X",fa,u16a))					

			elseif cmd==0x17A then
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("??????? (0x017A) %s0x%X",fa,u16a))

			elseif cmd==0x18F then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("?????? (0x018F)  %s%d",fa,u16a)) 

			elseif cmd==0x190 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("?????? (0x0190)  %s%d",fa,u16a)) 

			elseif cmd==0x191 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("?????? (0x0191)  %s%d",fa,u16a)) 
				
			elseif cmd==0x19B then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("???CONT??? (0x019B)  %s%d",fa,u16a)) 
				
			elseif cmd==0x19C then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("???VAR??? (0x019C)  %s%d",fa,u16a)) 				

			elseif cmd==0x1AA then
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa=""
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb=""
					end
				u16c=mw(SRP) SRP=SRP+2
					if 	u16c/0x8000>=1 then 	fc="Var_"  u16c=u16c%0x4000
					elseif 	u16c/0x4000>=1 then 	fc="Cont_" u16c=u16c%0x4000
					else 				fc=""
					end
				u16d=mw(SRP) SRP=SRP+2
					if 	u16d/0x8000>=1 then 	fd="Var_"  u16d=u16d%0x4000
					elseif 	u16d/0x4000>=1 then 	fd="Cont_" u16d=u16d%0x4000
					else 				fd=""
					end
				print(""..sf("???? (0x01AA) A=%s%d B=%s%d C=%s%d D=%s%d",fa,u16a,fb,u16b,fc,u16c,fd,u16d))

			elseif cmd==0x1B4 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("??? (0x01B4) A=%s%d B=%s%d",fa,u16a,fb,u16b))	

			elseif cmd==0x1B5 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("??? (0x01B5) A=%s%d B=%s%d",fa,u16a,fb,u16b))				
				
			elseif cmd==0x1C1 then
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa=""
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb=""
					end
				u16c=mw(SRP) SRP=SRP+2
					if 	u16c/0x8000>=1 then 	fc="Var_"  u16c=u16c%0x4000
					elseif 	u16c/0x4000>=1 then 	fc="Cont_" u16c=u16c%0x4000
					else 				fc=""
					end
				u16d=mw(SRP) SRP=SRP+2
					if 	u16d/0x8000>=1 then 	fd="Var_"  u16d=u16d%0x4000
					elseif 	u16d/0x4000>=1 then 	fd="Cont_" u16d=u16d%0x4000
					else 				fd=""
					end
				u16e=mw(SRP) SRP=SRP+2
					if 	u16e/0x8000>=1 then 	fe="Var_"  u16e=u16e%0x4000
					elseif 	u16e/0x4000>=1 then 	fe="Cont_" u16e=u16e%0x4000
					else 				fe=""
					end
				print(""..sf("???? (0x01C1) A=%s%d B=%s%d C=%s%d D=%s%d E=%s%d",fa,u16a,fb,u16b,fc,u16c,fd,u16d,fe,u16e))
				
			elseif cmd==0x1CC then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("??? (0x01CC) A=%s%d",fa,u16a))
				
			elseif cmd==0x1CD then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("??? (0x01CD) A=%s%d",fa,u16a))
				
			elseif cmd==0x1D1 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("?????? (0x01D1) unk=%s%d A=%s%d ",fa,u16a,fb,u16b)) 				
				
			elseif cmd==0x1D2 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa=""
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb=""
					end
				u16c=mw(SRP) SRP=SRP+2
					if u16c/0x8000>=1 then fc="Var_" u16c=u16c%0x4000
					elseif u16c/0x4000>=1 then fc="Cont_" u16c=u16c%0x4000
					else fc=""
					end
				print(""..sf("????? (0x01D2) unk=%s%d A=%s%d B=%s%d",fa,u16a,fb,u16b,fc,u16c)) 				
				
			elseif cmd==0x1D3 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa=""
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb=""
					end
				u16c=mw(SRP) SRP=SRP+2
					if u16c/0x8000>=1 then fc="Var_" u16c=u16c%0x4000
					elseif u16c/0x4000>=1 then fc="Cont_" u16c=u16c%0x4000
					else fc=""
					end
				print(""..sf("????? (0x01D3) unk=%s%d A=%s%d B=%s%d",fa,u16a,fb,u16b,fc,u16c))  
				
			elseif cmd==0x1D4 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa=""
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb=""
					end
				u16c=mw(SRP) SRP=SRP+2
					if u16c/0x8000>=1 then fc="Var_" u16c=u16c%0x4000
					elseif u16c/0x4000>=1 then fc="Cont_" u16c=u16c%0x4000
					else fc=""
					end
				print(""..sf("????? (0x01D4) unk=%s%d V1=%s%d V2=%s%d",fa,u16a,fb,u16b,fc,u16c)) 				
					
			elseif cmd==0x1D5 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("??? (0x01D5) V1=%s%d V2=%s%d",fa,u16a,fb,u16b))

			elseif cmd==0x1D6 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("??? (0x01D6) V1=%s%d V2=%s%d",fa,u16a,fb,u16b))
					
			elseif cmd==0x1D8 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa=""
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb=""
					end
				u16c=mw(SRP) SRP=SRP+2
					if u16c/0x8000>=1 then fc="Var_" u16c=u16c%0x4000
					elseif u16c/0x4000>=1 then fc="Cont_" u16c=u16c%0x4000
					else fc=""
					end
				u16d=mw(SRP) SRP=SRP+2
					if u16d/0x8000>=1 then fd="Var_" u16d=u16d%0x4000
					elseif u16d/0x4000>=1 then fd="Cont_" u16d=u16d%0x4000
					else fd=""
					end
				print(""..sf("????? (0x01D8) A=%s%d B=%s%d C=%s%d D=%s%d",fa,u16a,fb,u16b,fc,u16c,fd,u16d))  
						
					
			elseif cmd==0x1DD then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa=""
					end
					varct67=1
				while mw(SRP)>=0x8000 do
					varct67=varct67+1
					SRP=SRP+2 end
				print(""..sf("***************MultiVar1DF???? (0x01DD)  %s%d vars total=%d",fa,u16a,varct67)) 				


			elseif cmd==0x1DF then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa=""
					end
					varct67=1
				while mw(SRP)>=0x8000 do
					varct67=varct67+1
					SRP=SRP+2 end
				print(""..sf("***************MultiVar1DF???? (0x01DF)  %s%d vars total=%d",fa,u16a,varct67)) 				
				
			elseif cmd==0x1EC then
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa=""
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb=""
					end
				u16c=mw(SRP) SRP=SRP+2
					if 	u16c/0x8000>=1 then 	fc="Var_"  u16c=u16c%0x4000
					elseif 	u16c/0x4000>=1 then 	fc="Cont_" u16c=u16c%0x4000
					else 				fc=""
					end
				print(""..sf("?????? (0x01EC) a=%s%d V1=%s%d V2=%s%d",fa,u16a,fb,u16b,fc,u16c))
	
	
			elseif cmd==0x1FB then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("?????? (0x01FB) A=%s%d B=%s%d",fa,u16a,fb,u16b)) 
				
			elseif cmd==0x1FC then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("?????? (0x01FC) A=%s%d B=%s%d",fa,u16a,fb,u16b)) 

			elseif cmd==0x1FF then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("??? (0x01FF) A=%s%d",fa,u16a))
				
			elseif cmd==0x218 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("??? (0x0218) a=%s%d V1=%s%d",fa,u16a,fb,u16b))

			elseif cmd==0x21A then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("??? (0x021A) a=%s%d V1=%s%d",fa,u16a,fb,u16b))
				
			elseif cmd==0x21C then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("??? (0x021C) V1=%s%d V2=%s%d",fa,u16a,fb,u16b))				
				
			elseif cmd==0x21D then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("??? (0x021D) V1=%s%d",fa,u16a))		
				
			elseif cmd==0x21F then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("??? (0x021F) A=%s%d",fa,u16a))				
				
			elseif cmd==0x227 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("??? (0x0227) A=%s%d B=%s%d",fa,u16a,fb,u16b))

			elseif cmd==0x231 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("??? (0x0231) V=%s%d",fa,u16a))
				
			elseif cmd==0x233 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("??? (0x0233) V=%s%d",fa,u16a))				
				
			elseif cmd==0x236 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("??? (0x0236) A=%s%d B=%s%d",fa,u16a,fb,u16b))

			elseif cmd==0x237 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("?????? (0x0237) A=%s%d B=%s%d",fa,u16a,fb,u16b)) 
				
			elseif cmd==0x239 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("?VAR?? (0x0239) V=%s%d",fa,u16a))						
				
			elseif cmd==0x23A then
				u16a=mw(SRP) SRP=SRP+2
					if 	u16a/0x8000>=1 then 	fa="Var_"  u16a=u16a%0x4000
					elseif 	u16a/0x4000>=1 then 	fa="Cont_" u16a=u16a%0x4000
					else 				fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if 	u16b/0x8000>=1 then 	fb="Var_"  u16b=u16b%0x4000
					elseif 	u16b/0x4000>=1 then 	fb="Cont_" u16b=u16b%0x4000
					else 				fb="Num_"
					end
				print(""..sf("??VARONLY?? (0x0023A) V1=%s%d V2=%s%d",fa,u16a,fb,u16b))				

			elseif cmd==0x23F then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("?????? (0x023F) A=%s%d B=%s%d",fa,u16a,fb,u16b)) 

			elseif cmd==0x24C then
				print(""..sf("???? (0x024C)"))

			elseif cmd==0x24E then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("?????? (0x024E) V1=%s%d V2=%s%d",fa,u16a,fb,u16b)) 
				
			elseif cmd==0x24F then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa=""
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb=""
					end
				u16c=mw(SRP) SRP=SRP+2
					if u16c/0x8000>=1 then fc="Var_" u16c=u16c%0x4000
					elseif u16c/0x4000>=1 then fc="Cont_" u16c=u16c%0x4000
					else fc=""
					end
				u16d=mw(SRP) SRP=SRP+2
					if u16d/0x8000>=1 then fd="Var_" u16d=u16d%0x4000
					elseif u16d/0x4000>=1 then fd="Cont_" u16d=u16d%0x4000
					else fd=""
					end
				print(""..sf("????? (0x024F) A=%s%d B=%s%d C=%s%d D=%s%d",fa,u16a,fb,u16b,fc,u16c,fd,u16d))  
	

			elseif cmd==0x262 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("?????? (0x0262) A=%s%d B=%s%d",fa,u16a,fb,u16b))

			elseif cmd==0x266 then
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("?????? (0x0266) %s%d",fa,u16a)) 
 
			elseif cmd==0x0275 then
				u8a=mb(SRP) SRP=SRP+1
				u16a=mw(SRP) SRP=SRP+4
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("???? (0x0275) 0x%02X 0x%04X",u8a,u16a))



			elseif cmd==0x276 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("??? (0x0276) A=%s%d B=%s%d",fa,u16a,fb,u16b))
				

				

			elseif cmd==0x291 then
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("??????? (0x0291) %s%d",fa,u16a))

			elseif cmd==0x292 then
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("??????? (0x0292) %s%d",fa,u16a))

			elseif cmd==0x29B then
				u8a=mb(SRP) SRP=SRP+1
				print(""..sf("????? (0x029B) 0x%02X",u8a))
				
			elseif cmd==0x29D then
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("??????? (0x029D) %s%d",fa,u16a))
				
			elseif cmd==0x29E then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("?????? (0x029E) A=%s%d B=%s%d",fa,u16a,fb,u16b))	
				

			elseif cmd==0x2A1 then
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("??????? (0x02A1) %s%d",fa,u16a))						

			elseif cmd==0x2A4 then
				print(""..sf("???? (0x02A4)"))				
				
			elseif cmd==0x2A5 then
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("??????? (0x02A5) %s%d",fa,u16a))				
				
				
			elseif cmd==0x2AF then
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("??????? (0x02AF) %s%d",fa,u16a))

 				
				
			elseif cmd==0x2B2 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("?????? (0x02B2) A=%s%d B=%s%d",fa,u16a,fb,u16b)) 
				
			elseif cmd==0x2B3 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("?????? (0x02B3) a=%s%d V1=%s%d",fa,u16a,fb,u16b))					
				
			elseif cmd==0x2B4 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("?????? (0x02B4) A=%s%d B=%s%d",fa,u16a,fb,u16b))
				
				
			elseif cmd==0x2B5 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("?????? (0x02B5) A=%s%d B=%s%d",fa,u16a,fb,u16b))				
				
			elseif cmd==0x2B8 then 
				print(""..sf("?????? (0x02B8)"))
				
			elseif cmd==0x2B9 then
				print(""..sf("???? (0x02B9)"))
				
			elseif cmd==0x2BA then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("??? (0x02BA) A=%s%d",fa,u16a))

			elseif cmd==0x2BB then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("??? (0x02BB) A=%s%d",fa,u16a))	

			elseif cmd==0x2C2 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("?????? (0x002C2) A=%s%d",fa,u16a)) 				
				
			elseif cmd==0x2C4 then
				print(""..sf("???? (0x02C4)"))

			elseif cmd==0x2C5 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("??? (0x02C5) A=%s%d",fa,u16a))

			elseif cmd==0x2CB then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("??? (0x02CB) A=%s%d",fa,u16a))


			elseif cmd==0x2D7 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("?????? (0x02D7) A=%s%d B=%s%d",fa,u16a,fb,u16b))
				
			elseif cmd==0x2DA then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("??? (0x02DA) A=%s%d",fa,u16a))
				
			elseif cmd==0x3ED then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				u16b=mw(SRP) SRP=SRP+2
					if u16b/0x8000>=1 then fb="Var_" u16b=u16b%0x4000
					elseif u16b/0x4000>=1 then fb="Cont_" u16b=u16b%0x4000
					else fb="Num_"
					end
				print(""..sf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!?????? (0x03ED) A=%s%d B=%s%d",fa,u16a,fb,u16b))		

			elseif cmd==0x3F1 then 
				u16a=mw(SRP) SRP=SRP+2
					if u16a/0x8000>=1 then fa="Var_" u16a=u16a%0x4000
					elseif u16a/0x4000>=1 then fa="Cont_" u16a=u16a%0x4000
					else fa="Num_"
					end
				print(""..sf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!??? (0x03F1) V1=%s%d",fa,u16a))				


			elseif cmd==0x2E00 then
				SRP=SRP-1
				print(""..sf("                 Attempting to Fix Continuity (0x2E00)"))
			elseif cmd==0x2F00 then
				SRP=SRP-3
				print(""..sf("                 Attempting to Fix Continuity (0x2F00)"))			
				
			elseif cmd==0x3C00 then
				SRP=SRP-1
				print(""..sf("                 Attempting to Fix Continuity (0x3C00)"))
			elseif cmd==0x7C00 then
				SRP=SRP-1
				print(""..sf("                 Attempting to Fix Continuity (0x7C00)"))	

			elseif cmd==0x4400 then 
				SRP=SRP-1
				print(""..sf("                 Attempting to Fix Continuity (0x4400)"))	
				break
			elseif cmd==0x4E00 then
				SRP=SRP-1
				print(""..sf("                 Attempting to Fix Continuity (0x4E00)"))				

			elseif cmd==0x5200 then 
				SRP=SRP-1
				print(""..sf("                 Attempting to Fix Continuity (0x5200)"))	
				break				
				
			elseif cmd==0x6400 then 
				SRP=SRP-1
				print(""..sf("                 Attempting to Fix Continuity (0x6400)"))	
				
			elseif cmd==0x5544 then 
				done=1  
				print(""..sf("                 Script is Finished. (0x5544)"))
				print(""..sf("                 STOP READ"))
				curscr=curscr+0
				goscrp=2
				goextra=1
				break		
				
			elseif cmd==0x4652 then 
				done=1  
				print(""..sf("                 Script is Finished. (0x5544)\n\nStop reading!\n"))
				print(""..sf("                 STOP READ"))
				curscr=curscr+0
				goscrp=2
				break	
					

			elseif cmd==0xFE00 then
				SRP=SRP-5
				print(""..sf("                 Attempting to Fix Continuity (0xFE00)"))
 			
			else
			if rshift(cmd,12)==0x8 then print(""..sf("0x%X past=0x%X",cmd,mw(SRP-4)))
			else print(""..sf("0x%X                                                 0x%X",cmd,mw(SRP-4))) end
			
			--iterscr=iterscr+1
			end
			--iterscr=iterscr+1
				if goscrp==1 and scrnum<curscr then 
					print(""..sf("~~~~~~Finish~~~~~~")) 
					print(""..sf("Debug Next %02X",mw(SRP))) 
					goscrp=2 
					break 
					end
		end end
		iterscr=iterscr+1






		
	end
	



gt(1,70,sf("Total Scripts: %d",scrnum))
gt(1,80,sf("Attempts: %d",iterhead))

gt(1,90,sf("SRP: %08X",SRP))
if goscrp==2 then 
	gt(1,100,sf("~~~~~Finish~~~~~")) 
	end

	

if scrnum>0 then gt(1,00,sf("%08X",scrt[0])) end
if scrnum>1 then gt(1,10,sf("%08X",scrt[1])) end
if scrnum>2 then gt(1,20,sf("%08X",scrt[2])) end
if scrnum>3 then gt(1,30,sf("%08X",scrt[3])) end
if scrnum>4 then gt(1,40,sf("%08X",scrt[4])) end

if iterhead-scrnum~=0 
	then gt(1,110,sf("Duplicate Entries Detected %d",iterhead-scrnum)) 
	else gt(1,110,sf("No Duplicate Entries Detected")) 
end

gt(1,120,sf("%08X",start))
		table=joypad.get(1)
        if (table.R) then
		enbl=0
		gt(1,150,sf("PromptExtra")) 
		
		else              
		if enbl==0 then print(""..sf("Debug GoExtra")) goextra=0 enbl=1 end
		end








end
gui.register(main)