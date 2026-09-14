module Api
  class ObjectivesController < ApplicationController
    skip_forgery_protection

    def index
  objectives = Objective
    .includes(key_results: { key_result_workstreams: :workstream })
    .order(:position, :id)

  render json: objectives.map { |objective|
    {
      id: objective.id,
      title: objective.title,
      position: objective.position,
      active: objective.active,
      keyResults: objective.key_results
        .sort_by { |kr| [kr.position, kr.id] }
        .map { |kr|
          {
            id: kr.id,
            title: kr.title,
            position: kr.position,
            active: kr.active,
            workstreams: kr.key_result_workstreams
              .sort_by { |lane| [lane.position, lane.id] }
              .map { |lane|
                {
                  id: lane.id,
                  workstreamId: lane.workstream_id,
                  title: lane.workstream.title,
                  colour: lane.workstream.colour,
                  position: lane.position,
                  activityCount: lane.activities.count
                }
              }
          }
        }
    }
  }
end

    def create
  objective = Objective.new(objective_params)

  if objective.position.blank? || objective.position.zero?
    objective.position = (Objective.maximum(:position) || 0) + 1
  end

  if objective.save
    render json: objective, status: :created
  else
    render json: { errors: objective.errors.full_messages }, status: :unprocessable_entity
  end
end

    def update
      objective = Objective.find(params[:id])

      if objective.update(objective_params)
        render json: objective
      else
        render json: { errors: objective.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      Objective.find(params[:id]).destroy!
      head :no_content
    end

    private

    def objective_params
      params.permit(:title, :position, :active)
    end
  end
end
