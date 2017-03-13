Gem::Specification.new do |s|
  s.name = "drone-chef-supermarket"
  s.version = "0.0.0"
  s.date = Time.now.utc.strftime("%F")

  s.authors = ["Thomas Boerger", "Jacob McCann"]
  s.email = ["thomas@webhippie.de", "jmccann.git@gmail.com"]

  s.summary = <<-EOF
    Drone plugin to publish cookbooks to Chef Supermarket
  EOF

  s.description = <<-EOF
    Drone plugin to publish cookbooks to Chef Supermarket
  EOF

  s.homepage = "https://github.com/drone-plugins/drone-chef-supermarket"
  s.license = "Apache-2.0"

  s.files = ["README.md", "LICENSE"]
  s.files += Dir.glob("lib/**/*")
  s.files += Dir.glob("bin/**/drone-*")

  s.test_files = Dir.glob("spec/**/*")

  s.executables = ["drone-chef-supermarket"]
  s.require_paths = ["lib"]

  s.required_ruby_version = ">= 1.9.3"

  s.add_development_dependency "bundler"
  s.add_development_dependency "rake"
  s.add_development_dependency "yard"
  s.add_development_dependency "rspec", "~> 3.5"
  s.add_development_dependency "fakefs"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "simplecov-lcov"
  s.add_development_dependency "rubocop", "0.47.1"
  s.add_development_dependency "pry"

  # Keep the versions in sync with the Dockerfile
  s.add_runtime_dependency "gli", "~> 2.14"
  s.add_runtime_dependency "mixlib-shellout", "~> 2.2"
  s.add_runtime_dependency "chef", "12.10.24"
  s.add_runtime_dependency "knife-supermarket", "~> 0.2"

  s.add_runtime_dependency "json", "~> 2.0" # Required by Chef
end
