module MessageService
  module Helpers
    def self.init_environment(env)
      self.set_env(env)
      Sequel::Model.plugin :timestamps, update_on_create: true
      Sequel.connect("sqlite://db/#{env.downcase}.db")
    end

    def self.set_env(env)
      filename = env.to_s + ".env.sh"

      if File.exists? filename
        env_vars = File.read(filename)
        env_vars.each_line do |var|
          name, value = var.split("=", 2)
          if name && value
            ENV[name.strip] = value.gsub("\"", "").strip
          end
        end
      end
    end
  end
end
