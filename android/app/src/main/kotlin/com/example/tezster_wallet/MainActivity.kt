package com.naan

import androidx.annotation.NonNull
import com.example.tezster_wallet.BeaconPlugin
import io.flutter.Log
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.runBlocking
import org.json.JSONObject
import kotlin.concurrent.thread
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant;

class MainActivity : FlutterFragmentActivity() {

    // override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    //     GeneratedPluginRegistrant.registerWith(flutterEngine)
    // }

    var TAG = "MainActivity"

    var methodChannel = "com.beacon_flutter/beacon"
    var eventChannel = "com.beacon_flutter/beaconEvent"

    var beaconPlugin: BeaconPlugin? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

//        applicationContext.let {
//            BeaconApp.create(it)
//            logInfo(BeaconInitProvider.TAG, "BeaconApp created")
//        } ?: run {
//            logInfo(BeaconInitProvider.TAG, "BeaconApp could not be created")
//        }

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, eventChannel).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, eventSink: EventChannel.EventSink) {
                    BeaconPlugin.callback = {
                        runOnUiThread {
                            eventSink.success(it)
                        }
                        Log.i(TAG, "Got call back from plugin")
                    }
                }

                override fun onCancel(p0: Any) {

                }
            })

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            methodChannel
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "startBeacon" -> {
                    beaconPlugin = BeaconPlugin(call.arguments.toString())
                    runBlocking {
                        beaconPlugin?.startBeacon()
                    }

                    print("Beacon sdk started...")
//                    Log.d(TAG, call.arguments.toString())
                    result.success(1)
                }
                "addPeer" -> {
                    val id: String? = call.argument<String>("id")
                    val name: String? = call.argument<String>("name")
                    val publicKey: String? = call.argument<String>("publicKey")
                    val relayServer: String? = call.argument<String>("relayServer")
                    val version: String? = call.argument<String>("version")

                    thread {
                        beaconPlugin?.addPeer(id!!, name!!, publicKey!!, relayServer!!, version!!)
                    }
//                    Log.d(TAG, call.arguments.toString())
                    result.success(1)
                }
                "pair" -> {
                    val uri: String? = call.argument<String>("uri")
                    thread {
                        beaconPlugin?.pair(uri!!);
                    }
                }
                "respond" -> {
                    thread {
                        beaconPlugin?.respondExample(
                            Integer.parseInt(
                                call.argument<String>("result").toString()
                            ),
                            call.argument<String>("opHash").toString(),
                            call.argument<String>("accountAddress").toString()
                        )
                    }
                    result.success(1)
                }
                else -> result.notImplemented()
            }
        }
    }
}
