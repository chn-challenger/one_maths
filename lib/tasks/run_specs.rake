require 'rake'

namespace :specs do
  desc 'Running non Javascript tests inc Models, Helpers, Features and etc.'
  task :non_js do
    system "rspec spec/non_js_tests/"
  end

  desc 'Running only non js Feature specs.'
  task :features do
    system "rspec spec/non_js_tests/features/"
  end

  desc 'Running all Javascript tests.'
  task :js do
    system "rspec spec/zjavascript/"
  end
end
