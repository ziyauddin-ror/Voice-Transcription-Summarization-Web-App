# Voice Transcription & Summarization Web App

This Ruby on Rails 7 application provides **live audio transcription** and **summarization** using the **Deepgram API**. It includes both a **web interface** for live recording and **API endpoints** for uploading audio files.

---

## Features

* Live transcription via Deepgram WebSocket.
* Automatic summarization (for audio > 50 words).
* Web interface for live recording and viewing transcripts in real-time.
* API endpoints for creating transcriptions from audio files and fetching summaries.
* RSpec tests with **WebMock** to mock external API calls.

---

## Simple Demo Script

Hello, my name is **Mohammad Ziyauddin**, and I will walk you through my assignment demo.

* Built with **Ruby on Rails 7** and **plain JavaScript**.
* Uses **Deepgram API** for transcription and summarization.

**How it works:**

* **Start Listening:** Connects to Deepgram WebSocket to show live transcripts in real-time.
* **Stop Listening:** Sends the audio to Deepgram for final transcription and summary.

> 📝 Note: For proper summary generation, the user must speak **more than 50 words**.

---

## Prerequisites

* Ruby 3.x
* Rails 7.1.5
* PostgreSQL (or preferred database)
* Deepgram API key

---

## Installation

1. **Clone the repository and checkout the `transcribe` branch:**

```bash
git clone https://github.com/ziyauddin-ror/Voice-Transcription-Summarization-Web-App.git
cd Voice-Transcription-Summarization-Web-App
git checkout transcribe
```

2. **Install dependencies:**

```bash
bundle install
```

3. **Setup the database:**

```bash
rails db:create
rails db:migrate
```

4. **Set environment variables:**

Create a `.env` file in the root folder:

```
DEEPGRAM_API_KEY=your_deepgram_api_key_here
```

---

## Running the Application

Start the Rails server:

```bash
rails server
```

* Open [http://localhost:3000](http://localhost:3000)
* Or visit [http://localhost:3000/transcribe](http://localhost:3000/transcribe)

**Usage:**

* **Web Interface:**

  * Users can **record live audio** and see **real-time transcription**.
  * Click **Start Listening** to connect to the WebSocket.
  * Click **Stop Listening** to finalize the transcript and summary.
  * 📝 Note: Summaries work properly only for **more than 50 words**.

* **API Endpoints (for file uploads):**

  * `POST /transcriptions` → Upload an audio file to create a transcription and summary.

    * Required param: `audio` (audio file)
  * `GET /summary/:id` → Fetch the summary of a transcription by ID.

> This clarifies that **audio file uploads are only supported via the API**, not the web interface.

---

## Running RSpec Tests

Tests are configured with **WebMock** to mock Deepgram API calls.

```bash
bundle exec rspec
```
---

## Demo Video

https://github.com/user-attachments/assets/e6ff3019-9c86-4179-aec5-5dca1f7e8daf

It showcases live transcription, final transcript, and summary generation.

---
