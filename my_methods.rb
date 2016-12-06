helpers do
  def create_youtube(vref)
    refshort = "<iframe width=\"560\" height=\"315\" src=\""
	refpre = "<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/"
	refpost = "\" frameborder=\"0\" allowfullscreen></iframe>" 
	if vref.length < 15
		refpre + vref + refpost
	elsif vref.length < 48
		refshort + vref + refpost
	else
		vref
    end
  end
  
  def songUsers(mySong)
    collectUsers=[]
	mySong.tags.each do |aTag|
	    aTag.usertags.each do |myUT|   
			myUser = User.get(myUT.user_id)
	        collectUsers.push(myUser)
		end
	end
	userList= ""
	collectUsers.uniq.sort_by{|u| u.username.capitalize}.each do |myU|
        userList += "<a href=\"/users/" + myU.id.to_s + "\">" + myU.username + "</a>, " 
	end
	userList.length > 3 ? userList.chop.chop : "No user... yet"
  end  
end