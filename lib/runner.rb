# frozen_string_literal: true

require 'shellwords'

# Run deployment commands, either locally or remotely via SSH
class Runner
  attr_reader :options

  def initialize(options)
    @options = options
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

  def ssh_options?
    !!options[:ssh_options]
  end

  def ssh_options
    Shellwords.escape(options[:ssh_options]) if options[:ssh_options]
  end

  def run
    if local?
      shell('/bin/echo "Hello, world."')
    else
      ssh('/bin/echo "Hello, world."')
    end

    # TODO: implement the following:
    #  - both wrappers call the same method, which is constructed by a Deployer
    #  - Deployer builds a list of commands to run
    #    - create a secure tempdir (default, unless --temp-path is specified)
    #    - shallow clone the repo (--repo)
    #    - checkout the branch (--branch)
    #    - get a list of files that have changed (if --changes)
    #    - rsync the files to the target path (--path)
    #    - remove the tempdir
  end

  def prep_shell_command(cmd)
    "#{'set -x; ' if debugging?}#{cmd}"
  end

  def ssh(cmd)
    args = [host]
    args << '-v' if debugging?
    args << ssh_options if ssh_options?
    args << prep_shell_command(cmd)
    puts "Running: ssh #{args.join(' ')}" if debugging?
    system('ssh', *args)
  end

  def shell(cmd)
    puts "Running command locally: [#{cmd}]" if debugging?
    system('bash', '-c', prep_shell_command(cmd))
  end
end
