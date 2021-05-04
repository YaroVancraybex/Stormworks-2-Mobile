<?php
$giveUp = false;

if (file_exists('swImage.png')) {
	$resource = imagecreatefrompng('swImage.png');
	$imageName = 'swImage.png';
} elseif (file_exists('swImage.jpg') ) {
	$resource = imagecreatefromjpeg('swImage.jpg');
	$imageName = 'swImage.jpg';
} else {
	$giveUp = true;
}

$start = microtime(true);
if ($giveUp == false) {
	$width = imagesx($resource);
	$height = imagesy($resource);
	$pixelTable = $width.','.$height;

	for($x = 0; $x < $width; $x++) {
		for($y = 0; $y < $height; $y++) {
			//$color = imagecolorat($resource, $x, $y);
			$pixelTable = $pixelTable.','.dechex(imagecolorat($resource, $x, $y));
		}
	}
	echo $pixelTable;
}
//$time_elapsed_secs = microtime(true) - $start;
//echo '<br>'.$time_elapsed_secs;
//echo "<br>".imagecolorat($resource, 10, 10);