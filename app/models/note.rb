class Note < ApplicationRecord
  has_rich_text :content
  belongs_to :topic
end
