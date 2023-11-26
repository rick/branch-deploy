# frozen_string_literal: true

require 'shellwords'
require_relative 'deployer'

# Run deployment commands, either locally or remotely via SSH
class Runner
  attr_reader :deployer, :options

  def initialize(options)
    @options = options
    @deployer = Deployer.new(options)
  end

  def debugging?
    !!options[:verbose]
  end

  def remote?
    !!options[:host]
  end

  def local?
    !remote?
  end

  def host
    options[:host]
  end

  def ssh_options
    return unless options[:ssh_options]

    @ssh_options ||= Shellwords.escape(options[:ssh_options])
  end

  def run
    command = deployer.build

    if local?
      shell(command)
    else
      ssh(command)
    end
  end

  def prep_shell_command(cmd)
    "#{'set -x; ' if debugging?}#{cmd}"
  end

  def ssh(cmd)
    args = [host]
    args << '-v' if debugging?
    args << ssh_options if ssh_options
    args << prep_shell_command(cmd)
    puts "Running: ssh #{args.join(' ')}" if debugging?
    system('ssh', *args)
  end

  def shell(cmd)
    prepped_command = prep_shell_command(cmd)
    puts "Running locally: [#{prepped_command}]" if debugging?
    system('bash', '-c', prepped_command)
  end
end
