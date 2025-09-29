import com.android.build.api.dsl.ApplicationExtension
import java.util.*

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "me.bhaad.taskit"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_21.toString()
    }

    defaultConfig {
        applicationId = "me.bhaad.taskit"
        minSdk = project.findProperty("flutter.minSdkVersion")?.toString()?.toInt() ?: 24
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner" // Added for Espresso
    }

    signingConfigs {
        create("release") {
            storeFile = file("taskit-release.keystore")
            storePassword = "@nshul@12"
            keyAlias = "taskit-key-alias"
            keyPassword = "@nshul@12"
        }
    }

    buildTypes {
        getByName("release") {
            isShrinkResources = true
            isMinifyEnabled = true // ← must be true if shrinkResources is true
            signingConfig = signingConfigs.getByName("release")
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }

        getByName("debug") {
            signingConfig = signingConfigs.getByName("debug")
            applicationIdSuffix = ".debug"
            isDebuggable = true
        }
    }

    // Customize APK output file names
    android.applicationVariants.all {
        outputs.forEach { output ->
            val buildTypeName = buildType.name
            val apkName = if (buildTypeName == "debug") {
                "taskit-debug.apk"
            } else {
                "taskit-release.apk"
            }

            // Cast to InternalArtifactType to access outputFileName
            (output as com.android.build.gradle.internal.api.BaseVariantOutputImpl).outputFileName = apkName
        }
    }

    // Add test options for Espresso
    testOptions {
        unitTests.isReturnDefaultValues = true
        animationsDisabled = true // Disable animations for reliable testing
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib:1.9.22")
    // Test dependencies for Espresso
    androidTestImplementation("androidx.test.espresso:espresso-core:3.5.1")
    androidTestImplementation("androidx.test:runner:1.5.2")
    androidTestImplementation("androidx.test.espresso:espresso-intents:3.5.1")

    // JUnit runner
    androidTestImplementation("androidx.test.ext:junit:1.1.5")

    // ActivityScenarioRule
    androidTestImplementation("androidx.test:core:1.5.0")

    // Intent validation
    androidTestImplementation("androidx.test.espresso:espresso-intents:3.5.1")

    // Kotlin test support
    androidTestImplementation("org.jetbrains.kotlin:kotlin-test-junit:1.9.10")

    androidTestImplementation("androidx.test.uiautomator:uiautomator:2.2.0")
}