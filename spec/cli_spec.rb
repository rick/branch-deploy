# frozen_string_literal: true

require 'minitest/autorun'
require 'open3'
require_relative './spec_helper'

def bd_command
  File.expand_path(File.join(__dir__, "../bin/bd"))
end

def run_bd_command(args = [])
  if args.empty?
    stdout, stderr, status = Open3.capture3(bd_command)
  else
    stdout, stderr, status = Open3.capture3(bd_command, *args)
  end

  return stdout, stderr, status.exitstatus
end

def options_full
  {
    :repo => ["--repo", "git@github.com:rick/branch-deploy.git"],
    :branch => ["--branch", "main"],
    :host => ["--host", "example.com"],
    :local => ["--local"],
    :path => ["--path", "/var/www/branch-deploy"],
    :diff => ["--diff"],
    :confirm => ["--confirm"],
    :ssh_options => ["--ssh-options", "-p 2222"],
    :temp_path => ["--temp-path", "/tmp"],
    :verbose => ["--verbose"],
    :help => ["--help"]
  }
end

def options_brief
  {
    :repo => ["-r", "git@github.com:rick/branch-deploy.git"],
    :branch => ["-b", "main"],
    :host => ["-h", "example.com"],
    :local => ["-l"],
    :path => ["-p", "/var/www/branch-deploy"],
    :diff => ["-d"],
    :confirm => ["-c"],
    :ssh_options => ["-s", "-p 2222"],
    :temp_path => ["-t", "/tmp"],
    :verbose => ["-v"],
    :help => ["-h"]
  }
end

def required_option_keys
  [:repo, :branch, :host, :path]
end

def args_hash(keys)
  keys.map { |k| options_full[k] }.to_h
end

def args_list(hash_args)
  hash_args.keys.sort.map { |k| [k, hash_args[k]] }.flatten
end

def to_short_arg(hash_args, key)
  hash_args.except(key).merge(options_brief[key])
end

# TODO: once we get something actually working internally, we will want a way to only validate arguments
#       otherwise we will trigger deploys, etc., while just testing args

describe "CLI usage" do
  before do
    @valid_args_hash = args_hash(required_option_keys)
  end

  it "should exit 1 when no arguments are passed" do
    stdout, stderr, status = run_bd_command
    _(status).must_equal 1
  end


  it "should provide usage output when no arguments are passed" do
    stdout, stderr, status = run_bd_command
    _(stderr).must_match(/Usage: .*bd \[options\]/)
  end

  it "should return 0 if valid arguments are passed" do
    stdout, stderr, status = run_bd_command(args_list(@valid_args_hash))
    _(status).must_equal 0
  end

  it "should not provide usage output if valid arguments are passed" do
    stdout, stderr, status = run_bd_command(args_list(@valid_args_hash))
    _(stderr).must_be_empty
  end
end