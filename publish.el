;;; publish.el --- Build the wiki: emacs --batch -l publish.el -f org-publish-all
;;; Serve output with: python3 -m http.server 8080 --directory public/

(require 'org)
(require 'ox-html)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python      . t)
   (R           . t)
   (shell       . t)
   (emacs-lisp  . t)))

(setq org-confirm-babel-evaluate nil)
;; Use stored #+RESULTS: during export — run blocks interactively in Emacs first
(setq org-export-babel-evaluate nil)

(defvar wiki-html-head
  "<link rel=\"stylesheet\" href=\"/style.css?v=6\" />
<script>
MathJax = { tex: { inlineMath: [['\\\\(','\\\\)']], displayMath: [['\\\\[','\\\\]']] } };
</script>
<script src=\"https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml.js\"></script>")

;; Tabs are root-relative so they resolve correctly from any subdirectory.
;; The inline script adds an .active class to whichever tab matches the URL.
(defvar wiki-preamble
  "<a class=\"site-title\" href=\"/index.html\">yappopotamus</a>
<nav>
  <a href=\"/index.html\">Home</a>
  <div class=\"nav-group\">
    <a href=\"/ai/index.html\">AI</a>
    <div class=\"nav-sub\">
      <a href=\"/ai/bayesian-networks/index.html\">Bayesian Networks</a>
      <a href=\"/ai/cnns/index.html\">CNNs</a>
    </div>
  </div>
  <div class=\"nav-group\">
    <a href=\"/algorithms/index.html\">Algorithms</a>
    <div class=\"nav-sub\">
      <a href=\"/algorithms/spanning-trees/index.html\">Spanning Trees</a>
      <a href=\"/algorithms/divide-and-conquer/index.html\">Divide &amp; Conquer</a>
      <a href=\"/algorithms/dynamic-programming/index.html\">Dynamic Programming</a>
      <a href=\"/algorithms/greedy-scheduling/index.html\">Greedy Scheduling</a>
      <a href=\"/algorithms/linear-programming/index.html\">Linear Programming</a>
      <a href=\"/algorithms/simplex-algorithm/index.html\">Simplex Algorithm</a>
      <a href=\"/algorithms/integer-linear-programming/index.html\">Integer LP</a>
      <a href=\"/algorithms/flow-networks/index.html\">Flow Networks</a>
      <a href=\"/algorithms/randomized-algorithms/index.html\">Randomized Algorithms</a>
      <a href=\"/algorithms/approximation-algorithms/index.html\">Approximation Algorithms</a>
    </div>
  </div>
  <a href=\"/concerts/index.html\">Concerts</a>
  <a href=\"/examples/index.html\">Examples</a>
  <a href=\"/linear-algebra/index.html\">Linear Algebra</a>
  <div class=\"nav-group\">
    <a href=\"/statistics/index.html\">Statistics</a>
    <div class=\"nav-sub\">
        <a href=\"/statistics/glm/index.html\">GLMs</a>
      <a href=\"/statistics/binary_logistic.html\">Binary Logistic Regression</a>
      <a href=\"/statistics/binomial_glm.html\">Binomial GLM</a>
      <a href=\"/statistics/poisson_glm.html\">Poisson GLM</a>
    </div>
  </div>
</nav>
<script>
(function () {
  var path = window.location.pathname;
  document.querySelectorAll('nav a').forEach(function (a) {
    var dir = a.getAttribute('href').replace('index.html', '');
    var match = (dir === '/') ? (path === '/' || path === '/index.html')
                              : path.startsWith(dir);
    if (match) a.classList.add('active');
  });
}());
</script>")

(setq org-publish-project-alist
      `(("wiki-org"
         :base-directory "content/"
         :base-extension "org"
         :publishing-directory "public/"
         :recursive t
         :publishing-function org-html-publish-to-html
         :html-head ,wiki-html-head
         :html-preamble ,wiki-preamble
         :html-postamble nil
         :html-validation-link nil
         :html-head-include-default-style nil
         :html-head-include-scripts nil
         :section-numbers nil
         :with-toc t
         :with-author t
         :with-creator nil
         :with-timestamps nil)

        ;; Images and PDFs under content/ are copied as-is
        ("wiki-assets"
         :base-directory "content/"
         :base-extension "png\\|jpg\\|jpeg\\|gif\\|svg\\|pdf\\|mp4\\|webm"
         :publishing-directory "public/"
         :recursive t
         :publishing-function org-publish-attachment)

        ;; Stylesheet and any JS from static/ are copied as-is
        ("wiki-static"
         :base-directory "static/"
         :base-extension "css\\|js\\|ico"
         :publishing-directory "public/"
         :recursive t
         :publishing-function org-publish-attachment)

        ("wiki"
         :components ("wiki-org" "wiki-assets" "wiki-static"))))
