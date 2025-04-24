# 🔮 Trivisio

**Trivisio** is a Flutter-based AI image generation app that lets users enter a text prompt and generate **3 unique images**, each powered by a different cutting-edge model from Hugging Face. From imagination to visual art — instantly.

---

## 🚀 Features

- ✨ **Generate 3 AI Images** per Prompt — each from a different model
- 🤖 **Powered by Hugging Face AI Models**:
  - `Stable Diffusion 3.5 Large`
  - `Flux1`
  - `Flux Stendle`
- 🔐 Firebase Authentication (Email/Password)
- ☁️ Firebase Firestore to store user data and prompt history
- 📸 Save Generated Images to Device
- 📤 Share Images via Social Media or Messaging Apps
- 🕓 View Prompt History and Regenerate Images
- 🧑‍🎨 Smooth and Clean UI for a Seamless Experience

---

## 🧠 How It Works

1. User logs in using Firebase Authentication.
2. Enters a creative text prompt.
3. The app sends the prompt to **3 different Hugging Face models**.
4. Each model generates **1 unique image**.
5. User can:
   - View and compare all 3 images
   - Save to device
   - Share directly
   - Regenerate with a tap
   - Browse past prompts in history

---

## 🔧 Tech Stack

### 🛠️ Framework
- **Flutter** (Dart)

### 🧠 AI Models via Hugging Face
- `Stable Diffusion 3.5 Large`
- `Flux1`
- `Flux Stendle`

### 🔥 Backend
- **Firebase**:
  - Authentication
  - Firestore Database
  - (Optional) Firebase Storage

### 📦 Key Packages
- `http` – for REST API calls
- `firebase_auth`, `cloud_firestore`, `firebase_core`
- `cached_network_image` – for smooth image loading
- `image_picker`, `share_plus`, `path_provider` – for saving and sharing
- `flutter_spinkit`, `lottie` – for animations and UI polish

---

## 📸 Screenshots

| Prompt Input | AI Results | Save & Share |
|--------------|------------|--------------|
| ![Prompt](assets/screens/prompt.png) | ![Images](assets/screens/results.png) | ![Share](assets/screens/share.png) |

---

## 📲 Getting Started

### 1. Clone the Repository

```bash
git clone [https://github.com/your-username](https://github.com/sneh1604/Trivisio)/Trivisio.git
cd Trivisio
