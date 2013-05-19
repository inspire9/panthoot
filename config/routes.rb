Rails.application.routes.draw do
  mount Panthoot::App.new => '/panthoot/hooks'
end
