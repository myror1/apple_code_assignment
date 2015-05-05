namespace :accounts do
	desc "Remove accounts where the email was never validated and it is over 30 days old"
	task remove_unvalidated: :environment do
		@people = Person.where('created_at < ?', Time.now - 30.days).where(:validated => false)
		@people.each do |person|
			Rails.logger.info "Removing unvalidated user #{person.email}"
			person.destroy
		end
		Emails.admin_removing_unvalidated_users(Person.where(:admin => true), @people).deliver
	end
	
end

	  
