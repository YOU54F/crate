class App
  def initialize
	  puts "initialized #{self.class}"
  end

  def run( argv, env )
    puts "Hello from ruby #{RUBY_VERSION} on #{RUBY_PLATFORM}"
    puts "This application was built with crate 📦"
    puts "Executing : #{$0}"
    puts "ARGV      : #{argv.join(' ')}"
    # puts "OpenSSL Version : #{OpenSSL::OPENSSL_VERSION}"
    # env.keys.sort.each do |k|
    #   puts "    #{k}  => #{env[k]}"
    # end
  end
end
