module Api
  class WorkstreamsController < ApplicationController
    skip_forgery_protection

    def index
      workstreams = Workstream.order(:position, :id)

      render json: workstreams.map { |workstream|
        {
          id: workstream.id,
          title: workstream.title,
          colour: workstream.colour,
          position: workstream.position,
          active: workstream.active
        }
      }
    end

    def create
      workstream = Workstream.new(workstream_params)

      if workstream.save
        render json: workstream, status: :created
      else
        render json: { errors: workstream.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      workstream = Workstream.find(params[:id])

      if workstream.update(workstream_params)
        render json: workstream
      else
        render json: { errors: workstream.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      workstream = Workstream.find(params[:id])

      if workstream.destroy
        head :no_content
      else
        render json: { errors: workstream.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def workstream_params
      params.permit(:title, :colour, :position, :active)
    end
  end
end
