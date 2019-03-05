# ESP8266 NodeMcu Multi DHT-11 Home Temp/Humidity Webpage #

Materials required
   * Base station ESP8266 with DHT-11 
   * 3 More ESP8266 with DHT-11

The file init.lua is run by each of the devices to first
setup a wifi connection (after editting ssid and key into
file) and then dofile the base or remote .lua file.

* Build and flash NodeMcu into the 4 esp8266 devices
* Edit init.lua for base station 
  * add ssid and key for your wifi network
  * edit --dofile line to dofile("dualserver.lua")
* Edit init.lua for remote stations
  * add ssid and key for your wifi network (same as above)
  * edit --dofile line to dofile("remotes.lua")
* Each remote station can have it's own name in remote.lua
* Flash the two .lua files into each device (1 base - multiple remotes),
  the base module will also ness the dht.html file to serve up

I used nodemcu-tool flash and monitor the esps.

Each remote station starts a UPD socket and then transmits a json
packet with the dht-11 measurment data repeated every 1.5 seconds.
Remote station name can be editted into remotes.lua.

The base station collects data from all of the remote stations and from 
it's self and sends a joson packet in response to an HTTP Request. 
The base station will return the dht.html text in responce to an HTTP
Request with the base stations url or url/dht.httml.





