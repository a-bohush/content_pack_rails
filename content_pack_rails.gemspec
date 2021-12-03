require_relative "lib/content_pack_rails/version"

Gem::Specification.new do |spec|
  spec.name        = "content_pack_rails"
  spec.version     = ContentPackRails::VERSION
  spec.authors     = ["Andrew Bohush"]
  spec.email       = ["a.bohush01@gmail.com"]
  spec.homepage    = "https://github.com/a-bohush/content_pack_rails.git"
  spec.summary     = "Ruby on Rails helpers for capturing view content into bundles."
  spec.license     = "MIT"

  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/a-bohush/content_pack_rails/blob/main/README.md"
  spec.extra_rdoc_files = ['README.md']
  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.add_development_dependency "rails", "~> 6.1.4", ">= 6.1.4.1"
  spec.add_development_dependency "pry-byebug"
end
