require 'nokogiri'

data = File.read("/root/downloads/exports/codingbee.wordpress-just-all-posts.xml")

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
   post_category_id = %x(wp term list category --fields=term_id,name --path=/var/www/html/ | grep -i #{post_category} | awk '{print $2;}')
   %x( echo "#{post_category_id}"  > /tmp/post_category.txt )

   post_date = post_data.xpath("wp:post_date").inner_text
   puts post_date

   post_status = post_data.xpath("wp:status").inner_text
   puts post_status

   post_id = %x(cat /tmp/post_content.txt | wp post create --post_type=post --path=/var/www/html --porcelain --post_title='#{post_title}' --post_status='#{post_status}' --post_date='#{post_date}' --post_category=#{post_category_id}).to_s.chomp
   #%x( echo "#{post_title}"  > /tmp/testfile.txt )

   post_tags = ''
   post_data.xpath("category[@domain='post_tag']").each do |post_tag|
     # puts post_tag.inner_text
     post_tag = post_tag.inner_text.chomp
     post_tags = '#{post_tags},#{post_tag}'
     %x(wp post term add #{post_id} --path=/var/www/html/ post_tag "#{post_tag}")
   end
end
#%x( echo #{post_status}  > /tmp/testfile.txt )
