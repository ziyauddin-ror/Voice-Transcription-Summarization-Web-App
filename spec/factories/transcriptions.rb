FactoryBot.define do
  factory :transcription do
    audio_filename { "sample.webm" }
    text { "Sample transcription text." }
    summary { "Sample summary." }
  end
end