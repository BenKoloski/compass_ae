Rails.application.config.erp_tech_svcs.configure do |config|
  config.file_storage = :filesystem # Can be either :s3 or :filesystem
  config.installation_domain = 'benkoloski.mycompassagile.com'
  config.file_protocol = 'https'
  config.email_notifications_from = 'noreply@mycompassagile.com'
end
Rails.application.config.erp_tech_svcs.configure!

