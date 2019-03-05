SampleRate=2000 
SampleNumber=100
humi=0
temp=0 
humi1=0
temp1=0 
webpagesent = 0
station1 = "undef"
bkst={}
bkst.tr1={}
bkst.tr1.name= "undef"
bkst.tr1.temp= -99
bkst.tr1.humi= -99
bkst.tr2={}
bkst.tr2.name= "undef"
bkst.tr2.temp= -99
bkst.tr2.humi= -99
bkst.tr3={}
bkst.tr3.name= "undef"
bkst.tr3.temp= -99
bkst.tr3.humi= -99
bkst.tr4={}
bkst.tr4.name= "undef"
bkst.tr4.temp= -99
bkst.tr4.humi= -99
name1 = "undef"
temp1 = -99
humi1 = -99
name2 = "undef"
temp2 = -99
humi2 = -99
name3 = "undef"
temp3 = -99
humi3 = -99

tmr.alarm(0,2000,1, function()
   pin = 4
   status, temp, humi, temp_dec, humi_dec = dht.read11(pin)
end)

function parsepayload (payload)
    --print (payload)
    filstart = string.find(payload,"/")
    cmdstart = string.find(payload,"?")
    cmdequal = string.find(payload,"=")
    cmdend   = string.find(payload,"HTTP")
    if cmdstart==nil or cmdstart > cmdend then cmdstart = cmdend-1 end

    filename = string.sub(payload,filstart+1,cmdstart-1)
    nocommand = 1
    if cmdstart ~= cmdend-1 then
       command  = string.sub(payload,cmdstart+1,cmdequal-1)
       value    = string.sub(payload,cmdequal+1,cmdend-1)
       value    = string.gsub(value,"+"," ")
       nocommand = 0
    end
end

function SFC(SS)  --big file sender
    local line=file.read(1460);
    if line then 
       SS:send(line, function (c) SFC(c) end); 
       --print("packet ==> "..line);
    else 
       file.close(); 
       SS:close(); 
    end
end


srv=net.createServer(net.TCP) 
srv:listen(80,function(conn) 
    conn:on("receive",function(conn,payload) 
    parsepayload(payload)
    
    if filename=="index.html" then
       if command == "SampleNumber" then SampleNumber=value end
       if webpagesent == 0 then
          webpagesent = 1
          line='<!doctype html>\n';  --interpreted by browser as html 
          file.open("dht.html", "r");
          conn:send(line, function (c) SFC(c); end)
          print("packet ==> "..line);
       end
    elseif filename=="getData" then

       bkst.gcnt=tonumber(SampleNumber)
       --bkst.tr1={}
       bkst.tr1.name="Base"
       bkst.tr1.temp=temp
       bkst.tr1.humi=humi
       bkst.tr1.ok=status
       jsonstr = sjson.encode(bkst)
       --bkst.tr2={}
       bkst.tr2.name= name1
       bkst.tr2.temp= temp1
       bkst.tr2.humi= humi1
       bkst.tr2.ok= 0
       --bkst.tr3={}
       bkst.tr3.name= name2
       bkst.tr3.temp= temp2
       bkst.tr3.humi= humi2
       bkst.tr3.ok= 0
       --bkst.tr4={}
       bkst.tr4.name= name3
       bkst.tr4.temp= temp3
       bkst.tr4.humi= humi3
       bkst.tr4.ok= 0

       --print ("sending --> "..jsonstr)
       conn:send(jsonstr)
       --conn:send(SampleNumber..", Base, "..temp..", "..humi..", "..station1..", "..temp1..", "..humi1)
       conn:on("sent", function(conn) conn:close() end) 
    else
       conn:send('<html><body>') 
       conn:send("<br><h1>&emsp;404 - nothing found at that request name</h1>")
       conn:send('</body></html>') 
       conn:on("sent", function(conn) conn:close() end) 
    end
    
    end) 
end)


------------   UDP Socket   -----------------

udpSocket = net.createUDPSocket()
udpSocket:listen(5000)
udpSocket:on("receive", function(s, data, port, ip)
    print("SJSON udp rcv : "..data.." from "..ip.."\n") 
    local jsonobj = sjson.decode(data)

    if jsonobj.tr3 ~= nil then
       name2=jsonobj.tr3.name
       temp2=jsonobj.tr3.temp
       humi2=jsonobj.tr3.humi
    end
    if jsonobj.tr4 ~= nil then
       name3=jsonobj.tr4.name
       temp3=jsonobj.tr4.temp
       humi3=jsonobj.tr4.humi
    end
    if jsonobj.tr2 ~= nil then
       name1=jsonobj.tr2.name
       temp1=jsonobj.tr2.temp
       humi1=jsonobj.tr2.humi
    end

end)

