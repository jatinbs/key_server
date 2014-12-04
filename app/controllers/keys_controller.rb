class KeysController < ApplicationController

  def index
    @keys = Key.all
    render json: @keys
  end

  def generate
    key_params = {
        unique_hash: "test"
    }
    @key = Key.new(key_params)
    @key.save
    render json: @key
  end

  def getKey

  end

  def touch
    @key = Key.where(unique_hash: params[:key_hash]).first
    @key.touch
    render json: @key
  end
end
