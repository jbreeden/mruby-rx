MRuby::Build.new do |conf|
  if ENV['VisualStudioVersion'] || ENV['VSINSTALLDIR']
    toolchain :visualcpp
  else
    toolchain :clang
  end

  conf.enable_debug

  conf.cc.flags << '-DMRB_INT64'

  conf.gembox 'full-core'
  conf.gem '../mruby-apr'
  conf.gem '../mruby-libuv'
  conf.gem '../mruby-rx'

  # # Libuv
  conf.cc.flags << `pkg-config libuv --cflags`.strip
  conf.linker.flags << `pkg-config libuv --libs`.strip
end
