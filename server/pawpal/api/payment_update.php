<?php
// error_reporting(0);
include 'dbconnect.php';

$email = $_GET['email'];
$phone = $_GET['phone']; 
$name = $_GET['name']; 
$amount = $_GET['amount']; 
$userid = $_GET['userid'];
$petid = $_GET['pet_id']; 

$data = array(
    'id' =>  $_GET['billplz']['id'],
    'paid_at' => $_GET['billplz']['paid_at'],
    'paid' => $_GET['billplz']['paid'],
    'x_signature' => $_GET['billplz']['x_signature']
);

$paidstatus = ($_GET['billplz']['paid'] == "true") ? "Success" : "Failed";
$receiptid = $_GET['billplz']['id'];


$signing = '';
foreach ($data as $key => $value) {
    $signing .= 'billplz' . $key . $value;
    if ($key === 'paid') break;
    else $signing .= '|';
}
 
// put your own xket here
// after the $signing
$signed = hash_hmac('sha256', $signing, '5367828d0b8a66fec2ea00129841994cc8cf352e449500a44ab723afe59acad02b639a0fee249f75b34228fd060ef47cf92fba3816b88f02b477b498f516a1c9');

echo "<html><meta name='viewport' content='width=device-width, initial-scale=1'>
      <link rel='stylesheet' href='https://www.w3schools.com/w3css/4/w3.css'>
      <style>
        .loader { border: 4px solid #f3f3f3; border-top: 4px solid #3498db; border-radius: 50%; width: 20px; height: 20px; animation: spin 2s linear infinite; display: inline-block; vertical-align: middle; }
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
      </style>
      <body><div class='w3-container w3-padding'>";

if ($signed === $data['x_signature'] && $paidstatus == "Success") {
    
    // 1. Update Donation Table
    $sqlinsert = "INSERT INTO `tbl_donations` (`user_id`, `pet_id`, `donation_type`, `amount`) 
                  VALUES ('$userid', '$petid', 'Money', '$amount')";
    
    if ($conn->query($sqlinsert) === TRUE) {
        $statusText = "Donation Successful";
        $colorClass = "w3-text-green";
        
        // Auto-close script for success
        echo "<script>
                setTimeout(function(){
                    window.close();
                }, 3000);
              </script>";
    } else {
        $statusText = "Payment Success, but Database Update Failed";
        $colorClass = "w3-text-orange";
    }
} else {
    $statusText = "Payment Failed";
    $colorClass = "w3-text-red";
}

// Display Receipt
echo "<center><h3>Receipt</h3></center>
    <table class='w3-table w3-striped w3-bordered'>
    <tr><td><b>Receipt ID</b></td><td>$receiptid</td></tr>
    <tr><td><b>Pet ID</b></td><td>$petid</td></tr>
    <tr><td><b>Paid Amount</b></td><td>RM $amount</td></tr>
    <tr><td><b>Status</b></td><td class='$colorClass'>$statusText</td></tr>
    </table>
    <br>
    <div class='w3-center'>";

if ($paidstatus == "Success") {
    echo "<p class='w3-text-blue'><div class='loader'></div> Returning to PawPal in 3 seconds...</p>";
}

echo "  <p>If the window does not close automatically, please click the button below.</p>
        <button onclick='window.close()' class='w3-button w3-blue w3-round-large'>Return to PawPal</button>
    </div>";

echo "</div></body></html>";
?>