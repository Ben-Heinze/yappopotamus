run:
    #!/usr/bin/env bash
    if [ -f .server.pid ] && kill -0 "$(cat .server.pid)" 2>/dev/null; then
        kill "$(cat .server.pid)"
    fi
    emacs --batch -l publish.el --eval "(org-publish-all t)"
    cp static/style.css public/style.css
    python3 serve.py &
    echo $! > .server.pid
    SERVER_PID=$!
    sleep 0.5
    xdg-open http://localhost:8080
    wait $SERVER_PID
