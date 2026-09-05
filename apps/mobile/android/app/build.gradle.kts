plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

// google_mobile_ads currently pulls an older WorkManager runtime on Android.
// Android 16 release-mode crashes have been reproduced upstream with that
// combination. Pin the current stable runtime so AndroidX Startup can create
// WorkDatabase safely before Flutter starts.
dependencies {
    implementation("androidx.work:work-runtime:2.11.2")
}

val deviceTestKeystorePath = System.getenv("DEVICE_TEST_KEYSTORE_PATH")
    ?.takeIf { it.isNotBlank() }
val deviceTestStorePassword = System.getenv("DEVICE_TEST_STORE_PASSWORD")
val deviceTestKeyAlias = System.getenv("DEVICE_TEST_KEY_ALIAS")
val deviceTestKeyPassword = System.getenv("DEVICE_TEST_KEY_PASSWORD")

val playUploadKeystorePath = System.getenv("PLAY_UPLOAD_KEYSTORE_PATH")
    ?.takeIf { it.isNotBlank() }
val playUploadStorePassword = System.getenv("PLAY_UPLOAD_STORE_PASSWORD")
val playUploadKeyAlias = System.getenv("PLAY_UPLOAD_KEY_ALIAS")
val playUploadKeyPassword = System.getenv("PLAY_UPLOAD_KEY_PASSWORD")

val admobAppId = System.getenv("ADMOB_APP_ID")
    ?.takeIf { it.isNotBlank() }
    ?: "ca-app-pub-3940256099942544~3347511713"

android {
    namespace = "com.zmilastudio.takipanalizi"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.zmilastudio.takipanalizi"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["admobAppId"] = admobAppId
    }

    signingConfigs {
        if (deviceTestKeystorePath != null) {
            create("deviceTest") {
                storeFile = file(deviceTestKeystorePath)
                storePassword = requireNotNull(deviceTestStorePassword) {
                    "DEVICE_TEST_STORE_PASSWORD is required for device-test signing"
                }
                keyAlias = requireNotNull(deviceTestKeyAlias) {
                    "DEVICE_TEST_KEY_ALIAS is required for device-test signing"
                }
                keyPassword = requireNotNull(deviceTestKeyPassword) {
                    "DEVICE_TEST_KEY_PASSWORD is required for device-test signing"
                }
            }
        }

        if (playUploadKeystorePath != null) {
            create("playUpload") {
                storeFile = file(playUploadKeystorePath)
                storePassword = requireNotNull(playUploadStorePassword) {
                    "PLAY_UPLOAD_STORE_PASSWORD is required for production signing"
                }
                keyAlias = requireNotNull(playUploadKeyAlias) {
                    "PLAY_UPLOAD_KEY_ALIAS is required for production signing"
                }
                keyPassword = requireNotNull(playUploadKeyPassword) {
                    "PLAY_UPLOAD_KEY_PASSWORD is required for production signing"
                }
            }
        }
    }

    buildTypes {
        debug {
            // Device-test builds always use a separate package id. When the
            // dedicated keystore environment is present, bind the APK to the
            // exact stable device-test signing key instead of Gradle's default
            // per-run debug key.
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            if (deviceTestKeystorePath != null) {
                signingConfig = signingConfigs.getByName("deviceTest")
            }
        }
        release {
            // Production signing is isolated from the public device-test key.
            // A release is signed only when the private Play upload-key
            // environment is explicitly provided by a secure CI/local setup.
            signingConfig = if (playUploadKeystorePath != null) {
                signingConfigs.getByName("playUpload")
            } else {
                null
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
