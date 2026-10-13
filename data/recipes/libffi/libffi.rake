#
# Crate recipe for zlib version 1.2.3
#
Crate::Dependency.new( "libffi", "3.2.1") do |t|
  t.upstream_source = "ftp://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz"
  # t.upstream_md5    = "debc62758716a169df9f62e6ab2bc634"
  # ENV["CFLAGS"]= " -fPIC -static-libstdc++"

  t.build_commands =  [
  "autoconf",  
  "./configure --host aarch64-linux-gnu --prefix=#{File.join( '/', 'usr' )}  --enable-static --disable-shared"]

  t.install_commands = [
    "make install DESTDIR=#{File.join( t.install_dir )}",
    "make distclean"
  ]

end

