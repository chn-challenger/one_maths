# encoding: utf-8

# Backup v4.x Configuration
##
# Backup Generated: db_backup
# Once configured, you can run the backup with the following command:
#
# $ backup perform -t db_backup [-c <path_to_configuration_file>]
#

db_config  = YAML.load_file('/home/deploy/one_maths/config/database.yml')['production']
app_config = YAML.load_file('/etc/env.yml')['production']

Model.new(:db_backup, 'Description for db_backup') do
  ##
  # Split [Splitter]
  #
  # Split the backup file in to chunks of 250 megabytes
  # if the backup file size exceeds 250 megabytes
  #
  split_into_chunks_of 250

  ##
  # PostgreSQL [Database]
  #
  database PostgreSQL do |db|
    db.name               = db_config['database']
    db.username           = db_config['username']
    db.password           = app_config['ONE_MATHS_DATABASE_PASSWORD']
    db.host               = "localhost"
    db.additional_options = ["-F c -v"]
  end

  ##
  # Dropbox File Hosting Service [Storage]
  #
  # Access Type:
  #
  #  - :app_folder (Default)
  #  - :dropbox
  #
  # Note:
  #
  #  Initial backup must be performed manually to authorize
  #  this machine with your Dropbox account.
  #
  store_with Dropbox do |db|
    db.api_key     = app_config['DROPBOX_APP_KEY']
    db.api_secret  = app_config['DROPBOX_APP_SECRET']
    db.access_type = :dropbox
    db.path        = "/one_maths_db_backup"
    db.keep        = 10
  end

  ##
  # Gzip [Compressor]
  #
  compress_with Gzip

  ##
  # Mail [Notifier]
  #
  # The default delivery method for Mail Notifiers is 'SMTP'.
  # See the Wiki for other delivery options.
  # https://github.com/meskyanichi/backup/wiki/Notifiers
  #
  notify_by Mail do |mail|
    mail.on_success           = false
    mail.on_warning           = true
    mail.on_failure           = true

    mail.delivery_method      = :sendmail
    mail.from                 = "joezhou@onemaths.com"
    mail.to                   = "joezhou@onemaths.com"
  end

end
