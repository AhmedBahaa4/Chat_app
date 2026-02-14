# Chat App (Flutter + Gemini)

AI chat application built with Flutter.

The app supports:
- Real chat with Gemini API
- Streaming assistant responses
- Conversation list with rename/share/delete actions
- Image attachment in chat (send image + prompt)
- Local persistence with Hive (messages survive app restart and hot restart)
- Mock mode for UI/dev testing without API calls

## Tech Stack

- Flutter + Material 3
- Riverpod (state management + dependency injection)
- Dio (networking)
- Hive (local persistence)
- Image Picker + Share Plus

## Project Structure

```text
lib/
  core/
    config/
    theme/
  domain/
    entities/
    repositories/
  data/
    clients/
      gemini/
    local/
    repositories/
  features/
    home/
    chat/
```

Architecture style:
- `domain`: entities + repository contracts
- `data`: implementations (Gemini client + local store)
- `features`: UI + feature state/controllers

## Prerequisites

- Flutter SDK installed
- Android Studio / VS Code
- A Gemini API key

## Run The App

1. Install dependencies:

```bash
flutter pub get
```

2. Run with Gemini API key:

```bash
flutter run --dart-define=GEMINI_API_KEY=YOUR_KEY
```

Optional model override:

```bash
flutter run --dart-define=GEMINI_API_KEY=YOUR_KEY --dart-define=GEMINI_MODEL=gemini-2.0-flash
```

Optional mock mode:

```bash
flutter run --dart-define=USE_MOCK_AI=true
```

## Android Package Name

Current Android package/application id:

```text
com.example.chatapp
```

If your API key uses Android app restrictions, make sure this package name (and SHA-1) is configured in Google Cloud.

## Persistence

Persistence is implemented in:
- `lib/data/local/conversation_store.dart`
- `lib/data/local/conversation_store_codec.dart`

Hive box name:

```text
chat_store
```

Stored data:
- Conversations metadata
- Messages (including streamed assistant responses)
- Attachments metadata/content (base64)

## Useful Commands

```bash
flutter analyze
flutter test
flutter clean
```

## Troubleshooting

### 1) `Missing GEMINI_API_KEY`

Reason:
- App started without `--dart-define=GEMINI_API_KEY=...`

Fix:
- Stop app fully, then run again with `--dart-define`

### 2) `Gemini request failed (429)`

Reason:
- Quota/rate limit reached on Gemini project

Fix:
- Check quota and billing in your Google project
- Wait and retry, or upgrade limits

### 3) Image picker channel error on Android

Reason:
- Plugin registration mismatch after dependency changes / hot restart

Fix:

```bash
flutter clean
flutter pub get
flutter run --dart-define=GEMINI_API_KEY=YOUR_KEY
```

### 4) Internet/network errors in emulator

Fix:
- Verify emulator internet access
- Keep `android.permission.INTERNET` in manifest

## Security Notes

- Do not hardcode API keys in source files.
- Rotate keys immediately if exposed.
- For production, prefer a backend proxy to protect API keys.

## Current Status

Implemented:
- Chat UI redesign and modular widgets
- Conversation actions and navigation
- Gemini integration with streaming
- Persistence across app restarts
- Error reporting improvements

Planned next steps:
- Backend proxy for key security
- Better retry/backoff UX
- Optional cloud sync across devices

