class NotificationsController < ApiController
  load_and_authorize_resource

  def index
    notifications = @notifications.includes(:content).order(viewed: :asc).order(created_at: :desc).page(params[:page]).per(params[:per_page])
    Notification.preload(notifications)
    render_resources(notifications, notifications: true)
  end

  def update
    @notification.update(notification_params)
    render_resource_or_errors(@notification)
  end

  def mass_update
    current_user.notifications.not_viewed.update_all(viewed: true)
    current_user.refresh_unread_notifications_count
    render nothing: true
  end

  def unread_count
    render json: { new_notifications: current_user.unread_notifications_count }
  end

  private

  def notification_params
    params.require(:resource).permit(:viewed)
  end
end
