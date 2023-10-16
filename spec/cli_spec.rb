# frozen_string_literal: true

require 'minitest/autorun'
require 'open3'
require_relative './spec_helper'

def bd_command
  File.expand_path(File.join(__dir__, "../bin/bd"))
end

def run_bd_command(args = "")
  if args.empty?
    stdout, stderr, status = Open3.capture3(bd_command)
  else
    stdout, stderr, status = Open3.capture3(bd_command, args)
  end

  return stdout, stderr, status.exitstatus
end

describe "CLI usage" do
  it "should exit 1 when no arguments are passed" do
    stdout, stderr, status = run_bd_command
    _(status).must_equal 1
  end


  it "should provide usage output when no arguments are passed" do
    stdout, stderr, status = run_bd_command
    _(stderr).must_match(/Usage: .*bd \[options\]/)
  end

end
