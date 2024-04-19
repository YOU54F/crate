

## Previous Posts

- https://railsenvy.com/tags/rubyconf.html
  - > Jeremy Hinegardner speaking about "Crate : forming your custom ruby application into a packaged, standalone, easily distributable executable"
- PDF Slideshare
  - https://www.slideshare.net/copiousfreetime/crate-ruby-based-standalone-executables

- Scotland On Rails Presentation
  - http://www.rubyinside.com/scotland-on-rails-presentations-now-online-27-awesome-videos-1799.html
  -  https://scotland-on-rails.s3.amazonaws.com/2B11_JeremyHinegardner-SOR.mp4

## Packaging an Application With Crate (2008-11-30)

Crate is way to package up your ruby applications as statically compiled binaries. I was lucky enough to talk about Crate at RubyConf '08.

This is a small tutorial that expands upon my RubyConf talk and demonstrates how to package gem application as a standalone statically compiled executable.

### Step 1 — Install Crate

To get started, you'll need to install crate. It is distributed mainly as a gem from rubyforge and installs in the standard way.

    gem install crate

Crate is part of my copiousfreetime rubyforge project and its git repository is available on github. Patches are always welcome.

- crate on github
- public clone url - <git://github.com/copiousfreetime/crate.git>

### Step 2 — Create a new Crate Application

In this tutorial we are going to package up the htpassword-ruby commandline application in my htauth gem as a standalone executable.

    % crate -v
    Crate 0.2.1

    % crate htpassword-ruby
    [16:39:00]  INFO: creating htpasswd-ruby
    [16:39:00]  INFO: creating htpasswd-ruby/Rakefile
    [16:39:00]  INFO: creating htpasswd-ruby/crate_boot.c
    [16:39:00]  INFO: creating htpasswd-ruby/recipes/amalgalite
    [16:39:00]  INFO: creating htpasswd-ruby/recipes/amalgalite/amalgalite.rake
    [16:39:00]  INFO: creating htpasswd-ruby/recipes/arrayfields
    [16:39:00]  INFO: creating htpasswd-ruby/recipes/arrayfields/arrayfields.rake
    [16:39:00]  INFO: creating htpasswd-ruby/recipes/configuration
    [16:39:00]  INFO: creating htpasswd-ruby/recipes/configuration/configuration.rake
    [16:39:00]  INFO: creating htpasswd-ruby/recipes/openssl
    [16:39:00]  INFO: creating htpasswd-ruby/recipes/openssl/openssl.rake
    [16:39:00]  INFO: creating htpasswd-ruby/recipes/ruby
    [16:39:00]  INFO: creating htpasswd-ruby/recipes/ruby/ext-extmk.rb.patch
    [16:39:00]  INFO: creating htpasswd-ruby/recipes/ruby/ruby.rake
    [16:39:00]  INFO: creating htpasswd-ruby/recipes/rubygems
    [16:39:00]  INFO: creating htpasswd-ruby/recipes/rubygems/rubygems.rake
    [16:39:00]  INFO: creating htpasswd-ruby/recipes/zlib
    [16:39:00]  INFO: creating htpasswd-ruby/recipes/zlib/zlib.rake

    % cd htpassword-ruby

This created a new directory structure to do the building of our standalone htpassword-ruby application. Change into the new `htpassword-ruby` directory now and run `rake -T` to see the full set of tasks that are available. Most of them you will not use. The two you want to pay attention to are default and ruby.

### Step 3 — Integrate HTAuth Dependency Targets

The way all of this is integrated together is a final single binary with the name htpassword-ruby which is an embedded ruby interpreter wrapped up in a thin C application. The C application is in the `crate_boot.c `file you'll see in the top level of the project directory.

The pure ruby code involved in the whole system is stored in SQLite databases. This will included the ruby standard library and your application code. As part of a Crate application, the `require` statement is overwritten to load from rows in an SQLite database instead of the file system. This feature is all from the amalgalite gem and anyone case use it for other projects if they so choose.

In the mean time, we now have a build system setup to build ruby, but not our application. There is no facility as of yet in Crate to automatically add build targets for a gem, but they are in the works for a later version. In the mean time we'll need to roll our own, its not that hard. Currently I'm not completely satisfied with the way this integrates and will most likely change it in a future release.

The HTAuth gem is pretty self contained, it only has one dependency, [highline](https://rubygems.org/gems/highline/versions/1.7.8?locale=en). We're going to add two new recipes, one for highline and one for htauth.

    % mkdir recipes/highline
    % vi recipes/highline/highline.rake

We edit it to be the following:

    #
    # The recipe for integrating highline into the ruby build
    #
    Crate::GemIntegration.new("highline", "1.5.0") do |t|
    t.upstream_source = "http://rubyforge.org/frs/download.php/46328/highline-1.5.0.gem"
    end

And we do the same for htauth:

    % mkdir recipes/htauth
    % vi recipes/htauth/htauth.rake

Recipe

    #
    # The recipe for integrating htauth into the ruby build
    #
    Crate::GemIntegration.new("htauth", "1.0.2") do |t|
    t.upstream_source = "http://rubyforge.org/frs/download.php/47663/htauth-1.0.2.gem"
    end

And finally we we integrate these two new build targets into the final ruby build. Edit the `recipes/ruby/ruby.rake` file and add the two noted lines.

    Crate::Ruby.new( "ruby", "1.8.6-p287") do |t| 
    t.depends_on( "openssl" )
    t.depends_on( "zlib" )

    t.integrates( "amalgalite" )
    t.integrates( "arrayfields" )
    t.integrates( "configuration" )

    t.integrates( "highline" )    # Add this line
    t.integrates( "htauth" )      # and this line

    t.upstream_source  = "ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.6-p287.tar.gz"
    t.upstream_md5     = "f6cd51001534ced5375339707a757556"

    ENV["CPPFLAGS"]= "-I#{File.join( t.install_dir, 'usr', 'include')}"
    ENV["LDFLAGS"] = "-L#{File.join( t.install_dir, 'usr', 'lib' )}" 

    def t.build
        # put the .a files from the fakeroot/usr/lib directory into the package
        # directory so the compilation can use them
        %w[ libz.a libcrypto.a libssl.a ].each do |f| 
        FileUtils.cp File.join( install_dir, "usr", "lib", f ), pkg_dir
        end 
        sh "./configure --disable-shared --prefix=#{File.join( '/', 'usr' )}" 
        sh "make"
    end

    t.install_commands << "make install DESTDIR=#{t.install_dir}"

    end

Now we are setup to do the two big build steps.

### Step 4 — Building Ruby as a Static Library

In order to build a static ruby based application we first need to build ruby itself as a static library. In doing so we also need to build all the binary dependencies of ruby statically. In this case, that includes zlib, openssl and amalgalite.

Fortunately, all that is taken care of for you in the rake tasks. All you need to do at this point is run the `ruby` rake task. It will download, unpack and build all the various components. This may take a while, so take a break and get something to drink.

    % rake ruby
    # snip lots of output, look in project.log for the full output.  
    ....
    23:54:58  INFO: Bulding zlib 1.2.3
    ....
    23:55:30  INFO: Bulding openssl 0.9.8i
    ...
    00:01:22  INFO: Integrating highline into ruby's tree
    ...
    00:01:24  INFO: Integrating htauth into ruby's tree
    ...
    00:01:24  INFO: Bulding ruby 1.8.6-p287
    ...
    00:02:59  INFO: ruby 1.8.6-p287 is installed

You should now have a ruby executable in `fakeroot/usr/bin/ruby`. You can run this script to prove that it is statically compiled. Notice that there are no `require` statements. This script will not run on a normal ruby, it will only work with one that is statically compiled.

    % cat versions.rb
    puts "zlib    : #{Zlib::zlib_version}"
    puts "OpenSSL : #{OpenSSL::OPENSSL_VERSION}"
    puts "SQLite  : #{Amalgalite::SQLite3::Version}"

    % /opt/local/bin/ruby versions.rb
    ruby versions.rb
    versions.rb:1: uninitialized constant Zlib (NameError)

    % fakeroot/usr/bin/ruby versions.rb
    zlib    : 1.2.3
    OpenSSL : OpenSSL 0.9.8j 07 Jan 2009
    SQLite  : 3.6.10

The really important products of this build process are all the `.a` files in the ruby build directory that will be used to build the final `httpassword-ruby` executable.

    % ls -1 build/ruby/ruby-1.8.6-p287/*.a
    build/ruby/ruby-1.8.6-p287/libcrypto.a
    build/ruby/ruby-1.8.6-p287/libruby-static.a
    build/ruby/ruby-1.8.6-p287/libssl.a
    build/ruby/ruby-1.8.6-p287/libz.a

Additionally the `highline` and `htauth` ruby code was integrated into the ruby stdlib directory structure.

### Step 5 — Building the final executable

The final step is to create out final `htpasswd-ruby` executable. The output of this step is:

- a single executable
- multiple SQLite databases holding all the ruby source code

At this point we need to update the top level `Rakefile` in your build system. We need to set the executable name and tell the crate build system how to launch the application.

In our case, we are going to wrap only the htpasswd-ruby application that is part of htauth. For this we look at that script which comes with the htauth gem. This script boils down to the single line:

    HTAuth::Passwd.new.run(ARGV, ENV)

Which, it turns out, is exactly the way that crate likes to have applications launched. At this point I should sidestep and say how a crate based application is launched.

#### Crate Bootstrap Process

A Crate built application is fundamentally an embedded ruby interpreter that runs a single script. The file crate_boot.c at the top of your build system is

    1. initialize the ruby interpreter
    2. set ARGV for ruby
    3. initialize all statically compiled extensions
    4. bootstrap the Amalgalite driver
    5. remove all filesystem directories from the $LOAD_PATH
    6. switch to using Amalgalite backed require
    7. require the file in the C constant CRATE_MAIN_FILE
    8. instantiate a single instance of the class named in the C constant CRATE_MAIN_CLASS
    9. invoke run( ARGV, ENV) on the newly instantiated class
    10. exit

Now we dive into the `Rakefile` and put the final touches on our build to make everything come out the way we want. Currently crate only supports launching an application from a top level class. That means no `Module::Class` to use for the main class.

    require 'crate'

    PROJ_NAME = "htpasswd-ruby"
    Crate::Project.new( PROJ_NAME ) do |crate|

    # setting these will set the appropriate C constants
    crate.main_file  = "application"
    crate.main_class = "App"
    crate.run_method = "run"

    # make sure 'application.rb' is packed into the databases
    crate.packing_lists << Crate::PackingList.new( Dir.glob("*.rb") )

    end

We then have the `application.rb` file at the top of our build system directory. It is very simple and gives you an idea of how to put a thin ruby wrapper around any existing ruby application.

    class App
    def run( argv, env )
        require 'htauth'
        HTAuth::Passwd.new.run( argv, env )
    end
    end

Run the default rake task and take a look at the output.

    % rake default
    (in /Users/jeremy/tmp/htpasswd-ruby)
    mkdir -p /Users/jeremy/tmp/htpasswd-ruby/dist
    16:59:27  INFO: Packing amalgalite into /Users/jeremy/tmp/htpasswd-ruby/dist/lib.db
    16:59:28  INFO: Packing ruby standard lib into /Users/jeremy/tmp/htpasswd-ruby/dist/lib.db
    16:59:29  INFO: Packing ruby extension libs into /Users/jeremy/tmp/htpasswd-ruby/dist/lib.db
    16:59:31  INFO: Packing project packing lists lists into /Users/jeremy/tmp/htpasswd-ruby/dist/app.db
    16:59:32  INFO: Build htpasswd-ruby

    % file dist/*
    dist/app.db:        SQLite database (Version 3)
    dist/htpasswd-ruby: Mach-O executable i386
    dist/lib.db:        SQLite database (Version 3)

Our final result, a self-contained set of 3 files containing a statically compiled ruby interpreter and and app to run in it. In this case, we can deploy these 3 files to any i386 Mac OS X machine and run it, it will not use the system ruby. All the ruby libs are in the SQLite3 databases. And just to show that it works.

    % cd dist/
    % ./htpasswd-ruby -c test.db jjh
    Adding password for jjh.
            New password: *****************
    Re-type new password: *****************
    % cat test.db 
    jjh:GtPOQTplES6BE

### Closing Thoughts

Well, there you have it; self-contained, statically-built, shippable ruby applications. There are definite improvements that can be made, and I would love to hear what people would like to do with Crate.

Some specific features that I will be adding in no particular order and as my copious free time allows:

- cratify an existing gem for one-stop packaging cross compilation targets so you can build, from one library, any executable for any target you have a cross - compiler
- installer wrappers, so you can ship
  - .dmg for Mac OS X
  - setup.exe for Windows
  - rpm for CentOS/RHEL/Fedora/etc
- shar for general UNIX
- smart dependency tracking so only those portions of the ruby stdlib that your application needs is packaged