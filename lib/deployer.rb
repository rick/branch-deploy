# frozen_string_literal: true

require 'shellwords'

# Construct a deployment command to be executed by the Runner
class Deployer
  attr_reader :options

  def initialize(options)
    @options = options
  end

  def repo
    Shellwords.escape(options[:repo])
  end

  def branch
    Shellwords.escape(options[:branch])
  end

  def temp_path
    return unless options[:temp_path]

    @temp_path ||= Shellwords.escape(options[:temp_path])
  end

  def build
    commands = []
    commands += create_tempdir
    commands += shallow_clone
    commands += fetch_changed_files
    commands += rsync_files
    commands += remove_tempdir
    commands.flatten.compact.join(' && ')
  end

  def create_tempdir
    commands = []

    if temp_path
      # NOTE: this is not portable -- some implementations ignore TMPDIR
      commands << "mkdir -p #{temp_path}"
      commands << "export TMPDIR=#{temp_path}"
    end

    commands << 'TMPFILE=$(mktemp -d -t branch-deploy-tmp.XXXXXX)'
  end

  def shallow_clone
    [
      'cd $TMPFILE',
      "git clone --depth 1 #{repo} --branch #{branch} checkout",
      'cd checkout'
    ]
  end

  def fetch_changed_files
    # TODO: this will be via rsync diff between the checkout and the --path
    []
  end

  def rsync_files
    # TODO: actually rsync the files into place; this is from the checkout to the --path
    []
  end

  def remove_tempdir
    [
      'rm -rf $TMPFILE'
    ]
  end
end
