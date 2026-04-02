package com.kurt.bgmate

import android.app.Application
import coil3.ImageLoader
import coil3.SingletonImageLoader
import coil3.network.okhttp.OkHttpNetworkFetcherFactory
import coil3.request.crossfade
import dagger.hilt.android.HiltAndroidApp

@HiltAndroidApp
class BGMateApp : Application(), SingletonImageLoader.Factory {

    override fun newImageLoader(context: android.content.Context): ImageLoader =
        ImageLoader.Builder(context)
            .components { add(OkHttpNetworkFetcherFactory()) }
            .crossfade(true)
            .build()
}