ActionMailer::Base.smtp_settings = {
    :address   => 'smtp.mandrillapp.com',
    :port      => 587,
    :enable_starttls_auto => true,
    :user_name => 'rholmes@truenorthtechnology.com',
    :password  => '3VmED6Nh5PrKjzNYaHyb5g',
    :authentication => 'login',
    :domain => 'truenorthtechnology.com',
}

