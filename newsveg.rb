require 'nokogiri'
require 'open-uri'

sitemapxml = 'https://newsveg.tw/post-sitemap.xml'
xml = Nokogiri::HTML(URI.open(sitemapxml))
if !Dir.exist?("./public")
    Dir.mkdir("./public")
end


toolong=[
    
]

xml.xpath("//url/loc").each do |url|
    darencademyUrl = url.text
    if(darencademyUrl.include? "https://newsveg.tw/blog/")
        pageNumber = /\d+$/.match(darencademyUrl)
        page = Nokogiri::HTML(URI.open(darencademyUrl))
        title = page.xpath("//div[@class='elementor-widget-container']/h1[contains(@class,'elementor-heading-title')]").text.gsub("/", "+")
        body = page.xpath("//div[contains(@class,'elementor-widget-theme-post-content')]/div[@class='elementor-widget-container']")

        toolong.each do |str|
            if title.include? str
                title = title.sub(str,"")
            end
        end
        author = page.xpath("//li[@itemprop='author']/a/span")[1].text.strip.gsub("/", "+")
        
        dirname = author
        if !Dir.exist?("./public/#{dirname}") && dirname != ""
            Dir.mkdir("./public/#{dirname}")
        end
        File.write("./public/#{dirname}/#{pageNumber}-#{title}.html", body)
    end 
end