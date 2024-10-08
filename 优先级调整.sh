#!/system/bin/sh
date="$( date "+%Y年%m月%d日%H时%M分%S秒")"
#通过获取系统最近使用的应用进程并对该应用CPU频率、进程优先级、I/O优先级及CPU核心调整优先提高其性能、关屏不运行
while true; do
screen_status=$(dumpsys window | grep "mScreenOn" | grep true)
if [[ "${screen_status}" ]]; then
echo "$date *📲- 亮屏运行*"
namaapk=$(dumpsys activity recents | grep 'Recent #0:' | awk -F= '{print $2}' | awk '{print $1}')
p=$(pgrep -f $namaapk | head -n 1)
echo "$date *🔨- 已获取进程$namaapk并调整renice、ionice、taskset和chrt优先级*" 
    renice -n -20 -p "$p" || echo "$date *⚠️- renice失败*"
    ionice -c 1 -n 0 -p "$p" || echo "$date *⚠️- ionice失败*"
    taskset -c 0-7 -p "$p" || echo "$date *⚠️- taskset失败*"
    chrt -f -p 1 "$p" || echo "$date *⚠️- chrt失败*"
else
echo "$date *📵- 暗屏状态，跳过优化*"
fi
sleep 10
done
