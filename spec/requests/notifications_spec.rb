require 'spec_helper'

describe 'MailChimp Webhook Notifications' do
  let(:fired_at) { Time.zone.local(2009, 3, 26, 21, 35, 57) }

  describe 'subscribes' do
    it "sends the listener a subscription object" do
      MailChimpListener.should_receive(:subscribe) do |subscription, fired_at|
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
      end

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
      MailChimpListener.should_receive(:subscribe).with(anything, fired_at)

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
      MailChimpListener.should_receive(:unsubscribe) do |unsubscription, fired_at|
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
      end

      post '/panthoot/hooks', 'type' => 'unsubscribe',
        'fired_at' => fired_at.to_s(:db), 'data[action]' => 'unsub',
        'data[reason]' => 'manual', 'data[id]' => '8a25ff1d98',
        'data[list_id]' => 'a6b5da1054', 'data[email]' => 'api@mailchimp.com',
        'data[email_type]' => 'html',
        'data[merges][EMAIL]' => 'api@mailchimp.com',
        'data[merges][FNAME]' => 'MailChimp',
        'data[merges][LNAME]' => 'API',
        'data[merges][INTERESTS]' => 'Group1,Group2',
        'data[ip_opt]' => '10.20.10.30',
        'data[campaign_id]' => 'cb398d21d2'
    end

    it "sends the listener the fired at timestamp" do
      MailChimpListener.should_receive(:unsubscribe).with(anything, fired_at)

      post '/panthoot/hooks', 'type' => 'unsubscribe',
        'fired_at' => fired_at.to_s(:db), 'data[action]' => 'unsub',
        'data[reason]' => 'manual', 'data[id]' => '8a25ff1d98',
        'data[list_id]' => 'a6b5da1054', 'data[email]' => 'api@mailchimp.com',
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
      MailChimpListener.should_receive(:profile_update) do |profile, fired_at|
        profile.id.should          == '8a25ff1d98'
        profile.list_id.should     == 'a6b5da1054'
        profile.email.should       == 'api+unsub@mailchimp.com'
        profile.email_type.should  == 'html'
        profile.ip_opt.should      == '10.20.10.30'
        profile.merges.should == {
          'EMAIL'     => 'api@mailchimp.com',
          'FNAME'     => 'MailChimp',
          'LNAME'     => 'API',
          'INTERESTS' => 'Group1,Group2'
        }
      end

      post '/panthoot/hooks', 'type' => 'profile',
        'fired_at' => fired_at.to_s(:db), 'data[id]' => '8a25ff1d98',
        'data[list_id]' => 'a6b5da1054', 'data[email]' => 'api@mailchimp.com',
        'data[email_type]' => 'html',
        'data[merges][EMAIL]' => 'api@mailchimp.com',
        'data[merges][FNAME]' => 'MailChimp',
        'data[merges][LNAME]' => 'API',
        'data[merges][INTERESTS]' => 'Group1,Group2',
        'data[ip_opt]' => '10.20.10.30'
    end

    it "sends the listener the fired at timestamp" do
      MailChimpListener.should_receive(:profile_update).with(anything, fired_at)

      post '/panthoot/hooks', 'type' => 'profile',
        'fired_at' => fired_at.to_s(:db), 'data[id]' => '8a25ff1d98',
        'data[list_id]' => 'a6b5da1054', 'data[email]' => 'api@mailchimp.com',
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
      MailChimpListener.should_receive(:email_address_change) do |email_change, fired_at|
        email_change.list_id.should   == 'a6b5da1054'
        email_change.new_id.should    == '51da8c3259'
        email_change.new_email.should == 'api+new@mailchimp.com'
        email_change.old_email.should == 'api+old@mailchimp.com'
      end

      post '/panthoot/hooks', 'type' => 'upemail',
        'fired_at' => fired_at.to_s(:db), 'data[list_id]' => 'a6b5da1054',
        'data[new_id]' => '51da8c3259',
        'data[new_email]' => 'api+new@mailchimp.com',
        'data[old_email]' => 'api+old@mailchimp.com'
    end

    it "sends the listener the fired at timestamp" do
      MailChimpListener.should_receive(:email_address_change).
        with(anything, fired_at)

      post '/panthoot/hooks', 'type' => 'upemail',
        'fired_at' => fired_at.to_s(:db), 'data[list_id]' => 'a6b5da1054',
        'data[new_id]' => '51da8c3259',
        'data[new_email]' => 'api+new@mailchimp.com',
        'data[old_email]' => 'api+old@mailchimp.com'
    end
  end

  describe 'cleaned emails' do
    it "sends the listener a cleaned email object" do
      MailChimpListener.should_receive(:email_cleaned) do |cleaned, fired_at|
        cleaned.list_id.should     == 'a6b5da1054'
        cleaned.campaign_id.should == '4fjk2ma9xd'
        cleaned.reason.should      == 'hard'
        cleaned.email.should       == 'api+cleaned@mailchimp.com'
      end

      post '/panthoot/hooks', 'type' => 'cleaned',
        'fired_at' => fired_at.to_s(:db), 'data[list_id]' => 'a6b5da1054',
        'data[campaign_id]' => '4fjk2ma9xd', 'data[reason]' => 'hard',
        'data[email]' => 'api+cleaned@mailchimp.com'
    end

    it "sends the listener the fired at timestamp" do
      MailChimpListener.should_receive(:email_cleaned).with(anything, fired_at)

      post '/panthoot/hooks', 'type' => 'cleaned',
        'fired_at' => fired_at.to_s(:db), 'data[list_id]' => 'a6b5da1054',
        'data[campaign_id]' => '4fjk2ma9xd', 'data[reason]' => 'hard',
        'data[email]' => 'api+cleaned@mailchimp.com'
    end
  end

  describe 'cleaned emails' do
    it "sends the listener a campaign sending status object" do
      MailChimpListener.should_receive(:campaign_sending_status) do |status, fired_at|
        status.id.should      == '5aa2102003'
        status.subject.should == 'Test Campaign Subject'
        status.status.should  == 'sent'
        status.reason.should  == ''
        status.list_id.should == 'a6b5da1054'
      end

      post '/panthoot/hooks', 'type' => 'campaign',
        'fired_at' => fired_at.to_s(:db), 'data[list_id]' => 'a6b5da1054',
        'data[subject]' => 'Test Campaign Subject', 'data[status]' => 'sent',
        'data[reason]' => '', 'data[id]' => '5aa2102003'
    end

    it "sends the listener the fired at timestamp" do
      MailChimpListener.should_receive(:campaign_sending_status).
        with(anything, fired_at)

      post '/panthoot/hooks', 'type' => 'campaign',
        'fired_at' => fired_at.to_s(:db), 'data[list_id]' => 'a6b5da1054',
        'data[subject]' => 'Test Campaign Subject', 'data[status]' => 'sent',
        'data[reason]' => '', 'data[id]' => '5aa2102003'
    end
  end
end
