# MySpendiOS
My Spend version para iOS con Core Data

Copyright 2025 Fabian Rodriguez Alvarez. Todos los derechos reservados.

Se creó una lista de tareas TODO, In progress y Done en Trello: https://trello.com/b/wJz1gcrI/myspend

<p>&nbsp;</p>


## Packages:

- [Firebase](#firebase)
- [Binding example](#binding-example)
- [Download Firebase Firestore Database](#download-firebase-firestore-database)
- [Outputs folder](#outputs-folder)

<p>&nbsp;</p>


## Firebase

Firebase is in charge of manage the Auth in app and the database using Firestore. Also the Crashlytics analyzer for crashes in the app the Analytic.

- **Guide to add Firebase:**
    * Add firebase dependecy with Swift Package Manager (Swift 3.0 or later): https://github.com/firebase/firebase-ios-sdk.git
    * Download from firebase and add `GoogleService-Info.plist` to the project.
    * Select the opciones: `FirebaseAuth`, `FireabaseFirestore`, `FirebaseCrashlytics`, `FirebaseAnalytics`.
    * In app initialization `MySpendApp`, add the `import Firebase` and `FirebaseApp.configure()`. File: [Source](https://github.com/fabianjra/MySpendiOS/blob/main/MySpend/MySpend/MySpendApp.swift)
    * For Crashlytics: In targets `MySpend` go to:
        - Tab `Build Settings` and change all `debug information format` from `DWARF` to `DWARF with dSSYM file`.
        - Tab `Build Phases` -> `+ > New Run Script Phase`.
            * In shell terminal add: `"${BUILD_DIR%/Build/*}/SourcePackages/checkouts/firebase-ios-sdk/Crashlytics/run"`
            * In `input files` add: `${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Resources/DWARF/${TARGET_NAME}`
            * In `input files` add: `$(SRCROOT)/$(BUILT_PRODUCTS_DIR)/$(INFOPLIST_PATH)`


<p>&nbsp;</p>


## Binding example:

```
struct TextFieldIconStyle: TextFieldStyle {
    
    @Binding private var text: String
    private let size: CGFloat
    
    public init(_ text: Binding<String>, size: CGFloat = FontSizes.body) {
        self._text = text
        self.size = size
    }
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        HStack {
            configuration
                .frame(height: Frames.textFieldHeight)
                .paddig()
        }
    }
}

struct TextFieldIconStyle_Previews: PreviewProvider {
    static var previews: some View {
        
        @State var text = ""

        TextField("", text: $text)
            .textFieldStyle(TextFieldIconStyle($text))
    }
}

```

## Download Firebase Firestore Database:

Firestore does not support exporting existing data to a file (JSON file).
Instructions to export the Firestore Data to JSON file using **NPM**:

1. Generate a private key file for your service account. In the Firebase console, open Settings > Service Accounts.
2. Click Generate New Private Key, then confirm by clicking Generate Key.
3. Store the JSON file containing the key.
4. Rename the JSON file to `credentials.json`.
5. Navigate to the folder that contains the credentials.json file and enter this code in console:
```
npx -p node-firestore-import-export firestore-export -a credentials.json -b backup.json
```
7. Follow the instructions prompted on your console.

Import data to Firestore using this command:
```
npx -p node-firestore-import-export firestore-import -a credentials.json -b backup.json
```

## Outputs folder:

Se agrega una carpeta de outputs folder por si Crashlytics necesita guardar archivos generados.

