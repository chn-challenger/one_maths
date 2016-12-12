RSpec.configure do |config|
  config.before(:all)  { FFaker::Random.seed=config.seed }
  config.before(:each) { FFaker::Random.reset! }
end
