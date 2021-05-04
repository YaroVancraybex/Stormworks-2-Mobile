checkForImageCounter,reloadTimeout,loaded=0,300,false
image,imageRgb={},{}
y,A=0.544,0.48
mMin,sC,dL=math.min,screen.setColor,screen.drawLine
imageW,imageH=0,0

function onTick()
	if not loaded then
		loaded = true
		async.httpGet(80, "/retrieveImage.php")
	end

	if input.getBool(1) and reloadTimeout==0 then
		loaded,reloadTimeout = false,300
		async.httpGet(80, "/retrieveImage.php")
	elseif reloadTimeout>0 then reloadTimeout=reloadTimeout-1 end
end


function onDraw()
	local sH,sW = screen.getHeight(),screen.getWidth()
	local pX = sH * sW
	if pX >= #imageRgb then
		counter=0
		for w=0,imageW do
			for h=0,imageH do
				counter=w*imageH+h+1
				v=imageRgb[counter] or {0,0,0}
				sC(v[1],v[2],v[3])
				dL(w,h,w,h+1)
			end
		end
	elseif #imageRgb>1 then
		counter=0
		for w=0,sW do
			for h=0,sH do
				counter=w*imageH+h+1
				v=imageRgb[counter] or {0,0,0}
				sC(v[1],v[2],v[3])
				dL(w,h,w,h+1)
			end
		end
	end
end


function httpReply(port, request_body, response_body)
	image = split(response_body,',')
	imageW,imageH = image[1],image[2]
	table.remove(image,1)
	table.remove(image,2)

	imageUpdate()
end


function gameToLua(r,g,b)
	r=mMin(A*r^y/255^y*r,255)
	g=mMin(A*g^y/255^y*g,255)
	b=mMin(A*b^y/255^y*b,255)

	return r,g,b
end


function imageUpdate()
	imageRgb = {}

	for k,v in ipairs(image) do
		val=tonumber(v,16)
		r,g,b=val//65536,(val//256)%256,val%256
		r,g,b=gameToLua(r,g,b)
		table.insert(imageRgb,{r,g,b})
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