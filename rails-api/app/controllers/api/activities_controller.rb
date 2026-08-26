module Api
  class ActivitiesController < ApplicationController
    skip_forgery_protection

    def index
      activities = Activity.includes(key_result: :objective).order(:id)
      render json: activities.map { |activity| activity_json(activity) }
    end

    def create
      key_result = resolve_key_result

      activity = Activity.new(activity_attributes.merge(key_result: key_result))

      if activity.save
        render json: activity_json(activity), status: :created
      else
        render json: { errors: activity.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      activity = Activity.find(params[:id])
      key_result = resolve_key_result

      if activity.update(activity_attributes.merge(key_result: key_result))
        render json: activity_json(activity)
      else
        render json: { errors: activity.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      activity = Activity.find(params[:id])
      activity.destroy!
      head :no_content
    end

    private

    def resolve_key_result
      if params[:keyResultId].present?
        return KeyResult.find(params[:keyResultId])
      end

      objective = Objective.find_or_create_by!(title: params.require(:objective))
      objective.key_results.find_or_create_by!(title: params.require(:keyResult))
    end

    def activity_attributes
      {
        workstream: params.require(:workstream),
        activity: params.require(:activity),
        start_sprint: params[:startSprint].presence,
        end_sprint: params[:endSprint].presence,
        status: params[:status].presence || "Not started",
        delivery_link: params[:deliveryLink].presence,
        depends_on: params[:dependsOn].presence,
        schedule_basis: params[:scheduleBasis].presence
      }
    end

    def activity_json(activity)
      {
        id: activity.id,
        objective: activity.key_result.objective.title,
        objectiveId: activity.key_result.objective_id,
        keyResult: activity.key_result.title,
        keyResultId: activity.key_result_id,
        workstream: activity.workstream,
        activity: activity.activity,
        startSprint: activity.start_sprint,
        endSprint: activity.end_sprint,
        durationSprints: activity.start_sprint && activity.end_sprint ?
          activity.end_sprint - activity.start_sprint + 1 : nil,
        status: activity.status,
        deliveryLink: activity.delivery_link,
        dependsOn: activity.depends_on,
        scheduleBasis: activity.schedule_basis
      }
    end
  end
end
