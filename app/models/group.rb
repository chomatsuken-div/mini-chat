class Group < ApplicationRecord
  has_many :messages

  default_scope -> { order(created_at: :desc) }

  validates :name, presence: true, uniqueness: true, length: { maximum: 20 }
end
