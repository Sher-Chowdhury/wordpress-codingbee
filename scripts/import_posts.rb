require 'nokogiri'

data = File.read("/root/codingbee.wordpress.2017-01-14-just-all-posts.xml")

xml_doc = Nokogiri::XML(data)

#output = @xml_doc.xpath("//channel/item")

#puts output.public_methods

#puts output

#puts output.inner_text

#for post_data in output
xml_doc.xpath("//channel/item").each do |post_data|
   post_title = post_data.xpath("title")
   #puts post_title.inner_text
   post_content = post_data.xpath("content:encoded")
   #puts post_content.inner_text
   post_category = post_data.xpath("category[@domain='category']")
   #puts post_category.inner_text
   post_data.xpath("category[@domain='post_tag']").each do |post_tag|
     puts post_tag.inner_text
     puts "#####"
   end
   #puts post_tags
   puts "################################################################################################################################################################################"
end
