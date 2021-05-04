<?php
$json = file_get_contents("data.json");
$json = json_decode($json, true);

if (isset($json['joystickData']['axis4']) and isset($json['buttonData']['button1']) and isset($json['sliderData']['slider4'])) {
	echo
	strval($json['joystickData']['axis1']).':'.
	strval($json['joystickData']['axis2']).':'.
	strval($json['joystickData']['axis3']).':'.
	strval($json['joystickData']['axis4']).':'.

	$json['buttonData']['button1'].':'.
	$json['buttonData']['button2'].':'.
	$json['buttonData']['button3'].':'.
	$json['buttonData']['button4'].':'.

	$json['sliderData']['slider1'].':'.
	$json['sliderData']['slider2'].':'.
	$json['sliderData']['slider3'].':'.
	$json['sliderData']['slider4']
	;
} else {
	echo "error";
	$dataFile = fopen("data.json", "w");
	$resetJson = '{"joystickData":{"axis1":0,"axis2":0,"axis3":0,"axis4":0},"buttonData":{"button1":"0","button2":"0","button3":"0","button4":"0"},"sliderData":{"slider1":"0.0","slider2":"0.0","slider3":"0.0","slider4":"0.0"}}';
	fwrite($dataFile, $resetJson);
	fclose($dataFile);
}

// Data is being transmitted as follows:
// axis1:axis2:axis3:axis4:button1:button2:button3:button4:slider1:slider2:slider3:slider4