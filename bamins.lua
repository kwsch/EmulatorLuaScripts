local wb,md,gt,sf=memory.writebyte,memory.readdwordunsigned,gui.text,string.format
local rd,rw,rb=memory.readdwordunsigned,memory.readwordunsigned,memory.readbyteunsigned
mb=function(x) return rb(x) 							end
mw=function(x) return rb(x)+rb(x+1)*0x100 					end
md=function(x) return rb(x)+rb(x+1)*0x100+rb(x+2)*0x10000+rb(x+3)*0x1000000 	end
local i,j,x,t=1,1,1,{}

	scstart=md(0x02000024)+0x1267C4
	game=2

function main()

--List all portions of or script
s1="2E 00 FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"
s2=""
s3=""
s4="02 00"

--Concatenate all strings in order
s=s1..s2..s3..s4

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

x=1
end
gui.register(main)