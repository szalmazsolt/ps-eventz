class Category < ApplicationRecord
  has_many :categorization, dependent: :destroy
  has_many :events, through: :categorization

  validates :name, presence: true, uniqueness: true
end
