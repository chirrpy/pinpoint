# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'pinpoint/version'

Gem::Specification.new do |s|
  s.rubygems_version      = '1.3.5'

  s.name                  = 'pinpoint'
  s.rubyforge_project     = 'pinpoint'

  s.version               = Pinpoint::VERSION
  s.platform              = Gem::Platform::RUBY

  s.authors               = %w{jfelchner m5rk}
  s.email                 = 'support@chirrpy.com'
  s.date                  = Date.today
  s.homepage              = 'https://github.com/chirrpy/pinpoint'

  s.summary               = %q{(Un)conventional Address Composition for Ruby (and Rails)}
  s.description           = %q{Handling common address logic. (currently only for US addresses but international is planned.)}

  s.rdoc_options          = ["--charset = UTF-8"]
  s.extra_rdoc_files      = %w[README.md LICENSE]

  #= Manifest =#
  s.executables           = Dir["{bin}/**/*"]
  s.files                 = Dir["{app,config,db,lib}/**/*"] + %w{Rakefile README.md}
  s.test_files            = Dir["{test,spec,features}/**/*"]
  s.require_paths         = ["lib"]
  #= Manifest =#

  s.add_development_dependency  'rspec',                '~> 2.11'
  s.add_development_dependency  'rspectacular',         '~> 0.7'
  s.add_development_dependency  'valid_attribute',      '~> 1.3.1'
  s.add_development_dependency  'activemodel',          '~> 3.1.8'
end
