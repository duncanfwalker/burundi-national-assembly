require 'scraperwiki'
require 'mechanize'

url = "http://www.assemblee.bi/spip.php?page=imprimer&id_article=418"
year = '2015'

# # Read in a page
agent = Mechanize.new
page = agent.get(url)

table = page.at('div.Sect table')
table.xpath('./*/tr[position()>1]').each  do |row|
  row_data = {
      :id => year+'-'+row.css('td')[0].text.strip,
      # first name and surname is sometimes two <p>s, sometimes not
      :name =>  row.xpath('./td[position()=2]/p/span').collect{|part| part.text.gsub('Hon.', '').strip}.join(' '),
      :national_identity =>row.css('td')[2].text.strip,
      :gender => { 'M'=>'Male', 'F'=>'Female' }[row.css('td')[3].text.strip],
      :party => row.css('td')[4].text.strip,
      :area => row.css('td')[5].text.strip,
      :term => year
  }
  puts row_data
  ScraperWiki.save_sqlite([:id],row_data )
end
