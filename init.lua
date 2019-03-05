mySsid=""
myKey=""

wifi.setmode(wifi.STATION)
wifi.sta.config {ssid=mySsid,pwd=myKey }
wifi.sta.connect()

print("Waiting for IP")
tmr.alarm(0, 1000, 1, function()
    print("waiting 1 sec....")
    if wifi.sta.getip()~=nil then
       print(wifi.sta.getip()) 
       tmr.stop(0) 
       --dofile("remotes.lua")
    end
end)
