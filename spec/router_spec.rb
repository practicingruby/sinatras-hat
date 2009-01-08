require 'spec/spec_helper'

describe Sinatra::Hat::Router do
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
      @app = mock_app { self }
      @maker = new_maker
      @router = Sinatra::Hat::Router.new(maker)
    end
    
    it "takes a Sinatra app" do
      router.generate(app)
    end

    describe "generating index route" do
      it "uses the maker's resource path" do
        mock.proxy(maker).resource_path('/') { '/articles' }
        mock.proxy(app).get('/articles')
        mock.proxy(app).get('/articles.:format')
        router.generate(app)
      end
      
      it "calls the block, passing the request" do
        router.generate(app)
        mock.proxy(maker.model).all("format" => "yaml")
        mock.proxy(maker).handle_index(anything) { "" }
        get '/articles.yaml'
      end
    end
  end
end
