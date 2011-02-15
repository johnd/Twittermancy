class Divination
  require 'rubygems'
  require 'active_support/all'
  require 'open-uri'
  require 'json'
  require 'digest/sha1'

  def initialize(search_term, time_delay=2, cache_root='cache')

    cache_file = APP_ROOT + cache_root + "/" + Digest::SHA1.hexdigest(search_term)

    if File.exists?(cache_file) && File.mtime(cache_file) > time_delay.hours.ago
      cache = File.new(cache_file, 'r')
      @feed = JSON.parse(cache.gets)

    else

      source = "http://search.twitter.com/search.json?q=#{search_term}&rpp=50&lang=en"
      content = ""
      open(source) do |s| 
        content = s.read
      end

      cache = File.new(cache_file, 'w+')
      cache.puts content
      cache.rewind
      @feed = JSON.parse(cache.gets)

    end
  end

  def results
    results = []
    query = @feed['query'].downcase
    @feed['results'].each do | entry |
      text = sanitise entry['text']
      words = text.downcase.scan(/\w+/).-([query])
      word = words[rand(words.length)]
      results << {:word => word, :tweet => entry["text"], :user => entry['from_user'], :id => entry['id']}
    end
    return results
  end
  
  private
  
  def sanitise(string)
    # This is really ugly.
    converter = Iconv.new('ASCII//IGNORE//TRANSLIT', 'UTF-8') 
    converter.iconv(string).unpack('U*').select{ |cp| cp < 127 && cp > 31}.pack('U*').gsub(/@\w+/,'').gsub(/&.*?;/, '').gsub(/(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix,'')
  end
end