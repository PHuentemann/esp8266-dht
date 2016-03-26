uart.setup(0, 115200, 8, 0, 1, 1)
tmr.delay(2*1000*1000)
print("\n")
gpio.mode(3, gpio.OUTPUT)
file.open("mode.lua", "r")
local line = file.read("\n")
file.close()
if "1" in line then
	local mode = wifi.STATION
elseif "2" in line then
	local mode = wifi.SOFTAP
end	
if mode == wifi.SOFTAP then
	if wifi.getmode() ~= mode then
		wifi.setmode(mode)
		cfg = {}
		cfg.ssid = "ESP8266-DHT11"
		cfg.pwd = "***********"
		wifi.ap.config(cfg)
		print(string.format("ESP8266 is now in Access Point mode.\nSSID: %s\nPassword: %s", cfg.ssid, cfg.pwd))
	else
		ip = wifi.ap.getip()
		print("The ESP8266 is in Access Point mode. IP: "..ip)
	end
elseif mode == wifi.STATION then
	if wifi.getmode() ~= mode then
		wifi.setmode(mode)
		wifi.sta.config("Repeater", "***********")
		print("Waiting for ip ...")
		tmr.alarm(1, 1000, 1, function() if wifi.sta.getip() ~= nil then print("Assgined IP-Address "..wifi.sta.getip()) tmr.stop(1) end end)
	else
		print("Waiting for ip ...")
		tmr.alarm(1, 1000, 1, function() if wifi.sta.getip() ~= nil then print("Assgined IP-Address "..wifi.sta.getip()) tmr.stop(1) end end)
	end
end
print("init.lua finished.")
dofile("dht.lua")