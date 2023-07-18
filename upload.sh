#!/bin/bash

# A Function to Send Posts to Telegram
telegram_message() {
	curl -s -X POST "https://api.telegram.org/bot${TG_TOKEN}/sendMessage" \
	-d chat_id="${TG_CHAT_ID}" \
	-d parse_mode="HTML" \
	-d text="$1"
}

for file in *.zip; do
    echo "Uploading ${file} ..."
    curl --upload-file ${file} https://transfer.sh/${file}

# Send the Message on Telegram
echo -e \
"
![ Infinix-X573 ](https://skyhuppa.files.wordpress.com/2023/07/infinix-x573.jpg?w=984)
📋 Kernel Builder

✅ Build Completed Successfully!

🔥 Build-CI: Github Runner
📱 Device: Infinix-X573
🖥 Kernel Verssion: 3.18.X
⬇️ Download: <a href=\"${https://oshi.at/_*}\">Here</a>
📅 Date: "$(date +%d\ %B\ %Y)"
⏱ Time: "$(date +%T)"
" > tg.html

TG_TEXT=$(< tg.html)

telegram_message "$TG_TEXT"

echo " "
    
done
