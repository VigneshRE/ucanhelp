require "spec_helper"

describe OrphanagesController do
  describe "routing" do

    it "routes to #index" do
      get("/orphanages").should route_to("orphanages#index")
    end

    it "routes to #new" do
      get("/orphanages/new").should route_to("orphanages#new")
    end

    it "routes to #show" do
      get("/orphanages/1").should route_to("orphanages#show", :id => "1")
    end

    it "routes to #edit" do
      get("/orphanages/1/edit").should route_to("orphanages#edit", :id => "1")
    end

    it "routes to #create" do
      post("/orphanages").should route_to("orphanages#create")
    end

    it "routes to #update" do
      put("/orphanages/1").should route_to("orphanages#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/orphanages/1").should route_to("orphanages#destroy", :id => "1")
    end

  end
end
