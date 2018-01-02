require 'rails_helper'
require 'murker/spec_helper'

RSpec.describe MartiansController, type: :request do

  describe "GET #index and martian" do
    it "returns a success response", :murker do
      martian = Martian.create! name: 'spajic', age: 30, id: 1

      get '/martians.json'
      get '/martians/1.json'

      expect(response).to be_success
    end
  end
end