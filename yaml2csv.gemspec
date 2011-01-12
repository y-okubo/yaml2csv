$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name = "yaml2csv"
  s.homepage = "http://github.com/benhutton/yaml2csv"
  s.authors = ["Ben Hutton", "Arnau Sanchez"]
  s.summary = "Convert YAML to CSV (and backward)"
  s.description = "yaml2csv converts between YAML and CSV files"
  s.email = "benhutton@gmail.com"
  s.require_path = "lib"
  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- spec/*`.split("\n")

  s.version = '0.0.1'
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 1.8.6'
  s.required_rubygems_version = '>= 1.3.5'

  {
    'bundler'         => '~> 1.0.7',
    'rake'            => '~> 0.8.7',
    'ya2yaml'            => '~> 0.30',
  }.each do |lib, version|
    s.add_development_dependency lib, version
  end
end
