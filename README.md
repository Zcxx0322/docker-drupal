# docker-drupal

Drupal-Dockerfile

## 构建镜像

`docker build -t zcxx0322/drupal:0.0.1 .`

## 创建容器

```bash
docker run -d --privileged \
    -p 2022:22 \
    --env LANG=en_US.UTF-8 \
    --env TZ=Asia/Shanghai \
    --name drupal zcxx0322/drupal:0.0.1
```

## 添加本地域名解析
```bash
vim /etc/hosts
```
- 添加以下内容：
```
容器ip地址 test.drupal.com
``` 

## 访问地址
```bash
test.drupal.com
```