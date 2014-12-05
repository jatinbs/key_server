require 'rails_helper'

RSpec.describe KeysController, :type => :controller do

  describe "GET #index" do

    it "responds with a HTTP 200" do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

  end

  describe "GET #generate" do

    it "responds with a HTTP 200" do
      get :generate
      expect(response).to be_success
      expect(response).to have_http_status(200)

      #cehck if all arrays are displayed
      get :index
      keys_array = JSON.parse(response.body)
      expect(keys_array.length).to equal(1)
    end

  end

  describe "GET #getKey" do

    it "responds with a HTTP 404" do
      get :getKey
      expect(response).to have_http_status(404)
    end

    it "responds with 200 after key is generated" do
      get :generate
      get :getKey
      expect(response).to be_success
      expect(response).to have_http_status(200)

      #todo: check if lockerd = true
    end

  end

  describe "GET #unblock" do

    it "responds with 404 when supplied with invalid hash" do
      get :touch, :key_hash => 'adasdsa'
      expect(response).to have_http_status(404)
    end

    it "responds with 200" do
      get :generate
      get :getKey
      key_content = JSON.parse(response.body)
      unique_hash = key_content["unique_hash"]
      get :touch, :key_hash => unique_hash
      expect(response).to have_http_status(200)
    end

  end

  describe "GET #touch" do

    it "responds with 404 when supplied with invalid hash" do
      get :unblock, :key_hash => 'adasdsa'
      expect(response).to have_http_status(404)
    end

    it "responds with 200" do
      get :generate
      get :getKey
      key_content = JSON.parse(response.body)
      unique_hash = key_content["unique_hash"]
      get :unblock, :key_hash => unique_hash
      expect(response).to have_http_status(200)

      unblocked_key = JSON.parse(response.body)
      expect(unblocked_key["locked"]).to equal(false)
    end

  end

  describe  "get #delete" do
    it "responds with 404 when supplied with invalid hash" do
      get :delete, :key_hash => 'adasdsa'
      expect(response).to have_http_status(404)
    end

    it "responds with 200" do
      get :generate
      get :getKey
      key_content = JSON.parse(response.body)
      unique_hash = key_content["unique_hash"]
      get :delete, :key_hash => unique_hash
      expect(response).to have_http_status(200)
    end
  end

end
