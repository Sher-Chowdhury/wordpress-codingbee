require 'nokogiri'

result = system("wp post create /tmp/post_content.txt --post_type=post --post_title='another test post' --post_status=publish --post_date='2015-12-01 07:00:00' --post_category=53 --path=/var/www/html/ --porcelain")
puts result
puts "hello"
exit


data = File.read("/root/codingbee.wordpress.2017-01-14-just-all-posts.xml")

xml_doc = Nokogiri::XML(data)

#output = @xml_doc.xpath("//channel/item")

#puts output.public_methods

#puts output

#puts output.inner_text

#for post_data in output
xml_doc.xpath("//channel/item").each do |post_data|
   post_title = post_data.xpath("title").inner_text
   #puts post_title
   post_content = post_data.xpath("content:encoded").inner_text
   #puts post_content

   %x( echo "#{post_content}"  > /tmp/post_content.txt )
   post_category = post_data.xpath("category[@domain='category']").inner_text
   #puts post_category
   post_category_id = %x(wp term list category --fields=term_id,name --path=/var/www/html/ | grep -i ansible | awk '{print $2;}')

   post_date = post_data.xpath("wp:post_date").inner_text
   #puts post_date

   post_status = post_data.xpath("wp:status").inner_text
   #puts post_status
   post_id = %x(wp post create /tmp/post_content.txt --post_type=post --post_title='#{post_title}' --post_status='#{post_status}' --post_date='#{post_date}' --post_category=#{post_category_id} --path=/var/www/html/)
   #%x( echo "#{post_title}"  > /tmp/testfile.txt )


   post_data.xpath("category[@domain='post_tag']").each do |post_tag|
     # puts post_tag.inner_text
     post_tag = post_tag.inner_text
     %x(wp post term add #{post_id} post_tag "%{post_tag}" --path=/var/www/html/)
   end
   puts "################################################################################################################################################################################"

end
#%x( echo #{post_status}  > /tmp/testfile.txt )
