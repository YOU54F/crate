#
# Crate recipe for zlib version 1.2.3
#
Crate::Dependency.new( "zlib", "1.3.1") do |t|
  t.upstream_source = "http://www.zlib.net/zlib-1.3.1.tar.gz"
  # t.upstream_md5    = "debc62758716a169df9f62e6ab2bc634"
  ENV["CFLAGS"]= " -fPIC -static-libstdc++"

  t.build_commands << "./configure --static --prefix=#{File.join( '/', 'usr' )}"

  t.install_commands = [
    "make install prefix=#{File.join( t.install_dir, 'usr' )}",
    "make distclean"
  ]

end

