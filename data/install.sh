#!/bin/bash
CURRENT_DIR=`pwd`
#安装nginx#######################################
NGINX=`which nginx`

if [ -z "${NGINX}" ]; then
        echo "安装nginx …… "

#       mv /etc/yum.repos.d/webtatic* /etc/yum.repos.d/bak

#       rpm -ivh http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm

#       yum install nginx -y
        echo "安装nginx的环境！！！"
        yum install mod_ssl.x86_64 -y
	yum -y install pcre-devel openssl openssl-devel

                if [ $? -eq 0 ];then
                        echo "nginx依赖环境安装成功！"
                else
                        echo "nginx依赖环境安装失败！"
                        exit
                fi
        echo "创建nginx启动帐号"
        useradd -s /sbin/nologin -r nginx

        echo "创建ningx日志目录"
        mkdir -p /data/nginx/log

                if [ -d /data/nginx/log ];then
                        echo "nginx日志目录创建成功"
                else
                        echo "nginx日志目录创建失败"
                        exit
                fi

        echo "开始编译安装Nginx"

	cd ${CURRENT_DIR}

        if [ -f "nginx.tgz" ];then
                echo "nginx安装包存在"
                tar -zxf nginx.tgz

		chown root:root nginx-1.12.1 -R

                        if [ "$?" -eq 0 ];then
                                echo "nginx权限修改成功"
                        else
                                echo "nginx权限修改失败"
                                exit
                        fi

                cd nginx-1.12.1

                ./configure --prefix=/etc/nginx --with-http_stub_status_module --with-http_ssl_module --with-stream

                        if [ $? -eq 0 ];then
                                echo "nginx编译成功"
                        else
                                echo "nginx编译失败"
                                exit
                        fi

                make && make install

                        if [ $? -eq 0 ];then
                                echo "nginx安装成功"
                        else
                                echo "nginx安装失败"
                                exit
                        fi
        else
                echo "nginx安装包不存在！"
                exit
        fi

        echo "复制优化版的配置文件"

	cd ..

        if [ -d "/root/data/nginx" ];then
                echo "nginx优化版目录存在"

                /bin/cp -rpf ${CURRENT_DIR}/nginx/* /etc/nginx/conf/
	#	/bin/cp -rpf ${CURRENT_DIR}/shkuangjing.com_bundle.crt /etc/pki/tls/certs/
         #       /bin/cp -rpf ${CURRENT_DIR}/shkuangjing.com.key /etc/pki/tls/certs/
        else
                echo "nginx优化版目录不存在"
                exit
        fi

        echo "/etc/nginx/sbin/nginx" >> /etc/rc.d/rc.local

        /etc/nginx/sbin/nginx

        if [ $? -eq 0 ];then
                echo "nginx启动成功！"
        else
                echo "nginx启动失败脚本终止！"
                exit
        fi

else
        echo "nginx 已经安装，已经重启！"
fi
#安装nginx完成###################################
