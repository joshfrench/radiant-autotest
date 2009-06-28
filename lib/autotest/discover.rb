Autotest.add_discovery do
  "radiant" if Dir.pwd =~ /vendor\/extensions/ && !Dir.glob('*_extension.rb').empty?
end