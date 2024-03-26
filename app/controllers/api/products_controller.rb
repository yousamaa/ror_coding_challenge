class Api::ProductsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_product, only: %i[update destroy]
  before_action :set_approval_queue, only: %i[approve reject]

  def index
    @products = Product.active.order(created_at: :desc)

    render json: @products
  end

  def search
    @products = Product.active
                     .name_like(params[:productName])
                     .price_range(params[:minPrice], params[:maxPrice])
                     .posted_between(params[:minPostedDate], params[:maxPostedDate])
                     .order(created_at: :desc)

    render json: @products
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      if price_exceeds_limit?
        @product.update(status: 'pending')

        ApprovalQueue.create(product: @product)
      end
      render json: @product, status: :created
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def update
    price = @product.price

    if @product.update(product_params)
      if price_exceeds_previous?(price)
        @product.update(status: 'pending')

        ApprovalQueue.create(product: @product)
      end
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def destroy
    ApprovalQueue.create(product: @product)

    render json: "Product added to approval queue for deletion"
  end

  def approval_queue
    @products = Product.find(ApprovalQueue.pluck(:product_id)).sort

    render json: @products
  end

  def approve
    product = @approval_queue.product

    if product.status == 'approved'
      render json: "Product deletion approved and deleted successfully" if product.destroy
    else
      if product.update(status: 'approved')
        render json: product if @approval_queue.delete
      end
    end
  end

  def reject
    render json: "Approval rejected" if @approval_queue.delete
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.permit(:name, :price, :status)
  end

  def price_exceeds_previous?(price)
    @product.price > price * 1.5
  end

  def price_exceeds_limit?
    @product.price > 5000
  end

  def set_approval_queue
    @approval_queue = ApprovalQueue.find(params[:approval_id])
  end
end
