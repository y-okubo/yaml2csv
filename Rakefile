require 'bundler'
require 'bundler/setup'
Bundler::GemHelper.install_tasks

require 'rake'
require "rspec/core/rake_task"

require File.expand_path("../lib/tasks/yaml2csv", __FILE__)

RSpec::Core::RakeTask.new(:spec)

task :default => [:spec]
