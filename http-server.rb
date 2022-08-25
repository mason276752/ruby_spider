require 'nokogiri'
require 'open-uri'

@httpserverUrl = 'http://127.0.0.1:8080'



toolong=[
    
]


def decode(path)
    xml = Nokogiri::HTML(URI.open(@httpserverUrl+path))
    if !Dir.exist?("./public"+URI.unescape(path))
        Dir.mkdir("./public"+URI.unescape(path))
    end
    
    File.write("./public#{URI.unescape(path)}index.html", xml.to_html)
    
    xml.xpath("//tr").each do |tr|
        trxml = Nokogiri::HTML(tr.to_html)
        code = trxml.xpath("//td[@class='perms']/code").text
        if code.include?("(dr")
            # puts trxml.xpath("//td[@class='display-name']/a")[0]["href"]
            pathdeep = trxml.xpath("//td[@class='display-name']/a")[0]["href"]
            if (!pathdeep.include?(".."))
                puts URI.unescape(pathdeep)
                decode(pathdeep)
            end

            # if(@httpserverUrl.include? "/")
            #     # meta
            #     pageNumber = /\d+$/.match(@httpserverUrl)
            #     page = Nokogiri::HTML(URI.open(@httpserverUrl))
            #     title = page.xpath("//div[@class='elementor-widget-container']/h1[contains(@class,'elementor-heading-title')]").text.gsub("/", "+")
            #     body = page.xpath("//div[contains(@class,'elementor-widget-theme-post-content')]/div[@class='elementor-widget-container']")
        
            #     toolong.each do |str|
            #         if title.include? str
            #             title = title.sub(str,"")
            #         end
            #     end
        
            #     # author
            #     author = ""
            #     begin
            #         author = page.xpath("//li[@itemprop='author']/a/span")[1].text.strip.gsub("/", "+")
            #     rescue => exception
            #         author = ""
            #     else
        
            #     # categories
            #     categories = page.xpath("//div[contains(@class,'singlepost-tag-list')]/div/h2/a").each do |categorie|
            #         dirname = categorie.text.gsub("/", "+")
            #         if !Dir.exist?("./public/#{dirname}") && dirname != ""
            #             Dir.mkdir("./public/#{dirname}")
            #         end
            #         File.write("./public/#{dirname}/#{pageNumber}-#{author}-#{title}.html", body)
            #     end
            # end 
        end
    end
end
decode("/")