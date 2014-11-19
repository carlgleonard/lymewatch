require 'sinatra'
require './helpers/sinatra'
require './helpers/lymetest'
require './model/mongodb'
require 'haml'
require 'digest/md5'
require 'googlestaticmap'


configure do
  enable :sessions
end

# This runs prior to all requests.
# It passes along the logged in user's object (from the session)
before do
  unless session[:user] == nil
    @suser = session[:user]
  end
end


####################################################################


get '/venue' do

  if session[:user] == nil
      flash("Login UNsuccessful")
      return haml :login
  else
      haml :index
  end
  flash("Login successful " + session[:user].email.to_s)
  haml :venue
end


get '/showit' do

  #if session[:user] == nil
  #    flash("Login UNsuccessful")
  #    return haml :login
  #else
  #    haml :index
  #end
  #flash("Login IDd as: " + session[:user].email.to_s)
  #"Hello World"
  haml :showit
end


get '/display' do
  haml :display
  #"Hello World"
end

get '/user/:email/profile' do
    # Code to get a user hash from MongoDB here
    #
    if u == nil
        return haml :profile_missing
    else
        @user = User.new(u)
    end
    haml :user_profile
end


get '/showout' do
  vvv = ['aa','bb','cc']
  @array = [{"name" => "a", "age" => 1}, {"name" => "b", "age" => 2}]
  ##@ttt = 'Hi Carl!!!'
  haml :showout
end

get '/showout:yoname' do
  "Hello, #{params[:yoname]}!"
  #vvv = ['aa','bb','cc']
  ##@ttt = 'Hi Carl!!!'
  #haml :showout
end


####################################################################

get '/' do
  haml :index
end

get '/login' do
  haml :login
end

# The login post routine will take the provided params and run the auth routine.
# If the auth routine is successful it will return the user object, else nil
post '/login' do
  if session[:user] = User.auth(params["email"], params["password"])
    flash("Login successful")
    redirect "/user/" << session[:user].email << "/dashboard"
  else
    flash("Login failed - Try again")
    redirect '/login'
  end
end

get '/logout' do
  session[:user] = nil
  flash("Logout successful")
  redirect '/'
end

get '/register' do
  haml :register
end

post '/register' do
  # Creating and populating a new user object from the DB
  u            = User.new
  u.email      = params[:email]
  u.password   = params[:password]
  u.name       = params[:name]

  # Attempt to save the user to the DB
  if u.save()
    flash("User created")

    # If user saved, authenticate from the database
    session[:user] = User.auth( params["email"], params["password"])
    redirect '/user/' << session[:user].email.to_s << "/dashboard"
  else
    # Else, display errors
    tmp = []
    u.errors.each do |e|
      tmp << (e.join("<br/>"))
    end
    flash(tmp)
    redirect '/create'
  end
end

get '/user' do
  if logged_in?
      redirect '/user/' + session[:user].email + '/profile'
  else
      redirect '/'
  end
end

get '/user/:email/dashboard' do
  haml :user_dashboard
end
