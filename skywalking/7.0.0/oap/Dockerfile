FROM harbor-cz.deepblueai.com/apache/skywalking-oap-server:7.0.0-es7

#  修正时区为东八区
RUN apk add --no-cache tzdata
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
