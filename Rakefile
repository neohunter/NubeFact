require "bundler/gem_tasks"
task :default => :spec

task :pry do
  $: << Dir.pwd + '/lib'
  require 'pry'
  require 'nube_fact'
  pry
end