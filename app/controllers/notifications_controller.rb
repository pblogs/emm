class NotificationsController < ApplicationController
  load_and_authorize_resource

  def index
    notifications = @notifications.includes(:content).page(params[:page]).per(params[:per_page])
    Notification.preload(notifications)
    render_resources(notifications.includes(:content), notifications: true)
  end

  def update
    @notification.update(notification_params)
    render_resource_or_errors(@notification)
  end

  def mass_update
    current_user.notifications.not_viewed.update_all(viewed: true)
    render nothing: true
  end

  private

  def notification_params
    params.require(:resource).permit(:viewed)
  end
end
