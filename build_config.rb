MRuby::Build.new do |conf|
  # Setup your compiler toolchin as needed.
  if ENV['VisualStudioVersion'] || ENV['VSINSTALLDIR']
    toolchain :visualcpp
  else
    toolchain :clang
  end

  # Enable debugging features (optional)
  conf.enable_debug

  # Need to use 64 bit ints if building with mruby-apr (optional)
  conf.cc.flags << '-DMRB_INT64'

  # Select the gems required for your project. (optional)
  conf.gembox 'full-core'
  
  # mruby-apr is used here for convenience in testing (optional)
  conf.gem '../mruby-apr'
  
  # Dependency of mruby-rx (required)
  conf.gem '../mruby-libuv'
  
  # This gem! (required)
  conf.gem '../mruby-rx'

  # Libuv build flags (required)
  conf.cc.flags << `pkg-config libuv --cflags`.strip
  conf.linker.flags << `pkg-config libuv --libs`.strip
end
