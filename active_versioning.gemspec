require_relative "lib/version"

Gem::Specification.new do |spec|
  spec.name = "active_versioning"
  spec.version = ActiveVersioning::VERSION
  spec.authors = ["notWolfxd", "Winter"]
  spec.email = ["nyx.justink@gmail.com"]

  spec.summary = "Basic versioning system for ActiveRecord"
  spec.homepage = "https://github.com/notWolfxd/active_versioning"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files = %w[
    lib/version.rb
    lib/active_versioning.rb
    lib/components/model_extensions.rb
    lib/components/model_versions.rb
    lib/components/historical.rb
  ]

  spec.add_development_dependency("minitest", ["~> 5.15"])
  spec.add_development_dependency("rake", ["~> 13"])
  spec.add_development_dependency("active_record", ["~> 7"])
end