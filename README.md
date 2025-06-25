# MySpendiOS
My Spend version para iOS con Core Data

Copyright © 2025 Fabián Josué Rodríguez Álvarez. Todos los derechos reservados.

Se creó una lista de tareas TODO, In progress y Done en Trello: https://trello.com/b/wJz1gcrI/myspend

<p>&nbsp;</p>


## Main:

- [Firebase](#firebase)
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


## Errors FAQ:

1. Could not get GOOGLE_APP_ID in Google Services file from build environment

- R:
If you use Xcode 15 (beta as of 2023), you might have updated your project with ENABLE_USER_SCRIPT_SANDBOXING.
The default is YES, and this will cause the issue with Crashlytics during archive.
Go to Build Settings > User Script Sandboxing > Set to No.

Esto es un parche, aunque se deberian crear variables de entorno y por ambiente separados.
More info: https://stackoverflow.com/questions/57006663/could-not-get-google-app-id-in-google-services-file-from-build-environment

2. DEBUG_INFORMATION_FORMAT should be set to dwarf-with-dsym for all configurations

- R: Los settings de compilación deberían estar configurados para generar archivos dSYM usando el formato dwarf-with-dsym.

2.1 Unable to process MySpend.app.dSYM

- R: Crashlytics no encontró el archivo .dSYM donde lo esperaba, entonces no puede subir los símbolos necesarios.

- Solución para 2 y 2.1:

```
Ve a tu target principal → Build Settings.
Busca: Debug Information Format
Asegúrate que en Debug y Release esté en DWARF with dSYM File.

Ubicación de la fase del script:

En Build Phases, asegúrate que el script de Crashlytics esté al final de todos los scripts de build.
Si tienes otros scripts que muevan archivos .dSYM, pon el de Firebase al final.
```
