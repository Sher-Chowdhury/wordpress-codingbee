<?php
echo "My first PHP script!";




$con=mysqli_connect("localhost","xxxxxxx","xxxxxxxx","xxxxxxxxx");

// Check connection
if (mysqli_connect_errno()) {
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}








// $xml=simplexml_load_file("codingbee-posts-exports-dummy.xml") or die("Error: Cannot create object");
$xml=simplexml_load_file("codingbee-posts-exports.xml") or die("Error: Cannot create object");

/*
print_r($xml);
print (string) $xml->post->Title;
*/

foreach($xml->post as $post)
{

  // escape variables for security
  post_title=$post->Title
  post_content=$post->Content
  post_tags=$post->Tags


  $escaped_post_title = mysqli_real_escape_string($con, $post_title);
  $escaped_post_content = mysqli_real_escape_string($con, $post_content);
  $escaped_post_tags = mysqli_real_escape_string($con, $post_tags);







  echo (string) $post->Title;
  echo "<br />";

   
}
?>
