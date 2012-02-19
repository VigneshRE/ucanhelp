require "spec_helper"

describe NeedsController do
  describe "routing" do

    it "routes to #index" do
      get("/needs").should route_to("needs#index")
    end

    it "routes to #index" do
      get("/orphanages/1/needs").should route_to("needs#index", :orphanage_id => "1")
    end

    it "routes to #new" do
      get("/orphanages/1/needs/new").should route_to("needs#new", :orphanage_id => "1")
    end

    it "routes to #show" do
      get("/orphanages/1/needs/1").should route_to("needs#show", :id => "1", :orphanage_id => "1")
    end

    it "routes to #edit" do
      get("/orphanages/1/needs/1/edit").should route_to("needs#edit", :id => "1", :orphanage_id => "1")
    end

    it "routes to #create" do
      post("/orphanages/1/needs").should route_to("needs#create", :orphanage_id => "1")
    end

    it "routes to #update" do
      put("/orphanages/1/needs/1").should route_to("needs#update", :id => "1", :orphanage_id => "1")
    end

    it "routes to #destroy" do
      delete("/orphanages/1/needs/1").should route_to("needs#destroy", :id => "1", :orphanage_id => "1")
    end

  end
end
