require 'rails_helper'

RSpec.describe TranscriptionService, type: :service do
  let(:audio_file) { fixture_file_upload("spec/fixtures/files/sample.webm", "audio/webm") }
  let(:api_url) { "https://api.deepgram.com/v1/listen?smart_format=true&summarize=v2&model=nova-3&diarize=true&filler_words=true" }

  let(:deepgram_response) do
    {
      results: {
        summary: { short: "This is a summary" },
        channels: [
          {
            alternatives: [
              {
                paragraphs: {
                  paragraphs: [
                    {
                      speaker: 1,
                      sentences: [
                        { start: 0.0, text: "Hello world" },
                        { start: 1.0, text: "How are you?" }
                      ]
                    }
                  ]
                }
              }
            ]
          }
        ]
      }
    }.to_json
  end

  before do
    stub_request(:post, api_url)
      .to_return(status: 200, body: deepgram_response, headers: { 'Content-Type' => 'application/json' })
  end

  it "creates a transcription with text and summary" do
    service = TranscriptionService.new(audio_file)
    transcription = service.call

    expect(transcription.text).to include("Speaker 1 [0.0s]: Hello world")
    expect(transcription.summary).to eq("This is a summary")
    expect(Transcription.count).to eq(1)
  end
end
