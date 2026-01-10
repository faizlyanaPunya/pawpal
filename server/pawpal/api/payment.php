<?php
error_reporting(0);
include 'dbconnect.php';

$email = $_GET['email']; 
$phone = $_GET['phone']; 
$name = $_GET['name']; 
$amount = $_GET['amount']; 
$userid = $_GET['userid'];
$petid = $_GET['pet_id'];

// check your own API key here ( Billplz dashboard )
// as well as the collection ID
$api_key = '7713cf5e-cc82-4124-9f8d-81ab64ba2da9';
$collection_id = '_dful5u8';
$host = 'https://www.billplz-sandbox.com/api/v3/bills';

$data = array(
    'collection_id' => $collection_id,
    'email'         => $email,
    'mobile'        => $phone,
    'name'          => $name,
    'amount'        => $amount * 100, // Billplz uses cents
    'description'   => 'Donation for Pet ID: '.$petid,
    'callback_url'  => "https://socstudentmusicforlife.com/faiz/pawpal/api/return_url.php",
    // Passing pet_id to the update script so the donation can be recorded
    'redirect_url'  => "https://socstudentmusicforlife.com/faiz/pawpal/api/payment.php?userid=$userid&email=$email&name=$name&phone=$phone&amount=$amount&pet_id=$petid" 
);

$process = curl_init($host);
curl_setopt($process, CURLOPT_HEADER, 0);
curl_setopt($process, CURLOPT_USERPWD, $api_key . ":");
curl_setopt($process, CURLOPT_TIMEOUT, 30);
curl_setopt($process, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($process, CURLOPT_SSL_VERIFYHOST, 0);
curl_setopt($process, CURLOPT_SSL_VERIFYPEER, 0);
curl_setopt($process, CURLOPT_POSTFIELDS, http_build_query($data)); 

$return = curl_exec($process);
curl_close($process);

$bill = json_decode($return, true);
header("Location: {$bill['url']}");
?>