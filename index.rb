require 'nokogiri'
require 'open-uri'

sitemapxml = 'https://afu.tw/post-sitemap.xml'
xml = Nokogiri::HTML(open( sitemapxml ))
if !Dir.exist?("./public")
    Dir.mkdir("./public")
end

xml.xpath("//url/loc").each do |url|
    afuurl = url.text
    page_number= /\d+$/.match(afuurl)
    page = Nokogiri::HTML(open( afuurl ))
    title = page.xpath("//title").text.gsub("/","+")
    body = page.xpath("//div[@class='the_content_wrapper']")

    categories = page.xpath("//ul[@class='post-categories']/li").each do |categorie|
        dirname=categorie.text.gsub("/","+")
        if !Dir.exist?("./public/#{dirname}") && dirname != ""
            Dir.mkdir("./public/#{dirname}")
        end
        File.write("./public/#{dirname}/#{page_number}-#{title}.html",body)
    end
end