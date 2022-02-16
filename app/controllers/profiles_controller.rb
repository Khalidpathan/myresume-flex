class ProfilesController < ApplicationController
    include HomeHelper
    include ProfilesHelper

  def show
    @profile = Profile.find_by_id(params[:id])
    respond_to do |format|
      format.html do
         render :template => "shared/profile/guestpreview" , locals: {profile: @profile}
     end
      format.pdf do
        render pdf: "#{User.find(@profile.user_id).email}.resume"  , template: "shared/profile/_preview.html.erb" , locals: {profile: @profile}
      end
    end
  end

    def preview
           render :template => "shared/profile/userpreview" , locals: { profile: current_user.profile}
    end
    def create
        @profile = Profile.new(profile_params)
        if @profile.save
        else
            render 'new'
    end
end

    def update
        updated_profile_params = update_array_attributes_in_params(profile_params)
        @profile = Profile.find(params[:id])
        @profile.avatar.purge_later
        @profile.avatar.attach(params[:avatar])
        if @profile.update(updated_profile_params)
            flash[:success] = "Profile updated successfully."
            redirect_to preview_url
        else
            flash[:danger] = "Profile update failed."
            redirect_to root_url
        end
    end

    def correct_user
        @profile = Profile.find(params[:id])
        @user = User.find(@profile.user_id)
        redirect_to(root_url) unless @user == current_user
    end

    private
        def profile_params
            params.require(:profile).permit(:name, :avatar ,:job_title, :total_experience, :overview, :career_highlights, :primary_skills, :secondary_skills,
                educations_attributes: [ :id, :school, :degree, :description, :start, :end, :_destroy],
                experiences_attributes: [:id, :company, :position, :start_date, :end_date, :description, :_destroy, {projects_attributes: %i[id title url tech_stack description _destroy]}])
        end
end
