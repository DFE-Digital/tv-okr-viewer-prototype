namespace :roadmap do
  desc "Backfill Workstreams and Key Result Workstream lanes from existing activities"
  task backfill_workstreams: :environment do
    colours = {
      "Development" => "#1d70b8",
      "Marketing" => "#912b88",
      "Performance Analysis" => "#00703c",
      "Policy" => "#d4351c",
      "Product & BA" => "#f47738",
      "Service & Content Design" => "#4c2c92",
      "User Research" => "#28a197"
    }

    ActiveRecord::Base.transaction do
      Activity.includes(:key_result).find_each do |activity|
        workstream = Workstream.find_or_create_by!(title: activity.workstream) do |record|
          record.colour = colours.fetch(activity.workstream, "#738096")
          record.position = Workstream.count + 1
          record.active = true
        end

        lane = KeyResultWorkstream.find_or_create_by!(
          key_result: activity.key_result,
          workstream: workstream
        ) do |record|
          record.position = activity.key_result.key_result_workstreams.count + 1
        end

        activity.update!(key_result_workstream: lane)
      end

      puts "Backfill complete:"
      puts "  #{Workstream.count} workstreams"
      puts "  #{KeyResultWorkstream.count} workstream lanes"
      puts "  #{Activity.where.not(key_result_workstream_id: nil).count} linked activities"
    end
  end
end
