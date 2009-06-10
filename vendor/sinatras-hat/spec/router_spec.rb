require 'spec/spec_helper'

describe Sinatra::Hat::Router do
  before(:each) do
    build_models!
  end
  
  describe "initialization" do
    it "takes an instance of Maker" do
      proc {
        maker = new_maker
        Sinatra::Hat::Router.new(maker)
      }.should_not raise_error
    end
  end
  
  describe "#generate" do
    attr_reader :app, :maker, :router
    
    before(:each) do
      @app = mock_app { set :views, fixture('views') }
      @maker = new_maker
      @router = Sinatra::Hat::Router.new(maker)
      stub.proxy(app).get(anything)
    end
    
    it "takes a Sinatra app" do
      router.generate(app)
    end
    
    describe "abiding by the maker's :only option" do
      before(:each) do
        maker.only :index, :show
        router.generate(app)
      end
      
      it "should only have the limited options" do
        mock(app).put(anything).never
        mock(app).delete(anything).never
        post '/articles'
        response.status.should == 404
        put "/articles/#{@article.to_param}"
        response.status.should == 404
        delete "/articles/#{@article.to_param}"
        response.status.should == 404
      end
    end

    describe "generating index route" do
      it "calls the block, passing the request" do
        router.generate(app)
        mock.proxy(maker).handle(:index, anything) { "" }
        get '/articles.yaml'
      end
    end
    
    describe "generating show route" do
      it "calls the block, passing the request" do
        router.generate(app)
        mock.proxy(maker).handle(:show, anything) { "" }
        get '/articles/1.yaml'
      end
    end
    
    describe "generating create route" do
      it "calls the block, passing the request" do
        router.generate(app)
        mock(maker).handle(:create, anything)
        post '/articles', "maker[name]" => "Pat"
      end
    end
    
    describe "generating new route" do
      it "calls the block, passing the request" do
        router.generate(app)
        mock.proxy(maker).handle(:new, anything) { "" }
        get '/articles/new'
      end
    end
    
    describe "generating destroy route" do
      it "calls the block, passing the request" do
        router.generate(app)
        mock.proxy(maker).handle(:destroy, anything) { "" }
        delete "/articles/#{@article.to_param}"
      end
    end
    
    describe "generating edit route" do
      it "calls the block, passing the request" do
        router.generate(app)
        mock.proxy(maker).handle(:edit, anything) { "" }
        get "/articles/#{@article.to_param}/edit"
      end
    end
    
    describe "generating update route" do
      it "calls the block, passing the request" do
        router.generate(app)
        mock.proxy(maker).handle(:update, anything) { "" }
        put "/articles/#{@article.to_param}"
      end
    end
  end
end
