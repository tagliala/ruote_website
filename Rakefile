$:.unshift(File.dirname(__FILE__))

require 'listen'
begin
  require 'nanoc/tasks'
rescue LoadError
end

task :compile do
  exec 'bundle exec nanoc compile'
end

task :aco do
  #exec "nanoc aco" # <--- too slow, can't wait nanoc 3.2
  queue = Queue.new

  Thread.new do
    loop { queue.pop; sh 'bundle exec nanoc co'; queue.clear }
  end
  Thread.new do
    Listen.to('content', :filter => /\.txt$/) do |mod, add, rem|
      queue << :doit
    end
  end

  sh 'bundle exec nanoc view'
end

task :rdoc do
  #sh "./scripts/ep2tex.rb"
  load 'scripts/ep2tex.rb'
end

task :deploy do
  exec 'bundle exec nanoc deploy'
end
