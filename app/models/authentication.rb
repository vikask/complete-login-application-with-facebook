class Authentication < ActiveRecord::Base
  belongs_to :user
  attr_accessible :provider, :token, :uid, :user_id

  validates_uniqueness_of :uid, :scope => :provider

  def provider_name
    if provider == 'open_id'
      "Open_ID"
    elsif provider == 'google_oauth2'
      'Google'
    else
      provider.titleize
    end
  end
end
