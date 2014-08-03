# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_downloader_td/version'

Gem::Specification.new do |spec|
  spec.name          = "simple_downloader_td"
  spec.version       = SimpleDownloaderTd::VERSION
  spec.authors       = ["toru-takahashi"]
  spec.email         = ["torutakahashi.ayashi@gmail.com"]
  spec.summary       = %q{Download job result from TreasureData}
  spec.description   = %q{Download job result from TreasureData}
  spec.homepage      = "https://github.com/toru-takahashi/simple_downloader_td"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_dependency "td"
  spec.add_dependency "td-client"
  spec.add_dependency "msgpack"
end
