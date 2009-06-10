require 'spec/spec_helper'

describe "handle create" do
  attr_reader :maker, :app, :request, :article
  
  before(:each) do
    build_models!
    mock_app {  }
    @maker = new_maker(Article)
    @request = fake_request("article[name]" => "The article")
    stub(request).redirect(anything)
  end
  
  def handle(*args)
    maker.handle(:create, *args)
  end
  
  it "instantiates a new record and saves it" do
    mock.proxy(article = Article.new).save
    mock.proxy(maker.model).new("article[name]" => "The article") { article }
    handle(request)
  end
  
  describe "responding" do
    attr_reader :new_article
    
    before(:each) do
      @new_article = Article.new
    end
    
    context "when the save is successful" do
      before(:each) do
        stub(Article).new(anything).returns(new_article)
      end
      
      context "when there's no format" do
        it "redirects" do
          mock(request).redirect(anything)
          mock.proxy(maker.responder).success(:create, request, new_article)
          handle(request)
        end
      end
    end

    context "when the save is not successful" do
      before(:each) do
        stub(Article).new(anything).returns(new_article)
        stub(new_article).save { false }
      end
      
      context "when there's no format" do
        it "renders edit template" do
          mock(request).erb :"articles/new"
          mock.proxy(maker.responder).failure(:create, request, new_article)
          handle(request)
        end
      end

      context "when there's a format" do
        it "serializes the response errors" do
          request = fake_request(:format => "yaml")
          mock.proxy(maker.responder).serialize(new_article.errors, "yaml") { :yaml }
          catch('halt') { handle(request) }
        end

        it "returns a 427 Unprocessable Entry with the serialized errors" do
          request = fake_request(:format => "yaml")
          mock.proxy(maker.responder).serialize(new_article.errors, "yaml") { :yaml }
          mock(request).error(427, :yaml)
          catch('halt') { handle(request) }
        end
      end
    end
  end
end