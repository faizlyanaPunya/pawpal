<?php
	header("Access-Control-Allow-Origin: *");
	include 'dbconnect.php';

	if ($_SERVER['REQUEST_METHOD'] != 'POST') {
		http_response_code(405);
		echo json_encode(array('error' => 'Method Not Allowed'));
		exit();
	}
	$userid = $_POST['userid'];
	$petname = addslashes($_POST['petname']);
	$pettype = $_POST['pettype'];
	$category = $_POST['category'];
	$description = addslashes($_POST['description']);
	$latitude = isset($_POST['latitude']) ? $_POST['latitude'] : '';
	$longitude = isset($_POST['longitude']) ? $_POST['longitude'] : '';

	$images = []; 
	for ($i = 1; $i <= 3; $i++) {
		if (isset($_POST['image'.$i]) && !empty($_POST['image'.$i])) {
			$images[] = base64_decode($_POST['image'.$i]);
		}
	}

	// Insert new service into database
	$sqlinsertpet = "INSERT INTO `tbl_pets`(`user_id`, `pet_name`, `pet_type`, `category`, `description`, `lat`, `lng`) VALUES ('$userid','$petname','$pettype','$category','$description','$latitude','$longitude')";
	try{
		if ($conn->query($sqlinsertpet) === TRUE){
			$last_id = $conn->insert_id;
			$imagePaths = [];

			// Save each image file
			foreach ($images as $index => $img) {
				$imgIndex = $index + 1;
				$path = "../assets/pets/pet_{$last_id}_{$imgIndex}.png";
				file_put_contents($path, $img);
				$imagePaths[] = "assets/pets/pet_{$last_id}_{$imgIndex}.png";
			}

			// Save image paths in DB as JSON (so you can have multiple images)
			$imagePathsJson = json_encode($imagePaths);
			$sqlupdateimage = "UPDATE tbl_pets SET image_paths='$imagePathsJson' WHERE pet_id='$last_id'";
			$conn->query($sqlupdateimage);

			$response = array('status' => 'success', 'message' => 'Pet added successfully');
			sendJsonResponse($response);
		}else{
			$response = array('status' => 'failed', 'message' => 'Pet not added');
			sendJsonResponse($response);
		}
	}catch(Exception $e){
		$response = array('status' => 'failed', 'message' => $e->getMessage());
		sendJsonResponse($response);
	}


//	function to send json response	
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}


?>