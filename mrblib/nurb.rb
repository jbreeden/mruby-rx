module Nurb
  def self.main_loop
    @main_loop ||= UV.uv_default_loop
  end
  
  def self.run(&block)
    block[] if block_given?
    UV.uv_run(main_loop)
  end
end
