<?php
//echo "My first PHP script!";



$con=mysqli_connect("localhost","USERNAME","PASSWORD","DATABASENAME");

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
  $post_title=$post->Title;
  $post_content=$post->Content;
  $post_tags=$post->Tags;

  $escaped_post_title = mysqli_real_escape_string($con, $post_title);
  $escaped_post_content = mysqli_real_escape_string($con, $post_content);
  $escaped_post_tags = mysqli_real_escape_string($con, $post_tags);

  $sql = "UPDATE wp_posts SET post_content='$escaped_post_content' WHERE post_title='$escaped_post_title'";

  if (!mysqli_query($con,$sql)) {
    die('Error: ' . mysqli_error($con));
  }
  echo "The following post has been update: $post_title";
  echo "<br />";


}

// The above foreach loop introduced other brand new weird looking characters which I ended up fixing with the
// following sql queries


// https://digwp.com/2011/07/clean-up-weird-characters-in-database/

$sql = "UPDATE wp_posts SET post_content = REPLACE(post_content, 'Â', ' ')";
if (!mysqli_query($con,$sql)) {
  die('Error: ' . mysqli_error($con));
}
$sql = "UPDATE wp_posts SET post_content = REPLACE(post_content, 'â€œ', '“')";
if (!mysqli_query($con,$sql)) {
  die('Error: ' . mysqli_error($con));
}
$sql = "UPDATE wp_posts SET post_content = REPLACE(post_content, 'â€™', '’')";
if (!mysqli_query($con,$sql)) {
  die('Error: ' . mysqli_error($con));
}
$sql = "UPDATE wp_posts SET post_content = REPLACE(post_content, 'â€˜', '‘')";
if (!mysqli_query($con,$sql)) {
  die('Error: ' . mysqli_error($con));
}
$sql = "UPDATE wp_posts SET post_content = REPLACE(post_content, 'â€”', '-')";
if (!mysqli_query($con,$sql)) {
  die('Error: ' . mysqli_error($con));
}
$sql = "UPDATE wp_posts SET post_content = REPLACE(post_content, 'â€“', '-')";
if (!mysqli_query($con,$sql)) {
  die('Error: ' . mysqli_error($con));
}
$sql = "UPDATE wp_posts SET post_content = REPLACE(post_content, 'â€¢', '-')";
if (!mysqli_query($con,$sql)) {
  die('Error: ' . mysqli_error($con));
}
$sql = "UPDATE wp_posts SET post_content = REPLACE(post_content, 'â€¦', '…')";
if (!mysqli_query($con,$sql)) {
  die('Error: ' . mysqli_error($con));
}


mysqli_close($con);
?>
