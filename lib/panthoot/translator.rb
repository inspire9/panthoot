class Panthoot::Translator
  DATA_CLASSES = {
    'subscribe'   => Panthoot::Data::Subscription,
    'unsubscribe' => Panthoot::Data::Unsubscription,
    'profile'     => Panthoot::Data::Profile,
    'upemail'     => Panthoot::Data::EmailAddressChange,
    'cleaned'     => Panthoot::Data::CleanedEmail,
    'campaign'    => Panthoot::Data::CampaignSendingStatus
  }

  LISTENER_METHODS = {
    'subscribe' => 'subscribe',      'unsubscribe' => 'unsubscribe',
    'profile'   => 'profile_update', 'upemail'     => 'email_address_change',
    'cleaned'   => 'email_cleaned',  'campaign'    => 'campaign_sending_status'
  }

  def self.translate!(params)
    new(params).translate!
  end

  def initialize(params)
    @params = params
  end

  def translate!
    key = LISTENER_METHODS[type]
    ActiveSupport::Notifications.instrument "#{key}.panthoot",
      key.to_sym => translated_object, :fired_at => fired_at
  end

  private

  attr_reader :params

  def translated_object
    DATA_CLASSES[type].new data
  end

  def data
    params['data']
  end

  def fired_at
    Time.zone.parse params['fired_at']
  end

  def type
    params['type']
  end
end
