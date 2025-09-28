# Poppins Font Files

To complete the font setup, download the following Poppins font files from Google Fonts:

1. **Poppins-Regular.ttf** - Regular weight (400)
2. **Poppins-Medium.ttf** - Medium weight (500) 
3. **Poppins-SemiBold.ttf** - SemiBold weight (600)
4. **Poppins-Bold.ttf** - Bold weight (700)

## Download Instructions:
1. Go to https://fonts.google.com/specimen/Poppins
2. Click "Download family"
3. Extract the zip file
4. Copy the following files to this directory:
   - Poppins-Regular.ttf
   - Poppins-Medium.ttf
   - Poppins-SemiBold.ttf
   - Poppins-Bold.ttf

## Alternative: Use Google Fonts Package
You can also use the `google_fonts` package instead of local font files:

```yaml
dependencies:
  google_fonts: ^6.1.0
```

Then update the theme to use:
```dart
fontFamily: GoogleFonts.poppins().fontFamily,
```
