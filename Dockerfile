FROM alpine:3.19

# نصب پیش‌نیازها
RUN apk add --no-cache \
    curl \
    bash \
    ca-certificates \
    socat \
    tzdata \
    sqlite \
    nginx \
    gettext && ln -sf /usr/share/zoneinfo/Asia/Tehran /etc/localtime

# دانلود و نصب آخرین نسخه 3x-ui به صورت خودکار
RUN LATEST_VERSION=$(curl -sI https://github.com/MHSanaei/3x-ui/releases/latest | grep -i "^location:" | awk -F'/' '{print $NF}' | tr -d '\r\n') && \
    echo "Installing 3x-ui version: $LATEST_VERSION" && \
    curl -L "https://github.com/MHSanaei/3x-ui/releases/download/${LATEST_VERSION}/x-ui-linux-amd64.tar.gz" -o /tmp/x-ui.tar.gz && \
    tar -xzf /tmp/x-ui.tar.gz -C /usr/local/ && \
    rm /tmp/x-ui.tar.gz && \
    chmod +x /usr/local/x-ui/x-ui

# ایجاد دایرکتوری‌های مورد نیاز
RUN mkdir -p /etc/x-ui /var/log/x-ui

# کپی فایل‌های تنظیمات و استارت
COPY nginx.conf.template /etc/nginx/nginx.conf.template
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
