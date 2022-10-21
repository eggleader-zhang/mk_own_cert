# 确定文件的绝对位置
SH_PATH=$(readlink -f $0)
EXEC_PATH=$(dirname $SH_PATH)
echo 当前的工作目录是：$EXEC_PATH
# 修改IP_ADD的同时，也要在openssl.cnf中修改IP地址
IP_ADD=xxxx.xxx
DAYS=3650

# 删除之前旧的证书，生成新的目录
ls|grep -Ev "mkcert_new.sh|openssl.cnf"|xargs rm -rf
mkdir -p demoCA/newcerts
touch ./demoCA/index.txt ./demoCA/serial
echo "01">> ./demoCA/serial

# Step1.生成CA的key和证书
openssl genrsa -traditional -out ca.key 2048
openssl req -new -x509 -days $DAYS -key ca.key -out ca.crt -subj /C=CN/ST=Sichuan/L=ChengDu/O=H3C/OU=CA/CN=$IP_ADD/emailAddress=CA@eggleader.com -config $EXEC_PATH/openssl.cnf

# Step2.生成Server的key和证书
openssl genrsa -traditional -out server.key 2048
openssl req -new -days $DAYS -out server.csr -key server.key -subj /C=CN/ST=Sichuan/L=ChengDu/O=H3C/OU=Server/CN=$IP_ADD/emailAddress=Server@eggleader.com -config $EXEC_PATH/openssl.cnf
openssl ca -in server.csr -out server.crt -cert ca.crt -keyfile ca.key -extensions v3_req -config $EXEC_PATH/openssl.cnf