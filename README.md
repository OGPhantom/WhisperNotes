# 🎙️ WhisperNotes
A **privacy-first, on-device AI-powered voice notes app for iOS** built with **SwiftUI**, **SwiftData**, **Whisper**, **Core ML**, and **Apple Intelligence (FoundationModels)**.  
Capture your **spoken thoughts in real time**, turn them into clean structured notes, and manage a polished library of transcripts and refined note versions without sending private data to the cloud.

---

### 📌 Short Description

WhisperNotes is a focused iOS app designed for **real-time speech capture**, **on-device transcription**, and **AI-powered note refinement**.  
Users can record voice notes with a premium minimal recording interface, watch text appear live during capture, save sessions into a searchable notes library, and open each entry in a detail screen with separate **Note** and **Transcript** views.
The app also includes integrated note transformation workflows powered by Apple Foundation Models, allowing users to rewrite recordings into formats like **Email**, **Prompt**, **List**, **Summary**, and **Meeting Notes**, with additional tone refinements such as **Professional**, **Casual**, **Shorter**, and **Clearer**.

---

### 🚀 Why WhisperNotes

- 🔒 Fully on-device capture, transcription, and refinement for maximum privacy
- ⚡ Fast voice-to-note workflow built for capturing ideas with minimal friction
- 🧠 AI-powered rewriting that transforms raw transcripts into polished output formats

---

## 📹 App Demo

[Watch Demo](https://drive.google.com/file/d/1h_8TwkOwn_NI9LJIcWRY2zcuQ7E6f87S/view?usp=sharing)

---

## ✨ Features

- 🎙️ **Real-time voice recording** with a focused, premium recording interface
- 📝 **Live speech-to-text transcription** powered by **Whisper** and **Core ML**
- 🌊 Animated **waveform visualization**, recording timer, pause/resume, stop, and discard controls
- 💾 Save recordings as structured notes with a dedicated **review flow**
- 🧠 **AI-powered note refinement** using **Apple Foundation Models**
- ✉️ Rewrite notes into formats like **Email**, **Prompt**, **List**, **Summary**, and **Meeting Notes**
- 🎛 Apply tone modifiers such as **Professional**, **Casual**, **Shorter**, and **Clearer**
- 📚 Browse saved notes in a polished **masonry-style notes library**
- 🔎 Search notes by **title**, **refined note text**, or **raw transcript**
- 📄 Open note details with separate **Note** and **Transcript** tabs
- 📋 Copy note content directly from the library and detail screens
- 🗑 Delete notes from both the notes grid and note detail screen
- 💾 Store notes, transcripts, durations, and refined output locally with **SwiftData**
- 🌙 Premium dark-first UI with custom editorial styling and native iOS interactions

---

## 🛠️ Tech Stack

iOS
- **SwiftUI**
- **SwiftData**
- **Observation (`@Observable`)**
- **UIKit** (clipboard and system interactions)

AI & Audio
- **Whisper**
- **Core ML**
- **Apple Intelligence / FoundationModels**
- **On-device speech processing pipeline**

Architecture & UI
- **MV-style state-driven screen models**
- **Native iOS design patterns**
- **SF Symbols**
- **Custom design system**

---

## 📄 Requirements

- Xcode 26+
- iOS 26.2+
- Microphone permission for recording and transcription features
- Apple Intelligence-supported device or simulator setup for AI note refinement features

---

## 🚀 Installation

1. Clone the repository.
2. Open `WhisperNotes.xcodeproj` in Xcode.
3. Build and run on an iPhone simulator or physical device.
4. Grant **microphone permission** to use live recording and transcription.
5. For AI note refinement, use an environment that supports **Apple Intelligence / FoundationModels**.

---

## 🧠 Notes

- Voice capture, transcription, and note refinement are designed to run **entirely on-device**.
- Notes are stored locally using **SwiftData**.
- Each saved entry keeps both a **raw transcript** and a **refined note representation**.
- If AI refinement is unavailable on the current device, the app still works as a full voice recording and note management experience.
