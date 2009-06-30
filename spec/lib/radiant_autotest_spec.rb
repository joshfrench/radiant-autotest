require File.join(File.dirname(__FILE__), %w(.. .. lib autotest radiant))
require File.join(File.dirname(__FILE__), %w(.. matchers autotest_matchers))

describe Autotest::Radiant do
  before do
    Dir.stub!(:pwd).and_return('my')  # stub name as my_extension
    @autotest = Autotest::Radiant.new
    @autotest.hook :initialize
  end

  it "should know which extension is running" do
    @autotest.extension_name.should == 'my'
  end

  it "should initialize count attrs with 0" do
    @autotest.examples_total.should == 0
    @autotest.examples_pending.should == 0
    @autotest.examples_failed.should == 0
  end

  it "should calculate successful specs" do
    @autotest.examples_total = 10
    @autotest.examples_pending = 3
    @autotest.examples_failed = 2
    @autotest.success_count.should == 5
  end

  describe "spec matchers" do
    it "should map controller spec" do
      @autotest.should  map_specs(['spec/controllers/my_controller_spec.rb']).
                        to('spec/controllers/my_controller_spec.rb')
    end

    it "should map nested controller spec" do
      @autotest.should  map_specs(['spec/controllers/admin/my_controller_spec.rb']).
                        to('spec/controllers/admin/my_controller_spec.rb')
    end

    it "should map helper spec" do
      @autotest.should  map_specs(['spec/helpers/my_helper_spec.rb']).
                        to('spec/helpers/my_helper_spec.rb')
    end

    it "should map model spec" do
      @autotest.should  map_specs(['spec/models/my_model_spec.rb']).
                        to('spec/models/my_model_spec.rb')
    end
  end

  # Assumption: my_extension, my_controller, my_helper are often parent classes
  # for other concrete descendants
  describe "extension matchers" do
    it "should map extension.rb to all specs" do
      @autotest.should  map_specs(['spec/controllers/my_controller_spec.rb', 'spec/helpers/my_helper_spec.rb', 
                                   'spec/lib/my_lib_spec.rb', 'spec/models/my_model_spec.rb', 'spec/views/my_view_spec.rb']).
                        to('my_extension.rb')
    end

    it "should map extension controller to all controller specs" do
      @autotest.should  map_specs(['spec/controllers/admin/another_controller_spec.rb', 'spec/controllers/my_controller_spec.rb']).
                        to('app/controllers/my_controller.rb')
    end

    it "should map extension helper to all controller and view specs" do
      @autotest.should  map_specs(['spec/helpers/sample_helper_spec.rb', 'spec/views/sample_view_spec.rb']).
                        to('app/helpers/my_helper.rb')
    end
  end

  describe "application matchers" do
    it "should map controller" do
      @autotest.should  map_specs(['spec/controllers/my_controller_spec.rb']).
                        to('app/controllers/my_controller.rb')
    end

    it "should map nested controller" do
      @autotest.should  map_specs(['spec/controllers/admin/my_controller_spec.rb']).
                        to('app/controllers/admin/my_controller.rb')
    end



    it "should map helper to controller, helper, and view specs" do
      @autotest.should  map_specs(['spec/controllers/sample_controller_spec.rb', 'spec/helpers/sample_helper_spec.rb',
                                   'spec/views/sample_view_spec.rb']).
                        to('app/helpers/sample_helper.rb')
    end

    it "should map lib to spec" do
      @autotest.should  map_specs(['spec/lib/lib_spec.rb']).
                        to('lib/lib.rb')
    end

    it "should map nested lib" do
      @autotest.should  map_specs(['spec/lib/lib_spec.rb']).
                        to('lib/nested/lib.rb')
    end

    it "should map model to spec" do
      @autotest.should  map_specs(['spec/models/model_spec.rb']).
                        to('app/models/model.rb')
    end

    it "should map view to spec" do
      @autotest.should  map_specs(['spec/views/samples/index_view_spec.rb']).
                        to('app/views/samples/index.anything')
    end
  end
end