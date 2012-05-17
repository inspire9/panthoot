Rails.application.routes.draw do
  mount Panthoot::App => '/panthoot/hooks'
end
