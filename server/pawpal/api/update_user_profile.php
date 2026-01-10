<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Method Not Allowed']);
    exit();
}

// Get POST data
$userid = $_POST['userid'];
$name = addslashes($_POST['name']);
$phone = addslashes($_POST['phone']);
$profile_image = $_POST['profile_image'];

// Validate required fields
if (empty($userid) || empty($name) || empty($phone)) {
    sendJsonResponse([
        'success' => false,
        'message' => 'Missing required fields'
    ]);
    exit();
}

// Handle image decode
if ($profile_image == "NA" || empty($profile_image)) {
    $decodedImage = "NA";
} else {
    $decodedImage = base64_decode($profile_image);
}

// Update user profile in database
$sqlupdateprofile = "
UPDATE tbl_users 
SET 
    name = '$name',
    phone = '$phone'
WHERE user_id = '$userid'
";

try {
    if ($conn->query($sqlupdateprofile) === TRUE) {

        // Handle profile image save
        if ($decodedImage != "NA") {
            $upload_dir = "../assets/profiles/";

            // Create directory if not exists
            if (!file_exists($upload_dir)) {
                mkdir($upload_dir, 0777, true);
            }

            $filename = $upload_dir . $userid . ".png";
            file_put_contents($filename, $decodedImage);

            // Update image_path in database
            $image_path = "assets/profiles/" . $userid . ".png";
            $sqlupdateimage = "UPDATE tbl_users SET image_path = '$image_path' WHERE user_id = '$userid'";
            $conn->query($sqlupdateimage);
        }

        // Fetch updated user data
        $sqlgetuser = "SELECT user_id, name, email, phone, image_path, reg_date 
                       FROM tbl_users 
                       WHERE user_id = '$userid'";

        $result = $conn->query($sqlgetuser);

        if ($result->num_rows > 0) {
            $userdata = array();
            while ($row = $result->fetch_assoc()) {
                $userdata[] = $row;
            }

            sendJsonResponse([
                'success' => true,
                'message' => 'Profile updated successfully',
                'data' => $userdata
            ]);
        } else {
            sendJsonResponse([
                'success' => true,
                'message' => 'Profile updated successfully'
            ]);
        }
    } else {
        sendJsonResponse([
            'success' => false,
            'message' => 'Profile update failed'
        ]);
    }
} catch (Exception $e) {
    sendJsonResponse([
        'success' => false,
        'message' => $e->getMessage()
    ]);
}

$conn->close();

// ---------- JSON response ----------
function sendJsonResponse($sentArray)
{
    echo json_encode($sentArray);
}
