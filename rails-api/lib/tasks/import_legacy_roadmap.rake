require "csv"

namespace :roadmap do
  desc "Import legacy flat roadmap data into the relational Rails model"
  task import_legacy: :environment do
    csv_path = Rails.root.join("tmp", "legacy-import", "activities.csv")

    abort "Import file not found: #{csv_path}" unless File.exist?(csv_path)

    rows = CSV.read(csv_path, headers: true)

    puts "Found #{rows.length} legacy activities"

    ActiveRecord::Base.transaction do
      # Keep this import repeatable while we're developing.
      Activity.delete_all
      KeyResult.delete_all
      Objective.delete_all

      objective_positions = {}
      key_result_positions = Hash.new { |hash, key| hash[key] = {} }

      rows.each do |row|
        objective_title = row.fetch("objective")
        key_result_title = row.fetch("key_result")

        objective_positions[objective_title] ||= objective_positions.length + 1

        objective = Objective.find_or_create_by!(title: objective_title) do |record|
          record.position = objective_positions[objective_title]
          record.active = true
        end

        positions = key_result_positions[objective_title]
        positions[key_result_title] ||= positions.length + 1

        key_result = objective.key_results.find_or_create_by!(title: key_result_title) do |record|
          record.position = positions[key_result_title]
          record.active = true
        end

        Activity.create!(
          id: row.fetch("id"),
          key_result: key_result,
          workstream: row.fetch("workstream"),
          activity: row.fetch("activity"),
          start_sprint: row["start_sprint"].presence,
          end_sprint: row["end_sprint"].presence,
          status: row["status"].presence || "Not started",
          delivery_link: row["delivery_link"].presence,
          depends_on: row["depends_on"].presence,
          schedule_basis: row["schedule_basis"].presence
        )
      end

      # PostgreSQL sequences need advancing because we've preserved legacy IDs.
      max_id = Activity.maximum(:id)
      if max_id
        ActiveRecord::Base.connection.execute(
          "SELECT setval(pg_get_serial_sequence('activities', 'id'), #{max_id}, true)"
        )
      end

      puts "Imported:"
      puts "  #{Objective.count} objectives"
      puts "  #{KeyResult.count} key results"
      puts "  #{Activity.count} activities"
    end
  end
end
