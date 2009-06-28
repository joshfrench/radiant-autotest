require 'autotest/rspec'

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
  attr_reader :count_re
  attr_writer :examples_total, :examples_failed, :examples_pending

  def initialize
    super
    @count_re = /(\d+) examples?, (\d+) failures?(?:, (\d+) pending)?/
  end

  def success_count
    examples_total - examples_pending - examples_failed
  end

  %w(examples_total examples_failed examples_pending).each do |attr|
    class_eval <<-EOS, __FILE__, __LINE__
      def #{attr}             # def examples_total
        @#{attr} ||= 0        #   @examples_total ||= 0
      end                     # end
    EOS
  end

end

Autotest.add_hook :ran_command do |at|
  at.results.grep at.count_re
  at.examples_total, at.examples_failed, at.examples_pending = $1.to_i, $2.to_i, $3.to_i
end

def spec_string(n=1)
  1 == n ? "#{n} spec" : "#{n} specs"
end