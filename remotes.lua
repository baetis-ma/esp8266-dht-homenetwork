
tmr.alarm(0, 1500, 1, function()
   pin = 4
   status, temp, humi, temp_dec, humi_dec = dht.read11(pin)

   jsonobj = {}
   jsonobj.tr2 = {}
   jsonobj.tr2.name = "Default"
   jsonobj.tr2.temp = temp
   jsonobj.tr2.humi = humi
   jsonobj.tr2.ok = status
   
   jsonstr =  sjson.encode(jsonobj)
   udpSocket:send(5000, '10.0.0.255', jsonstr)
   print("sent ==> "..jsonstr)
   --udpSocket:send(5000, '10.0.0.255', stationid..", "..temp..", "..humi)
   --print("sent : "..stationid..", "..temp..", "..humi)

end)

udpSocket = net.createUDPSocket()

