class C
  def initialize
    @ivar = 'ivar'
  end

  def a
    puts 'a'
  end

  def b(arg)
    puts arg
  end

  def c(&block)
    block.call
  end

  def d(key:)
    puts key
  end
end

module Omnihooks
  def self.included(base)
    base.include InstanceMethods
  end

  def self.extended(base)
    base.extend ClassMethods
  end

  module InstanceMethods
    def define_hook(kind, target_method, &block)
      original_method = method(target_method)
      case kind
      when :before
        define_singleton_method(target_method) do |*args, **kwargs, &blk|
          instance_exec(*args, **kwargs, &block)
          original_method.call(*args, **kwargs, &blk)
        end
      when :after
        define_singleton_method(target_method) do |*args, **kwargs, &blk|
          original_method.call(*args, **kwargs, &blk)
          instance_exec(*args, **kwargs, &block)
        end
      when :around
        define_singleton_method(target_method) do |*args, **kwargs, &blk|
          wrapper = -> { original_method.call(*args, **kwargs, &blk) }
          instance_exec(wrapper, *args, **kwargs, &block)
        end
      else
        raise 'Not supported!'
      end
    end
  end

  module ClassMethods
    def define_hook(kind, target_method, &block)
      original_method = instance_method(target_method)
      case kind
      when :before
        define_method(target_method) do |*args, **kwargs, &blk|
          instance_exec(*args, **kwargs, &block)
          original_method.bind(self).call(*args, **kwargs, &blk)
        end
      when :after
        define_method(target_method) do |*args, **kwargs, &blk|
          original_method.bind(self).call(*args, **kwargs, &blk)
          instance_exec(*args, **kwargs, &block)
        end
      when :around
        define_method(target_method) do |*args, **kwargs, &blk|
          wrapper = -> { original_method.bind(self).call(*args, **kwargs, &blk) }
          instance_exec(wrapper, *args, **kwargs, &block)
        end
      else
        raise 'Not supported!'
      end
    end
  end
end

C.extend Omnihooks

C.define_hook(:after, :a) { puts 'after a' }

C.include Omnihooks

c = C.new

c.define_hook(:before, :a) { puts @ivar }
c.a

c.define_hook(:before, :b) { |arg| puts "argument is: #{arg}" }
c.b('arg')

c.define_hook(:before, :c) { puts 'before c'}
c.c { puts 'method c' }

c.define_hook(:before, :d) { |key:| puts "key: #{key}" }
c.d(key: 'key')

c2 = C.new

c2.define_hook(:around, :a) do |original|
  puts 'before a'
  original.call
  puts 'after a'
end
c2.a

c2.define_hook(:around, :b) do |original, arg|
  puts "arg for b is: #{arg}"
  puts 'before b'
  original.call
  puts 'after b'
end
c2.b('I am b')

c2.define_hook(:around, :c) do |original|
  puts 'before c'
  original.call
  puts 'after c'
end
c2.c { puts 'I am c' }

c2.define_hook(:around, :d) do |original|
  puts 'before d'
  original.call
  puts 'after d'
end
c2.d(key: 'key2')
