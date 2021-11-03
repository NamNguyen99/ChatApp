class Attachment < ApplicationRecord
  belongs_to :target, polymorphic: true, optional: true

  has_one_attached :attachment
end
