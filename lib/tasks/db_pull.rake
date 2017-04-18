require 'rake'

namespace :db do
  desc 'Pull production db to development'

  task :pull do
    # dumpfile = "#{Rails.root}/tmp/latest.dump"
    puts 'PG_DUMP on production database...'
    # production = Rails.application.config.database_configuration['production']
    system "ssh deploy@138.68.139.152 'cd one_maths; pg_dump -F c -v -U deploy one_maths_production -f current_data.psql'"
    system "scp deploy@138.68.139.152:one_maths/current_data.psql ."
    puts 'Done!'
  end

  # task :restore do
  #   dev = Rails.application.config.database_configuration['development']
  #   dumpfile = "#{Rails.root}/tmp/latest.dump"
  #   puts 'PG_RESTORE on development database...'
  #   system "pg_restore --verbose --clean --no-acl --no-owner -h 127.0.0.1 -U #{dev['username']} -d #{dev['database']} #{dumpfile}"
  #   puts 'Done!'
  # end
end
