#
# Crate recipe for ruby version 1.2.3
#
Crate::Ruby.new( "ruby", "3.3.1") do |t|
  # t.depends_on( "zlib" )
  # t.depends_on( "openssl" )

  t.integrates( "amalgalite" )
  t.integrates( "arrayfields" )
  t.integrates( "configuration" )

  t.upstream_source  = "https://cache.ruby-lang.org/pub/ruby/3.3/ruby-3.3.1.tar.gz"
  # t.upstream_md5     = "f6cd51001534ced5375339707a757556"


  # ENV["PKGCONFIG"] = "-L#{File.join( t.install_dir, 'usr', 'lib', 'pkgconfig' )}"

  def t.build
    ENV["CFLAGS"]= "-I#{File.join( install_dir, 'usr', 'include')} -I#{ File.join( pkg_dir )}  -I#{ File.join( pkg_dir, 'include' )}"
    ENV["CPPFLAGS"]= "-I#{File.join( install_dir, 'usr', 'include')} -I#{ File.join(  pkg_dir )}  -I#{ File.join( pkg_dir, 'include' )}"
    ENV["LDFLAGS"] = "-L#{File.join( install_dir, 'usr', 'lib' )}"
    # put the .a files from the fakeroot/usr/lib directory into the package
    # directory so the compilation can use them
    %w[ libz.a libcrypto.a libssl.a libyaml.a libffi.a libgmp.a libcrypt.a ].each do |f| 
      FileUtils.cp File.join( install_dir, "usr", "lib", f ), pkg_dir
    end 
    # Dir.glob("ext/*").each do |ext_folder|
    #   sh "cd #{ext_folder} && ruby extconf.rb && cd ../.."
    # end
    sh "rm -rf ext/-test-"
    sh "./configure --build=aarch64-unknown-linux-gnu --prefix=#{File.join( '/', 'usr' )} \
    --disable-install-doc \
    --disable-shared \
    --enable-static \
    --with-static-linked-ext \
    --without-dbm \
    --with-gdbm"
    # sh "./configure --build=aarch64-unknown-linux-gnu --enable-static --with-static-linked-ext --prefix=#{File.join( '/', 'usr' )} --disable-install-doc"
    sh "make"
  end

  t.install_commands << "make install DESTDIR=#{t.install_dir} && cat ext/openssl/mkmf.log"

end
