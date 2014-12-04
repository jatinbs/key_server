class KeysController < ApplicationController

  #todo: auth for generate and viewing all keys

  #delete old keys on each call.
  #todo: spin off into own thread or do a async call every few mins?
  def initialize
    deleteOldKeys
    super
  end

  #list all keys. only for debugging/admin purposes
  def index
    @keys = Key.all
    render json: @keys
  end

  #generate a new unlocked key
  def generate
    @key = Key.new
    @key.save
    render json: @key
  end

  #get valid key and lock it
  def getKey

    #for the or where thing.
    t = Key.arel_table

    @key = Key.where(
        #auto-unlock after 60secs
        t[:updated_at].lt(1.minute.ago).
       #or unlocked
        or(t[:locked].eq(false))
    ).where('updated_at>?', 5.minutes.ago).first

    if @key
      @key.update(locked: true)
      #todo: only call if updated failed.(ie already locked)
      @key.touch
      render json: @key
    else
      render :status => 404, :json => {
                               error: "No keys available at this time."
                           }
    end

  end

  #method to unblock keys
  def unblock
    @key = Key.where(unique_hash: params[:key_hash]).first
    @key.update(locked: false)
    render json: @key
  end

  #method to keep the key alive and locked
  def touch
    @key = Key.where(unique_hash: params[:key_hash]).first
    @key.touch
    render json: @key
  end


  def delete
    @key = Key.where(unique_hash: params[:key_hash]).first
    @key.destroy if @key
    render json: @key
  end

  private

  #delete keys not accessed for 5 mins
  def deleteOldKeys
    Key.delete_all(['updated_at<?', 5.minute.ago])
  end
end
