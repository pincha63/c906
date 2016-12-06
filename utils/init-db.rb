# this is to be run ONCE on irb to expose the class definitions
require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development903.db")

class Songtag
   include DataMapper::Resource
   belongs_to :song,   :key => true
   belongs_to :tag,   :key => true
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
#DataMapper.auto_migrate!
#DataMapper.auto_upgrade!