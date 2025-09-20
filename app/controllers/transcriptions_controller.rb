class TranscriptionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  # POST /transcriptions
  def create
    audio_file = params[:audio]
    return render json: { error: "No audio file uploaded" }, status: :bad_request unless audio_file

    transcription = TranscriptionService.new(audio_file).call

    render json: {
      id: transcription.id,
      transcription: transcription.text,
      summary: transcription.summary
    }
  end

  # GET /summary/:id
  def summary
    transcription = Transcription.find(params[:id])
    render json: { summary: transcription.summary }
  end
end
