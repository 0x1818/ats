# ats
apache traffice server dockerfile


### 使用方法:docker build -t ats:9.1.0 .

### 启动容器：docker run --restart=always --name=ats -d -p 443:443 -v /data/trafficserver:/opt/trafficserver/etc/trafficserver ats:9.1.2
