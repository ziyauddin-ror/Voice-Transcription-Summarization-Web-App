Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  root "transcriptions#new"
  
  get "/transcribe", to: "transcriptions#new"
  post "/transcriptions", to: "transcriptions#create"
  get "/summary/:id", to: "transcriptions#summary", as: "summary"

  # Defines the root path route ("/")
  # root "posts#index"
end
