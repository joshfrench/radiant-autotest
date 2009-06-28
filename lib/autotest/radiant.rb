require 'autotest/rspec'
require 'autotest/radiant/growl'

Autotest.add_hook :initialize do |at|
  extension = Dir.pwd.split('/').last

  at.clear_mappings
  at.add_exception(%r%^\.\/(?:cache|db|doc|log|public|script|tmp|vendor)%)

  at.add_mapping(%r%^spec/(controllers|helpers|models|lib|views)/.*rb$%) do |filename,_|
    filename
  end

  at.add_mapping(%r%spec/spec_helper\.rb%) do
    at.files_matching %r%^spec/(controllers|helpers|lib|models|views)/.*_spec%
  end

  at.add_mapping(%r%^#{extension}_extension\.rb%) do
    at.files_matching %r%^spec/(controllers|helpers|lib|models|views)/.*_spec%
  end

  at.add_mapping(%r%^app/controllers/(.*)\.rb$%) do |_,match|
    if match[1] == "#{extension}_controller"
      at.files_matching %r%^spec/controllers/.*_spec\.rb$%
    else
      ["spec/controllers/#{match[1]}_spec.rb"]
    end
  end

  at.add_mapping(%r%^app/helpers/(.*)_helper.rb%) do |_,match|
    if match[1] == extension
      at.files_matching %r%^spec/(helpers|views)/.*_spec\.rb$%
    else
      ["spec/controllers/#{match[1]}_controller_spec.rb",
       "spec/helpers/#{match[1]}_helper_spec.rb",
       "spec/views/#{match[1]}_view_spec.rb"]
    end
  end

  at.add_mapping(%r%lib/.*([\w_])\.rb%) do |_,match|
    at.files_matching(%r%^spec/.*#{match[1]}_spec\.rb%)
  end

  at.add_mapping(%r%^app/models/(.*)\.rb$%) do |_,match|
    ["spec/models/#{match[1]}_spec.rb"]
  end

  at.add_mapping(%r%^app/views/([\w\/_]+)\.%) do |_,match|
    ["spec/views/#{match[1]}_view_spec.rb"]
  end
end

class Autotest::Radiant < Autotest::Rspec

end