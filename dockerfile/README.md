# dockerfile 部署方法

- 1.安装 docker
- 2.将本文件夹内所有文件下载
- 3.运行 docker build -t piazza-together:V1.0.0 .
- 4.运行 docker run -p 8888:80 -d piazza-together:V1.0.0

注：8888为外网端口 可以修改成80等端口
- 5.可选运行 docker save piazza-together:V1.0.0 > piazza-together_V1.0.0.tar 
即导出镜像到文件