#!/bin/bash

URL="https://test.com/monitoring/test/api"
PID_FILE="/tmp/test_process.pid"
LOG_FILE="/var/log/monitoring.log"

log() {
    echo "$(date) - $1" >> $LOG_FILE
}

if pgrep test > /dev/null; then
    CURRENT_PID=$(pgrep test)

    if [ ! -f $PID_FILE ] || [ "$(cat $PID_FILE)" != $CURRENT_PID ]; then
        log "Процесс 'test' был перезапущен. Новый PID: $CURRENT_PID"
        echo $CURRENT_PID > $PID_FILE
    fi

    if ! curl -s --head "$URL" | grep "200 OK" > /dev/null; then
        log "Сервер мониторинга недоступен. URL: $URL"
    fi
else
    exit 0
fi
