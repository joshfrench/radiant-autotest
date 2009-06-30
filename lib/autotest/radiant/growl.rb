# Additional Autotest hooks and notification methods for Growl integration.

require 'autotest/rspec'

class Autotest::Radiant < Autotest::Rspec

  # Basic notification function. +pri+ = priority, which is used by Growl
  # to tweak background color and other settings to help visually distinguish
  # red/green notifications.
  def growl title, msg, img, pri=0
    system "growlnotify -n autotest --image #{img} -p #{pri} -m #{msg.inspect} #{title}"
  end

  # The image used in success notifications. Checks in local lib/ for
  # pass.png; if none is found, defaults to the delightful smiley face.
  def pass_img
    local = File.expand_path(File.join(Dir.pwd, %w(lib pass.png)))
    File.exists?(local) ? local : File.expand_path(File.join(__FILE__, %w(.. .. .. pass.png)))
  end

  # The image used in failure notifications. Checks in local lib/ for
  # fail.png; if none is found, defaults to the delightful frowny face.
  def fail_img
    local = File.expand_path(File.join(Dir.pwd, %w(lib fail.png)))
    File.exists?(local) ? local : File.expand_path(File.join(__FILE__, %w(.. .. .. fail.png)))
  end

end

Autotest.add_hook :red do |at|
  at.growl "Failure", "#{at.spec_string at.examples_failed} failed", at.fail_img, 2
end

Autotest.add_hook :green do |at|
  msg = "#{at.spec_string at.success_count} passed"
  msg += ", #{at.examples_pending} pending" if at.examples_pending > 0
  at.growl "Success", msg, at.pass_img, -2 if at.tainted
end

Autotest.add_hook :all_good do |at|
  msg = "#{at.spec_string at.success_count} passed"
  msg += ", #{at.examples_pending} pending" if at.examples_pending > 0
  at.growl "Success", msg, at.pass_img, -2 if at.tainted
end