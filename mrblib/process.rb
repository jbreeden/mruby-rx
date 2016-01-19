module Nurb
module Process
  def self.on(signal, &listener)
    handle = UV::UvSignalT.new
    UV.uv_signal_init(Nurb.main_loop, handle)
    UV.uv_unref(handle)
    UV.uv_signal_start(handle, signal) do
      listener[]
    end
  end
end
end
