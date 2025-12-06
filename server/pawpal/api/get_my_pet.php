<?php
header("Access-Control-Allow-Origin: *"); // running as chrome app

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    include 'dbconnect.php';

    // Base JOIN query for PETS
    $baseQuery = "
        SELECT 
            p.pet_id,
            p.user_id,
            p.pet_name,
            p.pet_type,
            p.category,
            p.description,
            p.image_paths,
            p.lat,
            p.lng,
            p.created_at,
            u.name,
            u.email,
            u.phone
        FROM tbl_pets p
        JOIN tbl_users u ON p.user_id = u.user_id
    ";

    // Search logic
    if (isset($_GET['search']) && !empty($_GET['search'])) {
        $search = $conn->real_escape_string($_GET['search']);
        $sqlloadpets = $baseQuery . "
            WHERE p.pet_name LIKE '%$search%' 
               OR p.pet_type LIKE '%$search%'
               OR p.category LIKE '%$search%'
               OR p.description LIKE '%$search%'
            ORDER BY p.pet_id DESC";
    } else {
        $sqlloadpets = $baseQuery . " ORDER BY p.pet_id DESC";
    }

    $result = $conn->query($sqlloadpets);

    if ($result && $result->num_rows > 0) {
        $petdata = array();
        while ($row = $result->fetch_assoc()) {
            $petdata[] = $row;
        }
        $response = array('status' => 'success', 'data' => $petdata);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }

} else {
    $response = array('status' => 'failed');
    sendJsonResponse($response);
    exit();
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>