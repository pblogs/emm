namespace :images do

  desc 'Recreate image versions for all models'
  # rake images:recreate
  task recreate: :environment do
    {User: [:avatar, :background], Album: [:cover], Photo: [:image], Video: [:preview]}.each do |model, fields|
      recreate_versions(model.to_s.constantize, fields)
    end
  end

  desc 'Recreate image versions for single uploader in one model'
  # rake images:recreate_one[User,avatar]
  task :recreate_one, [:model, :field] => :environment do |task, args|
    raise Exception, 'model and field arguments are required' unless args.model && args.field
    recreate_versions(args.model.constantize, [args.field])
  end

  private

  def recreate_versions(model, fields)
    model.find_each do |record|
      puts "Recreating #{model.name} ##{record.id} #{fields}"
      fields.each { |field| record.send(field).recreate_versions! if record.send(field).present? }
      record.save!
    end
  end
end
