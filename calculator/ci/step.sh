#!/usr/bin/env bash
# Запуск шага CI: при ошибке хвост вывода попадает в аннотацию GitHub Actions.
set -o pipefail
log=$(mktemp)
"$@" 2>&1 | tee "$log"
rc=${PIPESTATUS[0]}
if [ "$rc" -ne 0 ]; then
    msg=$(tail -n 40 "$log" | sed -e 's/%/%25/g' | awk 'BEGIN{ORS="%0A"} {print}')
    echo "::error title=$1 $2::${msg}"
fi
exit "$rc"
