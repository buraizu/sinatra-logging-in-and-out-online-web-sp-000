require_relative '../../config/environment'
require 'pry'
class ApplicationController < Sinatra::Base
  configure do
    set :views, Proc.new { File.join(root, "../views/") }
    enable :sessions unless test?
    set :session_secret, "secret"
  end

  get '/' do
    erb :index
  end

  post '/login' do
    @user = User.find_by(username: params[:username], password: params[:password])
    if @user == nil
      erb :error
    else
      session[:user_id] = @user.id
      redirect to '/account'
    end
  end

  get '/account' do
    if Helpers.is_logged_in?(session)
      @user = Helpers.current_user(session)

      erb :account
    elsif Helpers.is_logged_in?(session) == false
      erb :error
    end
  end

  get '/logout' do
    session.clear
    redirect to '/'
  end
end
