require 'forwardable'
require "redis"

module GameOn 
  module Persistence
    class DS 
      #extend Forwardable 

      GameOn::Env.register do 
	attr_accessor :id
      end

      @@redis = Redis.new

      #def_delegator :@gameon_env, :id
      def initialize app
	@app = app
	@id = GameOn::Env.id
      end

      def call(env)
	p "GameOn::Persistence::DS instance id = #{@id}" 
	if exists? @id 
	  env[:gameon] = DS.load @id 
	  p "resotred #{env[:gameon]}"
	else 
	  p 'new obj from GameOn::Env class '
	  env[:gameon] = GameOn::Env.new
	  env[:gameon].id  = @id
	  p "env[:gameon].id equals #{env[:gameon].id}"
	end
	@app.call(env)
	DS.store env[:gameon] 
	p "stored #{env[:gameon]}" 
      end

      def DS.store obj
	begin
	  @gameon_env = Marshal.dump obj 
	  @@redis.set(obj.id, @gameon_env)
	ensure
	  p "storing GameOn Env #{obj}"
	end
      end
      def DS.load id
	return Marshal.load (@@redis.get(id))
      end

      def exists? id
	if (@@redis.get id) && (Marshal.load @@redis.get id) 
	  p "GameOn::Persistence::DS.exists? true" 
	  return true
	else 
	  p "GameOn::Persistence::DS.exists? false" 
	  return false
	end
      end
    end
  end
end
