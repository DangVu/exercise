class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  before_action :user_logged_in, only: [:show, :new, :edit, :index, :create, :update]
  before_action :find_params, only: [:edit, :update, :show]

  def initialize
    super
    @model = nil
    @model_ids = nil
    @model_symb = nil
    @model_method = nil
    @model_params = nil
    @model_update = nil
  end

  def index
    @model_objs = @model.search(params[:search]).paginate(page: params[:page]).per_page(5)
    if params[:sort] == "desc"
        @model_objs = @model.search(params[:search]).order("#{params[:col]} desc").paginate(page: params[:page]).per_page(5)
        @sort_type = "asc"
     else
        @model_objs = @model.search(params[:search]).order(params[:col]).paginate(page: params[:page]).per_page(5)
        @sort_type = "desc"
     end
  end

  def show
  end

  def new
    @model_obj = @model.new
    if @model == Product
      @product_picture = @model_obj.product_pictures.build
    end
  end

  def create
    @model_obj = @model.new(model_obj_params)
    if @model_obj.save
      create_product_image if defined? create_product_image
      flash[:success] = "Create successfully"
      redirect_to send @model_method
    else
      render 'new'
    end
  end

  def update
    if @model_obj.update_attributes(model_obj_params)
      create_product_image if defined? create_product_image
      flash[:success] = "Update successfully"
      redirect_to send @model_method
    else
      if @model == Product
        @product_pictures = @model_obj.product_pictures
      end
      render 'edit'
    end
  end

  def activate
    if params[@model_ids]
     @model_objs = @model.find(params[@model_ids])
     @model_objs.each do |object|
      if params.keys.include?("Activate")
          object.active = true
          object.save
      elsif params.keys.include?("Delete")
          object.active = false
          object.save
      end
     end
      redirect_to :back
    else
      flash[:danger] = "You must chosse one!"
      redirect_to send @model_method
    end
  end

  private
  def render_404(exception = nil)
  	if exception
  		logger.info "Rendering 404: #{exception.message}"
  	end
  	render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end

  def user_logged_in
      unless logged_in?
        flash[:danger] = "Please login"
        redirect_to login_path
      end
    end

  def model_obj_params
    params.require(@model_symb).permit(@model_params.values)
  end

  def find_params
    if @model.find_by_id(params[:id]) != nil
      @model_obj = @model.find(params[:id])
    else
      render_404
    end
  end

  end
