#!/bin/sh
sed -i "s#\(port\).*#\1=$STORAGE_PORT#" /etc/fdfs/storage.conf
sed -i "s#\(group_name\).*#\1=$GROUP_NAME#" /etc/fdfs/storage.conf
sed -i "s#\(base_path\).*#\1=$STORAGE_BASE_PATH#" /etc/fdfs/storage.conf
sed -i "s#\(store_path0\).*#\1=$STORAGE_PATH0#" /etc/fdfs/storage.conf
sed -i "s#\(tracker_server\).*#\1=$TRACKER_SERVER#" /etc/fdfs/storage.conf
sed -i "s#\(http.server_port\).*#\1=$HTTP_SERVER_PORT#" /etc/fdfs/storage.conf

sed -i "s#\(base_path\).*#\1=$STORAGE_BASE_PATH#" /etc/fdfs/mod_fastdfs.conf
sed -i "s#\(store_path0\).*#\1=$STORAGE_PATH0#" /etc/fdfs/mod_fastdfs.conf
sed -i "s#\(storage_server_port\).*#\1=$STORAGE_PORT#" /etc/fdfs/mod_fastdfs.conf
sed -i "s#\(tracker_server\).*#\1=$TRACKER_SERVER#" /etc/fdfs/mod_fastdfs.conf
sed -i "s#\(group_name\).*#\1=$GROUP_NAME#" /etc/fdfs/mod_fastdfs.conf
sed -i "s#\(group_count\).*#\1=$GROUP_COUNT#" /etc/fdfs/mod_fastdfs.conf
sed -i "s#\(http.server_port\).*#\1=$HTTP_SERVER_PORT#" /etc/fdfs/mod_fastdfs.conf
sed -i "s#\(url_have_group_name\).*#\1=true#" /etc/fdfs/mod_fastdfs.conf

sed -i "s#\(http.anti_steal.check_token\).*#\1=$CHECK_TOKEN#" /etc/fdfs/http.conf
sed -i "s#\(http.anti_steal.secret_key\).*#\1=$SECRET_KEY#" /etc/fdfs/http.conf
sed -i "s#\(token_ttl\).*#\1=$TOKEN_TTL#" /etc/fdfs/http.conf


#add groups
i=0
while(( $i<$GROUP_COUNT ))
do
echo "[group$i]" >> /etc/fdfs/mod_fastdfs.conf
echo "group_name=group$i" >> /etc/fdfs/mod_fastdfs.conf
echo "storage_server_port=$STORAGE_PORT" >> /etc/fdfs/mod_fastdfs.conf
echo "store_path_count=1" >> /etc/fdfs/mod_fastdfs.conf
echo "store_path0=$STORAGE_PATH0" >> /etc/fdfs/mod_fastdfs.conf
let "i++"
done

cd /etc/fdfs
touch mime.types
/usr/local/nginx/sbin/nginx -t
/usr/local/nginx/sbin/nginx

/usr/bin/fdfs_storaged /etc/fdfs/storage.conf restart
tail -f /export/fastdfs/storage/logs/storaged.log
