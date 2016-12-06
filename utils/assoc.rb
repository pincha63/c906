require './utils/init-db'

@songs     = Song.all
@tags      = Tag.all
@users     = User.all
@usertags  = Usertag.all
@songtags  = Songtag.all

@songs.each do |s|
   puts "song name is " + s.title
end

puts "\n\n****** Users via usertags to tags then via songtags to songs"

@users.each do |u|
  puts "** " + u.username 
  u.tags.each do |aTag|
    puts "=== " + aTag.tagname
    aTag.songs.each do |aSong|  
      puts "::::: " + aSong.title
    end
  end
end

puts "\n\n****** Songs via songtags to tags then via usertags to users"

@songs.each do |s|
  puts "** " + s.title 
  s.tags.each do |aTag|
	 puts "=== " + aTag.tagname
	 aTag.users.each do |myUser|
	   puts myUser.id.to_s.ljust(4) + ": " + myUser.username
	 end
  end
end
puts "****** Done"






