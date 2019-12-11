class Rock < ApplicationRecord
  validates :name, presence: true

  belongs_to :user

  mount_uploader :picture, PictureUploader
end
