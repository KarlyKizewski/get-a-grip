require 'rails_helper'

RSpec.describe RocksController, type: :controller do
  describe "rocks#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "rocks#new action" do
    it "should successfully show the new form" do 
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "rocks#create action" do 
    it "should successfully create a new rock in the database" do
      post :create, params: { rock: { name: "Rock" } }
      expect(response).to redirect_to root_path

      rock = Rock.last
      expect(rock.name).to eq("Rock")
    end

    it "should probably deal with validation errors" do
      post :create, params: { rock: { name: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Rock.count).to eq 0
    end
  end
end
