post "/" do 
	
	
	params.each do |k,v|
		details = JSON.parse k
	end	
	
	if details['user'] and details['password']
		if details['user'] == "test" && details['password'] =="test"
			return "valid credentials"
		else
			return "invalid credentials"
		end
	end

end