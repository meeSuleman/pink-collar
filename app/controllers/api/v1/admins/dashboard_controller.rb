module Api
  module V1
    module Admins
      class DashboardController < ApplicationController
        before_action :authenticate_admin!

        def index
          # Add dashboard logic here
        end

        def admins_list
          @admins = Admin.all
          success_response("Fetched admins successfully", @admins)
        end

        def show_admin
          @admin = Admin.find(params[:id])
          success_response("Fetched admin successfully", @admin)
        end
      end
    end
  end
end
