require 'nokogiri'
require 'open-uri'

sitemapxml = 'https://afu.tw/post-sitemap.xml'
xml = Nokogiri::HTML(URI.open(sitemapxml))
if !Dir.exist?("./public")
    Dir.mkdir("./public")
end


toolong=[
    "（含文獻 Reference，原文標題：The Key Elements of Gamification in Corporate Training - The Delphi Method）",
    "：在Hahow的《教學的技術－線上課程》，與PressPlay「教學的技術12堂案例課」、大大學院「如何成為超級好講師」"
]

xml.xpath("//url/loc").each do |url|
    afuUrl = url.text
    puts afuUrl
    if(afuUrl.include? "https://afu.tw/")
        # meta
        page_number = /\d+$/.match(afuUrl)
        page = Nokogiri::HTML(URI.open(afuUrl))
        title = page.xpath("//title").text.gsub("/", "+")
        body = page.xpath("//div[@class='the_content_wrapper']")

        toolong.each do |str|
            if title.include? str
                title = title.sub(str,"")
            end
        end

        # author

        # categories
        categories = page.xpath("//ul[@class='post-categories']/li").each do |categorie|
            dirname = categorie.text.gsub("/", "+")
            if !Dir.exist?("./public/#{dirname}") && dirname != ""
                Dir.mkdir("./public/#{dirname}")
            end
            File.write("./public/#{dirname}/#{page_number}-#{title}.html", body)
        end
    end
end