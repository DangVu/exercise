class UsersController < ApplicationController

  def initialize
    super
    @model = User
    @model_ids = :user_ids
    @model_symb = :user
    @model_method = :users_path
    @model_params = { key1: :name, key2: :email, key3: :password, 
                      key4: :password_confirmation, key5: :picture, key6: :active }
  end

  def destroy
    image = User.find(params[:id]).picture
    image.remove!
    redirect_to :back
  end

  private
  	def user_params
  		params.require(:user).permit(:name, :email, :password, :password_confirmation, :picture, :active)
  	end
end
