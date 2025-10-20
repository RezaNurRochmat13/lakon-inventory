class ProductService
  def getAllProducts
    Product.all
  end

  def createProduct(product)
    Product.create(product)
  end
end
