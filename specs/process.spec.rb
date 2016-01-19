Nurb::Spec.new('Nurb::Process Module') do
  blurb <<-EOS
The specs listed below are implemented, but the tests are not yet written.
EOS
  describe 'Process::on(signal, &block)' do
    it "Registers a handler for the given signal"
    it "`signal` may be a Fixnum, String, or Symbol, matching one of the UV::SIG* constants"
  end
  
  describe 'Process::execPath' do
    it 'Returns the absolute path to the running executable'
  end
end
