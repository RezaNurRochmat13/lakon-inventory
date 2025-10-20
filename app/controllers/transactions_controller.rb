class TransactionsController < ApplicationController
  # GET /transactions
  # optional params: product_id, user_id, status, page, per_page
  def index
    transactions = TransactionService.new.getAllTransactions(
      filter_params,
      params[:page] || 1,
      params[:per_page] || 20
    )

    render json: {
      message: "success",
      data: transactions.as_json
    }, status: :ok
  end

  # POST /transactions
  def create
    transaction = TransactionService.new.createTransaction(transaction_params)
    render json: {
      message: "success",
      data: transaction.as_json
    }, status: :created
  rescue TransactionService::InsufficientStockError => e
    render json: {
      message: "error",
      error: e.message
    }, status: :unprocessable_content
  rescue ActiveRecord::RecordInvalid => e
    render json: {
      message: "error",
      error: e.record.errors.full_messages
    }, status: :unprocessable_content
  end

  private

  # Strong params untuk create transaction
  def transaction_params
    params.require(:transaction).permit(:product_id, :user_id, :quantity)
  end

  # Filter params untuk index
  def filter_params
    params.slice(:product_id, :user_id, :status).to_unsafe_h.compact
  end
end
