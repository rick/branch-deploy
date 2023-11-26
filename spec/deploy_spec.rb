# frozen_string_literal: true

require 'debug'
require 'minitest/autorun'
require_relative 'spec_helper'

def options_full
  {
    repo: ['--repo', 'git@github.com:rick/branch-deploy.git'],
    branch: ['--branch', 'main'],
    host: ['--host', target_hostname],
    local: ['--local'],
    path: ['--path', target_path],
    changes: ['--changes'],
    deploy: ['--deploy'],
    ssh_options: ['--ssh-options', "-p #{target_ssh_port}"],
    temp_path: ['--temp-path', '/tmp'],
    verbose: ['--verbose'],
    help: ['--help']
  }
end

def required_option_keys
  %i[repo branch host path]
end

def args_hash(keys)
  keys.map { |k| [options_full[k].first, options_full[k].last] }.to_h
end

def args_list(hash_args)
  hash_args.keys.sort.map { |k| [k, hash_args[k]] }.flatten
end

def to_short_arg(hash_args, key)
  long_key = options_full[key].first
  hash_args.except(long_key).merge(options_brief[key].first => options_brief[key].last)
end

describe 'Deploying' do
  before do
    @valid_args_hash = args_hash(:host, :repo, :branch, :path, :deploy)
    run_on_host("rm -rf #{target_path}")
  end

  it 'should exit with status 0' do
    _, _, status = run_bd_command(args_list(@valid_args_hash))
    _(status).must_equal 0
  end

  it 'should result in the repo branch being checkout out to the path' do
    run_bd_command(args_list(@valid_args_hash))
    # TODO : check that the README.md from the fixture is checked out to the --path
  end
end
