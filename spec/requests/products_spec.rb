require 'rails_helper'

RSpec.describe "Products API", type: :request do
  let!(:product1) { Product.create!(name: "Product A") }
  let!(:product2) { Product.create!(name: "Product B") }

  describe "GET /products" do
    it "returns all products" do
      get "/products"

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["message"]).to eq("success")
      expect(json["data"].length).to eq(2)
      expect(json["data"].map { |p| p["name"] }).to include("Product A", "Product B")
    end
  end

  describe "POST /products" do
    context "with valid params" do
      it "creates a new product successfully" do
        post "/products", params: { product: { name: "Product C", stock: 0 } }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["message"]).to eq("success")
        expect(json["data"]["name"]).to eq("Product C")
      end
    end
  end
end
