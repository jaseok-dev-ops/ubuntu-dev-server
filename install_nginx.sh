#!/bin/bash

# NGINX Media Server installation script
# by JASEOK DEV OPS

# Make sure only root can run this script
# make sure this script is running as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo "Starting NGINX media server installation..."

echo "REQUIRED - Enter the FQDN or domain of this server (i.e. some.domain.com)"
read -e -p "DOMAIN: " domain
history -s "$domain"

echo "REQUIRED - full system path for your SSL certificate file (full chain)"
read -e -p "CERTIFICATE PATH: " cp
history -s "$cp"

certpem=${cp//\//\\\/}

echo "REQUIRED - full system path for your SSL certificate key file"
read -e -p "CERTIFICATE KEY PATH: " ck
history -s "$ck"

certkey=${ck//\//\\\/}

# set the current working directory variable
CURRENT_PATH=$(pwd)
INSTALL_PATH=$CURRENT_PATH/nginx-install

# add the nginx user and 
useradd -r -s /bin/false nginx

# create and cd to installation directory
mkdir $INSTALL_PATH
cd $INSTALL_PATH

# make sure we are updated
dnf update -y
dnf makecache --refresh

# download dependencies
dnf install geoip geoip-devel openssl openssl-devel sox -y

wget https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.40/pcre2-10.40.tar.gz
tar -zxf pcre2-10.40.tar.gz
cd pcre2-10.40
./configure
make
make install
cd $INSTALL_PATH

wget https://zlib.net/zlib-1.2.13.tar.gz
tar -zxf zlib-1.2.13.tar.gz
cd zlib-1.2.13
./configure
make
make install
cd $INSTALL_PATH

# download and expand NGINX source files
wget https://nginx.org/download/nginx-1.22.1.tar.gz
tar zxf nginx-1.22.1.tar.gz
rm -f nginx-1.22.1.tar.gz

# download NGINX RTMP module
wget https://github.com/arut/nginx-rtmp-module/archive/refs/tags/v1.2.2.tar.gz
tar zxf v1.2.2.tar.gz
rm -f v1.2.2.tar.gz

# download kaltura VOD module
wget https://github.com/kaltura/nginx-vod-module/archive/refs/tags/1.31.tar.gz
tar zxf 1.31.tar.gz
rm -f 1.31.tar.gz

# download multi part upload module
wget https://github.com/vkholodkov/nginx-upload-module/archive/refs/tags/2.3.0.tar.gz
tar zxf 2.3.0.tar.gz
rm -f 2.3.0.tar.gz

# download upload progress module
wget https://github.com/masterzen/nginx-upload-progress-module/archive/refs/tags/v0.9.2.tar.gz
tar zxf v0.9.2.tar.gz
rm -f v0.9.2.tar.gz

# download new nchan push stream module
wget https://github.com/slact/nchan/archive/refs/tags/v1.3.6.tar.gz
tar zxf v1.3.6.tar.gz
rm -f v1.3.6.tar.gz

# configure the build
cd $INSTALL_PATH/nginx-1.22.1

./configure \
--prefix=/etc/nginx \
--conf-path=/etc/nginx/nginx.conf \
--sbin-path=/usr/local/bin/nginx \
--pid-path=/var/run/nginx/nginx.pid \
--user=nginx \
--group=nginx \
--with-pcre=../pcre2-10.40 \
--with-zlib=../zlib-1.2.13 \
--with-http_ssl_module \
--with-http_ssl_module \
--with-http_addition_module \
--with-http_geoip_module \
--with-http_gunzip_module \
--with-http_gzip_static_module \
--with-http_mp4_module \
--with-http_secure_link_module \
--with-http_v2_module \
--with-file-aio \
--with-http_stub_status_module \
--with-stream \
--with-stream_ssl_module \
--with-threads \
--add-module=$INSTALL_PATH/nginx-rtmp-module-1.2.2 \
--add-module=$INSTALL_PATH/nginx-vod-module-1.31 \
--add-module=$INSTALL_PATH/nginx-upload-module-2.3.0 \
--add-module=$INSTALL_PATH/nginx-upload-progress-module-0.9.2 \
--add-module=$INSTALL_PATH/nginx-upload-progress-module-0.9.2 \
--add-module=$INSTALL_PATH/nchan-1.3.6

# start the build
make
make install

echo "Adding required ports to firewall"
firewall-cmd --add-port=1935/tcp --zone=public --permanent
firewall-cmd --add-port=80/tcp --zone=public --permanent
firewall-cmd --add-port=443/tcp --zone=public --permanent
firewall-cmd --add-service=http --zone=public --permanent
firewall-cmd --add-service=https --zone=public --permanent
firewall-cmd --reload

cd $CURRENT_PATH
rm -rf $INSTALL_PATH

mkdir -p /var/{www/vhosts/$domain/public,log/nginx}
mkdir -p /tmp/{hls/$domain,dash/$domain}
echo "This is $domain media server - Fueled by JASEOK" >> /var/www/vhosts/$domain/public/index.html
mkdir -p /etc/nginx/{sites-available,sites-enabled}
rm -f /etc/nginx/nginx.conf

echo 'user nginx nginx;
worker_processes  2;

events {
    worker_connections  1024;
}

rtmp_auto_push on;

http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;
    gzip  on;
    server_names_hash_bucket_size 128;
	
    include /etc/nginx/sites-enabled/*;
}

rtmp {
    server {
        listen 1935;
        chunk_size 4000;

        # TV mode: one publisher, many subscribers
        application mytv {

            # enable live streaming
            # live on;

            # record first 1K of stream
            # record all;
            # record_path /tmp/av;
            # record_max_size 1K;

            # append current timestamp to each flv
            # record_unique on;

            # publish only from localhost
            # allow publish 127.0.0.1;
            # deny publish all;

            # allow play all;
        }

        # Transcoding (ffmpeg needed)
        application big {
            # live on;

            # On every pusblished stream run this command (ffmpeg)
            # with substitutions: $app/${app}, $name/${name} for application & stream name.
            #
            # This ffmpeg call receives stream from this application &
            # reduces the resolution down to 32x32. The stream is the published to
            # 'small' application (see below) under the same name.
            #
            # ffmpeg can do anything with the stream like video/audio
            # transcoding, resizing, altering container/codec params etc
            #
            # Multiple exec lines can be specified.

            # exec ffmpeg -re -i rtmp://replace_domain:1935/$app/$name -vcodec flv -acodec copy -s 32x32 -f flv rtmp://domain:1935/small/${name};
        }

        application small {
            # live on;
            # Video with reduced resolution comes here from ffmpeg
        }

        application webcam {
            # live on;

            # Stream from local webcam
            # exec_static ffmpeg -f video4linux2 -i /dev/video0 -c:v libx264 -an -f flv rtmp://localhost:1935/webcam/mystream;
        }

        application mypush {
            # live on;

            # Every stream published here
            # is automatically pushed to
            # these two machines
            # push rtmp1.example.com;
            # push rtmp2.example.com:1934;
        }

        application mypull {
            # live on;

            # Pull all streams from remote machine
            # and play locally
            # pull rtmp://rtmp3.example.com pageUrl=www.example.com/index.html;
        }

        application mystaticpull {
            # live on;

            # Static pull is started at nginx start
            # pull rtmp://rtmp4.example.com pageUrl=www.example.com/index.html name=mystream static;
        }

        # video on demand
        application vod {
            play /var/flvs;
        }

        application vod2 {
            play /var/mp4s;
        }

        # Many publishers, many subscribers
        # no checks, no recording
        application videochat {

            live on;

            # The following notifications receive all
            # the session variables as well as
            # particular call arguments in HTTP POST
            # request

            # Make HTTP request & use HTTP retcode
            # to decide whether to allow publishing
            # from this connection or not
            # on_publish http://localhost:8080/publish;

            # Same with playing
            # on_play http://localhost:8080/play;

            # Publish/play end (repeats on disconnect)
            # on_done http://localhost:8080/done;

            # All above mentioned notifications receive
            # standard connect() arguments as well as
            # play/publish ones. If any arguments are sent
            # with GET-style syntax to play & publish
            # these are also included.
            # Example URL:
            #   rtmp://localhost/myapp/mystream?a=b&c=d

            # record 10 video keyframes (no audio) every 2 minutes
            record keyframes;
            record_path /tmp/vc;
            record_max_frames 10;
            record_interval 2m;

            # Async notify about an flv recorded
            # on_record_done http://localhost:8080/record_done;

        }


        # HLS

        # For HLS to work please create a directory in tmpfs (/tmp/hls here)
        # for the fragments. The directory contents is served via HTTP (see
        # http{} section in config)
        #
        # Incoming stream must be in H264/AAC. For iPhones use baseline H264
        # profile (see ffmpeg example).
        # This example creates RTMP stream from movie ready for HLS:
        #
        # ffmpeg -loglevel verbose -re -i movie.avi  -vcodec libx264
        #    -vprofile baseline -acodec libmp3lame -ar 44100 -ac 1
        #    -f flv rtmp://localhost:1935/hls/movie
        #
        # If you need to transcode live stream use 'exec' feature.
        #
        application live-hls {
            live on;
            hls on;
            hls_path /tmp/hls;
        }

        # MPEG-DASH is similar to HLS

        application live-dash {
            live on;
            dash on;
            dash_path /tmp/dash;
        }
    }
}

' >> /etc/nginx/nginx.conf

cp $CURRENT_PATH/nginx-site.conf.template /etc/nginx/sites-available/$domain.conf

ln -s /etc/nginx/sites-available/$domain.conf /etc/nginx/sites-enabled/$domain.conf

sed -i 's/replace_domain/'"$domain"'/g' /etc/nginx/sites-available/$domain.conf
sed -i 's/replace_cert_pem/'"$certpem"'/g' /etc/nginx/sites-available/$domain.conf
sed -i 's/replace_cert_key/'"$certkey"'/g' /etc/nginx/sites-available/$domain.conf

# set permissions
chown -R nginx:nginx /var/www/vhosts
chown -R nginx:nginx /var/log/nginx
chown -R nginx:nginx /tmp/hls/$domain
chown -R nginx:nginx /tmp/dash/$domain
chmod -R 755 /var/www/vhosts
chmod -R 755 /var/log/nginx
chmod -R 755 /tmp/hls/$domain
chmod -R 755 /tmp/dash/$domain

echo '[Unit]
Description=The NGINX HTTP RTMP and reverse proxy server
After=syslog.target network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target

[Service]
Type=forking
PIDFile=/run/nginx/nginx.pid
ExecStartPre=/usr/local/bin/nginx -t
ExecStart=/usr/local/bin/nginx
ExecReload=/usr/local/bin/nginx -s reload
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
' >> /lib/systemd/system/nginx.service

systemctl daemon-reload
systemctl start nginx
systemctl enable nginx

echo "NGINX Media Server installation complete."