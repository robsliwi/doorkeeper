module Doorkeeper
  class ApplicationsController < Doorkeeper::ApplicationController
    #layout 'doorkeeper/admin'
    layout nil

    before_action :authenticate_admin!
    before_action :set_application, only: %i[show edit update destroy]

    def index
      @applications = Application.ordered_by(:created_at)
    end

    def show; end
    def layout; end

    def new
      @application = Application.new
    end

    def create
      @application = Application.new(application_params)

      if @application.save
        flash[:notice] = I18n.t(:notice, scope: %i[doorkeeper flash applications create])
        redirect_to oauth_application_url(@application)
      else
        render :new
      end
    end

    def edit; end

    def update
      if @application.update_attributes(application_params)
        flash[:notice] = I18n.t(:notice, scope: %i[doorkeeper flash applications update])
        redirect_to oauth_application_url(@application)
      else
        render :edit
      end
    end

    def destroy
      flash[:notice] = I18n.t(:notice, scope: %i[doorkeeper flash applications destroy]) if @application.destroy
      redirect_to oauth_applications_url
    end

    private

    def set_application
      @application = Application.find(params[:id])
    end

    def application_params
      params.require(:doorkeeper_application).
        permit(:name, :redirect_uri, :scopes, :confidential)
    end
  end
end
