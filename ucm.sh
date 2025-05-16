#!/bin/bash

echo "欢迎使用本项目，作者 酷安@浅笑科技"
echo "该脚本正在测试中，如若继续使用后出现的任何问题均与本作者无关（如系统损坏，数据丢失等）"

# 判断是否为root用户
if [ $(id -u) != "0" ]; then
    echo "请使用root用户运行此脚本！"
    exit 1
fi

# 询问用户是否继续使用本脚本
read -p "是否继续执行脚本？(y/n): " answer
answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')  # 统一转小写
if [[ "$answer" == "y" ]]; then
    echo "继续执行..."
    # 在此添加后续操作
elif [[ "$answer" == "n" ]]; then
    echo "操作已取消"
    exit 0
else
    echo "输入无效，请输入 y 或 n"
    exit 1
fi

# 判断系统架构是否为x86_64，如果不是则判断是否为x86，如果还不是则退出脚本
if [ $(uname -m) != "x86_64" ]; then
    if [ $(uname -m) != "x86" ]; then
        echo "此脚本仅支持x86_64和x86架构！"
        exit 1
    fi
fi

# 判断系统是否为ubuntu，不是则退出脚本
OS_NAME=$(grep '^NAME=' /etc/os-release | cut -d= -f2- | tr -d '"')
if [ "$OS_NAME" = "Ubuntu" ]; then
    echo "正在判断系统版本"
else
    echo "该系统不是 Ubuntu"
fi

# 判断软件源是否为DEB822格式
if [ -f "/etc/apt/sources.list.d/ubuntu.sources" ]; then
    echo "检测到sources文件，正在替换"
    # 创建备份文件
    # 判断备份文件是否存在，存在则跳过备份
    if [ -f "/etc/apt/sources.list.d/ubuntu.sources.bak" ]; then
        echo "备份文件已存在，跳过备份"
    else
        cp /etc/apt/sources.list.d/ubuntu.sources /etc/apt/sources.list.d/ubuntu.sources.bak
        echo "已创建备份文件 /etc/apt/sources.list.d/ubuntu.sources.bak"
    sed -i 's#^URIs: .*#URIs: https://mirrors.ustc.edu.cn/ubuntu/#' /etc/apt/sources.list.d/ubuntu.sources
    echo "执行完毕！"
    fi
else
    echo "未检测到sources文件，将使用传统方式替换"
    # 创建备份文件
    # 判断备份文件是否存在，存在则跳过备份
    if [ -f "/etc/apt/sources.list.bak" ]; then
        echo "备份文件已存在，跳过备份"
    else
        cp /etc/apt/sources.list /etc/apt/sources.list.bak
        echo "已创建备份文件 /etc/apt/sources.list.bak"
    fi
    # 获取版本代号
    VERSION_CODENAME=$(grep '^VERSION_CODENAME=' /etc/os-release | cut -d= -f2- | tr -d '"')
    wget -O /etc/apt/sources.list https://mirrors.ustc.edu.cn/repogen/conf/ubuntu-https-4-$VERSION_CODENAME
    echo "执行完毕！"
fi

# 更新软件源
echo "如果需要更新软件源，则运行sudo apt update"
echo "如果需要更新软件源并更新现有软件包，则运行sudo apt update && sudo apt upgrade"

# 结束
echo "感谢您的使用！"
