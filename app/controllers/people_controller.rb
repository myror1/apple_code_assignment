class PeopleController < ApplicationController
  before_action :set_person, only: [:show, :edit, :update, :destroy]

  # GET /people
  # GET /people.json
  def index
    @people = Person.all
  end

  # GET /people/1
  # GET /people/1.json
  def show
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/1/edit
  def edit
  end

  # POST /people
  # POST /people.json
  def create
	@person = Person.new(person_params)

	slug = "ABC123#{Time.now.to_i.to_s}1239827#{rand(10000)}"
	@person.slug = slug
	@person.admin = false

	team = (Person.count + 1).odd? ? "UnicornRainbows":"LaserScorpions"
	handle = team=="UnicornRainbows" ? "UnicornRainbows"+(Person.count + 1).to_s : "LaserScorpions" + (Person.count + 1).to_s
	@person.handle = handle
	@person.team = team


	if @person.save
		Emails.validate_email(@person).deliver
		@admins = Person.where(:admin => true)
		Emails.admin_new_user(@admins, @person).deliver unless @admins.nil?
		redirect_to @person, :notice => "Account added!"
	else
		render :new
	end
  end

  # PATCH/PUT /people/1
  # PATCH/PUT /people/1.json
  def update
    respond_to do |format|
      if @person.update(person_params)
        format.html { redirect_to @person, notice: 'Person was successfully updated.' }
        format.json { render :show, status: :ok, location: @person }
      else
        format.html { render :edit }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.json
  def destroy
    @person.destroy
    respond_to do |format|
      format.html { redirect_to people_url, notice: 'Person was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
def validateEmail
	@user = Person.find_by_slug(params[:slug])
	if @user.present?
		@user.update(:validated => true)
		Rails.logger.info "USER: User ##{@user.id} validated email successfully."
		@admins = Person.where(:admin => true)
		Emails.admin_user_validated(@admins, @user)
		Emails.welcome(@user).deliver
		redirect_to @user, :notice => "Email Verified"
	end
end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def person_params
      params.require(:person).permit(:first_name, :last_name, :email, :admin, :slug, :validated, :handle, :team)
    end
end
