run:
    #!/usr/bin/env bash
    emacs --batch -l publish.el --eval "(org-publish-all t)"
    python3 -m http.server 8080 --directory public/ &
    SERVER_PID=$!
    sleep 0.5
    xdg-open http://localhost:8080
    wait $SERVER_PID
