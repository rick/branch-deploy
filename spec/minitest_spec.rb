require "minitest/autorun"
require_relative "./spec_helper"

describe String do
  it "should be a kind of String" do
    _("hello").must_be_instance_of String
  end
end
