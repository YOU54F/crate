#
# Crate recipe for zlib version 1.2.3
#
Crate::Dependency.new( "ncurses", "6.0") do |t|
  t.upstream_source = "ftp://ftp.gnu.org/gnu/ncurses/ncurses-6.0.tar.gz"
  # t.upstream_md5    = "debc62758716a169df9f62e6ab2bc634"
  # ENV["CFLAGS"]= " -fPIC -static-libstdc++"

  t.build_commands << "./configure --host aarch64-linux-gnu --prefix=#{File.join( '/', 'usr' )}  --without-cxx-binding"

  t.install_commands = [
    "make install DESTDIR=#{File.join( t.install_dir )}",
    # "make distclean"
  ]

end

