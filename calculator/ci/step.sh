#!/usr/bin/env bash
# Запуск шага CI: при ошибке хвост вывода попадает в аннотацию GitHub Actions.
set -o pipefail
log=$(mktemp)
"$@" 2>&1 | tee "$log"
rc=${PIPESTATUS[0]}
msg=$(tail -n 40 "$log" | sed -e 's/%/%25/g' | awk 'BEGIN{ORS="%0A"} {print}')
if [ "$rc" -ne 0 ]; then
    echo "::error title=$1 $2::${msg}"
elif [ -n "$NOTICE" ]; then
    echo "::notice title=$1 $2::${msg}"
fi
exit "$rc"
