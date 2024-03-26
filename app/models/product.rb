class Product < ApplicationRecord
  has_one :approval_queue, dependent: :destroy

  enum status: { approved: 'approved', pending: 'pending', rejected: 'rejected' }

  validates :name, :price, :status, presence: true

  scope :active, -> { where(status: 'approved') }
  scope :name_like, -> (name) { where("name LIKE ?", "%#{name}%") if name.present? }
  scope :price_range, -> (min_price, max_price) {
    if min_price.present? && max_price.present?
      where(price: min_price..max_price)
    elsif min_price.present?
      where('price >= ?', min_price)
    elsif max_price.present?
      where('price <= ?', max_price)
    else
      all
    end
  }
  scope :posted_between, -> (min_posted_date, max_posted_date) {
    if min_posted_date.present? || max_posted_date.present?
      where(created_at: (min_posted_date || 10.years.ago)..(max_posted_date || Time.zone.now))
    end
  }
end
