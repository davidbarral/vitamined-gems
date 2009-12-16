require 'rubygems'
require 'spec'

module Rails 
  def self.root
    File.dirname(__FILE__)
  end

  class Configuration
    def gem(name, options = {})
      [name, options]
    end
  end
end

require 'vitamined-gems'
vitamine_gems! do 
  fixed_version :version => '1.0'
  
  fixed_lib do |name, options|
    { :lib => "#{name}_fixed" }
  end
  
  overriden :version => 'overrides_file'
end

