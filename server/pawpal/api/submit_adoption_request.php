<?php
header("Access-Control-Allow-Origin: *");
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    // here it to check if all required fields are present
    if (!isset($_POST['user_id']) || !isset($_POST['pet_id']) || !isset($_POST['motivation_message'])) {
        $response = array('status' => 'failed', 'message' => 'Missing required fields');
        sendJsonResponse($response);
        exit();
    }

    // Get POST data
    $user_id = $_POST['user_id'];
    $pet_id = $_POST['pet_id'];
    $motivation_message = $_POST['motivation_message'];

    // Validate empty fields
    if (empty($user_id) || empty($pet_id) || empty($motivation_message)) {
        $response = array('status' => 'failed', 'message' => 'All fields are required');
        sendJsonResponse($response);
        exit();
    }

    // Sanitize inputs
    $user_id = $conn->real_escape_string($user_id);
    $pet_id = $conn->real_escape_string($pet_id);
    $motivation_message = $conn->real_escape_string($motivation_message);

    // Check if pet exists
    $checkPetSql = "SELECT pet_id FROM tbl_pets WHERE pet_id = '$pet_id'";
    $petResult = $conn->query($checkPetSql);

    if ($petResult->num_rows == 0) {
        $response = array('status' => 'failed', 'message' => 'Pet not found');
        sendJsonResponse($response);
        exit();
    }

    // Check if user already requested this pet
    $checkRequestSql = "SELECT * FROM tbl_adoptions WHERE user_id = '$user_id' AND pet_id = '$pet_id'";
    $requestResult = $conn->query($checkRequestSql);

    if ($requestResult->num_rows > 0) {
        $response = array('status' => 'failed', 'message' => 'You have already requested to adopt this pet');
        sendJsonResponse($response);
        exit();
    }

    // Insert adoption request
    $sqlInsert = "INSERT INTO tbl_adoptions (user_id, pet_id, motivation_message, created_at) 
                  VALUES ('$user_id', '$pet_id', '$motivation_message', NOW())";

    if ($conn->query($sqlInsert) === TRUE) {
        $response = array('status' => 'success', 'message' => 'Adoption request submitted successfully');
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'message' => 'Failed to submit request: ' . $conn->error);
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
