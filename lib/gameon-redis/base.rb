require "redis"

module GameOn 
  module Persistence
    class DS 

      GameOn::Env.register do 
	class << self
	  attr_accessor :id
	end
	attr_accessor :id
      end

      @@redis = Redis.new
      def initialize(app)
	@app = app
	@id = GameOn::Env.id 
      end

      def call(env)
	if DS.exists?(@id) 
	  p 'resotred'
	  env[:gameon] = DS.load @id 
	  p env[:gameon]
	else 
	  p 'new obj'
	  env[:gameon] = GameOn::Env.new
	  env[:gameon].id  = @id
	end
	@app.call(env)
	DS.store env[:gameon] 
	p env[:gameon] 
	p 'stored'
      end

      def DS.store obj
	@env = Marshal.dump obj 
	@@redis.set(obj.id, @env)
	return Marshal.load @env 
      end
      def DS.load id
	return Marshal.load @@redis.get id
      end

      def DS.exists? id
	if (@@redis.get id) && (Marshal.load @@redis.get id) 
	  p true
	  return true
	else 
	  p false
	  return false
	end
      end
    end
  end
end
