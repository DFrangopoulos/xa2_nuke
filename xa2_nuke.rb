#!/usr/bin/env ruby

require 'net/http'

puts "Welcome to the Android debloater for the Sony XA2!"

a_string = `adb shell pm list packages -u | cut -d':' -f2 | sort -u`

all_packages = a_string.clone.split(/\n/)

puts all_packages.length.to_s + " packages found!"

safe_packs = Array.new

puts "Asking google which packages are on the app store!"
all_packages.each do |package|
	
	#Skip Album/Music
	next if package.match("com.sonyericsson.album")
	next if package.match("com.sonyericsson.music")

	#Kill facebook packages
	safe_packs.push(package) if package.match("facebook")
	#Kill deprecated xperialounge
	safe_packs.push(package) if package.match("com.sonymobile.xperialounge.services")
	safe_packs.push(package) if package.match("com.sonyericsson.xhs")
	#Kill useless app that needs google
	safe_packs.push(package) if package.match("com.sony.tvsideview")
	#Kill apps that are not needed
	safe_packs.push(package) if package.match("email")
	safe_packs.push(package) if package.match("com.sonymobile.moviecreator")
	safe_packs.push(package) if package.match("com.sonyericsson.textinput.chinese")
	#Kill swiftkey
	safe_packs.push(package) if package.match("swiftkey")
	
	#Stuff that is present on the play store and can be removed super safely
	uri = URI("https://play.google.com/store/apps/details?id=#{package}")
	#if the play store doesn't have the app it returns 404
	safe_packs.push(package) if Net::HTTP.get_response(uri).is_a?(Net::HTTPSuccess)

end

to_delete = safe_packs.uniq

to_delete.each do |delete|

	puts "Removing " + delete
	result = ` adb shell pm uninstall --user 0 #{delete}`
	puts result

end

#Download Signal 
`wget https://updates.signal.org/android/Signal-website-universal-release-4.71.5.apk`
`adb install Signal-website-universal-release-4.71.5.apk`

#Download Firefox
`wget https://download-installer.cdn.mozilla.net/pub/mobile/releases/68.11.0/android-api-16/multi/fennec-68.11.0.multi.android-arm.apk`
`adb install fennec-68.11.0.multi.android-arm.apk`

#Download Maps
`wget https://download.osmand.net/releases/net.osmand-3.7.4-374.apk`
`adb install net.osmand-3.7.4-374.apk`

#Download a Keyboard
`wget https://github.com/dslul/openboard/releases/download/v1.4/app-release.apk`
`adb install app-release.apk`

#Download a VLC
`wget https://get.videolan.org/vlc-android/3.2.11/VLC-Android-3.2.11-arm64-v8a.apk`
`adb install VLC-Android-3.2.11-arm64-v8a.apk`
