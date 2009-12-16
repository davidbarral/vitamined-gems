module VitaminedGems
  
  VITAMINS_FILE = File.join(::Rails.root, 'config', 'vitamins.rb')
  
  def self.initialize(&block)
    @@vitamins = {
      :github => lambda { |name, _| { :lib => name.split('-', 2).last, :source => 'http://gems.github.com' } },
      :cutter => { :source => 'http://gemcutter.org' }
    }
  
    if File.exists?(VITAMINS_FILE)
      @@vitamins.merge!(VitaminExtractor.new(File.read(VITAMINS_FILE)).extract)
    end
  
    if block_given?
      @@vitamins.merge!(VitaminExtractor.new(&block).extract)
    end
  end

  def gem_with_vitamins(*args)
    args.empty? ? VitaminedGem.new(self, @@vitamins) : gem_without_vitamins(*args)
  end
  
  class UnknownVitamin < Exception
    def initialize(vitamin_name)
      super("Cannot find '#{vitamin_name}' vitamin")
    end
  end
  
  class VitaminedGem
    
    def initialize(rails_configuration, vitamins)
      @rails_configuration = rails_configuration
      @vitamins = vitamins
    end   
    
    def respond_to?(method)
      @vitamins.has_key?(method.to_sym) || super.respond_to?(method)
    end
    
    def method_missing(vitamin_name, gem_name, options = {})
      if vitamin = @vitamins[vitamin_name] 
        options = if vitamin.is_a? Hash
          vitamin.merge(options)
        else
          vitamin.call(gem_name, options).merge(options)
        end                
        @rails_configuration.gem(gem_name, options) 
      else
        raise UnknownVitamin.new(vitamin_name)
      end
    end
  end

  class VitaminExtractor
    
    def initialize(from = nil, &block)
      @from = from || block
      @extracted_vitamins = {}
    end
    
    def extract
       if @from.is_a? Proc
         instance_eval(&@from) 
       else 
         instance_eval(@from)
       end
       @extracted_vitamins
    end
    
    def method_missing(symbol, *args, &block)
      @extracted_vitamins[symbol] = block_given? ? block : args.first
    end
  end
end


#
# Setup method for the vitamined gems!! This pill should only be prescribed to 
# a Rails application ;)
# 
def vitamine_gems!(&block)
  
  Rails::Configuration.class_eval do 
    include VitaminedGems 
    alias :gem_without_vitamins :gem
    alias :gem :gem_with_vitamins
  end

  VitaminedGems.initialize(&block)
end
