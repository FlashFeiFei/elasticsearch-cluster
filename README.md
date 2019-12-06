# 目录架构
```
|-- elasticsearch
   |-- node1
      |-- data es映射出来的数据
      |-- config
         |-- es1.yml es1配置文件
   |-- node2
      |-- data
      |-- config
         |-- es2.yml
    |-- node3
      |-- data
      |-- config
         |-- es3.yml
```

# elasticsearch配置文件

- 配置文件讲解
```
#集群名字，同一个集群名字必须相同
cluster.name: elasticsearch-cluster
#该节点的名字,集群中node名字不能重复
node.name: es-node1
#设置可以访问的ip,可以是ipv4或ipv6的，默认为0.0.0.0，这里全部设置通过
network.bind_host: 0.0.0.0
#设置其它结点和该结点交互的ip地址，如果不设置它会自动判断，值必须是个真实的ip地址
network.publish_host: 106.12.76.73
#设置对外服务的http端口，默认为9200
http.port: 9200
#设置节点之间交互的tcp端口，默认是9300
transport.tcp.port: 9300
#是否允许跨域REST请求
http.cors.enabled: true
#允许 REST 请求来自何处
http.cors.allow-origin: "*"
#配置该结点有资格被选举为主结点（候选主结点），用于处理请求和管理集群。如果结点没有资格成为主结点，那么该结点永远不可能成为主结点；如果结点有资格成为主结点，只有在被其他候选主结点认可和被选举为主结点之后，才真正成为主结点。
node.master: true 
#配置该结点是数据结点，用于保存数据，执行数据相关的操作
node.data: true  
#集群个节点IP地址，也可以使用es-node等名称，需要各节点能够解析
discovery.zen.ping.unicast.hosts: ["106.12.76.73:9300","106.12.76.73:9301","106.12.76.73:9302"]
#discovery.zen.minimum_master_nodes: (有master资格节点数/2) + 1
#这个参数控制的是，选举主节点时需要看到最少多少个具有master资格的活节点，才能进行选举。官方的推荐值是(N/2)+1，其中N是具有master资格的节点的数量。
discovery.zen.minimum_master_nodes: 2
# discovery.zen.ping_timeout:30（默认值是3秒）——其他节点ping主节点多久时间没有响应就认为主节点不可用了
discovery.zen.ping_timeout: 30
```


- es1.yml
```
cluster.name: elasticsearch-cluster
node.name: es-node1
network.bind_host: 0.0.0.0
network.publish_host: 106.12.76.73
http.port: 9200
transport.tcp.port: 9300
http.cors.enabled: true
http.cors.allow-origin: "*"
node.master: true 
node.data: true  
discovery.zen.ping.unicast.hosts: ["106.12.76.73:9300","106.12.76.73:9301","106.12.76.73:9302"]
discovery.zen.minimum_master_nodes: 2
```

- es2.yml
```
cluster.name: elasticsearch-cluster
node.name: es-node2
network.bind_host: 0.0.0.0
network.publish_host: 106.12.76.73
http.port: 9201
transport.tcp.port: 9301
http.cors.enabled: true
http.cors.allow-origin: "*"
node.master: true 
node.data: true  
discovery.zen.ping.unicast.hosts: ["106.12.76.73:9300","106.12.76.73:9301","106.12.76.73:9302"]
discovery.zen.minimum_master_nodes: 2
```

- es3.yml
```
cluster.name: elasticsearch-cluster
node.name: es-node3
network.bind_host: 0.0.0.0
network.publish_host: 106.12.76.73
http.port: 9202
transport.tcp.port: 9302
http.cors.enabled: true
http.cors.allow-origin: "*"
node.master: true 
node.data: true  
discovery.zen.ping.unicast.hosts: ["106.12.76.73:9300","106.12.76.73:9301","106.12.76.73:9302"]
discovery.zen.minimum_master_nodes: 2
```

# docker-compose.yml

- node1的docker-compose.yml
```
version: '3.1'
services:
  es:
    image: elasticsearch:6.8.5
    environment:
      #我的服务器内存只有2g，这里设置只用128m，内存不够
      - ES_JAVA_OPTS=-Xms128m -Xmx128m
    volumes:
      - ./data:/usr/share/elasticsearch/data
      - ./config/es1.yml:/usr/share/elasticsearch/config/elasticsearch.yml
    ports:
      - 9200:9200
      - 9300:9300
```

- node2的docker-compose.yml

```
version: '3.1'
services:
  es:
    image: elasticsearch:6.8.5
    environment:
      - ES_JAVA_OPTS=-Xms128m -Xmx128m
    volumes:
      - ./data:/usr/share/elasticsearch/data
      - ./config/es2.yml:/usr/share/elasticsearch/config/elasticsearch.yml
    ports:
      - 9201:9201
      - 9301:9301
```

- node3的docker-compose.yml

```
version: '3.1'
services:
  es:
    image: elasticsearch:6.8.5
    environment:
      - ES_JAVA_OPTS=-Xms128m -Xmx128m
    volumes:
      - ./data:/usr/share/elasticsearch/data
      - ./config/es3.yml:/usr/share/elasticsearch/config/elasticsearch.yml
    ports:
      - 9202:9202
      - 9302:9302
```

# 可能遇到的问题

## java虚拟接内存默认太高，服务器不够,设置java虚拟机内存占用
- 设置-e ES_JAVA_OPTS="-Xms256m -Xmx256m" 是因为/etc/elasticsearch/jvm.options 默认jvm最大最小内存是2G


## 调高JVM线程数限制数量

```
bootstrap checks failed max virtual memory areas vm.max_map_count [65530] likely too low, increase to at least [262144]
```

解决

```
vim /etc/sysctl.conf
```

加入如下内容：

```
vm.max_map_count=262144 
```

启动配置:
```
sysctl -p
```