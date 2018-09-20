require 'sinatra/base'
require 'rack-flash'

class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :session_secret, "my_application_secret"
  set :views, Proc.new { File.join(root, "../views/") }
  enable :sessions
  use Rack::Flash
  set :method_override, true



  get '/' do
    erb :index
  end

  get '/songs' do
    @songs = Song.all
    erb :"songs/index"
  end
  get '/songs/new' do
    @artists = Artist.all
    @genres = Genre.all
  erb :"songs/new"
  end

  get '/songs/:slug' do

    @song = Song.find_by_slug(params[:slug])
    erb :"songs/show"
  end

  get '/songs/:slug/edit' do
      @song = Song.find_by_slug(params[:slug])
      erb :"songs/edit"
    end

  patch '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
     @song.update(params[:song])
     @song.artist = Artist.find_or_create_by(name: params[:artist][:name])
     @song.genre_ids = params[:genres]
     @song.save
    flash[:message] = "Successfully updated song."

    redirect "/songs/#{@song.slug}"


  end

  get '/artists' do
    @artists= Artist.all
    erb :"artists/index"
  end


post '/songs' do
song_name = params[:song_name]
artist = Artist.find_or_create_by(name:params[:artist_name])
song = Song.find_or_create_by(name: song_name, artist: artist)
params[:genres].each do |id|
  genre = Genre.find(id)
  song.genres << genre
end
flash[:message] = "Successfully created song."
redirect "/songs/#{song.slug}"
end


post '/set-flash' do
   # Set a flash entry
   flash[:notice] = "Successfully created song."

   # Get a flash entry
   flash[:notice] # => "Thanks for signing up!"

   # Set a flash entry for only the current request
   flash.now[:notice] = "Thanks for signing up!"
 end







  get '/artists/:slug' do
    @artist = Artist.find_by_slug(params[:slug])
    erb :"artists/show"
  end


  get '/genres' do
    @genres= Genre.all
    erb :"genres/index"
  end

  get '/genres/:slug' do
    @genre = Genre.find_by_slug(params[:slug])
    erb :"genres/show"
  end



end
