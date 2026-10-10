#!/data/data/com.termux/files/usr/bin/bash
# ═══════════════════════════════════════════════════════════
#   Mikrotik Router Test — Auto Installer
# ═══════════════════════════════════════════════════════════

echo -e "\033[96m═══════════════════════════════════════════════\033[0m"
echo -e "\033[96m      Mikrotik Router Test — Installer        \033[0m"
echo -e "\033[96m═══════════════════════════════════════════════\033[0m"

echo -e "\n\033[92m[*] mikrotik_voucher အား ထည့်သွင်းနေပါသည်...\033[0m"

# ─── ၀။ Storage access ───
echo -e "\033[94m[*] Storage permission တောင်းခံနေသည်...\033[0m"
termux-setup-storage
sleep 2

# ─── ၁။ လိုအပ်တဲ့ Python နဲ့ Library တွေ သွင်းမယ် ───
echo -e "\033[94m[*] Packages update လုပ်နေသည်...\033[0m"
pkg update && pkg upgrade -y

echo -e "\033[94m[*] Python + Termux:API + Tools သွင်းနေသည်...\033[0m"
pkg install -y python python-dev pip termux-api curl wget openssl libffi

echo -e "\033[94m[*] Python packages သွင်းနေသည်...\033[0m"
pip install --upgrade pip
pip install requests aiohttp

# ─── ၂။ Folder အဟောင်းရှိရင် ဖျက်ပြီး အသစ်ဆောက်မယ် ───
rm -rf ~/mkmk
mkdir -p ~/mkmk
cd ~/mkmk

# ─── ၃။ ဖုန်းရဲ့ Bit (Architecture) ကို စစ်ဆေးမယ် ───
ARCH=$(getprop ro.product.cpu.abi)

if [ "$ARCH" = "arm64-v8a" ]; then
    echo -e "\033[94m[*] 64-bit ဖုန်းဖြစ်ကြောင်း စစ်ဆေးတွေ့ရှိရသဖြင့် 64-bit version ကို ဒေါင်းလုဒ်ဆွဲနေသည်...\033[0m"
    curl -LO https://raw.githubusercontent.com/myominhtet114789-byte/new_mk/main/new_mk_64bit.so
    if [ -f "new_mk_64bit.so" ]; then
        mv new_mk_64bit.so new_mk.so
        echo -e "\033[92m[✔] 64-bit → new_mk.so ပြောင်းပြီးပါပြီ\033[0m"
    else
        echo -e "\033[91m[✘] new_mk_64bit.so ဒေါင်းလုဒ် မအောင်မြင်ပါ\033[0m"
    fi
else
    echo -e "\033[94m[*] 32-bit ဖုန်းဖြစ်ကြောင်း စစ်ဆေးတွေ့ရှိရသဖြင့် 32-bit version ကို ဒေါင်းလုဒ်ဆွဲနေသည်...\033[0m"
    curl -LO https://raw.githubusercontent.com/myominhtet114789-byte/new_mk/main/new_mk_32bit.so
    if [ -f "new_mk_32bit.so" ]; then
        mv new_mk_32bit.so new_mk.so
        echo -e "\033[92m[✔] 32-bit → new_mk.so ပြောင်းပြီးပါပြီ\033[0m"
    else
        echo -e "\033[91m[✘] new_mk_32bit.so ဒေါင်းလုဒ် မအောင်မြင်ပါ\033[0m"
    fi
fi

# ─── ၄။ Starter ဖိုင်ကို ဒေါင်းမယ် ───
curl -LO https://raw.githubusercontent.com/myominhtet114789-byte/new_mk/main/new_mk_run.py

# ─── ၅။ Verify ───
echo -e "\n\033[94m[*] ဖိုင်များ စစ်ဆေးနေသည်...\033[0m"
ls -lh ~/mkmk/

if [ -f "$HOME/mkmk/new_mk.so" ]; then
    echo -e "\033[92m[✔] အောင်မြင်စွာ ထည့်သွင်းပြီးပါပြီ!\033[0m"
    echo -e "\033[93mအသုံးပြုရန်: cd ~/mkmk && python new_mk_run.py\033[0m"
else
    echo -e "\033[91m[✘] new_mk.so မရှိပါ။ ပြန်စမ်းပါ။\033[0m"
fi
