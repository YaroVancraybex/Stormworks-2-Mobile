<?php
if (isset($_POST['type'])) {
	$json = file_get_contents("data.json");
	$json = json_decode($json, true);

	if ($_POST['type'] == 'joystick') {
		if ($_POST['verticalAxis'] < 0) {
			$verticalAxis = round($_POST['verticalAxis'],3);
		} else {
			$verticalAxis = round($_POST['verticalAxis'],4);
		}
		if ($_POST['horizontalAxis'] < 0) {
			$horizontalAxis = round($_POST['horizontalAxis'],3);
		} else {
			$horizontalAxis = round($_POST['horizontalAxis'],4);
		}

		if ($_POST['side'] == '1') {
			$json['joystickData']['axis1'] = $verticalAxis;
			$json['joystickData']['axis2'] = $horizontalAxis;
		} else {
			$json['joystickData']['axis3'] = $verticalAxis;
			$json['joystickData']['axis4'] = $horizontalAxis;
		}
	} elseif ($_POST['type'] == 'button') {
		$json['buttonData']['button'.$_POST['channel']] = $_POST['state'];
	} elseif ($_POST['type'] == 'slider') {
		$json['sliderData']['slider'.$_POST['channel']] = $_POST['value'];
	}

	$newJson = json_encode($json);
	file_put_contents('data.json', $newJson);
} else {
	echo "STATUS : OK";
}