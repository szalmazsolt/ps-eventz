class Event < ApplicationRecord

  before_save :set_slug

  has_many :registrations, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :user
  has_many :categorization, dependent: :destroy
  has_many :categories, through: :categorization

  validates :name, :location, :starts_at, presence: true
  validates :description, length: {minimum: 25}
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :capacity, numericality: 
                        { only_integer: true, greater_than: 0 }

  validates :image_file_name, format: {
    with: /\w+\.(jpg|png)\z/i,
    message: 'must be JPG or PNG image'
  }

  # Instead of using class methods for custom queries, we can define scopes
  # A scope basically declares the corresponding class method in the background
  # A scope is a method, that takes two parameters: the name of the custom query and the custom query itself as a lambda
  # a lambda turns a chunk of code into a callable object, called a Proc object
  scope :upcoming, lambda { where("starts_at > ?", Time.now).order("starts_at ASC") }
  scope :past, -> { where("starts_at < ?", Time.now).order("starts_at DESC") }
  # we can chain scopes
  scope :free, -> { upcoming.where(price: 0.0).order("starts_at ASC") } 
  # we can pass arguments to a lambda
  scope :recent, ->(num=3) { past.limit(num) }

  # def self.upcoming
  #   where("starts_at > ?", Time.now).order("starts_at")
  # end

  def free?
    price == 0 || price.blank?
  end

  def sold_out?
    (capacity - registrations.size).zero?
  end

  # Overriding the to_param method that's available for every ActiveRecord object
  # originally active_record_object.to_param return the string representation of the active_record_object's id
  # route helpers, like event_path(event) call the to_param method to generate the path
  # our custom to_param method returns the event name in a url-friendly format, like "kata-camp"
  def to_param
    slug
  end

  private

    def set_slug
      self.slug = name.parameterize + "-#{Time.now.to_i}"
    end
end
