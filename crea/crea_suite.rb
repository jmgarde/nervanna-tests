# output T/F as Green/Red
ENV['RSPEC_COLOR'] = 'true'

require File.join(File.dirname(__FILE__), "src/crea_adwords_a.rb")
require File.join(File.dirname(__FILE__), "src/crea_adwords_b.rb")
require File.join(File.dirname(__FILE__), "src/crea_gcn_a.rb")
require File.join(File.dirname(__FILE__), "src/crea_gcn_b.rb")
require File.join(File.dirname(__FILE__), "src/crea_gcn_c.rb")

