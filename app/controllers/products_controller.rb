class ProductsController < ApplicationController

  def initialize
    super
    @model = Product
    @model_ids = :product_ids
    @model_symb = :product
    @model_method = :products_path
    @model_params = { key1: :name, key2: :price, key3: :description, key4: :active }
    @model_update = :update_product
  end

  def edit
    @product_pictures = @model_obj.product_pictures
  end 

  def create_product_image
    if params[:product_pictures]
      params[:product_pictures]['picture'].each do |i|
          @product_picture = @model_obj.product_pictures.create!(:picture => i, :product_id => @model_obj.id)
      end
    end
  end

  def update_product
    unless params[:product_pictures] == nil 
      params[:product_pictures]['picture'].each do |i|
        @product_picture = @model_obj.product_pictures.create!(:picture => i, :product_id => @model_obj.id)
      end
    end
  end

end
