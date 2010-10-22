# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dkbrpc}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["doug"]
  s.date = %q{2010-10-22}
  s.description = %q{PCReservation}
  s.email = %q{doug@8thlight.com}
  s.extra_rdoc_files = [
    "README.rb"
  ]
  s.files = [
    ".gitignore",
     "README.rb",
     "VERSION",
     "examples/client.rb",
     "examples/server.rb",
     "lib/dkbrpc.rb",
     "lib/dkbrpc/connection.rb",
     "lib/dkbrpc/connection_id.rb",
     "lib/dkbrpc/fast_message_protocol.rb",
     "lib/dkbrpc/id.rb",
     "lib/dkbrpc/incoming_connection.rb",
     "lib/dkbrpc/outgoing_connection.rb",
     "lib/dkbrpc/remote_call.rb",
     "lib/dkbrpc/server.rb",
     "spec/dkbrpc/connection_failure_spec.rb",
     "spec/dkbrpc/connection_spec.rb",
     "spec/dkbrpc/incoming_connection_spec.rb",
     "spec/dkbrpc/integration_spec.rb",
     "spec/dkbrpc/remote_call_spec.rb",
     "spec/dkbrpc/server_failure_spec.rb",
     "spec/dkbrpc/server_spec.rb",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/dougbradbury/dkbrpc}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{PCReservation}
  s.test_files = [
    "spec/dkbrpc/connection_failure_spec.rb",
     "spec/dkbrpc/connection_spec.rb",
     "spec/dkbrpc/incoming_connection_spec.rb",
     "spec/dkbrpc/integration_spec.rb",
     "spec/dkbrpc/remote_call_spec.rb",
     "spec/dkbrpc/server_failure_spec.rb",
     "spec/dkbrpc/server_spec.rb",
     "spec/spec_helper.rb",
     "examples/client.rb",
     "examples/server.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.3.0"])
      s.add_runtime_dependency(%q<eventmachine>, [">= 0.12.10"])
    else
      s.add_dependency(%q<rspec>, [">= 1.3.0"])
      s.add_dependency(%q<eventmachine>, [">= 0.12.10"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.3.0"])
    s.add_dependency(%q<eventmachine>, [">= 0.12.10"])
  end
end

