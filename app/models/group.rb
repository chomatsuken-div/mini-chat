class Group < ApplicationRecord
  has_many :messages

  validates :name, presence: true, uniqueness: true, length: { maximum: 20 }
end
