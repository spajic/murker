require 'rails_helper'
require 'murker/spec_helper'

RSpec.describe MartiansController, type: :controller do
  render_views

  describe "GET #index" do
    it "returns a success response", :murker do
      martian = Martian.create! name: 'spajic', age: 30

      get :index, format: :json
      expect(response).to be_success
    end
  end
end