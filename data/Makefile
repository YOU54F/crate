# CFLAGS=-I/opt/local/lib/ruby/1.8/i686-darwin9.2.2/
# LDFLAGS=-L/opt/local/lib/ruby/1.8/i686-darwin9.2.2/ -L/opt/local/lib -lruby -lobjc -ldl
CFLAGS=-I/usr/local/lib/ruby/1.8/aarch64-linux/
LDFLAGS=-L/usr/local/lib/ruby/1.8/aarch64-linux/ -L/usr/lib/aarch64-linux-gnu -lruby -lobjc -ldl

crate_boot: crate_boot.o
	$(CC) -o crate_boot crate_boot.o $(LDFLAGS)
