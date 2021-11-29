require_relative "lib/content_pack_rails/version"

Gem::Specification.new do |spec|
  spec.name        = "content_pack_rails"
  spec.version     = ContentPackRails::VERSION
  spec.authors     = ["Andrew Bohush"]
  spec.email       = ["a.bohush01@gmail.com"]
  spec.homepage    = "TODO"
  spec.summary     = "TODO: Summary of ContentPackRails."
  spec.description = "TODO: Description of ContentPackRails."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.1.4", ">= 6.1.4.1"
end
