module Api
  class KeyResultsController < ApplicationController
    skip_forgery_protection

    def index
      key_results = KeyResult.includes(:objective).order(:objective_id, :position, :id)

      render json: key_results.map { |key_result|
        {
          id: key_result.id,
          objectiveId: key_result.objective_id,
          objective: key_result.objective.title,
          title: key_result.title,
          position: key_result.position,
          active: key_result.active
        }
      }
    end

 def create
  key_result = KeyResult.new(key_result_params)

  if key_result.position.blank? || key_result.position.zero?
    key_result.position =
      (KeyResult.where(objective_id: key_result.objective_id).maximum(:position) || 0) + 1
  end

  if key_result.save
    Workstream.find_each do |workstream|
      KeyResultWorkstream.find_or_create_by!(
        key_result: key_result,
        workstream: workstream
      )
    end

    render json: key_result, status: :created
  else
    render json: { errors: key_result.errors.full_messages }, status: :unprocessable_entity
  end
end

    def update
      key_result = KeyResult.find(params[:id])

      if key_result.update(key_result_params)
        render json: key_result
      else
        render json: { errors: key_result.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      KeyResult.find(params[:id]).destroy!
      head :no_content
    end

    private

    def key_result_params
      params.permit(:objective_id, :title, :position, :active)
    end
  end
end
