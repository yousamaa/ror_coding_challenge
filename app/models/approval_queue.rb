class ApprovalQueue < ApplicationRecord
  belongs_to :product, dependent: :destroy
end
