#!/system/bin/sh
date="$( date "+%Y年%m月%d日%H时%M分%S秒")"
#获取屏幕正在运行的应用匹配进程，提取出第一个进程ID，通过调整其进程的优先级、IO优先级以及CPU核心绑定，提高其在系统中的运行性能、关屏不运行
while true; do
cd ${MODDIR}/ll/log
log
screen_status=$(dumpsys window | grep "mScreenOn" | grep true)
if [[ "${screen_status}" ]]; then
    echo "$date *📲亮屏运行*" >>进程.log
    namaapk=$(dumpsys activity recents | grep 'Recent #0:' | awk -F= '{print $2}' | awk '{print $1}')
    p=$(pgrep -f "$namaapk" | head -n 1)
	echo "$date *🔨- 已获取进程$namaapk并调整renice、ionice、taskset和chrt优先级*" 
    renice -n -20 -p $p
    ionice -c 1 -n 0 -p $p 
    taskset -c 0,1,2,3,4,5,6,7 -p $p
    taskset -c 0-7 -p $p
    taskset -c 0-7 $p
    taskset -cp 0-7 $p
    taskset -ap 00ff $p
    chrt -f -p 1 $p 
    chrt -fp 1 $p 
fi
sleep 60
done
