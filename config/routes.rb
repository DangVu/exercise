Rails.application.routes.draw do
  get 'errors/new'

  get 'product_pictures/new'

  get 'products/new'

  get 'categories/new'

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  resources :categories do 
    collection do
      put 'activate'
    end
  end

  resources :products do
    collection do
      put 'activate'
    end
  end

  resources :users do
    collection do
      put 'activate'
    end

    member do
      delete 'delete_image' => 'users#destroy', as: :delete_image
    end
  end
  
  resources :product_pictures do
    member do
      delete 'delete_picture' => 'product_pictures#destroy', as: :delete_picture
    end
  end
  match '*a', :to => 'errors#routing', via: :get
end
