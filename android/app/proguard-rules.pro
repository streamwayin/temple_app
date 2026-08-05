# smart_auth (pulled in by google_sign_in_android / pinput) references the
# deprecated Smart Lock for Passwords credentials API, which Google removed
# from newer play-services-auth releases. The plugin ships no consumer rules
# for this, so R8 fails outright unless we tell it these classes are optional.
-dontwarn com.google.android.gms.auth.api.credentials.**
