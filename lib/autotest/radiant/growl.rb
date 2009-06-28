require 'autotest/rspec'

class Autotest::Radiant < Autotest::Rspec
  attr_reader :count_re
  attr_writer :examples_total, :examples_failed, :examples_pending

  def success_count
    examples_total - examples_pending - examples_failed
  end

  def growl title, msg, img, pri=0
    system "growlnotify -n autotest --image #{img} -p #{pri} -m #{msg.inspect} #{title}"
  end

  def pass_img
    File.expand_path(File.join __FILE__, %w(.. .. .. pass.png))
  end

  def fail_img
    File.expand_path(File.join __FILE__, %w(.. .. .. fail.png))
  end

  %w(examples_total examples_failed examples_pending).each do |attr|
    class_eval <<-EOS, __FILE__, __LINE__
      def #{attr}             # def examples_total
        @#{attr} ||= 0        #   @examples_total ||= 0
      end                     # end
    EOS
  end
end

def spec_string(n=1)
  1 == n ? "#{n} spec" : "#{n} specs"
end

Autotest.add_hook :ran_command do |at|
  at.results.grep at.count_re
  at.examples_total, at.examples_failed, at.examples_pending = $1.to_i, $2.to_i, $3.to_i
end

Autotest.add_hook :red do |at|
  at.growl "Failure", "#{spec_string at.examples_failed} failed", at.fail_img, 2
end

Autotest.add_hook :green do |at|
  msg = "#{spec_string at.success_count} passed"
  msg += ", #{at.examples_pending} pending" if at.examples_pending > 0
  at.growl "Success", msg, at.pass_img, -2 if at.tainted
end

Autotest.add_hook :all_good do |at|
  msg = "#{spec_string at.success_count} passed"
  msg += ", #{at.examples_pending} pending" if at.examples_pending > 0
  at.growl "Success", msg, at.pass_img, -2 if at.tainted
end