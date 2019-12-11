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
      user = User.create(
        email:                 'fakeuser@gmail.com',
        password:              'secretPassword',
        password_confirmation: 'secretPassword'
      )
      sign_in user

      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "rocks#create action" do
    it "should successfully creat a new rock in the database" do
      user = User.create(
        email:                 'fakeuser@gmail.com',
        password:              'secretPassword',
        password_confirmation: 'secretPassword'
      )
      sign_in user

      post :create, params: { rock: { name: 'Rock' } }
      expect(response).to redirect_to root_path

      rock = Rock.last
      expect(rock.name).to eq("Rock")
      expect(rock.user).to eq(user)
    end

    it "should properly deal with validation errors" do
      user = User.create(
        email:                 'fakeuser@gmail.com',
        password:              'secretPassword',
        password_confirmation: 'secretPassword'
      )
      sign_in user

      rock_count = Rock.count
      post :create, params: { rock: { name: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(rock_count).to eq Rock.count
    end
  end
end
