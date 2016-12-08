def create_youtube(vref)
    refshort = "<iframe width=\"560\" height=\"315\" src=\""
	refpre = "<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/"
	refpost = "\" frameborder=\"0\" allowfullscreen></iframe>" 
	if vref.length == 0
	    nil
	elsif vref.length < 15
		refpre + vref + refpost
	elsif vref.length < 48
		refshort + vref + refpost
	elsif vref.length > 47
		vref
	else
	    nil
    end
end
  
def allst
  Songtag.each do |st|
    puts st.song_id.to_s + " : " + st.tag_id.to_s
  end
end	
  
def allut
  Usertag.each do |ut|
    puts ut.user_id.to_s + " : " + ut.tag_id.to_s
  end
end	  
  
  
def dst(par)
  Songtag.each do |st|
    if st.song_id == par
	   st.destroy
    end
  end	
end 