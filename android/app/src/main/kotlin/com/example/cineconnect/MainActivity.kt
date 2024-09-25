package com.example.cineconnect

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import okhttp3.*
import okhttp3.OkHttpClient
import okhttp3.HttpUrl.Companion.toHttpUrl
import okhttp3.dnsoverhttps.DnsOverHttps
import java.net.InetAddress
import java.io.IOException

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.cineconnect/api"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "makeGetRequest") {
                val url = call.argument<String>("url")
                val headers = call.argument<Map<String, String>>("headers") // Retrieve headers
                if (url != null) {
                    ApiClient().makeGetRequest(
                        url,
                        headers ?: emptyMap()
                    ) { response, error -> // Pass headers to ApiClient
                        if (error != null) {
                            result.error("API_ERROR", error, null)
                        } else {
                            result.success(response)
                        }
                    }
                } else {
                    result.error("INVALID_ARGUMENT", "URL not provided", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}


class ApiClient {

    // Custom extension function to configure OkHttp with Cloudflare DNS over HTTPS (DoH)
    fun OkHttpClient.Builder.dohCloudflare(): OkHttpClient.Builder = this.dns(
        DnsOverHttps.Builder().client(this.build())
            .url("https://cloudflare-dns.com/dns-query".toHttpUrl())
            .bootstrapDnsHosts(
                InetAddress.getByName("162.159.36.1"),
                InetAddress.getByName("162.159.46.1"),
                InetAddress.getByName("1.1.1.1"),
                InetAddress.getByName("1.0.0.1"),
                InetAddress.getByName("162.159.132.53"),
                InetAddress.getByName("2606:4700:4700::1111"),
                InetAddress.getByName("2606:4700:4700::1001"),
                InetAddress.getByName("2606:4700:4700::0064"),
                InetAddress.getByName("2606:4700:4700::6400")
            )
            .build()
    )

    // Initialize OkHttp client with Cloudflare DoH
    private val client = OkHttpClient.Builder()
        .dohCloudflare() // Use the custom extension function to set up DoH with Cloudflare
        .build()

    // Add header support
    fun makeGetRequest(
        url: String,
        headers: Map<String, String>,
        result: (String?, String?) -> Unit
    ) {
        val builder = okhttp3.Request.Builder().url(url)

        // Add headers to the request
        for ((key, value) in headers) {
            builder.addHeader(key, value)
        }

        val request = builder.build()

        client.newCall(request).enqueue(object : okhttp3.Callback {
            override fun onFailure(call: okhttp3.Call, e: java.io.IOException) {
                result(null, e.message)
            }

            override fun onResponse(call: okhttp3.Call, response: okhttp3.Response) {
                if (!response.isSuccessful) {
                    result(null, response.message)
                    return
                }
                response.body?.string()?.let {
                    result(it, null)
                }
            }
        })
    }
}






