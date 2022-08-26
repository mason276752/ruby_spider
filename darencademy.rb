require 'nokogiri'
require 'open-uri'

sitemapxml = 'https://www.darencademy.com/sitemap.xml'
xml = Nokogiri::HTML(URI.open(sitemapxml))
if !Dir.exist?("./public")
    Dir.mkdir("./public")
end


toolong=[
    "#",
    "?"
]

xml.xpath("//url/loc").each do |url|
    darencademyUrl = url.text
    if(darencademyUrl.include? "https://www.darencademy.com/article/view/id")
        # meta
        pageNumber = /\d+$/.match(darencademyUrl)
        page = Nokogiri::HTML(URI.open(darencademyUrl))
        title = page.xpath("//header[@class='post_header']/h1").text.gsub("/", "+")
        body = page.xpath("//div[@class='post_content']")

        toolong.each do |str|
            if title.include? str
                title = title.gsub(str,"")
            end
        end

        # author
        author = page.xpath("//span[@class='author']").text.gsub("/", "+")

        # categories
        categories = page.xpath("//div[@class='content_meta']/span[@class='category']").each do |categorie|
            dirname = categorie.text.gsub("/", "+")
            if !Dir.exist?("./public/#{dirname}") && dirname != ""
                Dir.mkdir("./public/#{dirname}")
            end
            File.write("./public/#{dirname}/#{pageNumber}-#{author}-#{title}.html", body)
        end
    end 
end