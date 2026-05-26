# Keep Flutter embedding and plugin registration classes used by the app and plugins.
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-dontwarn io.flutter.embedding.**
-dontwarn io.flutter.plugin.**

# Keep Firebase / Google Play services reflection-heavy metadata commonly used by plugins.
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes EnclosingMethod

# Add app-specific keep rules here if a plugin requires them.

