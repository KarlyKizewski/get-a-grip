class Rock < ApplicationRecord
  validates :name, presence: true
  validates :picture, presence: true
  has_many :comments, dependent: :destroy

  belongs_to :user
  geocoded_by :address
  after_validation :geocode 

  mount_uploader :picture, PictureUploader
end
