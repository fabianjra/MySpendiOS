# My Spend: Version for iOS

mySpend es una app que te ayuda a controlar tus finazas.


<p>&nbsp;</p>


## Packages:

- [Key: Firebase](#firebase)


<p>&nbsp;</p>


## Firebase

Firebase is in charge of manage the Auth in app and the database using Firestore. Also the Crashlytics analyzer for crashes in the app the Analytic.

**Guide to add Firebase:**
    - 1: Add firebase dependecy with Swift Package Manager (Swift 3.0 or later): https://github.com/firebase/firebase-ios-sdk.git
    - 2: Download from firebase and add `GoogleService-Info.plist` to the project.
    - 3: Select the opciones: `FirebaseAuth`, `FireabaseFirestore`, `FirebaseCrashlytics`, `FirebaseAnalytics`
    - 4: In app initialization `MySpendApp`, add the `import Firebase` and `FirebaseApp.configure()`. File: [Source]()
    - 5: For Crashlytics: In targets `MySpend` go to:
        * 5.1: Tab `Build Settings` and change all `debug information format` from `DWARF` to `DWARF with dSSYM file`.
        * 5.2: Tab `Build Phases` -> `+ > New Run Script Phase`.
            - 5.2.1: In shell terminal add: `"${BUILD_DIR%/Build/*}/SourcePackages/checkouts/firebase-ios-sdk/Crashlytics/run"`
            - 5.2.2: In `input files` add: `${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Resources/DWARF/${TARGET_NAME}`
            - 5.2.3: In `input files` add: `$(SRCROOT)/$(BUILT_PRODUCTS_DIR)/$(INFOPLIST_PATH)`
