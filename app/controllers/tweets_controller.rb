class TweetsController < ApplicationController
    before_action :authorize_request
    before_action :find_tweet, except: %i[create index]
  
    # GET /users
    def index
      @tweets = @current_user.tweets
      render json: @tweets, status: :ok
    end
  
    # GET /users/{username}
    def show
      render json: @tweet, status: :ok
    end
  
    # POST /users
    def create
      @tweet = @current_user.tweets.new(tweet_params)
      if @tweet.save
        render json: @tweet, status: :created
      else
        render json: { errors: @tweet.errors.full_messages },
               status: :unprocessable_entity
      end
    end
  
    # PUT /users/{username}
    def update
      if !@tweet.update(tweet_params)
        render json: { errors: @tweet.errors.full_messages },
               status: :unprocessable_entity
      
      else
        render json: @tweet, status: :ok
      end
    end
  
    # DELETE /users/{username}
    def destroy
      @tweet.destroy
    end
  
    private
  
    def find_tweet
  
      @tweet = @current_user.tweets.find_by!(id: params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: 'User not found' }, status: :not_found
    end
  
    def tweet_params
      params.permit(
        :id, :title, :content, :user_id
      )
    end
  end