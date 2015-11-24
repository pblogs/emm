class LikesController < ApiController
  load_resource through: :current_user, except: :index

  def create
    @like.save
    render_resource_or_errors @like
  end

  def destroy
    @like.destroy

    render nothing: true
  end

  private

  def create_params
    params.require(:resource).permit(:type, :id).tap do |data|
      unless Like::TARGETS.include? data[:type]
        raise ::ParamError::NotAcceptableValue.new(:type, data[:type], Like::TARGETS)
      end

      data[:target_type] = data.delete(:type).camelize
      data[:target_id] = data.delete(:id)
    end
  end
end
