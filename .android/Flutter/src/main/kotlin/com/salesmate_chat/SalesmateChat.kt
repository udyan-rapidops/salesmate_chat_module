package com.salesmate_chat

import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.embedding.engine.loader.FlutterLoader
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlin.coroutines.resume


class SalesmateChat {

    companion object {
        private const val FLUTTER_ENGINE_CACHE = "salesmate_chat_engine"
        private const val METHOD_CHANNEL_NAME = "salesmate_chat_module"

        private val engineCache = FlutterEngineCache.getInstance()

        private inline fun withEngine(action: (FlutterEngine) -> Unit) {
            engineCache.get(FLUTTER_ENGINE_CACHE)?.let(action)
        }

        private suspend fun <T> invokeMethodWithResultSuspend(
            methodName: String, arguments: Any? = null, defaultValue: T
        ): T = suspendCancellableCoroutine { cont ->
            withEngine { engine ->
                MethodChannel(
                    engine.dartExecutor.binaryMessenger, METHOD_CHANNEL_NAME
                ).invokeMethod(methodName, arguments, object : MethodChannel.Result {
                    @Suppress("UNCHECKED_CAST")
                    override fun success(response: Any?) {
                        cont.resume(response as? T ?: defaultValue)
                    }

                    override fun error(code: String, msg: String?, details: Any?) {
                        cont.resume(defaultValue)
                    }

                    override fun notImplemented() {
                        cont.resume(defaultValue)
                    }
                })
            }
        }

        private fun invokeMethod(methodName: String, arguments: Any? = null) {
            withEngine { engine ->
                MethodChannel(
                    engine.dartExecutor.binaryMessenger, METHOD_CHANNEL_NAME
                ).invokeMethod(methodName, arguments)
            }
        }

        @JvmStatic
        fun initialize(context: Context, settings: SalesmateChatSettings) {
            FlutterLoader().apply {
                startInitialization(context.applicationContext)
                ensureInitializationComplete(context.applicationContext, null)
            }

            val flutterEngine = FlutterEngine(context).apply {
                dartExecutor.executeDartEntrypoint(
                    DartExecutor.DartEntrypoint.createDefault()
                )
            }

            engineCache.put(FLUTTER_ENGINE_CACHE, flutterEngine)

            invokeMethod("initializeSalesmateChatSDK", settings.toMap())
        }

        @JvmStatic
        fun launchApp(context: Context) {
            context.startActivity(
                FlutterActivity.withCachedEngine(FLUTTER_ENGINE_CACHE).build(context)
            )
        }

        @JvmStatic
        fun startMessenger() {
            invokeMethod("startMessenger")
        }

        suspend fun isInitialised(): Boolean {
            return invokeMethodWithResultSuspend("isInitialised", null, false)
        }

        suspend fun getVisitorId(): String {
            return invokeMethodWithResultSuspend("getVisitorId", null, "")
        }

        suspend fun getUserHash(): String {
            return invokeMethodWithResultSuspend("getUserHash", null, "")
        }


        @JvmStatic
        fun login(userId: String, userDetails: UserDetails) {
            val params = mapOf("userId" to userId, "userDetails" to userDetails.toMap())
            invokeMethod("login", params)
        }

        @JvmStatic
        fun logout() {
            invokeMethod("logout")
        }

        @JvmStatic
        fun updateUser(userId: String, userDetails: UserDetails) {
            val params = mapOf("userId" to userId, "userDetails" to userDetails.toMap())
            invokeMethod("updateUser", params)
        }

        @JvmStatic
        fun recordEvent(eventName: String, data: Map<String, Any>) {
            val params = mapOf("eventName" to eventName, "data" to data)
            invokeMethod("recordEvent", params)
        }

        @JvmStatic
        fun logDebug(message: String) {
            invokeMethod("logDebug", message)
        }

        @JvmStatic
        fun sendTokenToSalesmate(deviceToken: String) {
            invokeMethod("sendTokenToSalesmate", deviceToken)
        }

        @JvmStatic
        suspend fun isSalesmateChatSDKPush(valueMap: Map<String, Any>): Boolean {
            return invokeMethodWithResultSuspend("isSalesmateChatSDKPush", valueMap, false)
        }

        @JvmStatic
        fun handleSalesmateChatSDKPush(valueMap: Map<String, Any>) {
            invokeMethod("handleSalesmateChatSDKPush", valueMap)
        }
    }
}