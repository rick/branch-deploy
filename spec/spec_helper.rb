# frozen_string_literal: true

require 'open3'

unless Hash.method_defined? :except
  class Hash
    def except(*keys)
      if keys.size > 4 && size > 4 # index if O(m*n) is big
        h = {}
        keys.each { |key| h[key] = true }
        keys = h
      end
      reject { |key, _value| keys.include? key }
    end
  end
end

def bd_command
  File.expand_path(File.join(__dir__, '../bin/bd'))
end

def run_bd_command(args = [])
  if args.empty?
    stdout, stderr, status = Open3.capture3(bd_command)
  else
    stdout, stderr, status = Open3.capture3(bd_command, *args)
  end

  [stdout, stderr, status.exitstatus]
end
