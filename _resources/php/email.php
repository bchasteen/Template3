<?php
ini_set('display_errors', '0');
date_default_timezone_set("America/New_York");

$sendto = "";
$subject = "Demo Website Email";
$errors = $message = "";
$arr = [];

if(filter_var($sendto, FILTER_VALIDATE_EMAIL) === false)
	exit("<br/>Fix sender email in /_resources/php/email.php");

if(filter_input(INPUT_POST, "email", FILTER_VALIDATE_EMAIL) === false)
	exit("<br/>Your Email was not sent for the following reasons: ".filter_var($_POST["email"], FILTER_VALIDATE_EMAIL));

/**
* Send Email with Post Fields 
*/
if(isset($_POST)){
    foreach(["email", "name", "message"] as $key => $val)
        if(isset($_POST[$val]) && !empty($_POST[$val]))
            $arr[$val] = ($val === "email") 
				? filter_var($_POST[$val], FILTER_VALIDATE_EMAIL) 
				: filter_var($_POST[$val], FILTER_SANITIZE_STRING);
		else
			$errors .= ucwords($val)." is not valid.";
	
    if(empty($errors) && $arr){
		$message = sprintf("Name: %s\nEmail: %s\nMessage: %s\n", $arr["name"], $arr["email"], $arr["message"]);
        @mail($sendto, $subject, $message, "From: " . $arr["email"]);
       	printf("<br/>Hello %s. Thank you for your interest.  We have received your email and will be in touch!", $arr["name"]);
    }
}
?>