axis1,axis2,axis3,axis4=0,0,0,0
button1,button2,button3,button4=0,0,0,0
slider1,slider2,slider3,slider4=0,0,0,0
requestCounter,disabled=0,false
sN,sB=output.setNumber,output.setBool
d='OK'

function onTick()
	if requestCounter == 17 and not disabled then
		requestCounter = 0
		async.httpGet(80, "/retrieve.php")
	else
		requestCounter = requestCounter + 1
	end

	sN(1,axis1)
	sN(2,axis2)
	sN(3,axis3)
	sN(4,axis4)
	sN(5,slider1)
	sN(6,slider2)
	sN(7,slider3)
	sN(8,slider4)
	if button1 == '1' then sB(1,true)
	else sB(1,false) end
	if button2 == '1' then sB(2,true)
	else sB(2,false) end
	if button3 == '1' then sB(3,true)
	else sB(3,false) end
	if button4 == '1' then sB(4,true)
	else sB(4,false) end
end


function onDraw() screen.drawTextBox(0, 0, screen.getWidth(), screen.getHeight(), d, 0, 0) end


function httpReply(port, request_body, response_body)
	if response_body ~= 'error' and split(response_body,':')[2] ~= 'connection refused' then
		data = split(response_body,':')

		axis1,axis2,axis3,axis4=data[1],data[2],data[3],data[4]
		button1,button2,button3,button4=data[5],data[6],data[7],data[8]
		slider1,slider2,slider3,slider4=data[9],data[10],data[11],data[12]
	elseif response_body ~= 'error' then -- Can't connect so disable requests.
		disabled = true
		d=response_body
	end
end


function split(str,sep)
	if sep == nil then
		sep = "%s"
	end
	local t={}
	for str in string.gmatch(str, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end