# Proaims - Jewelry E-Commerce Flutter App

A beautiful, modern Flutter e-commerce application for a jewelry collection store with dynamic API integration, featuring categories, products, collections, and live gold rate updates.

## 🎯 Features

- **Auto-Sliding Hero Carousel** - Beautiful banner carousel with automatic transitions every 3 seconds
- **Live Gold Rate Updates** - Real-time gold and 18-carat gold pricing with percentage change tracking
- **Dynamic Categories** - Fetches jewelry categories from API with images
- **Featured Products** - Auto-scrolling carousel showcasing latest products
- **Collections Grid** - 2x2 grid displaying product collections with discount badges
- **Custom Bottom Navigation** - 5-tab navigation bar for Home, Gallery, Rings, Products, and Profile
- **Responsive Design** - Optimized for Android and iOS platforms
- **Error Handling** - Graceful error states and loading indicators

## 📁 Project Structure

```
lib/
├── main.dart
├── pages/
│   └── home.dart
└── components/
    ├── app_bar.dart
    ├── hero_section.dart
    ├── price_rating_section.dart
    ├── categories_section.dart
    ├── featured_section.dart
    ├── collections_section.dart
    └── bottom_nav_bar.dart

assets/
├── Titleimage.png
└── Coins.png
```

## 🚀 Installation & Setup

### Prerequisites
- Flutter SDK 3.8.0 or higher
- Dart SDK
- Android Studio or Xcode (for emulator/device)

### Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/mohammedsinan33/proaims-project.git
   cd proaims
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Add assets**
   - Place `Titleimage.png` and `Coins.png` in the `assets/` folder

4. **Run the app**
   ```bash
   # On Android emulator
   flutter run
   
   # On specific device
   flutter run -d <device_id>
   ```

## 🔌 API Endpoints

| Endpoint | Purpose |
|----------|---------|
| `https://thangals.schemeapp.com/api/dashboard/2` | Fetch banner images and gold rates |
| `https://thangals.schemeapp.com/api/categoryList` | Fetch product categories and latest products |
| `https://thangals.schemeapp.com/api/AllProductList` | Fetch all products for collections |
| `https://thangals.schemeapp.com/storage/{image_name}` | Image storage base URL |

## 📱 Components Overview

### Hero Section
- Auto-sliding carousel with indicator dots
- Displays banner images from API
- 3-second auto-transition with smooth animations
- Full background image with text overlay

### Price Rating Section
- Real-time gold rate display (1 Gram & 18 Carat)
- Percentage change calculation with up/down indicators
- Today's system date display
- Coin imagery display
- Fetches data from dashboard API

### Categories Section
- Horizontal scrolling category list
- Fetches categories from API with images
- Click-ready navigation setup
- Loading and error states

### Featured Products Section
- Full-width auto-scrolling carousel
- One product per page with smooth transitions
- Product name, description, and star ratings
- Gradient overlay for text readability
- Fetches from categoryList API

### Collections Section
- 2x2 grid layout
- Product images with discount badges
- Forward navigation arrows
- Product details display
- Fetches from AllProductList API

### Bottom Navigation Bar
- 5 navigation tabs (Home, Gallery, Rings, Products, Profile)
- Active/inactive icon states
- Custom color scheme (Dark teal theme)
- Shadow effect

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  intl: ^0.19.0
  cupertino_icons: ^1.0.8
  flutter_svg: ^2.0.0
```

## ⚙️ Architecture

- **State Management**: StatefulWidget for components with data fetching
- **Data Models**: Structured JSON models for type safety
- **Async/Await**: HTTP calls with Future builders
- **Widget Composition**: Reusable, component-based architecture
- **Error Handling**: Try-catch with user-friendly error messages

## 🌐 Platform Support

- ✅ **Android** (Recommended - no CORS issues)
- ✅ **iOS**
- ⚠️ **Web** (Images blocked by CORS policy)

**Recommendation**: Test on Android emulator for best results with image loading.

## 🔄 How to Run on Android Emulator

1. **Open Android Studio**
   - Tools → Device Manager

2. **Create/Launch Emulator**
   - Create Device → Select Pixel 4 → API 30+ → Finish
   - Click Play icon to launch

3. **Run Flutter App**
   ```bash
   flutter run
   ```

## 🎨 Design Highlights

- Golden/tan color scheme (0xFFD4A574) for jewelry aesthetic
- Smooth animations and transitions
- Card-based layouts with shadows
- Responsive typography
- Gradient overlays for text readability
- Dark teal bottom navigation (0xFF0A372F)

## 📊 Data Flow

```
API → JSON Decode → Models → StatefulWidget → UI Update
```

## 🐛 Known Issues

- **Web Platform**: CORS blocks image loading from storage API
  - Solution: Use Android/iOS platforms or deploy with CORS headers
- **Image Loading**: Uses errorBuilder to show placeholder icon on CORS failures

## 🚀 Future Enhancements

- [ ] Product detail page navigation
- [ ] Shopping cart functionality
- [ ] User authentication
- [ ] Order history
- [ ] Wishlist feature
- [ ] Payment integration
- [ ] Search and filter
- [ ] User reviews and ratings
- [ ] Dark mode support
- [ ] Multi-language support

## 🔑 Key Features Implementation

### API Integration
- HTTP package for REST calls
- JSON parsing with dart:convert
- Error handling with try-catch blocks
- FutureBuilder for async operations

### State Management
- StatefulWidget for local state
- setState() for UI updates
- PageController for carousel management

### UI Components
- PageView for carousels
- GridView for collections
- ListView for horizontal scrolling
- Stack for overlays
- ClipRRect for rounded corners

## 📝 Environment Setup

The app uses:
- Flutter SDK: ^3.8.0
- Dart SDK: 3.8.0+

Verify your setup:
```bash
flutter doctor
flutter --version
dart --version
```

## 🔐 Security

- API endpoints use HTTPS
- No sensitive data stored locally
- Error messages sanitized for user display

## 📞 Support

For issues or questions, please:
1. Open an issue on [GitHub](https://github.com/mohammedsinan33/proaims-project)
2. Check existing issues for solutions
3. Provide detailed error messages and screenshots

## 👤 Author

- **Mohammed Sinan**
- GitHub: [@mohammedsinan33](https://github.com/mohammedsinan33)

## 📄 License

This project is open source and available under the MIT License.

## 🙏 Acknowledgments

- Thangals Jewelry API for data
- Flutter team for the amazing framework
- Material Design guidelines

---

**Last Updated**: June 22, 2026

**Happy Coding!** 💎 ✨
