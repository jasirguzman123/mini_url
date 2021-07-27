class UrlsController < ApplicationController
  before_action :set_url, only: %i[visit show]

  def create
    @url = Url.find_or_create_by(url_params)

    if @url.valid?
      render :create # not need to specify but this way is easier to understand
    else
      redirect_to request.referrer, alert: @url.errors.full_messages.join(', ')
    end
  end

  def show
    @visits = @url.visits
  end

  def new
    @url = Url.new
    @urls = Url.all
  end

  def visit
    @url.visits.create(ip_address: request.remote_ip)
    redirect_to @url.long_url
  end

  private

  def set_url
    @url = Url.find_by(token: params[:token])
    return if @url.present?

    # invalid token
    raise ActionController::RoutingError, 'Invalid token'
  end

  def url_params
    params.require(:url).permit(:long_url)
  end
end
