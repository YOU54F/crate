# CFLAGS=-I/opt/local/lib/ruby/1.8/i686-darwin9.2.2/
# LDFLAGS=-L/opt/local/lib/ruby/1.8/i686-darwin9.2.2/ -L/opt/local/lib -lruby -lobjc -ldl
CFLAGS=-I/usr/local/lib/site_ruby/1.8/x86_64-linux/
LDFLAGS=-L/usr/local/lib/site_ruby/1.8/x86_64-linux/ -L/usr/lib -lruby -lobjc -ldl

crate_boot: crate_boot.o
	$(CC) -o crate_boot crate_boot.o $(LDFLAGS)
