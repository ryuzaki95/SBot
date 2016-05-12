#!/usr/bin/ruby

require 'telegram_bot'
require './lib/skills.rb'
require './lib/karma.rb'

#for karma saving
kx = Karma.new()
#For skills saving
usr_x = Skills::Skills.new()

bot = TelegramBot.new(token: <YOUR TOKEN HERE>) #'201290882:AAG9urFzADJ1ymySBkiRfG2uvvAu9XkbLY')
bot.get_updates(fail_silently: true) do |message|
	puts "@#{message.from.username}: #{message.text}"
	command = message.get_command_for(bot)

	message.reply do |reply|
		if command == nil 
			reply.text = "try another command, see /help"
		elsif 
			cmd_x = command.split(" ")
		end

		case cmd_x[0]

		when '/help'
			reply.text = "SBot, ver 0.1!
						  SYNOPSIS: /command [options] [args]\n
						  * List all skills of @Someone
							/skills -l @Someone
						  * List all people who have #ThiSkills
							/skills -l #ThisSkills 
						  * Add #ThisSkills to @Someone 
							/skills -a @Someone #ThisSkills
						  * Remove #ThisSkills from @Someone 
							/skills -r @Someone #ThisSkills 
						  * Add X karma(s) to @Someone
							/give @Someone X
						  * Show karma of @Someone
							/give @Someone 
						  * Show karma list 
							/give list 
						  * Show this help
							/help"
		# handle karma /give command
		when '/give'
			if cmd_x.size == 1
				reply.text = "/give @Someone <karma>"
			elsif cmd_x.size == 2
				if cmd_x[1] == "list" #chua co tinh nang sort, de implement sau :))
					karma_l = kx.show_karma_list

					if karma_l == [] or karma_l == nil 
						reply.text = "any?"
					else 
						t_out = "Karma list:\n"

						karma_l.each do |i,j|
							t_out << i << " : " << j.to_s << "\n"
						end

						reply.text = t_out 
					end
				elsif cmd_x[1][0] == '@' #show karma of user
					if not kx.exist_user(cmd_x[1]) 
						reply.text = "user does not exist"
					else 
						karma_r = kx.show_karma_of(cmd_x[1])
						reply.text = "#{cmd_x[1]}: #{karma_r}"
					end
				else 
					reply.text = "syntax error, see /help"
				end

			elsif cmd_x.size == 3
				if cmd_x[1][0] != '@' or cmd_x[2].to_i < -5 or cmd_x[2].to_i > 5
					reply.text = "syntax error, see /help"
				else 
					q_user = cmd_x[1]
					q_karma = cmd_x[2].to_i
					kx.add_karma_to(q_user,q_karma)
					reply.text = "added #{q_karma} karma(s) to #{q_user}"
				end
			else
				reply.text = "syntax error, see /help"
			end
		# handle /skills command
		when '/skills'
			if cmd_x.size < 3 or cmd_x.size > 4
				reply.text = "syntax error, see /help"

			elsif cmd_x.size == 3
				if cmd_x[1] == '-l'
					if cmd_x[2][0] == '@' #query user 
						usr_x.debug
						skills_l = usr_x.list_skills_of_user(cmd_x[2]) 

						if skills_l == -1
							reply.text = "user does not exist"
 
						elsif skills_l == [] or skills_l == nil
							reply.text = "#{cmd_x[2]} doesnt have any skill, \
							add skills by /skills -a @username #skills_name"
						else
							reply.text = "#{cmd_x[2]}'s skills:\n"
							skills_l.each do |t|
								reply.text << t << "\n"
							end
						end

					elsif cmd_x[2][0] == '#' #query skills
						list_x = usr_x.list_users_who_have_skills(cmd_x[2])
						#debug
						puts list_x.class
						if list_x == -1 
							reply.text = "skills do not exist"
						elsif list_x == [] or list_x == nil
							reply.text = "any?"
						else
							reply.text = "list of users who have #{cmd_x[2]}:\n"

							list_x.each do |i|
								reply.text << i << "\n"
							end
						end
					end		 
				else 
					reply.text = "syntax error, see /help"
				end
					 
			elsif cmd_x.size == 4 
				if cmd_x[1] == '-a'
					q_user = cmd_x[2]
					q_skills = cmd_x[3]
					result = usr_x.add_skills_to(q_user,q_skills)
					
					if result == -1
						reply.text = "skills exist! done!"
					else 
						reply.text = "added #{q_skills} to #{q_user}"
						usr_x.debug
					end
				end

				if cmd_x[1] == '-r'
					q_user = cmd_x[2]
					q_skills = cmd_x[3]
					result = usr_x.remove_skills_from(q_user,q_skills)
					
					if result == -1
						reply.text = "skills do not exist!"
					elsif result == -2
						reply.text = "user does not exist!"
					else
						reply.text = "removed #{q_skills} from #{q_user}"
					end
				end
			else 
				reply.text = "syntax error, see /help"
			end
		
		#other funny stuffs 
		#todo: implement by modules for easy handling
		when '/start','/begin','/join'
			reply.text = "already!"

		when '/stop','/quit','/exit'
			reply.text = "huh?"

		when '/fuck','/shit'
			reply.text = "don't be rude!"

		when '/boobs', '/tits', '/ass', '/boob', '/porn', '/sex', '/nude'
			reply.text = "not my business!"

		when '/show', '/ahihi'
			reply.text = "..."

		when '/ping'
			if message.from.username == "lunix4"
				reply.text = "I'm ready here, my lord!"
			else
				reply.text = "pong! @#{message.from.username}" 
			end

		when '/hello','/hi','/greet'
			reply.text = "hello, @#{message.from.username}!"

		else
			reply.text = "sorry, I can't get this, see /help"

		end

		puts "sending #{reply.text.inspect} to @#{message.from.username}"
		reply.send_with(bot)
	end
end
