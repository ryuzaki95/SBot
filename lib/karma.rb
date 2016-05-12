class Karma    
	def initialize
		@karma_list = {}
		@user_list = []
	end

	def exist_user(user_name)
		if @user_list.include?(user_name)
			true
		else
			false
		end
	end

	def add_karma_to(user_name,karma)
		if self.exist_user(user_name)
			if @karma_list[user_name] == nil
				@karma_list[user_name] = karma
			else
				@karma_list[user_name] += karma
			end
		else
			@karma_list[user_name] = karma
			@user_list << user_name
		end
	end

	def show_karma_of(user_name)
		if self.exist_user(user_name)
			@karma_list[user_name]
		end
	end

	def show_karma_list
		@karma_list
	end

	def debug
		puts @karma_list 
		puts @user_list 
	end
end
