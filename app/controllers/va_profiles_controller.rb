class VaProfilesController < ApplicationController
  before_action :set_va_profile, only: %i[ show edit update destroy ]

  def index
    @va_profiles = VaProfile.all
  end

  def show
  end

  def new
    @va_profile = VaProfile.new
  end

  def edit
  end

  def create
    @va_profile = VaProfile.new(va_profile_params)

    respond_to do |format|
      if @va_profile.save
        format.html { redirect_to @va_profile, notice: "Profile saved successfully." }
        format.json { render :show, status: :created, location: @va_profile }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @va_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @va_profile.update(va_profile_params)
        format.html { redirect_to @va_profile, notice: "Profile updated successfully.", status: :see_other }
        format.json { render :show, status: :ok, location: @va_profile }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @va_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @va_profile.destroy!

    respond_to do |format|
      format.html { redirect_to va_profiles_path, notice: "Profile deleted.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def set_va_profile
    @va_profile = VaProfile.find(params.expect(:id))
  end

  def va_profile_params
    params.expect(va_profile: [ :niche, :budget ])
  end

  # Delegates recommendation logic to the ToolRecommender service object.
  # Keeps the controller thin — no business logic here.
  def recommend_tools(niche, budget)
    ToolRecommender.new(niche, budget).call
  end
  helper_method :recommend_tools
end
