local wb,md,gt,sf=memory.writebyte,memory.readdwordunsigned,gui.text,string.format
local rd,rw,rb=memory.readdwordunsigned,memory.readwordunsigned,memory.readbyteunsigned
mb=function(x) return rb(x) 							end
mw=function(x) return rb(x)+rb(x+1)*0x100 					end
md=function(x) return rb(x)+rb(x+1)*0x100+rb(x+2)*0x10000+rb(x+3)*0x1000000 	end
local i,j,x,t=1,1,1,{}
local on,enbl,overprint,enblo=1,1,1,1

if mb(0x023FFE09)==0x00 then		-- Not "2" ~ Not B2/W2
	  pos_m=md(0x02000024)+0x3461C
	    zds=md(0x02000024)+0x3DFAC
	ow=md(0x02000024)+0x34E04
	scstart=md(md(0x02000024)+0x41834)+md(0x02000024)+0x41838
	game=1
else
	  pos_m=md(0x02000024)+0x36780
	    zds=md(0x02000024)+0x41B2C
	ow=md(0x02000024)+0x36BE8
	scstart=md(md(0x02000024)+0x459A4)+md(0x02000024)+0x0459A8
	game=2
end

function main()
table=joypad.get(1)

--List all portions of or script
s1="2E 00"
s2="74 00 3D 00 02 00 00 00 00 00 00 00 32 00 3F 00"
s2=s2.."85 00 6C 02 00 00 00 00 28 00 20 80 00 00 8D 00 10 80 09 00 10 80 08 00 01 00 11 00 01 00 1F 00 FF 08 00 01 00 8E 00 1E 00 02 00 00 00 8C 00"
s3="3D 00 03 00 00 00 00 00 00 00 32 00 3F 00 "
s4="30 00 2F 00 02 00"

--Concatenate all strings in order
s=s1..s2..s3..s4

s="2E 00 74 00 A6 00 47 07 F1 08 01 00 02 00 03 00 0A 00 30 00 2F 00 02 00"

if overprint==0 then 
	overprint=1
	print(s)
end

--Remove spaces from eventscript so that we can add the script in
s = string.gsub (s, " ", "")

--Break up eventscript string into a table
while i<=string.len(s) do
	t[j] ="0x"..string.sub(s,i,i+1)
	j=j+1
	i=i+2
end

--Write script per byte via values in the table.
while x<j do
	wb(scstart+x-1,t[x])
	--Graphical display of text
	gt((x-1)%10*15,math.floor((x-1)/0xA)*10,sf("%02X",t[x]))
	x=x+1
end

if table.R then
                gt(0,0, "Printout")
                enblo=0
        else
                if enblo==0 then overprint=(overprint+1)%2 enblo=1 end
        end


x=1
end
gui.register(main)