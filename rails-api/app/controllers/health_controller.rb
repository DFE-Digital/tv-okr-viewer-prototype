class HealthController < ApplicationController
  def live
    render json: { status: "ok" }
  end

  def ready
    ActiveRecord::Base.connection.execute("SELECT 1")
    render json: { status: "ok" }
  rescue StandardError => e
    Rails.logger.error("Readiness check failed: #{e.message}")
    render json: { status: "not ready" }, status: :service_unavailable
  end
end
