require 'rails_helper'

RSpec.describe TranscriptionsController, type: :controller do
  let(:audio_file) { fixture_file_upload("spec/fixtures/files/sample.webm", "audio/webm") }

  describe "POST #create" do
    let(:api_url) { "https://api.deepgram.com/v1/listen?smart_format=true&summarize=v2&model=nova-3&diarize=true&filler_words=true" }

    let(:deepgram_response) do
      {
        results: {
          summary: { short: "Controller summary" },
          channels: [
            {
              alternatives: [
                {
                  paragraphs: {
                    paragraphs: [
                      {
                        speaker: 1,
                        sentences: [
                          { start: 0.0, text: "Hi there" }
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

    it "returns transcription JSON" do
      post :create, params: { audio: audio_file }

      json = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(json["transcription"]).to include("Speaker 1 [0.0s]: Hi there")
      expect(json["summary"]).to eq("Controller summary")
    end

    it "returns error if no audio uploaded" do
      post :create
      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)["error"]).to eq("No audio file uploaded")
    end
  end
end
