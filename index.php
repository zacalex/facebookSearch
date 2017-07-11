<?php
header('Access-Control-Allow-Origin: *');
$accessToken = "EAAaSjHYhi4MBAJEXrlMjBCprUm3OSHopXezJQy2u98Lcsg26Lu2HPIXmxPwwYNcPa5NRfgk6ZBA178RAjozaltn5TCJ0ZChORBlPeB6F0I6d8LfstsORyurZCdp833kv5pg2DxMEu2pTt0vwHU0YuWHLT3OBKEZD";

if(array_key_exists('paging',$_GET)) {
    $res = file_get_contents($_GET['paging']);
    echo $res;
    exit();
} else if(array_key_exists('id',$_GET) && array_key_exists('type',$_GET)){
    if($_GET['type'] == "album"){
        $url = 'https://graph.facebook.com/v2.8/'.$_GET['id'].'?fields=name,picture.width(700).height(700),albums.limit(5){name,photos.limit(2){name,picture}}&access_token='.$accessToken;
    }else {
        $url = 'https://graph.facebook.com/v2.8/'.$_GET['id'].'?fields=name,picture.width(700).height(700),posts.limit(5){created_time,message}&access_token='.$accessToken;
    }
    
    $res = file_get_contents($url);
    echo json_encode($res);
    exit();
}
$hint = $_GET['kw'];
$lat = $_GET['lat'];
$lon = $_GET['lon'];



$accessToken = "EAAJ5TIfborYBAHujLiM5DEMPYqhScsq4blcFyon6xvdoqX3WJR6kcoqiEg6aHZAkUJ8JxgoqTrxVOlWdJbywNyGnQIPCgNZCAVmy3zsrJbGm4r12y4y0FCuqqPPA5ruTXnmjIpxvaG1WdJnNapRnxskpZClM4gZD";

$url = "https://graph.facebook.com/v2.8/search?q=".$hint.'&type=user&limit=10&fields=id,name,picture.width(700).height(700)&access_token='.$accessToken;
$user = file_get_contents($url);

$url = "https://graph.facebook.com/v2.8/search?q=".$hint.'&type=page&limit=10&fields=id,name,picture.width(700).height(700)&access_token='.$accessToken;
$page = file_get_contents($url);

$url = "https://graph.facebook.com/v2.8/search?q=".$hint.'&type=event&limit=10&fields=id,name,picture.width(700).height(700)&access_token='.$accessToken;
$event = file_get_contents($url);

$url = "https://graph.facebook.com/v2.8/search?q=".$hint.'&type=place&limit=10&fields=id,name,picture.width(700).height(700)&center='.$lat.','.$lon.'&access_token='.$accessToken;
$place = file_get_contents($url);

$url = "https://graph.facebook.com/v2.8/search?q=".$hint.'&type=group&limit=10&fields=id,name,picture.width(700).height(700)&access_token='.$accessToken;
$group = file_get_contents($url);

$res = '{"user" : '.$user.',"page" : '.$page.',"event" : '.$event.',"place" : '.$place.',"group" : '.$group.',"lat" : '.$lat.',"lon" : '.$lon.'}';


echo json_encode($res);




?>