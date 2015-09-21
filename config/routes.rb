Rails.application.routes.draw do

  scope :api do
  end

  match '/(*path)', via: :all, to: frontend_page('index.htm')
end
