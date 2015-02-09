#Contains a list of all the results and metrics of of the movie prediction.
class MovieTest
	#Constructs a MovieTest object
	def initialize(result_list)
		#@result_list contains an array of strings, where each string is a user, movie, rating, and predicted rating concatenated together.
		@result_list = result_list
		#@difference_list is the list of every difference between a rating and its corresponding prediction.
		@difference_list = @result_list.map{|user, movie, rating, prediction| (rating.to_f - prediction.to_f).abs}
		@sample_length = @difference_list.length
	end
	
	#returns the average prediction error
	def mean
		prediction_number = @sample_length
		error_total = @difference_list.reduce{|total, difference| total + difference}
		error_total / prediction_number
	end
	
	#returns the standard deviation of the error
	def stddev
		difference_mean = mean
		#deviation_sum = the sum of all the differences between the mean and a rating-prediction difference
		deviation_sum = 0
		@difference_list.each do |difference|
			deviation_sum += (difference - difference_mean) ** 2
		end
		#variance
		variance = deviation_sum/@sample_length
		#standard deviation
		Math.sqrt(variance)
	end
	
	#returns the root mean square error of the prediction
	def rms
		error_sum = 0
		#This loop finds the total of the squares of the difference between ratings and predicted ratings
		@difference_list.each do |difference|
			error_sum += (difference) ** 2
		end
		#mean square error
		mean_square_error = error_sum / @sample_length
		#root mean square error
		Math.sqrt(mean_square_error)
	end
	
	#returns an array of the predictions in the form [user,movie,rating,prediction].
	def to_a
		return @result_list
	end
end