class ProductPicturesController < ApplicationController
  before_action :set_product_picture, only: [:show, :edit, :update, :destroy]

  def index
  	@product_pictures = ProductPicture.all
  end
  
  def new
  	@product_picture = ProductPicture.new
  end

  def create
  	@product_picture = ProductPicture.new(product_picture_params)
  end

  def update
  	if @product_picture.update(product_picture_params)
  		flash[:success] = "OK"
  	else
  		render "edit"
  	end
  end

  def destroy
  	@product_picture.destroy
  	FileUtils.remove_dir "#{Dir.pwd}/public/uploads/product_picture/picture/#{@product_picture.id}"
  	redirect_to :back
  end

  private
  def set_product_picture
  	@product_picture = ProductPicture.find(params[:id])
  end

  def product_picture_params
  	params.require(:product_picture).permit(:product_id, :picture)
  end

end
