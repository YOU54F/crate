#
# Crate recipe for zlib version 1.2.3
#
Crate::Dependency.new( "readline", "6.3") do |t|
  # t.depends_on( "ncurses" )
  t.upstream_source = "ftp://ftp.gnu.org/gnu/readline/readline-6.3.tar.gz"
  # t.upstream_md5    = "debc62758716a169df9f62e6ab2bc634"
  # ENV["CFLAGS"]= " -fPIC -static-libstdc++"

  t.build_commands << "./configure --host aarch64-linux-gnu --prefix=#{File.join( '/', 'usr' )}  --enable-static --disable-shared"

  t.install_commands = [
    "make install DESTDIR=#{File.join( t.install_dir )}",
    "make distclean"
  ]

end

