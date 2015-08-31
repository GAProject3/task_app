class Task < ActiveRecord::Base
	has_many :taskings
	has_many :users, through: :taskings
  # Paperclip atttachments
  has_attached_file :image, styles:{large: "600x600>",medium: "300x300>"}
  validates_attachment_content_type :image, content_type: /\Aimage\.*\Z/
end