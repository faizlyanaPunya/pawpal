<?php
header("Access-Control-Allow-Origin: *");
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (!isset($_POST['user_id']) || !isset($_POST['pet_id']) || !isset($_POST['donation_type'])) {
        $response = array('status' => 'failed', 'message' => 'Missing required fields');
        sendJsonResponse($response);
        exit();
    }

    $user_id = $_POST['user_id'];
    $pet_id = $_POST['pet_id'];
    $donation_type = $_POST['donation_type'];
    $amount = isset($_POST['amount']) ? $_POST['amount'] : null;

    if (empty($user_id) || empty($pet_id) || empty($donation_type)) {
        $response = array('status' => 'failed', 'message' => 'All required fields are necessary');
        sendJsonResponse($response);
        exit();
    }

    $valid_types = ['Food', 'Medical', 'Money'];
    if (!in_array($donation_type, $valid_types)) {
        $response = array('status' => 'failed', 'message' => 'Invalid donation type');
        sendJsonResponse($response);
        exit();
    }

    if ($donation_type === 'Money') {
        if (empty($amount) || !is_numeric($amount) || floatval($amount) <= 0) {
            $response = array('status' => 'failed', 'message' => 'Invalid donation amount');
            sendJsonResponse($response);
            exit();
        }
    }

    $user_id = $conn->real_escape_string($user_id);
    $pet_id = $conn->real_escape_string($pet_id);
    $donation_type = $conn->real_escape_string($donation_type);
    if ($amount !== null) {
        $amount = floatval($amount);
    }

    $checkPetSql = "SELECT pet_id FROM tbl_pets WHERE pet_id = '$pet_id'";
    $petResult = $conn->query($checkPetSql);

    if ($petResult->num_rows == 0) {
        $response = array('status' => 'failed', 'message' => 'Pet not found');
        sendJsonResponse($response);
        exit();
    }

    if ($amount !== null) {
        $sqlInsert = "INSERT INTO tbl_donations (user_id, pet_id, donation_type, amount, created_at) 
                      VALUES ('$user_id', '$pet_id', '$donation_type', $amount, NOW())";
    } else {
        $sqlInsert = "INSERT INTO tbl_donations (user_id, pet_id, donation_type, created_at) 
                      VALUES ('$user_id', '$pet_id', '$donation_type', NOW())";
    }

    if ($conn->query($sqlInsert) === TRUE) {
        $response = array('status' => 'success', 'message' => 'Donation submitted successfully');
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'message' => 'Failed to submit donation: ' . $conn->error);
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
