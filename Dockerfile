# 最小靜態站：nginx 直接 serve repo 根目錄
FROM nginx:alpine

# 拿掉預設站，放我們的檔案
RUN rm -rf /usr/share/nginx/html/*
COPY . /usr/share/nginx/html/

# 自訂 nginx.conf（CORS + JSON mime + 去掉 index.html 重導）
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
