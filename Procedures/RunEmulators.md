# Running Firebase Emulators

## Installation

Refer to Firebase notes at [Run functions locally](https://firebase.google.com/docs/functions/local-emulator).

1. Install [JDK 11 or higher](https://www.oracle.com/java/technologies/javase/jdk14-archive-downloads.html).  NOTE: Installing anything other than the JDK 14 seems to require an Oracle account and was not working at the time of writing.
2. Install Node.js 10.18.1 for the project with `nodenv install 10.18.1`.
3. Create a [Google Cloud Platform service account](https://console.cloud.google.com/iam-admin/serviceaccounts) and download the `.json` file. Put it in the `scratch` directory or other location that will not be put in version control.
4. Assign the service account the **Editor** role so it has permissions to work.
5. Add a user in the app using the service account email and a dummy password.
6. Ensure running `firebase-tools` 8.5 or higher.
7. Export the environment variable `export GOOGLE_APPLICATION_CREDENTIALS=<path-to-json-key>`
8. Compile the code locally with `npm run build`
9. Run `firebase emulators:start`.
10. Browse to the two URL's to monitor storage and functions.

## Usage

Instrument your app or website to use the emulator. See [Connect your app and start prototyping](https://firebase.google.com/docs/emulator-suite/connect_and_prototype)

For example, use the `.env` file and a variable `REACT_APP_USE_FUNCTIONS_EMULATOR` and point it to `http://localhost:5001` or wherever the Emulator says your endpoint is running.