pin = 4
port = 7777
gpio.mode(pin, gpio.INPUT, gpio.PULLUP)
sv = net.createServer(net.TCP, 30)
sv:listen(port, function(c)
	c:on("receive", function(c, pl)
		local status, temp, humidity, temp_dec, humidity_dec = dht.read11(4)
		if status == dht.OK then
			msg = string.format("%d,%d\n", temp, humidity)
		elseif status == dht.ERROR_CHECKSUM then
			msg = "error_checksum\n"
		elseif status == dht.ERROR_TIMEOUT then
			msg = "error_timeout\n"
		end
		if string.match(pl, "getdata") then
			c:send(msg)
		end
	end)
end)
port = nil
pin = nil
msg = nil
ip = nil