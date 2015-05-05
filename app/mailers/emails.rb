class Emails < ActionMailer::Base
  default from: "from@example.com"
	def common_methd(person)
		@person = person
		mail to: @person, from: 'foo@example.com'
	end
	def admin_common_method(admins, user)
		@admins = admins.collect {|a| a.email } rescue []
		@user = user
		mail to: @admins, from: 'foo@example.com'
	end

	def validate_email(person)
		common_methd(person)
	end
	
	
	def admin_new_user(admins, users)
		admin_common_method(admins, users)
	end

	def admin_removing_unvalidated_users(admins, users)
		admin_common_method(admins, users)
	end
	def welcome(person)
		common_methd(person)
        end
	
	def admin_user_validated(admins, user)
		admin_common_method(admins, user)
	end
end
