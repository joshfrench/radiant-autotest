# Loads the Autotest::Radiant runner if it appears that we're inside a Radiant extension.
Autotest.add_discovery do
  "radiant" if Dir.pwd =~ /vendor\/extensions/ && !Dir.glob('*_extension.rb').empty?
end