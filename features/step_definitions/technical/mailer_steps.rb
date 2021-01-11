When(/^the mail delivery method is set to "(.*?)"$/) do |method|
  case method.to_sym
  when :smtp
    @smtp_setting.update_attributes({enabled: true})
  when :test
    @smtp_setting.update_attributes({enabled: false})
  end
end

Then(/^ActionMailer's delivery method is "(.*?)"$/) do |method|
  expect(ActionMailer::Base.delivery_method).to eq method.to_sym
end

When(/^the SMTP username is set to "(.*?)"$/) do |username|
  expect(@smtp_setting.update_attributes({username: username})).to be true
  expect(SmtpSetting.first.username).to eq username
end

When(/^the SMTP password is set to "(.*?)"$/) do |password|
  expect(@smtp_setting.update_attributes({password: password})).to be true
  expect(SmtpSetting.first.password).to eq password
end

Then(/^ActionMailer's SMTP username is "(.*?)"$/) do |username|
  expect(ActionMailer::Base.smtp_settings['user_name'.to_sym]).to eq username
end

Then(/^ActionMailer's SMTP password is "(.*?)"$/) do |password|
  expect(ActionMailer::Base.smtp_settings['password'.to_sym]).to eq password
end

Then(/^ActionMailer's SMTP username is nil$/) do
  expect(ActionMailer::Base.smtp_settings['user_name'.to_sym]).to eq nil
end

Then(/^ActionMailer's SMTP password is nil$/) do
  expect(ActionMailer::Base.smtp_settings['password'.to_sym]).to eq nil
end
