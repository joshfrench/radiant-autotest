require 'autotest/rspec'

Autotest.add_hook :initialize do |at|
  at.clear_mappings
  at.add_exception(%r%^\.\/(?:cache|db|doc|log|public|script|tmp|vendor)%)

  at.add_mapping(%r%^spec/(controllers|helpers|models|lib|views)/.*rb$%) do |filename,_|
    filename
  end

  at.add_mapping(%r%spec/spec_helper\.rb%) do
    at.files_matching %r%^spec/(controllers|helpers|lib|models|views)/.*_spec%
  end

  at.add_mapping(%r%^#{at.extension_name}_extension\.rb%) do |f,m|
    at.files_matching %r%^spec/(controllers|helpers|lib|models|views)/.*_spec%
  end

  at.add_mapping(%r%^app/controllers/(.*)\.rb$%) do |_,match|
    if match[1] == "#{at.extension_name}_controller"
      at.files_matching %r%^spec/controllers/.*_spec\.rb$%
    else
      ["spec/controllers/#{match[1]}_spec.rb"]
    end
  end

  at.add_mapping(%r%^app/helpers/(.*)_helper.rb%) do |_,match|
    if match[1] == at.extension_name
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

Autotest.add_hook :ran_command do |at|
  at.results.grep at.count_re
  at.examples_total, at.examples_failed, at.examples_pending = $1.to_i, $2.to_i, $3.to_i
end

# Although not declared as readable attributes, the examples_total,
# examples_failed, and examples_pending counts are available on the instance.
# This may be useful if you're implementing new notifications:
#
#   Autotest.add_hook :ran_command do |at|
#     logger.info "You have #{at.examples_pending} specs pending!"
#   end
#
# Conscientious grammarians may wish to use the pluralization helper:
#
#  Autotest.add_hook :waiting do |at|
#    logger.info "You have #{at.spec_string at.examples_pending} pending!"
#  end
class Autotest::Radiant < Autotest::Rspec
  attr_reader :count_re
  attr_writer :examples_total, :examples_failed, :examples_pending

  def initialize #:nodoc:
    super
    @count_re = /(\d+) examples?, (\d+) failures?(?:, (\d+) pending)?/
  end

  # Return the number of passing specs, not including pending.
  def success_count
    examples_total - examples_pending - examples_failed
  end

  # Attr readers with special sauce to ensure initialization as integers.
  %w(examples_total examples_failed examples_pending).each do |attr|
    class_eval <<-EOS, __FILE__, __LINE__
      def #{attr}             # def examples_total
        @#{attr} ||= 0        #   @examples_total ||= 0
      end                     # end
    EOS
  end

  def extension_name
    Dir.pwd.split('/').last
  end

  # Cheapie pluralization helper for use in notifications.
  # Returns 'spec' or 'specs' based on the value of +n+.
  def spec_string(n=1)
    1 == n ? "#{n} spec" : "#{n} specs"
  end

end