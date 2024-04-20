class App
  def initialize
    puts "App Initialization"
  end

  def run( argv, env )

    puts "Hello from ruby #{RUBY_VERSION} on #{RUBY_PLATFORM}"
    puts "This application was built with crate 📦"
    puts "Executing : #{$0}"
    puts "ARGV      : #{argv.join(' ')}"

    puts "Loaded Features : "
    $LOADED_FEATURES.each do |lf|
      puts "  #{lf}"
    end

    puts
    puts "Load path : "
    $:.each do |lp|
      puts "  #{lp}"
    end

    puts
    puts "Env : "
    env.keys.sort.each do |k|
      puts "    #{k}  => #{env[k]}"
    end

    version_dump
    show_md5
    show_news
    puts "OpenSSL Version : #{OpenSSL::OPENSSL_VERSION}"
  end

  def version_dump
    puts "zlib Version    : #{Zlib::zlib_version}"
    puts "SQLite Version  : #{Amalgalite::SQLite3::Version}"
  end

  def show_news
    require 'uri'
    require 'net/https'
    require 'rexml/document'
    puts
    puts "Ruby Lang News Feed"
    # response = Net::HTTP.get_response( URI.parse( "http://www.ruby-lang.org/en/feeds/news.rss" ) )
    content_uri = URI.parse("https://www.ruby-lang.org")
    req = Net::HTTP::Get.new('/en/feeds/news.rss')
    https = Net::HTTP.new(content_uri.host, content_uri.port)
    https.use_ssl = true
    response = https.start { |cx| cx.request(req) }
    doc = REXML::Document.new( response.body )
    doc.root.each_element( "//rss/channel/item/title" ) do |element|
      puts " . #{element.text.to_s}"
    end
  end

  def show_md5
    require 'digest/md5'
    str = "I love ruby"
    puts "MD5 checksum of '#{str}' is : #{Digest::MD5.hexdigest( str ) }"
  end

end
