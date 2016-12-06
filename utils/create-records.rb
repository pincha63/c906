require './init-db'

Song.each do |aSong|
    songStr = "Song.create(title: \"#{aSong.title}\", videoref: \"#{aSong.videoref}\", "
    songStr += "artist: \"#{aSong.artist}\", length: #{aSong.length}, "
puts songStr
end

Tag.each do |aTag|
    tagStr = "Tag.create(tagname: \"#{aTag.tagname}\", current: \"#{aTag.current}\", song_id: #{aTag.song_id})"
puts tagStr
end
		 
User.each do |aUser|
    userStr = "User.create(username: \"#{aUser.username}\", useravatar: \"#{aUser.useravatar}\")"
puts userStr
end
			
Usertag.each do |aUT|
    usertagStr = "Usertag.create(validated: \"#{aUT.validated}\", user_id: #{aUT.user_id}, tag_id: #{aUT.tag_id})"	
puts usertagStr
end


