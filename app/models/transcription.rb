class Transcription < ApplicationRecord
  validates :audio_filename, presence: true
  validates :text, presence: true
end
