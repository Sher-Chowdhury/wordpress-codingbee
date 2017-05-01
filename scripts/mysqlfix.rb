require 'rubygems'
require 'nokogiri'
require 'mysql2'

# Added the following line to output to jenkins console in realtime.
STDOUT.sync = true

############################################################################
######################## Fix xml problem session ###########################
############################################################################

doc = Nokogiri::XML(File.read("/root/downloads/wp-all-import-exports/bundle/codingbee-posts-exports.xml"))

client = Mysql2::Client.new(:host => "localhost", :username => "root")
client.select_db('wp_db')
@doc = doc.xpath('//post').each do |record|
 puts record.xpath('Title').text
 title = record.xpath('Title').text
 content = record.xpath('Content').text
 #puts record.xpath('Title').public_methods.sort
 client.query("SET post_content = '#{content}' from wp_posts WHERE post_title='#{title}'")
end
exit

client = Mysql2::Client.new(:host => "localhost", :username => "root")
client.select_db('wp_db')

results = client.query("SELECT * from wp_posts WHERE post_title=\"Puppet - Format of the ENC's output\"")
results.each do |row|
  puts row['post_content']
  #puts row.public_methods # {"id"=>1, "dep"=>1, "name"=>"hoge"}
  puts row.class # {"id"=>1, "dep"=>1, "name"=>"hoge"}
end
#puts total_posts.public_methods.sort
#puts total_posts.class

exit
