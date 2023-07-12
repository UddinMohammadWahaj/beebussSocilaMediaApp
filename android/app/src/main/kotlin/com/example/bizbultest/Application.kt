package com.example.bizbultest


//import me.carda.awesome_notifications.AwesomeNotificationsPlugin;
import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundExecutor
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingPlugin
import io.flutter.plugins.pathprovider.PathProviderPlugin


class MyApplication : FlutterApplication(), PluginRegistrantCallback {

    override
    fun onCreate() {
        super.onCreate()
        
        //FlutterFirebaseMessagingBackgroundService.setPluginRegistrant(this)
        //FlutterFirebaseMessagingBackgroundExecutor.setPluginRegistrant(this)
    }

    override
    fun registerWith(registry: PluginRegistry) {
        PathProviderPlugin.registerWith(registry.registrarFor("io.flutter.plugins.pathprovider.PathProviderPlugin"))
       // FlutterLocalNotificationsPlugin.registerWith(registry.registrarFor("com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin"))
        //FlutterFirebaseMessagingPlugin.registerWith(registry.registrarFor("plugins.flutter.io/firebase_messaging"))
       // AwesomeNotificationsPlugin.registerWith(registry.registrarFor("me.carda.awesome_notifications.AwesomeNotificationsPlugin"))
        }
}