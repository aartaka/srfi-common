;;;; Create SRFI repositories on Github
;;;;
;;;; based on download from srfi.schemers.org created using
;;;;   <wget --mirror srfi.schemers.org>

(load-option 'format)

;; Set this manually.
(define github-authorization-token #f)

(define github-api-srfi-repos
  "https://api.github.com/orgs/scheme-requests-for-implementation/repos")

(define srfis
  '((0 final "Feature-based conditional expansion construct" "Marc Feeley")
    (1 final "List Library" "Olin Shivers")
    (2 final "AND-LET*: an AND with local bindings, a guarded LET* special form" "Oleg Kiselyov")
    (3 withdrawn "List-Set Library" "Olin Shivers")
    (4 final "Homogeneous numeric vector datatypes" "Marc Feeley")
    (5 final "A compatible let form with signatures and rest arguments" "Andy Gaynor")
    (6 final "Basic String Ports" "William D Clinger")
    (7 final "Feature-based program configuration language" "Richard Kelsey")
    (8 final "receive: Binding to multiple values" "John David Stone")
    (9 final "Defining Record Types" "Richard Kelsey")
    (10 final "#, external form" "Oleg Kiselyov")
    (11 final "Syntax for receiving multiple values" "Lars T Hansen")
    (12 withdrawn "Exception Handling" "William Clinger, R. Kent Dybvig, Matthew Flatt, and Marc Feeley")
    (13 final "String Libraries" "Olin Shivers")
    (14 final "Character-set Library" "Olin Shivers")
    (15 withdrawn "Syntax for dynamic scoping." "Lars T Hansen")
    (16 final "Syntax for procedures of variable arity." "Lars T Hansen")
    (17 final "Generalized set!" "Per Bothner")
    (18 final "Multithreading support" "Marc Feeley")
    (19 final "Time Data Types and Procedures" "Will Fitzgerald")
    (20 withdrawn "Simple object system." "Christian Queinnec")
    (21 final "Real-time multithreading support" "Marc Feeley")
    (22 final "Running Scheme Scripts on Unix" "Martin Gasbichler and Michael Sperber")
    (23 final "Error reporting mechanism" "Stephan Houben")
    (24 withdrawn "Define-syntax in local lexical scopes" "Antti Huima")
    (25 final "Multi-dimensional Array Primitives" "Jussi Piitulainen")
    (26 final "Notation for Specializing Parameters without Currying" "Sebastian Egner")
    (27 final "Sources of Random Bits" "Sebastian Egner")
    (28 final "Basic Format Strings " "Scott G. Miller")
    (29 final "Localization " "Scott G. Miller")
    (30 final "Nested Multi-line Comments" "Martin Gasbichler")
    (31 final "A special form `rec' for recursive evaluation" "Mirko.Luedde@Computer.Org")
    (32 withdrawn "Sort Libraries" "Olin Shivers")
    (33 withdrawn "Integer Bitwise-operation Library" "Olin Shivers")
    (34 final "Exception Handling for Programs" "Richard Kelsey and Michael Sperber")
    (35 final "Conditions" "Richard Kelsey and Michael Sperber")
    (36 final "I/O Conditions" "Michael Sperber")
    (37 final "args-fold: a program argument processor" "Anthony Carrico")
    (38 final "External Representation for Data With Shared Structure" "Ray Dillinger")
    (39 final "Parameter objects" "Marc Feeley")
    (40 final "A Library of Streams" "Philip L. Bewig")
    (41 final "Streams" "Philip L. Bewig")
    (42 final "Eager Comprehensions" "Sebastian Egner")
    (43 final "Vector library" "Taylor Campbell")
    (44 final "Collections" "Scott G. Miller")
    (45 final "Primitives for Expressing Iterative Lazy Algorithms" "André van Tonder")
    (46 final "Basic Syntax-rules Extensions" "Taylor Campbell")
    (47 final "Array" "Aubrey Jaffer")
    (48 final "Intermediate Format Strings" "Ken Dickey")
    (49 final "Indentation-sensitive syntax" "Egil Möller")
    (50 withdrawn "SRFI 50: Mixing Scheme and C" "Richard Kelsey and Michael Sperber")
    (51 final "Handling rest list" "Joo ChurlSoo")
    (52 withdrawn "Permitting and Supporting Extended Character Sets" "Thomas Lord (lord@emf.net aka lord@gnu.org)")
    (53 withdrawn "Syntactic computations with computation-rules" "André van Tonder")
    (54 final "Formatting" "Joo ChurlSoo")
    (55 final "require-extension" "Felix L. Winkelmann and D.C. Frost")
    (56 withdrawn "Binary I/O" "Alex Shinn")
    (57 final "Records" "André van Tonder")
    (58 final "Array Notation" "Aubrey Jaffer")
    (59 final "Vicinity" "Aubrey Jaffer")
    (60 final "Integers as Bits" "Aubrey Jaffer")
    (61 final "A more general cond clause" "Taylor Campbell")
    (62 final "S-expression comments" "Taylor Campbell")
    (63 final "Homogeneous and Heterogeneous Arrays" "Aubrey Jaffer")
    (64 final "A Scheme API for test suites" "Per Bothner")
    (65 withdrawn "define-immutable: A Syntax to Define Identifiers With Immutable Values" "Andrew Wilcox")
    (66 final "Octet Vectors" "Michael Sperber")
    (67 final "Compare Procedures" "Sebastian Egner and Jens Axel Søgaard")
    (68 withdrawn "Comprehensive I/O" "Michael Sperber")
    (69 final "Basic hash tables" "Panu Kalliokoski")
    (70 final "Numbers" "Aubrey Jaffer")
    (71 final "Extended LET-syntax for multiple values" "Sebastian Egner")
    (72 final "Hygienic macros." "André van Tonder")
    (73 withdrawn "Exact Infinities" "Chongkai Zhu")
    (74 final "Octet-Addressed Binary Blocks" "Michael Sperber")
    (75 withdrawn "R6RS Unicode data" "Matthew Flatt and Marc Feeley")
    (76 withdrawn "R6RS Records" "Will Clinger, R. Kent Dybvig, Michael Sperber, Anton van Straaten")
    (77 withdrawn "Preliminary Proposal for R6RS Arithmetic" "William D Clinger and Michael Sperber")
    (78 final "Lightweight testing" "Sebastian Egner")
    (79 withdrawn "Primitive I/O" "Michael Sperber")
    (80 withdrawn "Stream I/O" "Michael Sperber")
    (81 withdrawn "Port I/O" "Michael Sperber")
    (82 withdrawn "Stream Ports" "Michael Sperber")
    (83 withdrawn "R6RS Library Syntax" "Matthew Flatt and Kent Dybvig")
    (84 withdrawn "Universal Identifiers" "Andrew Wilcox")
    (85 withdrawn "Recursive Equivalence Predicates" "William D Clinger")
    (86 final "MU and NU simulating VALUES & CALL-WITH-VALUES, and their related LET-syntax" "Joo ChurlSoo")
    (87 final "=> in case clauses" "Chongkai Zhu")
    (88 final "Keyword objects" "Marc Feeley")
    (89 final "Optional positional and named parameters" "Marc Feeley")
    (90 final "Extensible hash table constructor" "Marc Feeley")
    (91 withdrawn "Extended ports" "Marc Feeley")
    (92 withdrawn "ALAMBDA and ALAMBDA*" "Joo ChurlSoo")
    (93 withdrawn "R6RS Syntax-Case Macros" "Kent Dybvig")
    (94 final "Type-Restricted Numerical Functions" "Aubrey Jaffer")
    (95 final "Sorting and Merging" "Aubrey Jaffer")
    (96 final "SLIB Prerequisites" "Aubrey Jaffer")
    (97 final "SRFI Libraries" "David Van Horn")
    (98 final "An interface to access environment variables." "Taro Minowa (Higepon)")
    (99 final "ERR5RS Records" "William D Clinger")
    (100 final "define-lambda-object" "Joo ChurlSoo")
    (101 final "Purely Functional Random-Access Pairs and Lists" "David Van Horn")
    (102 withdrawn "Procedure Arity Inspection" "David Van Horn")
    (103 withdrawn "Library Files" "Derick Eddington")
    (104 withdrawn "Library Files Utilities" "Derick Eddington")
    (105 final "Curly-infix-expressions" "David A. Wheeler, Alan Manuel K. Gloria")
    (106 final "Basic socket interface" "Takashi Kato")
    (107 final "XML reader syntax" "Per Bothner")
    (108 final "Named quasi-literal constructors" "Per Bothner")
    (109 final "Extended string quasi-literals" "Per Bothner")
    (110 final "Sweet-expressions (t-expressions)" "David A. Wheeler, Alan Manuel K. Gloria")
    (111 final "Boxes" "John Cowan")
    (112 final "Environment Inquiry" "John Cowan")
    (113 final "Sets and bags" "John Cowan")
    (114 final "Comparators" "John Cowan")
    (115 final "Scheme Regular Expressions" "Alex Shinn")
    (116 final "Immutable List Library" "John Cowan")
    (117 draft "Mutable Queues" "John Cowan")
    (118 final "Simple adjustable-size strings" "Per Bothner")
    (119 final "wisp: simpler indentation-sensitive scheme" "Arne Babenhauserheide")
    (120 final "Timer APIs" "Takashi Kato")
    (121 draft "Generators" "Shiro Kawai, John Cowan, Thomas Gilray")
    (122 draft "Intervals and Generalized Arrays" "Bradley J. Lucier")))

;; This is the first SRFI whose email archive was hosted first on
;; Simplelists.  SRFI with smaller numbers were originally hosted on
;; Michael Sperber's FreeBSD system, so the archive links are different.
(define first-simplelists-srfi 122)

(define (create-github-repository number)
  (let ((description (caddr (assoc number srfis))))
    (run-shell-command
     (format #f
	     "curl -i -H 'Authorization: token ~A' -d '{ \"name\": \"srfi-~A\", \"description\": \"~A\" }' ~A~%"
	     github-authorization-token
	     number
	     description
	     github-api-srfi-repos))))