require "iterm_color_profiles/version"
require "yaml"
require "json"
require "securerandom"

module ItermColorProfiles
  class Error < StandardError; end
  
  class << self
    def generate_profiles!
      default_profile = YAML.load(File.read(File.join(File.dirname(__FILE__), "iterm_color_profiles/default_profile.yml")))
      profiles = []
      profiles << default_profile.clone.merge({
        "Guid" => SecureRandom.uuid,
        "Name" => "Default"
      })
      puts "COLOR SCHEME NAMES: #{color_scheme_names}"
      color_scheme_names.each do |color|
        profiles << default_profile.clone.merge({
          "Guid" => SecureRandom.uuid,
          "Name" => color
        })
      end
      build_path = File.expand_path("../build", __dir__)
      File.write("#{build_path}/Profiles.json", { "Profiles" => profiles }.to_json)
      puts "Done!"
    end

    def color_scheme_names
      Dir["#{File.expand_path('../schemes', __dir__)}/*.itermcolors"].map{ |f| File.basename f, ".itermcolors" }
    end
  end
end
