require 'rails_helper'

RSpec.describe TeamsController, type: :controller do
  let!(:team) { create(:team) }
  let!(:user1) { create(:user, name: 'User One') }
  let!(:user2) { create(:user, name: 'User Two') }

  describe "GET #index" do
    it "returns a list of teams" do
      get :index
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(1)
    end
  end

  describe "GET #show" do
    context "when the team exists" do
      it "returns the team" do
        get :show, params: { id: team.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["id"]).to eq(team.id)
      end
    end

    context "when the team does not exist" do
      it "returns a not found status" do
        get :show, params: { id: -1 }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["error"]).to eq("Team not found")
      end
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      let(:valid_attributes) { { team: { name: "New Team" } } }

      it "creates a new team" do
        expect {
          post :create, params: valid_attributes
        }.to change(Team, :count).by(1)
        expect(response).to have_http_status(:created)
      end

      it "creates a wallet for the new team" do
        post :create, params: valid_attributes
        team = Team.last
        expect(team.wallet).to be_present
      end
    end

    context "with invalid attributes" do
      let(:invalid_attributes) { { team: { name: "" } } }

      it "does not create a new team" do
        expect {
          post :create, params: invalid_attributes
        }.not_to change(Team, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PUT #update" do
    context "with valid attributes" do
      let(:valid_attributes) { { name: "Updated Team Name" } }

      it "updates the team" do
        put :update, params: { id: team.id, team: valid_attributes }
        team.reload
        expect(team.name).to eq("Updated Team Name")
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid attributes" do
      let(:invalid_attributes) { { name: "" } }

      it "does not update the team" do
        put :update, params: { id: team.id, team: invalid_attributes }
        team.reload
        expect(team.name).not_to eq("")
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes the team" do
      expect {
        delete :destroy, params: { id: team.id }
      }.to change(Team, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end

  describe "GET #team_users" do
    let!(:user) { create(:user) }
    before { team.users << user }

    it "returns the users of the team" do
      get :team_users, params: { id: team.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).first["id"]).to eq(user.id)
    end

    it "returns an empty array if the team has no users" do
      team.users.destroy_all
      get :team_users, params: { id: team.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([])
    end
  end

  describe "POST #add_users" do
    let!(:user1) { create(:user, name: 'User One') }
    let!(:user2) { create(:user, name: 'User Two') }

    it "adds users to the team" do
      post :add_users, params: { id: team.id, user_names: [user1.name, user2.name] }
      expect(response).to have_http_status(:ok)
      expect(team.users).to include(user1, user2)
    end

    it "returns an error when no user names are provided" do
      post :add_users, params: { id: team.id }
      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)["error"]).to eq("No user IDs provided.")
    end
  end

  describe "DELETE #remove_user" do
    let!(:user) { create(:user, name: 'User two') }

    before do
      team.users << user
    end

    it "removes the user from the team" do
      delete :remove_user, params: { id: team.id, name: user.name }
      expect(response).to have_http_status(:ok)
      expect(team.users).not_to include(user)
    end

    it "returns a not found status when user does not exist in the team" do
      delete :remove_user, params: { id: team.id, name: 'Nonexistent User' }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq("User not found in this team or does not exist.")
    end
  end
end
