module TestHelper::Email
  def last_email
    ActionMailer::Base.deliveries.last
  end

  def emails
    ActionMailer::Base.deliveries
  end

  def clear_emails
    ActionMailer::Base.deliveries.clear
  end

  def sent_email_count
    ActionMailer::Base.deliveries.count
  end

  def setup_email
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries.clear
  end
end