plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

val deviceTestKeystorePath = System.getenv("DEVICE_TEST_KEYSTORE_PATH")
    ?.takeIf { it.isNotBlank() }
val deviceTestStorePassword = System.getenv("DEVICE_TEST_STORE_PASSWORD")
val deviceTestKeyAlias = System.getenv("DEVICE_TEST_KEY_ALIAS")
val deviceTestKeyPassword = System.getenv("DEVICE_TEST_KEY_PASSWORD")

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
            // Production signing is intentionally not wired to the public
            // device-test key. A separate private Play signing setup will be
            // configured before release.
            signingConfig = null
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
