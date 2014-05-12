Gem::Specification.new do |spec|
  spec.name          = "gameon-redis"
  spec.version       = "0.0.0.pre1" 
  spec.authors       = ["theotherstupidguy"]
  spec.email         = ["theotherstupidguy@gmail.com"]
  spec.summary       = "redis persistence for gameon" 
  spec.description   = "" 
  spec.homepage      = "https://github.com/gameon-rb/gameon-redis"
  spec.license       = "MIT"

  spec.files         = ["lib/gameon-redis.rb"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "redis", "~> 3.0.7"
end
