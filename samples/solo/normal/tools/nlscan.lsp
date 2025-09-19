#!/usr/bin/env newlisp

; nlscan.lsp - Concurrent TCP port scanner (newLISP)

; --- Helpers ---
(define (s-trim s) (replace "^\\s+|\\s+$" s "" 0))
(define (split-comma s) (filter (lambda (x) (and x (> (length x) 0))) (map s-trim (parse s ","))))

(define (read-lines-file p)
  (if (not (begin (catch (file-info p) 'err) true)) '()
      (let ((txt (read-file p)))
        (filter (lambda (ln) (and (> (length ln) 0) (!= (first ln) \#)))
                (map s-trim (parse txt "\n"))))))

(define (parse-ini path)
  (let ((cfg '()))
    (dolist (ln (read-lines-file path))
      (when (find "=" ln)
        (let ((kv (parse ln "=" 0)))
          (let ((k (s-trim (first kv))) (v (s-trim (join (rest kv) "="))))
            (push (list k v) cfg -1)))))
    cfg))

(define (assoc-get k al)
  (let ((p (assoc k al))) (if p (last p) nil)))

(define (get-cfg cfg key defv)
  (let ((v (assoc-get key cfg))) (if v v defv)))

(define (parse-ports s)
  (let ((acc '()))
    (dolist (tok (split-comma s))
      (if (find "-" tok)
          (let ((ab (parse tok "-")))
            (let ((a (int (first ab))) (b (int (last ab))))
              (if (> a b) (swap a b))
              (for (i a b) (push i acc -1))))
          (push (int tok) acc -1)))
    (unique acc)))

(define (parse-targets s)
  (let ((acc '()))
    (dolist (tok (split-comma s))
      (if (and (> (length tok) 1) (= (first tok) \@))
          (extend acc (read-lines-file (slice tok 1)))
          (push tok acc -1)))
    (unique acc)))

(define (partition-rr xs n)
  (let ((b (array n)))
    (for (i 0 (- n 1)) (setf (b i) '()))
    (let ((idx 0))
      (dolist (x xs)
        (push x (b idx) -1)
        (setf idx (% (+ idx 1) n))))
    (map reverse (array-list b))))

(define (write-line-file path line)
  (append-file path (string line "\n")))

(define (check-port host port timeout)
  (let ((cmd (format "nc -z -w%d %s %d >/dev/null 2>&1" timeout host port)))
    (let ((pid (process cmd))) (last (wait-pid pid)))))

; --- CLI ---
(define (usage)
  (println "nlscan - newLISP TCP port scanner")
  (println "Usage: newlisp tools/nlscan.lsp [options]")
  (println "  -t, --targets VAL     Targets (comma, @file)")
  (println "  -P, --ports VAL       Ports (comma and ranges, e.g., 22,80,8000-8100)")
  (println "  -c, --concurrency N   Number of worker processes (default 200)")
  (println "  -T, --timeout SEC     Timeout per connection in seconds (default 1)")
  (println "  -f, --format FMT      Output format: text|json|ndjson (default text)")
  (println "  -o, --output PATH     Output file path (default stdout)")
  (println "  -C, --config PATH     INI-style config file (key=value)")
  (println "      --emit-nmap-cmds PATH  Emit nmap commands per host to PATH")
  (println "      --emit-nmap-iL PATH    Emit host list with open ports to PATH")
  (println "  -h, --help            Show this help")
  (exit 0))

; parse args into dict
(define (parse-args argv)
  (let ((m '()) (i 0) (n (length argv)))
    (while (< i n)
      (let ((a (argv i)))
        (cond
          ((or (= a "-h") (= a "--help")) (usage))
          ((or (= a "-t") (= a "--targets")) (inc i) (set 'm (cons (list "targets" (argv i)) m)))
          ((or (= a "-P") (= a "--ports")) (inc i) (set 'm (cons (list "ports" (argv i)) m)))
          ((or (= a "-c") (= a "--concurrency")) (inc i) (set 'm (cons (list "concurrency" (int (argv i))) m)))
          ((or (= a "-T") (= a "--timeout")) (inc i) (set 'm (cons (list "timeout" (int (argv i))) m)))
          ((or (= a "-f") (= a "--format")) (inc i) (set 'm (cons (list "format" (argv i)) m)))
          ((or (= a "-o") (= a "--output")) (inc i) (set 'm (cons (list "output" (argv i)) m)))
          ((or (= a "-C") (= a "--config")) (inc i) (set 'm (cons (list "config" (argv i)) m)))
          ((= a "--emit-nmap-cmds") (inc i) (set 'm (cons (list "emit_nmap_cmds" (argv i)) m)))
          ((= a "--emit-nmap-iL") (inc i) (set 'm (cons (list "emit_nmap_iL" (argv i)) m)))
          (true (println "Unknown option: " a) (usage))))
      (inc i))
    m))

; --- Main flow ---
(set 'ARGV (rest (rest (main-args))))
(set 'OPTS (parse-args ARGV))
(set 'CFG (let ((cfgPath (assoc-get "config" OPTS))) (if cfgPath (parse-ini cfgPath) '())))

(set 'TARGETS-STR (or (assoc-get "targets" OPTS) (get-cfg CFG "targets" "")))
(set 'PORTS-STR (or (assoc-get "ports" OPTS) (get-cfg CFG "ports" "")))

(when (or (= (length TARGETS-STR) 0) (= (length PORTS-STR) 0))
  (println "[ERROR] --targets and --ports are required (or via --config)")
  (usage))

(set 'CONC (or (assoc-get "concurrency" OPTS) (int (or (get-cfg CFG "concurrency" "200") "200"))))
(set 'TIMEOUT (or (assoc-get "timeout" OPTS) (int (or (get-cfg CFG "timeout" "1") "1"))))
(set 'FMT (or (assoc-get "format" OPTS) (get-cfg CFG "format" "text")))
(set 'OUTPUT (or (assoc-get "output" OPTS) (get-cfg CFG "output" nil)))
(set 'EMIT-CMDS (or (assoc-get "emit_nmap_cmds" OPTS) (get-cfg CFG "emit_nmap_cmds" nil)))
(set 'EMIT-IL (or (assoc-get "emit_nmap_iL" OPTS) (get-cfg CFG "emit_nmap_iL" nil)))

(when (< CONC 1) (setf CONC 1))

(set 'TARGETS (parse-targets TARGETS-STR))
(set 'PORTS (parse-ports PORTS-STR))
(when (= (length TARGETS) 0) (println "[ERROR] no valid targets parsed") (exit 2))
(when (= (length PORTS) 0) (println "[ERROR] no valid ports parsed") (exit 2))

(set 'TASKS (begin (let ((acc '())) (dolist (h TARGETS) (dolist (p PORTS) (push (list h p) acc -1))) acc)))
(when (> CONC (length TASKS)) (setf CONC (length TASKS)))
(when (= CONC 0) (setf CONC 1))

(set 'PARTS (partition-rr TASKS CONC))
(set 'TMPDIR (string "/tmp/.nlscan-tmp-" (int (* (time-of-day) 1000)) "-" (rand 1000000)))
;(println "TMPDIR:" TMPDIR)
(exec (string "mkdir -p " TMPDIR))
(set 'PIDS '())
(set 'OUTFILES '())

(for (i 0 (- CONC 1))
  (let ((wpath (format "%s/worker-%d.out" TMPDIR i)))
    (push wpath OUTFILES -1)
    (let ((pid (fork)))
      (if (= pid 0)
          (begin (dolist (t (PARTS i))
                   (let ((host (first t)) (port (last t)))
                     (let ((t0 (time-of-day)) (rc (check-port host port TIMEOUT)) (t1 0) (ms 0))
                       (setf t1 (time-of-day))
                       (setf ms (int (* (- t1 t0) 1000)))
                       (write-line-file wpath (format "%s\t%d\t%s\t%d" host port (if (= rc 0) "open" "closed") ms)) )))
                 (exit 0))
          (push pid PIDS -1)))))

(dolist (pid PIDS) (wait-pid pid))

; read rows
(set 'ROWS '())
(dolist (f OUTFILES)
  (when (not (catch (file-info f) 'err))
    (dolist (ln (parse (read-file f) "\n"))
      (when (> (length ln) 0)
        (let ((p (parse ln "\t")))
          (push (list (p 0) (int (p 1)) (p 2) (int (p 3))) ROWS -1))))))

; format output
(define (json-escape s) (let ((s (replace "\\" s "\\\\" 0))) (setf s (replace "\"" s "\\\"" 0)) (setf s (replace "\n" s "\\n" 0)) s))

(set 'OUTSTR
  (cond ((= FMT "json") (string "[" (join (map (lambda (r) (format "{\"host\":\"%s\",\"port\":%d,\"status\":\"%s\",\"latency_ms\":%d}" (json-escape (r 0)) (r 1) (r 2) (r 3))) ROWS) ",") "]"))
        ((= FMT "ndjson") (join (map (lambda (r) (format "{\"host\":\"%s\",\"port\":%d,\"status\":\"%s\",\"latency_ms\":%d}" (json-escape (r 0)) (r 1) (r 2) (r 3))) ROWS) "\n"))
        (true (join (map (lambda (r) (format "%s %d %s %d" (r 0) (r 1) (r 2) (r 3))) ROWS) "\n"))))

(if OUTPUT (write-file OUTPUT OUTSTR) (println OUTSTR))

; emit nmap integration files
(when EMIT-CMDS
  (let ((by '()))
    (dolist (r ROWS)
      (when (= (r 2) "open")
        (let ((h (r 0)) (p (r 1)))
          (let ((old (assoc h by)))
            (if old
                (begin (set 'by (cons (list h (cons p (last old))) (remove old by))))
                (push (list h (list p)) by -1))))))
    (let ((lines '()))
      (dolist (pair by)
        (let ((h (first pair)) (ports (sort (unique (last pair)))))
          (push (format "nmap -Pn -n -sV -p %s %s" (join (map string ports) ",") h) lines -1)))
      (write-file EMIT-CMDS (join lines "\n"))))

(when EMIT-IL
  (let ((hosts (unique (map first (filter (lambda (r) (= (r 2) "open")) ROWS)))))
    (write-file EMIT-IL (join hosts "\n"))))

(exit 0)
)
