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
            p.pet_gender,
            p.pet_age,
            p.pet_health,
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

    // Initialize WHERE conditions array
    $conditions = array();

    // Search logic
    if (isset($_GET['search']) && !empty($_GET['search'])) {
        $search = $conn->real_escape_string($_GET['search']);
        $conditions[] = "(
            p.pet_name LIKE '%$search%' 
            OR p.pet_type LIKE '%$search%'
            OR p.category LIKE '%$search%'
            OR p.description LIKE '%$search%'
        )";
    }

    // Filter logic
    if (isset($_GET['filter']) && !empty($_GET['filter'])) {
        $filter = $conn->real_escape_string($_GET['filter']);
        $conditions[] = "p.pet_type = '$filter'";
    }

    // Build final query
    if (count($conditions) > 0) {
        $sqlloadpets = $baseQuery . " WHERE " . implode(' AND ', $conditions) . " ORDER BY p.pet_id DESC";
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