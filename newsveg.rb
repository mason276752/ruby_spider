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
    newsvegUrl = url.text
    puts newsvegUrl
    if(newsvegUrl.include? "https://newsveg.tw/blog/")
        # meta
        pageNumber = /\d+$/.match(newsvegUrl)
        page = Nokogiri::HTML(URI.open(newsvegUrl))
        title = page.xpath("//div[@class='elementor-widget-container']/h1[contains(@class,'elementor-heading-title')]").text.gsub("/", "+")
        body = page.xpath("//div[contains(@class,'elementor-widget-theme-post-content')]/div[@class='elementor-widget-container']")

        toolong.each do |str|
            if title.include? str
                title = title.sub(str,"")
            end
        end

        # author
        author = ""
        begin
            author = page.xpath("//li[@itemprop='author']/a/span")[1].text.strip.gsub("/", "+")
        rescue => exception
            author = ""
        else

        # categories
        categories = page.xpath("//div[contains(@class,'singlepost-tag-list')]/div/h2/a").each do |categorie|
            dirname = categorie.text.gsub("/", "+")
            if !Dir.exist?("./public/#{dirname}") && dirname != ""
                Dir.mkdir("./public/#{dirname}")
            end
            File.write("./public/#{dirname}/#{pageNumber}-#{author}-#{title}.html", body)
        end
    end 
end