<?php
$image = $_POST['image'];
$name = $_POST['name'];
$newName = explode(".", $name);
$newName = 'swImage.' . end($newName);
$realImage = base64_decode($image);

if (file_exists('swImage.png')) {
	unlink('swImage.png');
}

file_put_contents($newName, $realImage);
$resizedImage = resizeImage($newName,$_POST['width'],$_POST['height']);
imagepng($resizedImage,'swImage.png');
echo "success";


function resizeImage($file, $w, $h, $crop=FALSE) {
    list($width, $height) = getimagesize($file);
    $r = $width / $height;
    if ($crop) {
        if ($width > $height) {
            $width = ceil($width-($width*abs($r-$w/$h)));
        } else {
            $height = ceil($height-($height*abs($r-$w/$h)));
        }
        $newwidth = $w;
        $newheight = $h;
    } else {
        if ($w/$h > $r) {
            $newwidth = $h*$r;
            $newheight = $h;
        } else {
            $newheight = $w/$r;
            $newwidth = $w;
        }
    }
    $src = imagecreatefromjpeg($file);
    $dst = imagecreatetruecolor($newwidth, $newheight);
    imagecopyresampled($dst, $src, 0, 0, 0, 0, $newwidth, $newheight, $width, $height);

    return $dst;
}