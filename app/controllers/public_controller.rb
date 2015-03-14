class PublicController < ApplicationController
  layout "public"
  skip_before_action :authorize!
end
