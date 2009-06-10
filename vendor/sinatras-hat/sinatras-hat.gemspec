# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sinatras-hat}
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Pat Nakajima"]
  s.date = %q{2009-01-17}
  s.email = %q{patnakajima@gmail.com}
  s.files = ["README.md", "lib/core_ext", "lib/core_ext/array.rb", "lib/core_ext/hash.rb", "lib/core_ext/module.rb", "lib/core_ext/object.rb", "lib/sinatras-hat", "lib/sinatras-hat/actions.rb", "lib/sinatras-hat/authentication.rb", "lib/sinatras-hat/extendor.rb", "lib/sinatras-hat/hash_mutator.rb", "lib/sinatras-hat/logger.rb", "lib/sinatras-hat/maker.rb", "lib/sinatras-hat/model.rb", "lib/sinatras-hat/resource.rb", "lib/sinatras-hat/responder.rb", "lib/sinatras-hat/response.rb", "lib/sinatras-hat/router.rb", "lib/sinatras-hat.rb"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Simple REST-ful resources with Sinatra.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<extlib>, [">= 0"])
      s.add_runtime_dependency(%q<metaid>, [">= 0"])
      s.add_runtime_dependency(%q<sinatra>, [">= 0"])
    else
      s.add_dependency(%q<extlib>, [">= 0"])
      s.add_dependency(%q<metaid>, [">= 0"])
      s.add_dependency(%q<sinatra>, [">= 0"])
    end
  else
    s.add_dependency(%q<extlib>, [">= 0"])
    s.add_dependency(%q<metaid>, [">= 0"])
    s.add_dependency(%q<sinatra>, [">= 0"])
  end
end
