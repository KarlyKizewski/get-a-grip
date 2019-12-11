require 'rails_helper'

RSpec.describe RocksController, type: :controller do
  describe "rocks#destroy action" do
    it "shouldn't allow users who didn't create the rock to destroy it" do
      rock = FactoryBot.create(:rock)
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: { id: rock.id }
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthenticated users destroy a rock" do
      rock = FactoryBot.create(:rock)
      delete :destroy, params: { id: rock.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow a user to destroy rocks" do
      rock = FactoryBot.create(:rock)
      sign_in rock.user
      delete :destroy, params: { id: rock.id }
      expect(response).to redirect_to root_path
      rock = Rock.find_by_id(rock.id)
      expect(rock).to eq nil
    end

    it "should return a 404 message if we cannot find a rock with that id" do
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: { id: 'Truffles' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "rocks#update action" do
    it "shouldn't let users who did not create the rock update it" do
      rock = FactoryBot.create(:rock)
      user = FactoryBot.create(:user)
      sign_in user
      patch :update, params: { id: rock.id, rock: { name: 'Wahoowa' } }
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthenticated users update a rock" do
      rock = FactoryBot.create(:rock)
      delete :update, params: { id: rock.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow users to successfully update rocks" do
      rock = FactoryBot.create(:rock, name: "Initial Value")
      sign_in rock.user
      patch :update, params: { id: rock.id, rock: { name: 'Changed' } }
      expect(response).to redirect_to root_path
      rock.reload
      expect(rock.name).to eq "Changed"
    end

    it "should have http 404 if the gram cannot be found" do
      user = FactoryBot.create(:user)
      sign_in user
      patch :update, params: { id: "Not true", rock: { name: 'Changed' } }
      expect(response).to have_http_status(:not_found)
    end

    it "should render the edit form with an http status of unprocessable entity" do
      rock = FactoryBot.create(:rock, name: "Initial Value")
      sign_in rock.user
      patch :update, params: { id: rock.id, rock: { name: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      rock.reload
      expect(rock.name).to eq "Initial Value"
    end
  end

  describe "rocks#edit action" do
    it "shouldn't let a user who did not create the rock edit it" do
      rock = FactoryBot.create(:rock)
      user = FactoryBot.create(:user)
      sign_in user
      get :edit, params: { id: rock.id }
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthenticated users edit a rock" do
      rock = FactoryBot.create(:rock)
      delete :edit, params: { id: rock.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the edit form if the rock is found" do
      rock = FactoryBot.create(:rock)
      sign_in rock.user
      get :edit, params: { id: rock.id }
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error message if the rock is not found" do
      user = FactoryBot.create(:user)
      sign_in user
      get :edit, params: { id: 'Climb' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "rocks#show action" do
    it "should successfully show the page if the rock is found" do
      rock = FactoryBot.create(:rock)
      get :show, params: { id: rock.id }
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if the rock is not found" do
      get :show, params: { id: 'Rocky' }
      expect(response).to have_http_status(:not_found)
    end
  end


  describe "rocks#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "rocks#new action" do
    it "should require users to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the new form" do
      user = FactoryBot.create(:user)
      sign_in user

      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "rocks#create action" do

    it "should require users to be logged in" do
      post :create, params: { rock: { name: 'Rock' } }
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully creat a new rock in the database" do
      user = FactoryBot.create(:user)
      sign_in user

      post :create, params: { rock: { name: 'Rock' } }
      expect(response).to redirect_to root_path

      rock = Rock.last
      expect(rock.name).to eq("Rock")
      expect(rock.user).to eq(user)
    end

    it "should properly deal with validation errors" do
      user = FactoryBot.create(:user)
      sign_in user

      rock_count = Rock.count
      post :create, params: { rock: { name: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(rock_count).to eq Rock.count
    end
  end
end
