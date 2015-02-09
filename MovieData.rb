require './MovieTest.rb'
require './DataLoad.rb'
#Contains information about the base/test sets.
class MovieData

	#Constructs a MovieData object
	#The first parameter refers to the folder containing the movie data.
	#The second parameter refers to the particular base/test set pair that should be read
	def initialize(folder,reference = nil)
		@base_name = "#{reference}.base" unless reference.nil?
		@test_name = "#{reference}.test" unless reference.nil?
		#the default value for the base set is u.data
		@base_name ||= "u.data"
		#The default value for the test set is an empty set
		@test_name ||= ""
		#These hashes will contain data extracted from the base/test set pairs
		puts "Loading #{@base_name}..."
		@usermovie_rating = DataLoad.load_usermovie_rating(folder, @base_name)
		@movie_user = DataLoad.load_movie_user(folder, @base_name)
		puts "#{@base_name} loaded."
		puts ""
		
		@usermovie_rating_test = Hash.new
		@movie_user_test = Hash.new
		#If test_name is an empty string, then there is no data to load.
		if @test_name != ""
			puts "Loading #{@test_name}..."
			@usermovie_rating_test = DataLoad.load_usermovie_rating(folder, @test_name)
			@movie_user_test = DataLoad.load_movie_user(folder, @test_name)
			puts "#{@test_name} loaded."
			puts ""
		end
	end
	
	#returns the rating that user gave movie in the training set, 
	#and 0 if user did not rate movie
	def rating(user, movie)
		score = @usermovie_rating["#{user} #{movie}"]
		if score != nil
			return score
		end
		return 0
	end
	
	#returns the array of movies that user has watched
	def movies(user)
		movie_array = Array.new
		#user_movie_pairs is an array of the concatenated strings that represent all user/movie pairs 
		#in the original data
		user_movie_pairs = @usermovie_rating.keys
		user_movie_pairs.each do |user_in_data|
			#the concatenated strings are split up and saved as user_movie_array, an array with two string values, 
			#the first being a user and the second being the corresponding movie.
			user_movie_array = user_in_data.split(' ')
			#Any users in user_movie_pairs that match the parameter user have their corresponding movie added to movie_array
			if user_movie_array[0] == user
				movie_array.push(user_movie_array[1])
			end
		end
		#movie_array now contains all the movies that user has watched
		return movie_array
	end
	
	#returns the array of users that have seen movie m
	def viewers(movie)
		viewer_list = @movie_user[movie]
	end
	
	#returns a floating point number between 1.0 and 5.0 as an estimate 
	#of what user would rate movie
	def predict(user, movie)
		other_users = viewers(movie)
		ratings_combined = 0.0
		#2.5 is a default value in case there is no other data to base the rating off of.
		if other_users == nil
			return 2.5
		end
		rating_count = other_users.length
		other_users.each do |other_user|
			ratings_combined += rating(other_user, movie).to_f
		end
		#The algorithm sets the prediction equal to the average of all other ratings for the movie.
		return ratings_combined / rating_count
	end
	
	#runs the predict method on the first rating_num ratings in the test set and returns a 
	#MovieTest object containing the results.
	#Can possibly take no input and will then run a test on all the ratings in the set.
	def run_test(rating_num = @usermovie_rating_test.length)
		#Confirms that the requested number of predictions is not more than the total number of ratings
		#in the test set. If not, then the method is run again on all the ratings.
		if rating_num > @usermovie_rating_test.length	
			puts "Error: Test Set is too small."
			rating_num = @usermovie_rating_test.length
		end
		#user_movie_pairs is an array of the concatenated strings that represent all user/movie pairs 
		#in the original test set
		user_movie_pairs = @usermovie_rating_test.keys
		#user_movie_arrays contains an array for each string element in user_movie_pairs
		#each first element in each array is the user and each second is the movie
		user_movie_arrays = user_movie_pairs.map{|pair| pair.split(' ')}
		#users and movies contain a list of (respectively) all users and all movies from the original test set, in order.
		users = user_movie_arrays.map{|pair_array| pair_array[0]}
		movies = user_movie_arrays.map{|pair_array| pair_array[1]}
		result_list = []
		#result_list = users.map[]
		#usermovie_id corresponds to the usermovie_idth element of user_movie_pairs
		(0...rating_num).each do |usermovie_id|
			score_key = user_movie_pairs[usermovie_id]
			#user_movie_array is an array element in user_movie_arrays
			score = @usermovie_rating_test[score_key]
			user = users[usermovie_id]
			movie = movies[usermovie_id]
			result_list.push([user, movie, score, predict(user, movie)])
		end
		return MovieTest.new(result_list)
	end
end

#Debugging code:
#z = MovieData.new("ml-100k")
#y = MovieData.new('ml-100k',:u1)
#tester = y.run_test(500)
#y.run_test
#v = MovieData.new('ml-100k',:u2) 
#x = MovieData.new('ml-100k',:ua) 
#puts c = Random.rand(1...100).to_s
#puts d = Random.rand(1...100).to_s
#puts z.rating(c, d)
#puts z.viewers("1")
#puts "\n\n\n\n"
#puts y.viewers("56")
#y.movies("1")
#puts z.predict("1", "76")
