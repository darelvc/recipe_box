require "babosa"

class Recipe < ActiveRecord::Base
	extend FriendlyId
  friendly_id :title, use: :slugged

	belongs_to :user

	has_many :ingredients
	has_many :directions

	accepts_nested_attributes_for :ingredients,
																reject_if: proc { |attributes| attributes['name'].blank? },
																allow_destroy: true
	accepts_nested_attributes_for :directions,
																reject_if: proc { |attributes| attributes['step'].blank? },
																allow_destroy: true	
	
  validates :title, :description, :image, presence: true

	has_attached_file :image, styles: { medium: "400x400#" }, default_url: "missing.jpg"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  def normalize_friendly_id(input)
    input.to_s.to_slug.normalize(transliterations: :russian).to_s
  end
end
