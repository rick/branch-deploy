# frozen_string_literal: true

require 'debug'
require 'minitest/autorun'
require_relative 'spec_helper'

describe 'deploying' do
  before do
    @valid_args_hash = args_hash(required_option_keys)
    install_fixture('single-branch-repo', 'main', '/tmp/')
  end

  # TODO:
  #
  # before running a spec:
  #   - ensure that we have a clear target directory
  #   - deploy a starting fixture, via `bd`
  #   - then run the desired deploy command
  #   - then check the results

  it 'should exit with status 0 if valid arguments are passed' do
    _, _, status = run_bd_command(args_list(@valid_args_hash))
    _(status).must_equal 0
  end
end
