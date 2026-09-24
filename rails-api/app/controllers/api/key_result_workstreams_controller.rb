module Api
  class KeyResultWorkstreamsController < ApplicationController
    skip_forgery_protection

    def create
      lane = KeyResultWorkstream.new(lane_params)

      if lane.save
        render json: lane_json(lane), status: :created
      else
        render json: { errors: lane.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      lane = KeyResultWorkstream.find(params[:id])
      lane.destroy!
      head :no_content
    end

    private

    def lane_params
      params.permit(:key_result_id, :workstream_id, :position)
    end

    def lane_json(lane)
      {
        id: lane.id,
        keyResultId: lane.key_result_id,
        workstreamId: lane.workstream_id,
        title: lane.workstream.title,
        colour: lane.workstream.colour,
        position: lane.position,
        activityCount: lane.activities.count
      }
    end
  end
end
