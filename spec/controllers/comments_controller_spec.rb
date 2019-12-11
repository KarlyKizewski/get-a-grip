require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe "comments#create action" do
    it "should allow users to create comments on rocks" do
      rock = FactoryBot.create(:rock)

      user = FactoryBot.create(:user)
      sign_in user
      post :create, params: { rock_id: rock.id, comment: { message: 'tough climb!' } }
      expect(response).to redirect_to root_path
      expect(rock.comments.length).to eq 1
      expect(rock.comments.first.message).to eq "tough climb!"
    end

    it "should require a user to be logged in to comment on a rock" do
      rock = FactoryBot.create(:rock)
      post :create, params: { rock_id: rock.id, comment: { message: 'tough climb!' } }
      expect(response).to redirect_to new_user_session_path
    end

    it "should return http status code of not found if the rock isn't found" do
      user = FactoryBot.create(:user)
      sign_in user
      post :create, params: { rock_id: 'Yowza', comment: { message: 'tough climb!' } }
      expect(response).to have_http_status :not_found
    end
  end
end
