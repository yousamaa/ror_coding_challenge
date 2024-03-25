class Product < ApplicationRecord
  has_one :approval_queue

  enum status: { approved: 'approved', pending: 'pending', rejected: 'rejected' }

  validates :name, :price, :status, presence: true
end
