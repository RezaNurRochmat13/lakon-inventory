class TransactionService
  class InsufficientStockError < StandardError; end

  def getAllTransactions(filter = {}, page = 1, per_page = 20)
    transactions = Transaction.all

    # Apply filters if present
    filter.each do |key, value|
      transactions = transactions.where(key => value) if value.present?
    end

    # Apply pagination
    transactions = transactions.page(page).per(per_page) # requires 'kaminari' or 'will_paginate'

    transactions
  end

  def createTransaction(transaction_params)
    product = Product.find(transaction_params[:product_id])
    quantity = transaction_params[:quantity].to_i

    if product.stock >= quantity
      ActiveRecord::Base.transaction do
        # Deduct stock
        product.update!(stock: product.stock - quantity)
        # Create transaction record
        Transaction.create!(transaction_params)
      end
    else
      raise InsufficientStockError, "Stock insufficient for product #{product.name}"
    end
  end
end
