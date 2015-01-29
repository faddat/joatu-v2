class ProfilesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_profile, only: [:edit, :update, :destroy]

  respond_to :html

  def index
    @profiles = ProfileRepo.all_for_user(authenticated_user, params[:page])
    respond_with(@profiles)
  end

  def show
    @profile = ProfileRepo.find_with_offers(params[:id], params[:offers_page])
    authorize @profile
    respond_with(@profile)
  end

  def new
    @form = ProfileForm.new(Profile.new)
    authorize @form.model
    respond_with(@profile = @form)
  end

  def edit
    authorize @profile
  end

  def create
    @form = ProfileForm.new(Profile.new(user: authenticated_user))
    if @form.validate(params[:profile])
      authorize @form.model
      @form.save
    end
    respond_with(@profile = @form)
  end

  def update
    @form = ProfileForm.new(@profile)
    if @form.validate(params[:profile])
      authorize @form.model
      @form.save
    end
    respond_with(@profile = @form)
  end

  def destroy
    authorize @profile
    @profile.delete
    respond_with(@profile)
  end

  private

  def set_profile
    @profile = ProfileRepo.find(params[:id])
  end
end
