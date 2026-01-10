<?php
header("Access-Control-Allow-Origin: *");
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (!isset($_POST['user_id'])) {
        $response = array('status' => 'failed', 'message' => 'User ID is required');
        sendJsonResponse($response);
        exit();
    }

    $user_id = $_POST['user_id'];

    if (empty($user_id)) {
        $response = array('status' => 'failed', 'message' => 'User ID cannot be empty');
        sendJsonResponse($response);
        exit();
    }

    $user_id = $conn->real_escape_string($user_id);

    // Fetch all donations for the user
    $sql = "SELECT donation_id, pet_id, donation_type, amount, created_at 
            FROM tbl_donations 
            WHERE user_id = '$user_id' 
            ORDER BY created_at DESC";

    $result = $conn->query($sql);

    if ($result) {
        $donations = array();
        while ($row = $result->fetch_assoc()) {
            $donations[] = $row;
        }

        $response = array(
            'status' => 'success',
            'donations' => $donations,
            'count' => count($donations)
        );
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'message' => 'Error fetching donations: ' . $conn->error);
        sendJsonResponse($response);
    }

    $conn->close();
} else {
    $response = array('status' => 'failed', 'message' => 'Method Not Allowed');
    sendJsonResponse($response);
    exit();
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>