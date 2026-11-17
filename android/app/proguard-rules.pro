# ProGuard rules for TaskIt
# ML Kit GenAI Prompt API
-keep class com.google.mlkit.genai.** { *; }
-keep interface com.google.mlkit.genai.** { *; }

# Keep data models used in reflection or serialization
-keepclassmembers class * {
    @com.google.mlkit.genai.prompt.** *;
}
