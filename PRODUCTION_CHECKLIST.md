# Production Checklist

## Before Building for Production

### 1. Security Review
- [ ] Verify all API keys and credentials are in Firebase config files only
- [ ] Review Firestore security rules in Firebase Console
- [ ] Ensure no hardcoded secrets in code
- [ ] Check database rules for unauthorized access
- [ ] Review authentication settings (enable only needed providers)
- [ ] Verify email verification is enabled
- [ ] Test JWT token expiration handling

### 2. Code Quality
- [ ] Run `dart analyze` - no errors
- [ ] Run `flutter analyze` - no warnings
- [ ] Code review for all custom services
- [ ] Verify all error messages are user-friendly
- [ ] Check for null safety violations
- [ ] Review all async operations for proper error handling
- [ ] Remove all debug print statements
- [ ] Remove test data and mock calls

### 3. Testing
- [ ] Unit tests pass
- [ ] Widget tests pass
- [ ] Integration tests on real device
- [ ] Manual testing on multiple devices
- [ ] Test on different Android versions (5.0+)
- [ ] Test on different iOS versions (11.0+)
- [ ] Test network connectivity handling
- [ ] Test offline functionality
- [ ] Test GPS without location permissions
- [ ] Test with sensors disabled
- [ ] Test SMS with invalid number

### 4. Performance
- [ ] App starts in < 3 seconds
- [ ] Sensor monitoring uses < 5% CPU
- [ ] GPS tracking uses < 10% battery
- [ ] Database operations complete in < 2 seconds
- [ ] Notifications send within 5 seconds
- [ ] Memory usage stays < 100MB
- [ ] No memory leaks detected

### 5. Permissions & Privacy
- [ ] All required permissions documented
- [ ] Privacy policy page implemented
- [ ] Terms & conditions page implemented
- [ ] GDPR compliance verified
- [ ] Data retention policy in place
- [ ] User consent obtained for features
- [ ] Permission requests show clear reasons

### 6. Localization & Accessibility
- [ ] App supports multiple languages (optional)
- [ ] Accessibility labels on all buttons
- [ ] Font sizes are readable (minimum 12pt)
- [ ] Color contrast meets WCAG AA standard
- [ ] Keyboard navigation works
- [ ] Screen reader compatible

### 7. Platform-Specific Checks

#### Android
- [ ] API level 24+ (Android 7.0+)
- [ ] compileSdkVersion 34+
- [ ] targetSdkVersion 34
- [ ] Background execution policy compliant
- [ ] REQUEST_FOREGROUND_SERVICE_CAMERA permission if needed
- [ ] google-services.json in correct location
- [ ] Signing certificate configured
- [ ] App not debuggable in release build

#### iOS
- [ ] iOS 11.0+ minimum support
- [ ] Add GoogleService-Info.plist to Xcode
- [ ] Review Info.plist permissions
- [ ] Certificate and provisioning profile valid
- [ ] Background modes configured
- [ ] Push notification certificate uploaded

### 8. Firebase Configuration
- [ ] Firebase project created
- [ ] Firestore database in production mode
- [ ] Security rules reviewed and tested
- [ ] Firebase Authentication enabled
- [ ] Email verification enabled
- [ ] Password reset configured
- [ ] Firebase Storage (if used) configured
- [ ] Cloud Messaging (if used) configured
- [ ] Firestore indexes created for queries
- [ ] Backup policies configured

### 9. Build Configuration
- [ ] buildNumber incremented
- [ ] Version number updated (semantic versioning)
- [ ] Release notes prepared
- [ ] Changelog updated
- [ ] build.gradle.kts tested
- [ ] Proguard rules configured (Android)
- [ ] Strip unused resources enabled

### 10. Store Submission

#### Google Play Store
- [ ] Content rating form completed
- [ ] Target audience identified
- [ ] Screenshots prepared (min 2, max 8)
- [ ] Description written (max 4000 chars)
- [ ] Privacy policy URL provided
- [ ] App category selected
- [ ] Release notes written
- [ ] Pricing configured
- [ ] Payment methods setup (if applicable)
- [ ] APK built with `flutter build apk --release`
- [ ] App signed properly

#### Apple App Store
- [ ] App description written (max 4000 chars)
- [ ] Keywords added (max 100 chars)
- [ ] Support URL provided
- [ ] Privacy policy URL provided
- [ ] Category selected
- [ ] Screenshots prepared for all devices
- [ ] Preview video prepared (optional)
- [ ] Release notes written
- [ ] IPA built with `flutter build ios --release`

### 11. Monitoring & Analytics (Recommended)
- [ ] Firebase Analytics configured
- [ ] Crash reporting enabled
- [ ] Performance monitoring setup
- [ ] Custom events tracked
- [ ] User engagement metrics defined

### 12. Deployment
- [ ] Staging environment tested
- [ ] Database backup created
- [ ] Rollback plan prepared
- [ ] Support team notified
- [ ] Post-launch monitoring setup
- [ ] User support channels active

## Pre-Release Testing Checklist

```bash
# Run these commands before release
flutter clean
flutter pub get
flutter analyze
flutter test
flutter build apk --release
flutter build ios --release
```

## Post-Release Actions

- [ ] Monitor crash reports daily for first week
- [ ] Monitor user feedback in store reviews
- [ ] Track user retention metrics
- [ ] Monitor performance metrics
- [ ] Be ready for quick fixes/hotfixes
- [ ] Set up automated monitoring alerts
- [ ] Plan for update schedule

## Sign-Off

**Checklist Completed By**: ___________________
**Date**: ___________________
**Ready for Release**: [ ] Yes [ ] No

**Notes**:
_________________________________________________________________
_________________________________________________________________
_________________________________________________________________
