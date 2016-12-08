require 'dm-core'
require 'dm-migrations'

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development903.db")  
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
end

class Songtag
   include DataMapper::Resource
   belongs_to :song,   :key => true
   belongs_to :tag,    :key => true
end

class Song
  include DataMapper::Resource
  property :id, Serial
  property :title, String
  property :videoref, Text
  property :artist, String
  property :lyrics, Text
  property :length, Integer
  has n, :songtags
  has n, :tags, :through => :songtags  
end
  
class Usertag
  include DataMapper::Resource
  property :id, Serial
  property :validated, String
  belongs_to :tag
  belongs_to :user
end  
  
class Tag
  include DataMapper::Resource
  property :id, Serial
  property :tagname, String
  property :current, String
  has n, :songtags
  has n, :songs, :through => :songtags
  has n, :usertags
  has n, :users, :through => :usertags
  end

class User
  include DataMapper::Resource
  property :id, Serial
  property :username, String
  property :useravatar, String
  has n, :usertags
  has n, :tags, :through => :usertags
  end
  
DataMapper.finalize

module SongHelpers
  def songs_find
    @songs = Song.all
  end

  def song_find
    Song.get(params[:id]) 
  end
  
  def song_create
    @song = Song.create(params[:song])
  end
end
helpers SongHelpers

get '/songs' do #show list of songs
  songs_find
  tags_find
  slim :songs
end

get '/songs/new' do
  @song = Song.new
  slim :song_new
end

post '/songs' do
  song_create
  redirect to("/songs/#{@song.id}")
end

get '/songs/:id' do
  @song = song_find
  slim :song_show
end

put '/songs/:id' do
  song = song_find
  song.update(params[:song])
  redirect to("/songs/#{song.id}")
end

delete '/songs/:id' do
  Songtag.each do |st|
    if st.song_id == song_find.id
	   st.destroy
    end
  end	
  #redirect to('/songtags')  
  song_find.destroy
  redirect to('/songs')
end

get '/songs/:id/edit' do
  @song = song_find
  slim :song_edit
end

module TagHelpers
  def tags_find
    @tags = Tag.all
  end

  def tag_find
    Tag.get(params[:id]) 
  end
  
  def tag_create
    @tag = Tag.create(params[:tag])
  end
end
helpers TagHelpers

get '/tags' do #show list of tags
  tags_find
  slim :tags
end

get '/tags/new' do
  @tag = Tag.new
  slim :tag_new
end

post '/tags' do
  tag_create
  redirect to("/tags/#{@tag.id}")
end

get '/tags/:id' do
  @tag = tag_find
  slim :tag_show
end

put '/tags/:id' do
  tag = tag_find
  tag.update(params[:tag])
  redirect to("/tags/#{tag.id}")
end

delete '/tags/:id' do
  Songtag.each do |st|
    if st.tag_id == tag_find.id
	   st.destroy
    end
  end	
  Usertag.each do |ut|
    if ut.tag_id == tag_find.id
	   ut.destroy
    end
  end	
  tag_find.destroy
  redirect to('/tags')
end

get '/tags/:id/edit' do
  @tag = tag_find
  slim :tag_edit
end

module UserHelpers
  def users_find
    @users = User.all
  end

  def user_find
    User.get(params[:id]) 
  end
  
  def user_create
    @user = User.create(params[:user])
  end
end
helpers UserHelpers

get '/users' do #show list of users
  users_find
  slim :users
end

get '/users/new' do
  @user = User.new
  slim :user_new
end

post '/users' do
  user_create
  redirect to("/users/#{@user.id}")
end

get '/users/:id' do
  @user = user_find
  slim :user_show
end

put '/users/:id' do
  user = user_find
  user.update(params[:user])
  redirect to("/users/#{user.id}")
end

delete '/users/:id' do
  Usertag.each do |ut|
    if ut.user_id == user_find.id
	   ut.destroy
    end
  end	
  user_find.destroy
  redirect to('/users')
end

get '/users/:id/edit' do
  @user = user_find
  slim :user_edit
end

module UsertagHelpers
  def usertags_find
    @usertags = Usertag.all
  end

  def usertag_find
    Usertag.get(params[:id]) 
  end
  
  def usertag_create
    @usertag = Usertag.create(params[:usertag])
  end
end
helpers UsertagHelpers

get '/usertags' do #show list of usertags
  usertags_find
  slim :usertags
end

get '/usertags/new' do
  @usertag = Usertag.new
  slim :usertag_new
end

post '/usertags' do
  usertag_create
  if User.get(@usertag.user_id) && Tag.get(@usertag.tag_id)
	 redirect to("/usertags/#{@usertag.id}")
  else
    @usertag.destroy
    redirect to("/usertags") 
  end
end

get '/usertags/:id' do
  @usertag = usertag_find
  slim :usertag_show
end

put '/usertags/:id' do
  usertag = usertag_find
  usertag.update(params[:usertag])
  redirect to("/usertags/#{usertag.id}")
end

delete '/usertags/:id' do
  usertag_find.destroy
  redirect to('/usertags')
end

get '/usertags/:id/edit' do
  @usertag = usertag_find
  slim :usertag_edit
end

get '/songtags' do #show list of songtags
  @songtags = Songtag.all
  slim :songtags
end

get '/songtag/:song/:tag' do
  @linksong = params[:song]
  @linktag = params[:tag]
  slim :songtag    
end

get '/songtags/new/:song/:tag' do
  @linksong = Song.get(params[:song])
  @linktag  = Tag.get(params[:tag])
  @stcsong = params[:song]
  @stctag = params[:tag]
  if @linksong && @linktag
     Songtag.create(song_id: @stcsong, tag_id: @stctag)  
	 redirect to("/songs/#{@linksong.id}")
  else
     redirect to("/songtags")
  end
end

delete '/songtags/:song/:tag' do
  Songtag.get(params[:song],params[:tag]).destroy
  redirect to('/songtags')
end