require "httparty"
require "json"
class TranscriptionService
  def initialize(audio_file)
    @audio_file = audio_file
    @deepgram_api_key = ENV["DEEPGRAM_API_KEY"]
    @deepgram_url = "https://api.deepgram.com/v1/listen?smart_format=true&summarize=v2&model=nova-3&diarize=true&filler_words=true"
  end

  def call
    temp_file_path = save_temp_file(@audio_file)
    response = send_to_deepgram(temp_file_path)
    parsed = JSON.parse(response.body)
    final_segments = parse_segments(parsed)
    transcription_text = build_transcription_text(final_segments)
    summary_data = parsed.dig("results", "summary", "short") || transcription_text

    transcription = Transcription.create!(
      audio_filename: @audio_file.original_filename,
      text: transcription_text,
      summary: summary_data
    )

    transcription
  ensure
    File.delete(temp_file_path) if temp_file_path && File.exist?(temp_file_path)
  end

  private

  def save_temp_file(file)
    path = Rails.root.join("tmp", file.original_filename)
    File.open(path, "wb") { |f| f.write(file.read) }
    path
  end

  def send_to_deepgram(file_path)
    HTTParty.post(
      @deepgram_url,
      headers: {
        "Authorization" => "Token #{@deepgram_api_key}",
        "Content-Type" => "audio/webm"
      },
      body: File.binread(file_path)
    )
  end

  def parse_segments(parsed)
    segments = []
    parsed.dig("results", "channels", 0, "alternatives", 0, "paragraphs", "paragraphs")&.each do |p|
      speaker = p["speaker"]
      p["sentences"].each do |s|
        start_time = s["start"].round(1)
        
        # If the last segment has the same timestamp, merge text
        if segments.last && segments.last[:timestamp] == start_time && segments.last[:speaker] == speaker
          segments.last[:text] += " " + s["text"]
        else
          segments << {
            speaker: speaker,
            timestamp: start_time,
            text: s["text"]
          }
        end
      end
    end
    segments
  end

  def build_transcription_text(segments)
    segments.map do |s|
      # time = Time.at(s[:timestamp]).utc.strftime("%H:%M:%S")
      "Speaker #{s[:speaker]} [#{s[:timestamp]}s]: #{s[:text]}\n"
    end.join(" ")
  end
end
