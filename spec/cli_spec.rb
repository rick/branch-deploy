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

def options_brief
  {
    repo: ['-r', 'git@github.com:rick/branch-deploy.git'],
    branch: ['-b', 'main'],
    host: ['-h', target_hostname],
    local: ['-l'],
    path: ['-p', target_path],
    changes: ['-c'],
    deploy: ['-d'],
    ssh_options: ['-s', "-p #{target_ssh_port}"],
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
  hash_args.keys.sort.map { |k| [k, hash_args[k]] }.flatten
end

def to_short_arg(hash_args, key)
  long_key = options_full[key].first
  hash_args.except(long_key).merge(options_brief[key].first => options_brief[key].last)
end

describe 'CLI usage' do
  before do
    @valid_args_hash = args_hash(required_option_keys)
  end

  it 'should exit 1 when no arguments are passed' do
    _, _, status = run_bd_command
    _(status).must_equal 1
  end

  it 'should provide usage output when no arguments are passed' do
    _, stderr, = run_bd_command
    _(stderr).must_match(/Usage: .*bd \[options\]/)
  end

  it 'should exit with status 0 if valid arguments are passed' do
    _, _, status = run_bd_command(args_list(@valid_args_hash))
    _(status).must_equal 0
  end

  it 'should not provide usage output if valid arguments are passed' do
    _, stderr, = run_bd_command(args_list(@valid_args_hash))
    _(stderr).wont_match(/Usage: .*bd \[options\]/)
  end

  it 'should work if short repo argument is passed' do
    args = to_short_arg(@valid_args_hash, :repo)
    _, _, status = run_bd_command(args_list(args))
    _(status).must_equal 0
  end

  it 'should exit with status 1 if no repo is passed' do
    args = args_hash(required_option_keys - [:repo])
    _, _, status = run_bd_command(args_list(args))
    _(status).must_equal 1
  end

  it 'should provide usage output if no repo is passed' do
    args = args_hash(required_option_keys - [:repo])
    _, stderr, = run_bd_command(args_list(args))
    _(stderr).must_match(/Usage: .*bd \[options\]/)
  end

  it 'should work if short branch argument is passed' do
    args = to_short_arg(@valid_args_hash, :branch)
    _, _, status = run_bd_command(args_list(args))
    _(status).must_equal 0
  end

  it 'should exit with status 1 if no branch is passed' do
    args = args_hash(required_option_keys - [:branch])
    _, _, status = run_bd_command(args_list(args))
    _(status).must_equal 1
  end

  it 'should provide usage output if no branch is passed' do
    args = args_hash(required_option_keys - [:branch])
    _, stderr, = run_bd_command(args_list(args))
    _(stderr).must_match(/Usage: .*bd \[options\]/)
  end

  it 'should work if short host argument is passed' do
    args = to_short_arg(@valid_args_hash, :host)
    _, _, status = run_bd_command(args_list(args))
    _(status).must_equal 0
  end

  it 'should exit with status 1 if no host is passed' do
    args = args_hash(required_option_keys - [:host])
    _, _, status = run_bd_command(args_list(args))
    _(status).must_equal 1
  end

  it 'should provide usage output if no host is passed' do
    args = args_hash(required_option_keys - [:host])
    _, stderr, = run_bd_command(args_list(args))
    _(stderr).must_match(/Usage: .*bd \[options\]/)
  end

  it 'should work if short path argument is passed' do
    args = to_short_arg(@valid_args_hash, :path)
    _, _, status = run_bd_command(args_list(args))
    _(status).must_equal 0
  end

  it 'should exit with status 1 if no path is passed' do
    args = args_hash(required_option_keys - [:path])
    _, _, status = run_bd_command(args_list(args))
    _(status).must_equal 1
  end

  it 'should provide usage output if no path is passed' do
    args = args_hash(required_option_keys - [:path])
    _, stderr, = run_bd_command(args_list(args))
    _(stderr).must_match(/Usage: .*bd \[options\]/)
  end

  it 'should exit with status 0 if local argument is passed instead of host' do
    args = args_hash(required_option_keys - [:host] + [:local])
    _, _, status = run_bd_command(args_list(args))
    _(status).must_equal 0
  end

  it 'should not provide usage output if local argument is passed instead of host' do
    args = args_hash(required_option_keys - [:host] + [:local])
    _, stderr, = run_bd_command(args_list(args))
    _(stderr).wont_match(/Usage: .*bd \[options\]/)
  end

  it 'should work if short local argument is passed instead of host' do
    long_hash = args_hash(required_option_keys - [:host] + [:local])
    args = to_short_arg(long_hash, :local)
    _, _, status = run_bd_command(args_list(args))
    _(status).must_equal 0
  end

  it 'should exit with status 1 if no host or local is passed' do
    args = args_hash(required_option_keys - [:host] - [:local])
    _, _, status = run_bd_command(args_list(args))
    _(status).must_equal 1
  end

  it 'should provide usage output if no host or local is passed' do
    args = args_hash(required_option_keys - [:host] - [:local])
    _, stderr, = run_bd_command(args_list(args))
    _(stderr).must_match(/Usage: .*bd \[options\]/)
  end

  it 'should exit with status 1 if both local and host are passed' do
    args = args_hash(required_option_keys + [:local])
    _, _, status = run_bd_command(args_list(args))
    _(status).must_equal 1
  end

  it 'should provide usage output if both local and host are passed' do
    args = args_hash(required_option_keys + [:local])
    _, stderr, = run_bd_command(args_list(args))
    _(stderr).must_match(/Usage: .*bd \[options\]/)
  end

  it 'should exit with status 0 if changes argument is passed' do
    args = args_hash(required_option_keys + [:changes])
    _, _, status = run_bd_command(args_list(args))
    _(status).must_equal 0
  end

  it 'should exit with status 0 if short changes argument is passed' do
    args = to_short_arg(@valid_args_hash, :changes)
    _, _, status = run_bd_command(args_list(args))
    _(status).must_equal 0
  end

  it 'should not provide usage output if changes argument is passed' do
    args = args_hash(required_option_keys + [:changes])
    _, stderr, = run_bd_command(args_list(args))
    _(stderr).wont_match(/Usage: .*bd \[options\]/)
  end

  it 'should exit with status 0 if deploy argument is passed' do
    args = args_hash(required_option_keys + [:deploy])
    _, _, status = run_bd_command(args_list(args))
    _(status).must_equal 0
  end

  it 'should exit with status 0 if short deploy argument is passed' do
    args = to_short_arg(@valid_args_hash, :deploy)
    _, _, status = run_bd_command(args_list(args))
    _(status).must_equal 0
  end

  it 'should not provide usage output if deploy argument is passed' do
    args = args_hash(required_option_keys + [:deploy])
    _, stderr, = run_bd_command(args_list(args))
    _(stderr).wont_match(/Usage: .*bd \[options\]/)
  end

  it 'should exit with status 1 if both deploy and changes arguments are passed' do
    args = args_hash(required_option_keys + %i[deploy changes])
    _, _, status = run_bd_command(args_list(args))
    _(status).must_equal 1
  end

  it 'should provide usage output if both deploy and changes arguments are passed' do
    args = args_hash(required_option_keys + %i[deploy changes])
    _, stderr, = run_bd_command(args_list(args))
    _(stderr).must_match(/Usage: .*bd \[options\]/)
  end

  it 'should exit with status 0 if ssh-options argument is passed' do
    args = args_hash(required_option_keys + [:ssh_options])
    _, _, status = run_bd_command(args_list(args))
    _(status).must_equal 0
  end

  it 'should exit with status 0 if short ssh-options argument is passed' do
    args = to_short_arg(@valid_args_hash, :ssh_options)
    _, _, status = run_bd_command(args_list(args))
    _(status).must_equal 0
  end

  it 'should not provide usage output if ssh-options argument is passed' do
    args = args_hash(required_option_keys + [:ssh_options])
    _, stderr, = run_bd_command(args_list(args))
    _(stderr).wont_match(/Usage: .*bd \[options\]/)
  end

  it 'should exit with status 0 if temp-path argument is passed' do
    args = args_hash(required_option_keys + [:temp_path])
    _, _, status = run_bd_command(args_list(args))
    _(status).must_equal 0
  end

  it 'should exit with status 0 if short temp-path argument is passed' do
    args = to_short_arg(@valid_args_hash, :temp_path)
    _, _, status = run_bd_command(args_list(args))
    _(status).must_equal 0
  end

  it 'should not provide usage output if temp-path argument is passed' do
    args = args_hash(required_option_keys + [:temp_path])
    _, stderr, = run_bd_command(args_list(args))
    _(stderr).wont_match(/Usage: .*bd \[options\]/)
  end

  it 'should exit with status 0 if verbose argument is passed' do
    args = args_hash(required_option_keys + [:verbose])
    _, _, status = run_bd_command(args_list(args))
    _(status).must_equal 0
  end

  it 'should exit with status 0 if short verbose argument is passed' do
    args = to_short_arg(@valid_args_hash, :verbose)
    _, _, status = run_bd_command(args_list(args))
    _(status).must_equal 0
  end

  it 'should not provide usage output if verbose argument is passed' do
    args = args_hash(required_option_keys + [:verbose])
    _, stderr, = run_bd_command(args_list(args))
    _(stderr).wont_match(/Usage: .*bd \[options\]/)
  end

  it 'should exit with status 0 if help argument is passed' do
    args = args_hash(required_option_keys + [:help])
    _, _, status = run_bd_command(args_list(args))
    _(status).must_equal 0
  end

  it 'should exit with status 0 if short help argument is passed' do
    args = to_short_arg(@valid_args_hash, :help)
    _, _, status = run_bd_command(args_list(args))
    _(status).must_equal 0
  end

  it 'should provide usage output if help argument is passed' do
    args = args_hash(required_option_keys + [:help])
    _, stderr, = run_bd_command(args_list(args))
    _(stderr).must_match(/Usage: .*bd \[options\]/)
  end
end
