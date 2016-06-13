# Copyright (c) 2012 Sho Hashimoto
#
# MIT License
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#--
# Thanks! https://github.com/shokai/event_emitter/blob/master/lib/event_emitter/emitter.rb
#+++

module Rx
module EventEmitter
  def __events # :nodoc:
    @__events ||= []
  end

  # Assigns an event listener & returns an id for the subscription
  def add_listener(type, params={}, &block)
    raise ArgumentError, 'listener block not given' unless block_given?
    id = __events.empty? ? 0 : __events.last[:id]+1
    __events << {
      :type => type.to_sym,
      :listener => block,
      :params => params,
      :id => id
    }
    id
  end

  alias :on :add_listener

  def remove_listener(id_or_type)
    if id_or_type.class == Fixnum
      __events.delete_if do |e|
        e[:id] == id_or_type
      end
    elsif [String, Symbol].include? id_or_type.class
      __events.delete_if do |e|
        e[:type] == id_or_type.to_sym
      end
    end
  end

  def emit(type, *data)
    type = type.to_sym
    __events.each do |e|
      case e[:type]
      when type
        listener = e[:listener]
        e[:type] = nil if e[:params][:once]
        instance_exec(*data, &listener)
      when :*
        listener = e[:listener]
        e[:type] = nil if e[:params][:once]
        instance_exec(type, *data, &listener)
      end
    end
    __events.each do |e|
      remove_listener e[:id] unless e[:type]
    end
  end

  def once(type, &block)
    add_listener type, {:once => true}, &block
  end
end
end
