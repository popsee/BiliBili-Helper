{
    "biliVerify": {
        "biliCookies": "buvid3=2DC1B34D-30C6-55C3-7DFD-418A7619F41520737infoc; b_nut=1668217920; CURRENT_FNVAL=4048; theme_style=light; fingerprint=60bec3e91146d71f5d265affc4918f62; buvid_fp=217C26B3-833D-98EB-9758-D0A7D47DFC6D11550infoc; buvid_fp_plain=undefined; SESSDATA=cf0387a7,1683769939,a0415*b2; bili_jct=a9fa6f2cf4ffad3c50dda506ae93a896; DedeUserID=612548877; DedeUserID__ckMd5=bc22cebef858672d; sid=8rh0jxic; b_lsid=58B5AEE1_184699066C9; nostalgia_conf=-1; innersign=0; i-wanna-go-back=-1; b_ut=5"
    },
    "taskConfig": {
        "skipDailyTask": false,
        "matchGame": false,
        "showHandModel": false,
        "predictNumberOfCoins": 1,
        "minimumNumberOfCoins": 100,
        "taskIntervalTime": 8,
        "numberOfCoins": 5,
        "coinAddPriority": 1,
        "reserveCoins": 10,
        "selectLike": 1,
        "monthEndAutoCharge": true,
        "giveGift": true,
        "silver2Coin": true,
        "upLive": "0",
        "chargeForLove": "382666849",
        "chargeDay": 11,
        "devicePlatform": "ios",
        "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Version/14.0 Safari/537.36"
    },
    "pushConfig": {
        "SC_KEY": "",
        "SCT_KEY": "",
        "TG_BOT_TOKEN": "5250809169:AAFcfyeZHMF_oYDm15DDu2kMIacI9wIEjBc",
        "TG_USER_ID": "1892620917",
        "TG_USE_CUSTOM_URL": false,
        "DING_TALK_URL": "",
        "DING_TALK_SECRET": "",
        "PUSH_PLUS_TOKEN": "8390a9964ea64f10b1a038af6bd77f54",
        "WE_COM_GROUP_TOKEN": "",
        "WE_COM_APP_CORPID": "",
        "WE_COM_APP_CORP_SECRET": "",
        "WE_COM_APP_AGENT_ID": 0,
        "WE_COM_APP_TO_USER": "",
        "WE_COM_APP_MEDIA_ID": "",
        "PROXY_HTTP_HOST": "",
        "PROXY_SOCKET_HOST": "",
        "PROXY_PORT": 0
    }
}










https://raw.githubusercontent.com/popsee/BILIBILI-HELPER/main/bilibili_helper.sh



#!/usr/bin/env bash
#new Env('BILIBILI-HELPER');

if ! [ -x "$(command -v java)" ]; then
    echo "开始安装Java运行环境........."
    apk update
    apk add openjdk8
fi
if [ ! -d "/ql/scripts/bilibili/" ]; then
    mkdir /ql/scripts/bilibili
fi
cd bilibili
if [ -f "/tmp/bili-helper.log" ]; then
    VERSION=$(grep "当前版本" "/tmp/bili-helper.log" | awk '{print $2}')
else
    VERSION="0"
fi
echo "当前版本:"$VERSION
latest=$(curl -s https://api.github.com/repos/popsee/BILIBILI-HELPER/releases/latest)

latest_VERSION=$(echo $latest | jq '.tag_name' | sed 's/v\|"//g')
echo "最新版本:"$latest_VERSION
download_url=$(echo $latest | jq '.assets[0].browser_download_url' | sed 's/"//g')
download() {
    curl -L -o "./BILIBILI-HELPER.zip" "https://ghproxy.com/$download_url"
    mkdir ./tmp
    echo "正在解压文件......."
    unzip -o -d ./tmp/ BILIBILI-HELPER.zip
    cp -f ./tmp/BILIBILI-HELPER*.jar BILIBILI-HELPER.jar
    if [ ! -f "/ql/config/config.json" ]; then
        echo "配置文件不存在。"
        cp -f ./tmp/config.json /ql/config/config.json
    fi
    echo "清除缓存........."
    rm -rf tmp
    rm -rf BILIBILI-HELPER.zip
    echo "更新完成"
}
function version_lt() { test "$(echo "$@" | tr " " "\n" | sort -rV | head -n 1)" != "$1"; }
if version_lt $VERSION $latest_VERSION; then
    echo "有新版本，开始更新"
    download
else
    echo "已经是最新版本，不需要更新！！！"
fi
if [ ! -f "/ql/scripts/bilibili/BILIBILI-HELPER.jar" ]; then
    echo "没找到BILIBILI-HELPER.jar，开始下载.........."
    download
fi
files=$(ls /ql/config/*.json)
for file_name in $files; do
    if [[ $file_name != *auth* ]]; then
        echo "配置文件路径:"$file_name
        java -jar BILIBILI-HELPER.jar $file_name
    fi
done
