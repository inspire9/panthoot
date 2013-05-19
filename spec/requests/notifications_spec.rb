require 'spec_helper'

describe 'MailChimp Webhook Notifications' do
  let(:fired_at) { Time.zone.local(2009, 3, 26, 21, 35, 57) }

  def subscribe(type, &block)
    ActiveSupport::Notifications.subscribe type, &block
  end

  before :each do
    @lodged = false
  end

  after :each do
    ActiveSupport::Notifications.unsubscribe @subscription

    @lodged.should be_true
  end

  describe 'subscribes' do
    it "sends the listener a subscription object" do
      @subscription = subscribe('subscribe.panthoot') { |*args|
        event        = ActiveSupport::Notifications::Event.new *args
        subscription = event.payload[:subscribe]

        subscription.id.should         == '8a25ff1d98'
        subscription.list_id.should    == 'a6b5da1054'
        subscription.email.should      == 'api@mailchimp.com'
        subscription.email_type.should == 'html'
        subscription.ip_opt.should     == '10.20.10.30'
        subscription.ip_signup.should  == '10.20.10.30'
        subscription.merges.should == {
          'EMAIL' => 'api@mailchimp.com',
          'FNAME' => 'MailChimp',
          'LNAME' => 'API'
        }

        @lodged = true
      }

      post '/panthoot/hooks', 'type' => 'subscribe',
        'fired_at' => fired_at.to_s(:db), 'data[id]' => '8a25ff1d98',
        'data[list_id]' => 'a6b5da1054', 'data[email]' => 'api@mailchimp.com',
        'data[email_type]' => 'html',
        'data[merges][EMAIL]' => 'api@mailchimp.com',
        'data[merges][FNAME]' => 'MailChimp',
        'data[merges][LNAME]' => 'API', 'data[ip_opt]' => '10.20.10.30',
        'data[ip_signup]' => '10.20.10.30'
    end

    it "sends the listener the fired at timestamp" do
      @subscription = subscribe('subscribe.panthoot') { |*args|
        event = ActiveSupport::Notifications::Event.new *args
        event.payload[:fired_at].should == fired_at

        @lodged = true
      }

      post '/panthoot/hooks', 'type' => 'subscribe',
        'fired_at' => fired_at.to_s(:db), 'data[id]' => '8a25ff1d98',
        'data[list_id]' => 'a6b5da1054', 'data[email]' => 'api@mailchimp.com',
        'data[email_type]' => 'html',
        'data[merges][EMAIL]' => 'api@mailchimp.com',
        'data[merges][FNAME]' => 'MailChimp',
        'data[merges][LNAME]' => 'API', 'data[ip_opt]' => '10.20.10.30',
        'data[ip_signup]' => '10.20.10.30'
    end
  end

  describe 'unsubscribes' do
    it "sends the listener an unsubscription object" do
      @subscription = subscribe('unsubscribe.panthoot') { |*args|
        event          = ActiveSupport::Notifications::Event.new *args
        unsubscription = event.payload[:unsubscribe]

        unsubscription.action.should      == 'unsub'
        unsubscription.reason.should      == 'manual'
        unsubscription.id.should          == '8a25ff1d98'
        unsubscription.list_id.should     == 'a6b5da1054'
        unsubscription.email.should       == 'api+unsub@mailchimp.com'
        unsubscription.email_type.should  == 'html'
        unsubscription.ip_opt.should      == '10.20.10.30'
        unsubscription.campaign_id.should == 'cb398d21d2'
        unsubscription.merges.should == {
          'EMAIL'     => 'api@mailchimp.com',
          'FNAME'     => 'MailChimp',
          'LNAME'     => 'API',
          'INTERESTS' => 'Group1,Group2'
        }

        @lodged = true
      }

      post '/panthoot/hooks', 'type' => 'unsubscribe',
        'fired_at' => fired_at.to_s(:db), 'data[action]' => 'unsub',
        'data[reason]' => 'manual', 'data[id]' => '8a25ff1d98',
        'data[list_id]' => 'a6b5da1054',
        'data[email]' => 'api+unsub@mailchimp.com',
        'data[email_type]' => 'html',
        'data[merges][EMAIL]' => 'api@mailchimp.com',
        'data[merges][FNAME]' => 'MailChimp',
        'data[merges][LNAME]' => 'API',
        'data[merges][INTERESTS]' => 'Group1,Group2',
        'data[ip_opt]' => '10.20.10.30',
        'data[campaign_id]' => 'cb398d21d2'
    end

    it "sends the listener the fired at timestamp" do
      @subscription = subscribe('unsubscribe.panthoot') { |*args|
        event = ActiveSupport::Notifications::Event.new *args
        event.payload[:fired_at].should == fired_at

        @lodged = true
      }

      post '/panthoot/hooks', 'type' => 'unsubscribe',
        'fired_at' => fired_at.to_s(:db), 'data[action]' => 'unsub',
        'data[reason]' => 'manual', 'data[id]' => '8a25ff1d98',
        'data[list_id]' => 'a6b5da1054',
        'data[email]' => 'api+unsub@mailchimp.com',
        'data[email_type]' => 'html',
        'data[merges][EMAIL]' => 'api@mailchimp.com',
        'data[merges][FNAME]' => 'MailChimp',
        'data[merges][LNAME]' => 'API',
        'data[merges][INTERESTS]' => 'Group1,Group2',
        'data[ip_opt]' => '10.20.10.30',
        'data[campaign_id]' => 'cb398d21d2'
    end
  end

  describe 'profile updates' do
    it "sends the listener a profile object" do
      @subscription = subscribe('profile_update.panthoot') { |*args|
        event   = ActiveSupport::Notifications::Event.new *args
        profile = event.payload[:profile_update]

        profile.id.should          == '8a25ff1d98'
        profile.list_id.should     == 'a6b5da1054'
        profile.email.should       == 'api@mailchimp.com'
        profile.email_type.should  == 'html'
        profile.ip_opt.should      == '10.20.10.30'
        profile.merges.should == {
          'EMAIL'     => 'api@mailchimp.com',
          'FNAME'     => 'MailChimp',
          'LNAME'     => 'API',
          'INTERESTS' => 'Group1,Group2'
        }

        @lodged = true
      }

      post '/panthoot/hooks', 'type' => 'profile',
        'fired_at' => fired_at.to_s(:db), 'data[id]' => '8a25ff1d98',
        'data[list_id]' => 'a6b5da1054',
        'data[email]' => 'api@mailchimp.com',
        'data[email_type]' => 'html',
        'data[merges][EMAIL]' => 'api@mailchimp.com',
        'data[merges][FNAME]' => 'MailChimp',
        'data[merges][LNAME]' => 'API',
        'data[merges][INTERESTS]' => 'Group1,Group2',
        'data[ip_opt]' => '10.20.10.30'
    end

    it "sends the listener the fired at timestamp" do
      @subscription = subscribe('profile_update.panthoot') { |*args|
        event = ActiveSupport::Notifications::Event.new *args
        event.payload[:fired_at].should == fired_at

        @lodged = true
      }

      post '/panthoot/hooks', 'type' => 'profile',
        'fired_at' => fired_at.to_s(:db), 'data[id]' => '8a25ff1d98',
        'data[list_id]' => 'a6b5da1054',
        'data[email]' => 'api@mailchimp.com',
        'data[email_type]' => 'html',
        'data[merges][EMAIL]' => 'api@mailchimp.com',
        'data[merges][FNAME]' => 'MailChimp',
        'data[merges][LNAME]' => 'API',
        'data[merges][INTERESTS]' => 'Group1,Group2',
        'data[ip_opt]' => '10.20.10.30'
    end
  end

  describe 'email address changes' do
    it "sends the listener an email address change object" do
      @subscription = subscribe('email_address_change.panthoot') { |*args|
        event        = ActiveSupport::Notifications::Event.new *args
        email_change = event.payload[:email_address_change]

        email_change.list_id.should   == 'a6b5da1054'
        email_change.new_id.should    == '51da8c3259'
        email_change.new_email.should == 'api+new@mailchimp.com'
        email_change.old_email.should == 'api+old@mailchimp.com'

        @lodged = true
      }

      post '/panthoot/hooks', 'type' => 'upemail',
        'fired_at' => fired_at.to_s(:db), 'data[list_id]' => 'a6b5da1054',
        'data[new_id]' => '51da8c3259',
        'data[new_email]' => 'api+new@mailchimp.com',
        'data[old_email]' => 'api+old@mailchimp.com'
    end

    it "sends the listener the fired at timestamp" do
      @subscription = subscribe('email_address_change.panthoot') { |*args|
        event = ActiveSupport::Notifications::Event.new *args
        event.payload[:fired_at].should == fired_at

        @lodged = true
      }

      post '/panthoot/hooks', 'type' => 'upemail',
        'fired_at' => fired_at.to_s(:db), 'data[list_id]' => 'a6b5da1054',
        'data[new_id]' => '51da8c3259',
        'data[new_email]' => 'api+new@mailchimp.com',
        'data[old_email]' => 'api+old@mailchimp.com'
    end
  end

  describe 'cleaned emails' do
    it "sends the listener a cleaned email object" do
      @subscription = subscribe('email_cleaned.panthoot') { |*args|
        event   = ActiveSupport::Notifications::Event.new *args
        cleaned = event.payload[:email_cleaned]

        cleaned.list_id.should     == 'a6b5da1054'
        cleaned.campaign_id.should == '4fjk2ma9xd'
        cleaned.reason.should      == 'hard'
        cleaned.email.should       == 'api+cleaned@mailchimp.com'

        @lodged = true
      }

      post '/panthoot/hooks', 'type' => 'cleaned',
        'fired_at' => fired_at.to_s(:db), 'data[list_id]' => 'a6b5da1054',
        'data[campaign_id]' => '4fjk2ma9xd', 'data[reason]' => 'hard',
        'data[email]' => 'api+cleaned@mailchimp.com'
    end

    it "sends the listener the fired at timestamp" do
      @subscription = subscribe('email_cleaned.panthoot') { |*args|
        event = ActiveSupport::Notifications::Event.new *args
        event.payload[:fired_at].should == fired_at

        @lodged = true
      }

      post '/panthoot/hooks', 'type' => 'cleaned',
        'fired_at' => fired_at.to_s(:db), 'data[list_id]' => 'a6b5da1054',
        'data[campaign_id]' => '4fjk2ma9xd', 'data[reason]' => 'hard',
        'data[email]' => 'api+cleaned@mailchimp.com'
    end
  end

  describe 'campaign sending status' do
    it "sends the listener a campaign sending status object" do
      @subscription = subscribe('campaign_sending_status.panthoot') { |*args|
        event  = ActiveSupport::Notifications::Event.new *args
        status = event.payload[:campaign_sending_status]

        status.id.should      == '5aa2102003'
        status.subject.should == 'Test Campaign Subject'
        status.status.should  == 'sent'
        status.reason.should  == ''
        status.list_id.should == 'a6b5da1054'

        @lodged = true
      }

      post '/panthoot/hooks', 'type' => 'campaign',
        'fired_at' => fired_at.to_s(:db), 'data[list_id]' => 'a6b5da1054',
        'data[subject]' => 'Test Campaign Subject', 'data[status]' => 'sent',
        'data[reason]' => '', 'data[id]' => '5aa2102003'
    end

    it "sends the listener the fired at timestamp" do
      @subscription = subscribe('campaign_sending_status.panthoot') { |*args|
        event = ActiveSupport::Notifications::Event.new *args
        event.payload[:fired_at].should == fired_at

        @lodged = true
      }

      post '/panthoot/hooks', 'type' => 'campaign',
        'fired_at' => fired_at.to_s(:db), 'data[list_id]' => 'a6b5da1054',
        'data[subject]' => 'Test Campaign Subject', 'data[status]' => 'sent',
        'data[reason]' => '', 'data[id]' => '5aa2102003'
    end
  end
end
