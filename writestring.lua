local wb,md,gt,sf=memory.writebyte,memory.readdwordunsigned,gui.text,string.format
local rd,rw,rb=memory.readdwordunsigned,memory.readwordunsigned,memory.readbyteunsigned
mb=function(x) return rb(x) 							end
mw=function(x) return rb(x)+rb(x+1)*0x100 					end
md=function(x) return rb(x)+rb(x+1)*0x100+rb(x+2)*0x10000+rb(x+3)*0x1000000 	end
local i,j,x,t=1,1,1,{}
local on,enbl,overprint,enblo=1,1,1,1

writeat=0x02248B9C

function main()
table=joypad.get(1)

s="44 00 75 00 79 00 6F 00 78 00 79 00 73 00 3A 00 20 00 49 00 20 00 73 00 75 00 63 00 6B 00 2E 00 FF FF"
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
	wb(writeat+x-1,t[x])
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