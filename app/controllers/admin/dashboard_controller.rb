module Admin
  class DashboardController < ApplicationController
    before_action :authenticate_admin!
    layout "admin"

    def index
      # Add dashboard logic here
    end
  end
end
