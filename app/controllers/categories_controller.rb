class CategoriesController < ApplicationController

  def initialize
    super
    @model = Category
    @model_ids = :category_ids
    @model_symb = :category
    @model_method = :categories_path
    @model_params = { key1: :name, key2: :active }
  end

end
