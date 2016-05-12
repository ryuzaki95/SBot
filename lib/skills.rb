#
# Skills module for sbot
#
module Skills
class Skills
	def initialize
		@user_skills_list = {}
		@skills_list = []
	end

	def debug
		puts @user_skills_list 
		puts @skills_list 
	end

	def exist(user_name) 
		if @user_skills_list.keys.include?(user_name)
			true
		else
			false
		end
	end

	def add_skills_to(user_name,skills_name)
		#when user does not exist
		if not @skills_list.include?(skills_name)
			@skills_list << skills_name
		end

		if self.exist(user_name)
			if not @user_skills_list[user_name].include?(skills_name)
				@user_skills_list[user_name] << skills_name
			else 
				-1
			end

		else 
			@user_skills_list[user_name] = []
			@user_skills_list[user_name] << skills_name
		end
	end

	def remove_skills_from(user_name,skills_name)
		if not @skills_list.include?(skills_name)
			-1 #skills do not exist 
		end

		if self.exist(user_name)
			-2 #user_name does not exist		 
		end

		#keep skills in skills_list
		@user_skills_list[user_name] -= [skills_name]
	end

	def list_users_who_have_skills(skills_name)
		if not @skills_list.include?(skills_name)
			-1 #skills do not exist
		else 
			return_l = [] #return list 
			@user_skills_list.each do |i,j|
				if j.include?(skills_name)
					return_l << i
				end
			end
		end
		return_l
	end

	def list_skills_of_user(user_name)
		if self.exist(user_name)
			@user_skills_list[user_name]
		else 
			-1 #user_name does not exist
		end
	end
end

end

