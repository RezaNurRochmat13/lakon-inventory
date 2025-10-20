class ProductsController < ApplicationController
  def index
    products = ProductService.new.getAllProducts
    render json: {
      message: "success",
      data: products
    }
  end

  def create
    product = ProductService.new.createProduct(product_params)
    render json: {
      message: "success",
      data: product.as_json
    }
  end

  def product_params
    params.require(:product).permit(:name, :stock)
  end
end
