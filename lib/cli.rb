# frozen_string_literal: true

require 'optparse'
require_relative 'runner'

options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: bd [options]'
  opts.on('-r', '--repo REPO', "Repository passed to 'git clone' command on deployment host [REQUIRED]") do |r|
    options[:repo] = r
  end
  opts.on('-b', '--branch BRANCH', 'Branch name to deploy [REQUIRED]') do |b|
    options[:branch] = b
  end
  opts.on('-h', '--host HOSTNAME', 'Target host for remote deployment [REQUIRED, or --local]') do |h|
    options[:host] = h
  end
  opts.on('-l', '--local', 'Deploy to the local host (default: false) [REQUIRED, or --host]') do |l|
    options[:local] = l
  end
  opts.on('-p', '--path PATH', 'Deployment path on target host [REQUIRED]') do |p|
    options[:path] = p
  end
  opts.on('-c', '--changes', 'Output changes for proposed deployment, do not deploy (default: true)') do |d|
    options[:changes] = d
  end
  opts.on('-d', '--deploy', 'Perform deploy -- actually update files (default: false)') do |c|
    options[:deploy] = c
  end
  opts.on('-s', '--ssh-options OPTIONS',
          "Flags passed to the 'ssh' command for remote deployment (default: \"\")") do |s|
    options[:ssh_options] = s
  end
  opts.on('-t', '--temp-path PATH', 'Base path for tempdir creation on deployment host (default: OS default)') do |t|
    options[:temp_path] = t
  end
  opts.on('-v', '--verbose', 'Run verbosely') do |v|
    options[:verbose] = v
  end
  opts.on('-h', '--help', 'Prints this help') do
    warn opts
    exit
  end

  options[:help] = opts.help
end.parse!

unless options[:repo] && options[:branch] && options[:path]
  warn 'Requires --repo, --branch, and --path options.'
  warn options[:help]
  exit 1
end

unless options[:local] || options[:host]
  warn 'Requires either --local or --host.'
  warn options[:help]
  exit 1
end

if options[:local] && options[:host]
  warn 'Cannot specify both --local and --host.'
  warn options[:help]
  exit 1
end

if options[:deploy] && options[:changes]
  warn 'Cannot specify both --deploy and --changes.'
  warn options[:help]
  exit 1
end

Runner.new(options).run
