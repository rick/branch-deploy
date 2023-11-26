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

def options_full
  {
    repo: ['--repo', 'git@github.com:rick/branch-deploy.git'],
    branch: ['--branch', 'main'],
    host: ['--host', 'localhost'],
    local: ['--local'],
    path: ['--path', '/var/www/branch-deploy'],
    changes: ['--changes'],
    deploy: ['--deploy'],
    ssh_options: ['--ssh-options', '-p 2222'],
    temp_path: ['--temp-path', '/tmp'],
    verbose: ['--verbose'],
    help: ['--help']
  }
end

def options_brief
  {
    repo: ['-r', 'git@github.com:rick/branch-deploy.git'],
    branch: ['-b', 'main'],
    host: ['-h', 'localhost'],
    local: ['-l'],
    path: ['-p', '/var/www/branch-deploy'],
    changes: ['-c'],
    deploy: ['-d'],
    ssh_options: ['-s', '-p 2222'],
    temp_path: ['-t', '/tmp'],
    verbose: ['-v'],
    help: ['-h']
  }
end

def required_option_keys
  %i[repo branch host path]
end

def args_hash(keys)
  keys.map { |k| [options_full[k].first, options_full[k].last] }.to_h
end

def args_list(hash_args)
  hash_args.keys.map(&:to_s).sort.map { |k| [k, hash_args[k]] }.flatten
end

def to_short_arg(hash_args, key)
  long_key = options_full[key].first
  hash_args.except(long_key).merge(options_brief[key].first => options_brief[key].last)
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

def fixture_path(fixture_name)
  File.expand_path(File.join(__dir__, 'repo-fixtures', fixture_name))
end

def install_fixture(fixture_name, fixture_branch_name, target_path)
  args = args_hash(required_option_keys + %i[deploy verbose]).merge(
    "--repo"   => "file://#{fixture_path(fixture_name)}",
    "--branch" => fixture_branch_name,
    "--path"   => target_path
  )

  STDERR.puts "calling with #{args_list(args)}"

  stdout, stderr, status = run_bd_command(args_list(args))
  raise "Failed to install fixture #{fixture_name} to #{target_path}:\n#{stderr}" unless status.zero?

  STDERR.puts("STDOUT:\n#{stdout}")
  STDERR.puts("STDERR:\n#{stderr}")
  STDERR.puts(`ssh localhost 'ls -al /app/branch-deploy'`)
  STDERR.puts(`ssh localhost 'ls -al #{target_path}'`)
  STDERR.puts(`ssh localhost 'ls -al #{fixture_path(fixture_name)}'`)

  stdout
end
