require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Vitamined gem" do 

  before do
    @config = Rails::Configuration.new  
  end

  it "should behaves as usual wit non vitamined gems" do
    @config.gem('rails').should == ['rails', {} ]
    @config.gem('rails', :version => '1.1').should == ['rails', {:version => '1.1'}]
  end
  
  it "should have and only have a github and a cutter vitamin" do  
    @config.gem.respond_to?(:github).should be_true
    @config.gem.respond_to?(:cutter).should be_true
    @config.gem.respond_to?(:anothed_vitamin).should be_false
  end
  
  it "should accept configuration through a block" do
    @config.gem.respond_to?(:fixed_version).should be_true
    @config.gem.fixed_version('a_gem').should == ['a_gem', {:version => '1.0'} ]

    @config.gem.respond_to?(:fixed_lib).should be_true
    @config.gem.fixed_lib('b_gem').should == ['b_gem', {:lib => 'b_gem_fixed'} ]
  end
  
  it "should accept configuration through a RAILS_ROOT/config/vitamins.rb file" do
    @config.gem.respond_to?(:file_fixed_version).should be_true
    @config.gem.file_fixed_version('a_gem').should == ['a_gem', {:version => '1.0'} ]

    @config.gem.respond_to?(:file_fixed_lib).should be_true
    @config.gem.file_fixed_lib('b_gem').should == ['b_gem', {:lib => 'b_gem_fixed'} ]
  end
  
  it "should respect precedences" do
    @config.gem.overriden('a_gem').should == ['a_gem', {:version => 'overrides_file'}]
    @config.gem.overriden('a_gem', :version => 'overrides_block').should == ['a_gem', {:version => 'overrides_block'}]
  end  
    
  describe "Github vitamin" do
    it "should automatically add the lib and source values" do
    
      expected = {:lib => 'utility_scopes', :source => 'http://gems.github.com'}
    
      @config.gem.github('yfactorial-utility_scopes').should == ['yfactorial-utility_scopes', expected  ]
      @config.gem.github('yfactorial-utility_scopes', :version => '1.0').should == ['yfactorial-utility_scopes', expected.merge(:version => '1.0') ]
    end
  end  
  
  describe "Cutter vitamin" do
    it "should automatically add the source value" do
      expected = { :source => 'http://gemcutter.org' }
      
      @config.gem.cutter('sugarfree-config').should == ['sugarfree-config', expected]
      @config.gem.cutter('sugarfree-config', :version => '1.0.0').should == ['sugarfree-config', expected.merge(:version => '1.0.0')]
    end
  end
end
