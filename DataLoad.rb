#Given a movie rating file, this module loads the data from the file into appropriate hashes.
module DataLoad
	#Loads data from the given file into a hash with the pair "user movie" as the key and "rating" as the value.
	def DataLoad.load_usermovie_rating(folder, file_name)
		usermovie_rating = Hash.new
		data = File.open("#{folder}/#{file_name}")
		#The 0th element of data_line is the user. The 1st is the movie. The 2nd is the rating.
		data.each do |data_line|
			data_array = data_line.split(' ')
			user = data_array[0]
			movie = data_array[1]
			score = data_array[2]
			#usermovie_rating has the pair "user movie" as the key and "score" as the value.
			usermovie_rating["#{user} #{movie}"] = score
		end
		data.close
		return usermovie_rating
	end
	
	#Loads data from the given file into a hash, where each key is a movie and each value is an array of all the users#that have given that movie a rating.
	def DataLoad.load_movie_user(folder, file_name)
		#movie_user is a two-dimensional hash, where each key is a movie and each value is an array of all the users
		#that have given that movie a rating.
		movie_user = Hash.new
		data = File.open("#{folder}/#{file_name}")
		data.each do |data_line|
			data_array = data_line.split(' ')
			user = data_array[0]
			movie = data_array[1]
			if movie_user.has_key?(movie) == false
				movie_user[movie] = Array.new
			end
			movie_user[movie].push(user)
		end
		data.close
		return movie_user
	end
end