require 'rails_helper'

RSpec.describe Transcription, type: :model do
  it "is valid with valid attributes" do
    t = Transcription.new(audio_filename: "sample.webm", text: "Text", summary: "Summary")
    expect(t).to be_valid
  end

  it "is invalid without audio_filename" do
    t = Transcription.new(text: "Text", summary: "Summary")
    expect(t).not_to be_valid
  end

  it "is invalid without text" do
    t = Transcription.new(audio_filename: "sample.webm", summary: "Summary")
    expect(t).not_to be_valid
  end
end