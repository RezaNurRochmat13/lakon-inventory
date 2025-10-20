require 'rails_helper'

RSpec.describe "Transactions API", type: :request do
  let!(:product) { Product.create!(name: "Product A", stock: 10) }

  describe "GET /transactions" do
    before do
      # Buat beberapa transaksi dummy
      Transaction.create!(product_id: product.id, quantity: 2, transaction_type: "in")
      Transaction.create!(product_id: product.id, quantity: 1, transaction_type: "out")
    end

    it "returns all transactions with pagination and filter" do
      get "/transactions", params: { transaction_type: "in", page: 1, per_page: 10 }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["message"]).to eq("success")
      expect(json["data"].length).to eq(2)
      expect(json["data"].first["transaction_type"]).to eq("in")
    end
  end

  describe "POST /transactions" do
    context "when stock is sufficient" do
      it "creates a transaction successfully" do
        post "/transactions", params: { transaction: { product_id: product.id, quantity: 5 } }

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json["message"]).to eq("success")
        expect(json["data"]["product_id"]).to eq(product.id)
        expect(json["data"]["quantity"]).to eq(5)
      end
    end

    context "when stock is insufficient" do
      it "returns an error" do
        post "/transactions", params: { transaction: { product_id: product.id, quantity: 100 } }

        expect(response).to have_http_status(:unprocessable_content)
        json = JSON.parse(response.body)
        expect(json["message"]).to eq("error")
        expect(json["error"]).to match(/Stock insufficient/)
      end
    end
  end
end
