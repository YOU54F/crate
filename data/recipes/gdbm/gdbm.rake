#
# Crate recipe for zlib version 1.2.3
#
Crate::Dependency.new( "gdbm", "1.23") do |t|
  # t.depends_on( "ncurses" )
  # t.depends_on( "readline" )

  t.upstream_source = "ftp://ftp.gnu.org/gnu/gdbm/gdbm-1.23.tar.gz"
  # t.upstream_md5    = "debc62758716a169df9f62e6ab2bc634"
  # ENV["CFLAGS"]= " -fPIC -static-libstdc++"

  t.build_commands =  [
    "autoreconf -f",
  # "automake -f -c",
  "autoconf",
  "./configure --host aarch64-linux-gnu --prefix=#{File.join( '/', 'usr' )}  --enable-static --disable-shared"]

  t.install_commands = [
    "make install DESTDIR=#{File.join( t.install_dir )}",
    "make distclean"
  ]

end

