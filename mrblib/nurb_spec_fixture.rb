# Just-barely-usable spec framework

class Nurb::Spec
  class SkipTest < StandardError
  end
  
  def initialize(label, &block)
    @fixture_label = label
    @test_count = 0
    @fail_count = 0
    @pending_count = 0
    @current_test_passed = true
    @current_test_pending = false
    @indentation = 0
    write
    write label
    write '-' * label.size
    write
    self.instance_eval(&block)
    summarize
  end
  
  def write(*lines)
    if lines.empty?
      puts
    else
      # Ensure all lines are separate
      lines = lines.map { |l| l.split("\n") }.flatten
      lines.each do |l|
        print (' ' * (@indentation * 2)) unless l.empty?
        puts l
      end
    end
  end

  def indent(&block)
    @indentation += 1
    if block_given?
      begin
        block[]
      ensure
        unindent
      end
    end
  end
  
  def unindent
    if @indentation >= 1
      @indentation = @indentation - 1
    else
      @indentation = 0
    end
  end
  
  def bullet
    if @indentation % 3 == 0
      '-'
    elsif @indentation % 3 == 1
      '+'
    else
      '*'
    end
  end

  def describe(label, &block)
    write "#{bullet} #{label}"
    indent do
      self.instance_eval(&block)
    end
  end
  alias desc describe
  alias context describe

  def it(label, &block)
    @current_test_passed = true
    @current_test_pending = false
    exc = nil
    
    begin
      self.instance_eval(&block) if block
    rescue SkipTest => ex
      @current_test_pending = true
    rescue StandardError => ex
      exc = ex
      @current_test_passed = false
    end
    
    tag = ""
    if @current_test_pending
      tag = "[PENDING] "
    elsif !@current_test_passed
      tag = "[FAILED] "
    end
    write "#{bullet} #{tag}#{label}"

    @test_count += 1
    @fail_count += 1 unless @current_test_passed || @current_test_pending
    @pending_count += 1 if @current_test_pending

    if exc && !@current_test_pending
      write "Uncaught #{exc.class.to_s}: #{exc}\n#{exc.backtrace.join("\n")}"
    end
  end
  alias test it

  def assert(condition)
    @current_test_passed &&= condition
    condition # So client can react to result
  end

  def assert_raises(excClass, &block)
    begin
      block[]
    rescue excClass
      return
    rescue
      # fall through
    end
    @current_test_passed = false
  end

  def fail
    @current_test_passed = false
  end

  def pending
    raise SkipTest.new
  end

  def summarize
    write
    write "#{@fail_count == 0 ? 'SUCCESS' : 'FAILURE' } [#{@fail_count} failed, #{@pending_count} pending, #{@test_count} total]"
  end
end
