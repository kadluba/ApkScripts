# ApkScripts

Two perl scripts for static analysis of Android app files (APK) to find potentially dangerous permissions and API calls.

## License

The script is licensed under the MIT License. You can find the license text in the LICENSE file.

## apkperm.pl

Usage: perl apkperm.pl <apk-file>

Extracts the AndroidManifest.xml from a given APK and searches for "dangerous" permissions.

External dependencies: aapt

## apkapi.pl

Usage: perl apkapi.pl <apk-file>

Extracts the apk and decompiles (baksmali) the program from a given APK. Then searches for calls of "dangerous" APIs in the decompiled source.

External dependencies: apktool, apktool.jar
