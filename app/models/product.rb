class Product < ActiveRecord::Base
  extend FriendlyId
  include AlgoliaSearch

  has_many :agencies, through: :customers
  has_many :customers

  has_many :ato_types, through: :ato_statuses
  has_many :ato_statuses

  has_many :categories, through: :product_categories
  has_many :product_categories

  has_many :contracts, through: :product_contracts
  has_many :product_contracts

  has_many :keywords, through: :product_keywords
  has_many :product_keywords

  has_many :users, through: :product_requests
  has_many :product_requests

  has_drafts

  friendly_id :name, use: [:slugged, :finders]

  validates \
    :name,
    :short_description,
    :url,
    presence: true

  validates :slug, presence: true, uniqueness: true

  has_attached_file \
    :logo,
    default_url: ActionController::Base.helpers.asset_path("missing.png")

  validates_attachment_content_type :logo, content_type: %r{\Aimage\/.*\Z}

  algoliasearch enqueue: :trigger_delayed_job, sanitize: true do
    add_attribute :logo_url
  end

  def self.most_popular
    includes(:users).
      where("users.type" => "GovernmentUser").
      order("product_requests_count DESC").limit(3)
  end

  def self.search(query)
    where("name LIKE ?", "%#{query}%")
  end

  def self.trigger_delayed_job(record, remove)
    if remove
      record.delay.remove_from_index!
    else
      record.delay.index!
    end
  end

  def logo_url
    logo.url(:original)
  end
end
