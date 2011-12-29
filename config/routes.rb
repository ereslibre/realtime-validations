Rails.application.routes.draw do

  scope :module => :realtime_validations do
    match '/validations/*args(.:format)', :to => 'validations#validate', :via => :post
  end

end
