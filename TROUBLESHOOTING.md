# Troubleshooting Guide

## Common Issues and Solutions

### App Issues

#### App Won't Start
**Symptoms**: App crashes on launch, shows error screen

**Solutions**:
1. **Check Firebase Configuration**
   - Verify `google-services.json` (Android) is in `android/app/`
   - Verify `GoogleService-Info.plist` (iOS) is in Xcode
   - Check Firebase project is active

2. **Clear Cache**
   ```bash
   flutter clean
   flutter pub get
   ```

3. **Check Logs**
   ```bash
   flutter run -v
   ```

4. **Verify Permissions**
   - Android: Check `AndroidManifest.xml`
   - iOS: Check `Info.plist`

---

#### App Force Closes
**Symptoms**: App works initially but crashes randomly

**Solutions**:
1. **Check Memory**
   ```bash
   flutter run --profile
   # Use DevTools memory profiler
   ```

2. **Enable Stack Trace**
   ```bash
   flutter run -v
   ```

3. **Check Unhandled Exceptions**
   - Add logging to catch blocks
   - Review error logs in Firebase

---

#### App Slow/Laggy
**Symptoms**: Frame drops, jank, slow response

**Solutions**:
1. **Profile Performance**
   ```bash
   flutter run --profile
   ```

2. **Optimize Rebuilds**
   - Wrap widgets with `const`
   - Use `StreamBuilder` or `GetBuilder`
   - Avoid rebuilding entire list

3. **Reduce Database Queries**
   - Cache frequently accessed data
   - Use `snapshots()` for real-time updates
   - Implement pagination for large lists

---

### Authentication Issues

#### Can't Sign Up
**Symptoms**: Sign up fails, user not created

**Solutions**:
1. **Check Internet Connection**
   ```bash
   ping google.com
   ```

2. **Verify Email Format**
   - Use valid email: user@example.com
   - Check for typos

3. **Check Password Requirements**
   - Minimum 6 characters
   - Firebase rules in console

4. **Check Firestore Rules**
   ```
   // Allow user creation
   match /users/{userId} {
     allow create: if request.auth.uid == userId;
   }
   ```

5. **Enable Email/Password Auth**
   - Go to Firebase Console → Authentication → Sign-in method
   - Enable Email/Password

---

#### Can't Log In
**Symptoms**: Login fails, wrong password error

**Solutions**:
1. **Check Email Registered**
   - Sign up if account doesn't exist
   - Check email spelling

2. **Reset Password**
   - Use forgot password feature
   - Check email for reset link

3. **Check Firebase Connection**
   - Verify internet
   - Check Firebase status

4. **Clear Cache**
   ```bash
   flutter clean
   ```

---

#### User Profile Missing
**Symptoms**: User logged in but profile empty

**Solutions**:
1. **Check Firestore Rules**
   ```
   match /users/{userId} {
     allow read: if request.auth.uid == userId;
   }
   ```

2. **Verify Document Created**
   - Check Firestore Console
   - Look for `users/{uid}` document

3. **Re-create Profile**
   - Log out and log in
   - Update profile in settings

---

### Sensor Issues

#### Sensors Not Detected
**Symptoms**: No acceleration/rotation data

**Solutions**:
1. **Check Device Sensors**
   - Go to Settings → About → Sensors test (Android)
   - Not all emulators have sensors

2. **Grant Permissions**
   - Android: BODY_SENSORS permission
   - iOS: Motion & Fitness in Settings

3. **Verify sensors_plus Package**
   ```bash
   flutter pub add sensors_plus
   ```

4. **Check Emulator Configuration**
   ```bash
   # For Android Emulator
   emulator -avd <device> -qemu -M machine=type -m 1024 -c 2
   ```

---

#### Sensor Data Inaccurate
**Symptoms**: Impact detection inconsistent, wrong values

**Solutions**:
1. **Calibrate Sensors**
   - Rotate device in circle slowly
   - Wait for sensors to stabilize

2. **Adjust Threshold**
   - Go to Settings → Sensor Settings
   - Increase/decrease impact threshold

3. **Check Placement**
   - Device should be stable
   - Not held in hand during test

4. **Verify Algorithm**
   - Check impact force calculation
   - Review debounce settings (500ms)

---

### Location Issues

#### GPS Not Working
**Symptoms**: Location always null, coordinates (0,0)

**Solutions**:
1. **Enable Location Services**
   - Android: Settings → Location
   - iOS: Settings → Privacy → Location Services

2. **Grant Permissions**
   - Android: Fine/Coarse Location permissions
   - iOS: When in use / Always permissions

3. **Check GPS Signal**
   - Move to outdoor area
   - Wait 30-60 seconds for fix
   - Check in settings

4. **Verify Location Service**
   ```dart
   final enabled = await LocationService().isLocationServiceEnabled();
   ```

5. **Check Timeout**
   - Increase timeout from 10s to 20s
   - Modify in `app_config.dart`

---

#### Location Shows Old Data
**Symptoms**: Location not updating in real-time

**Solutions**:
1. **Stop and Restart Monitoring**
   - Toggle monitoring off/on
   - Forces location refresh

2. **Check Accuracy**
   - Large accuracy means less precise
   - Try outdoor location

3. **Verify Location Stream**
   ```dart
   locationService.getLocationStream().listen((location) {
     print('New location: $location');
   });
   ```

---

### Notification Issues

#### Notifications Not Showing
**Symptoms**: No notification alerts on accident detection

**Solutions**:
1. **Check Permissions**
   - Android: POST_NOTIFICATIONS permission
   - iOS: Settings → Notifications → Accident Detection

2. **Enable Notifications**
   - Go to Settings → Notifications
   - Toggle notifications ON

3. **Check Channel Configuration**
   - Verify notification channels created
   - Check in Firebase Console

4. **Check Device Settings**
   - Android: Settings → Apps → Notifications
   - iOS: Settings → Notifications → Accident Detection

5. **Test Manually**
   ```dart
   await NotificationService.sendGeneralNotification(
     title: 'Test',
     body: 'Test notification'
   );
   ```

---

#### SMS Not Sending
**Symptoms**: Emergency contacts not getting SMS

**Solutions**:
1. **Check Phone Permissions**
   - Android: SEND_SMS permission granted
   - iOS: Messages app configured

2. **Verify Phone Numbers**
   - Valid format: +1 (123) 456-7890
   - International format supported

3. **Check Carrier Limits**
   - Some carriers block mass SMS
   - Verify not hitting rate limits

4. **Test SMS Manually**
   ```dart
   await NotificationService.sendSMS(
     '+1234567890',
     'Test message'
   );
   ```

---

### Database Issues

#### Data Not Saving
**Symptoms**: Create/update operations fail silently

**Solutions**:
1. **Check Firestore Rules**
   ```
   match /{document=**} {
     allow read, write: if request.auth != null;
   }
   ```

2. **Verify Authentication**
   - User must be logged in
   - Check Auth.currentUser not null

3. **Check Collection Names**
   - Correct: `users`, `emergency_contacts`, `accident_reports`
   - Must match in code and Firestore

4. **Check Field Types**
   - Ensure field types match schema
   - Check for required fields

5. **Enable Offline Persistence**
   ```dart
   FirebaseFirestore.instance.settings = 
     Settings(persistenceEnabled: true);
   ```

---

#### Queries Slow
**Symptoms**: Data retrieval takes > 2 seconds

**Solutions**:
1. **Create Firestore Indexes**
   - Firebase Console → Firestore → Indexes
   - Create indexes for frequently queried fields

2. **Limit Document Size**
   - Keep documents < 1MB
   - Move large fields to subcollections

3. **Use Pagination**
   ```dart
   query.limit(20).get(); // Get first 20
   query.startAfter([lastDoc]).limit(20); // Get next 20
   ```

4. **Optimize Query**
   - Filter before sorting
   - Use composite indexes

---

### Firebase Issues

#### Firebase Connection Failed
**Symptoms**: "Failed to connect to Firebase Network error"

**Solutions**:
1. **Check Internet**
   - WiFi or mobile data enabled
   - Test connectivity: ping google.com

2. **Check Firebase Status**
   - Visit https://status.firebase.google.com/
   - Check for outages

3. **Verify Firebase Rules**
   - Firestore rules too restrictive
   - Allow anonymous reads for testing

4. **Check Credentials**
   - `google-services.json` correct
   - `GoogleService-Info.plist` correct

---

#### Too Many Requests Error
**Symptoms**: "Too many requests" error after repeated attempts

**Solutions**:
1. **Wait Before Retry**
   - Implement exponential backoff
   - Recommended: 1s, 2s, 4s

2. **Reduce Query Frequency**
   - Check for duplicate queries
   - Implement caching

3. **Check Rate Limits**
   - Firestore free tier: 50K reads/day
   - Upgrade if necessary

---

### Performance Issues

#### High Battery Usage
**Symptoms**: Battery drains quickly

**Solutions**:
1. **Disable Monitoring**
   -  Turn off accident monitoring when not needed
   - Reduces sensor polling

2. **Reduce Update Frequency**
   - Modify `app_config.dart`: `recordFrequencyMs`
   - Default: 100ms → increase to 200ms

3. **Disable Background Location**
   - Stop location updates when app in background
   - Use requestAlwaysLocationPermission only when needed

4. **Profile Battery Usage**
   ```bash
   flutter run --profile
   # Enable battery profiler in DevTools
   ```

---

#### High Data Usage
**Symptoms**: Excessive mobile data consumption

**Solutions**:
1. **Compress Data**
   - Use short field names
   - Optimize image sizes

2. **Reduce Update Frequency**
   - Less frequent sensor updates
   - Batch database updates

3. **Implement Caching**
   - Cache frequently accessed data
   - Reduce repeated queries

---

## Getting Help

### Before Asking for Help
1. Check this troubleshooting guide
2. Search documentation
3. Review error logs
4. Check Firebase Console
5. Test on different device/emulator

### Collecting Diagnostic Information
```bash
# Collect flutter info
flutter doctor -v

# Collect app logs
flutter run -v > logs.txt 2>&1

# Check device logs (Android)
adb logcat | grep "flutter"

# Check device logs (iOS)
xcrun simctldiagnosticsprofile show com.example.app
```

### Report Format
Include:
1. Device/emulator name and OS version
2. Flutter version: `flutter --version`
3. Complete error message
4. Steps to reproduce
5. Screenshots/logs if applicable

---

## Quick Fix Checklist

- [ ] Clear cache: `flutter clean && flutter pub get`
- [ ] Check internet connection
- [ ] Verify Firebase configuration
- [ ] Check app permissions
- [ ] Update dependencies: `flutter pub upgrade`
- [ ] Restart device/emulator
- [ ] Check Firebase Console
- [ ] Review error logs with `-v` flag
- [ ] Test on different device
- [ ] Check for updates

---

## Still Having Issues?

If you've tried all troubleshooting steps:
1. Gather diagnostic information above
2. Check project documentation
3. Review Firebase documentation
4. Post on Flutter forums
5. File issue on GitHub with details
