(define (srfi-mail-archive-url num)
  (string-append "https://srfi-email.schemers.org/"
                 (srfi-num-stem num) "/"))

(define-command (email-url num)
  "Display mail archive URL for SRFI <num>."
  (write-line-about-srfi srfi-mail-archive-url num))

(define (srfi-mail-address num)
  (string-append (srfi-num-stem num)
                 "@srfi.schemers.org"))

(define-command (mail-address num)
  "Display email address URL for SRFI <num>."
  (write-line-about-srfi srfi-mail-address num))

(define (mailto-address-subject address subject)
  (string-append "mailto:"
                 address
                 "?subject=" (url-hexify-string subject)))

(define (srfi-mailto-url num)
  (mailto-address-subject (srfi-mail-address num)
                          (srfi-title num)))

(define (find-matching-author author-name-part srfi)
  (or (find (lambda (author)
              (string-contains (string-downcase (srfi-author-name author))
			       (string-downcase author-name-part)))
            (srfi-authors srfi))
      (error "Cannot find matching author.")))

(define (compose-message num subject sxml)
  (let* ((html (with-output-to-string (lambda () (sxml-display-as-html sxml))))
         (mailto (mailto-address-subject (srfi-mail-address num) subject)))
    (copy-html-to-clipboard html)
    (browse-url mailto)))

(define (srfi-last-call-subject num)
  (format "Last call for comments on SRFI ~a: ~a" num (srfi-title num)))

(define (srfi-last-call-tail-sxml num)
  (let ((date (date->iso-date
               (julian-day->date
                (+ 7
                   (truncate		; Work around bug in Chibi's SRFI 19.
                    (date->julian-day (current-date))))))))
    `((p "In particular, I appeal to anyone reading this to try the "
	 "sample implementation, run the tests, and send feedback "
	 "about your results.")
      (p "If you're interested in this SRFI, please give your "
	 "feedback via the SRFI "
	 ,num
	 " mailing list before "
	 (b ,date)
	 ".  After that, assuming that no major revisions are required, we "
	 "will declare it final.  It is important that we get your feedback "
	 "before "
	 ,date
         ".  "
	 (b "If that deadline is too soon for you, but you would like to "
	    "contribute, please let me know so that I can extend the last-"
	    "call period."))
      (p "Regards,")
      (p (@ (style "margin-top: 3em;")) "SRFI Editor"))))

(define (srfi-last-call-sxml num author-name-part pronoun)
  (let* ((srfi (srfi-by-number num))
         (url (srfi-landing-url num))
         (title (srfi-title srfi))
         (author (srfi-author-name
                  (find-matching-author author-name-part srfi)))
	 (single-author? (null? (cdr (srfi-authors srfi)))))
    `((p ,author
	 ", "
	 ,(if single-author? "author" "co-author")
	 " of "
	 (a (@ (href ,url)) "SRFI " ,num)
	 ": "
	 ,title
	 ", has asked me to announce "
	 (b "last call")
	 " for this SRFI.  "
	 ,(string-capitalize-first pronoun)
         " believes that it is ready for finalization, but would like "
	 "to give reviewers one last chance to submit corrections and "
	 "feedback before we finalize it.")
      ,@(srfi-last-call-tail-sxml num))))

;; TODO: Rather than take pronoun as an argument, perhaps keep a database of
;; authors.
(define-command (compose-last-call num author-name-part pronoun)
  "Put HTML of last-call message for SRFI <num> with author <author-name-part>
into clipboard, then open email client with new message addressed to mailing
list for SRFI <num>, ready for pasting the body.  Use first-person <pronoun>."
  (let ((num (parse-srfi-number num)))
    (compose-message num
		     (srfi-last-call-subject num)
		     (srfi-last-call-sxml num author-name-part pronoun))))

(define (srfi-draft-and-last-call-subject num draft-no)
  (format "New draft (#~a) and last call for comments on SRFI ~a: ~a"
	  draft-no
	  num
	  (srfi-title num)))

;; TODO: Change this retrieve the latest draft number from git.
(define (srfi-draft-and-last-call-sxml num draft-no submitter-name-part pronoun)
  (let* ((srfi (srfi-by-number num))
         (url (srfi-landing-url num))
         (title (srfi-title srfi))
	 (single-author? (null? (cdr (srfi-authors srfi))))
	 (submitter (find-matching-author submitter-name-part srfi))
	 (first-name (srfi-author-first-name submitter)))
    `((p "I've just published draft #"
	 ,draft-no
	 " of "
	 (a (@ (href ,url)) "SRFI " ,num)
	 ".  It was submitted by "
	 ,(srfi-author-name submitter)
	 ", "
	 ,(if single-author? "author" "co-author")
	 " of the SRFI.")
      (p ,first-name
	 " has asked me to announce "
	 (b "last call")
	 " for this SRFI.  "
	 ,(string-capitalize-first pronoun)
         " believes that it is ready for finalization, but would like "
	 "to give reviewers one last chance to submit corrections and "
	 "feedback before we finalize it.")
      ,@(srfi-last-call-tail-sxml num))))

;; TODO: Rather than take pronoun as an argument, perhaps keep a database of
;; authors.
(define-command (compose-draft-and-last-call num
					     draft-no
					     author-name-part
					     pronoun)
  "Put HTML of a combined new-draft and last-call message for draft <draft-no>
of SRFI <num> and author <author-name-part> into clipboard, then open email
client with new message addressed to mailing list for SRFI <num>, ready for
pasting the body.  Use first-person <pronoun>."
  (let ((num (parse-srfi-number num)))
    (compose-message num
		     (srfi-draft-and-last-call-subject num draft-no)
		     (srfi-draft-and-last-call-sxml num
						    draft-no
						    author-name-part
						    pronoun))))

(define (srfi-new-subject num)
  (format "SRFI ~a: ~a" num (srfi-title num)))

(define (srfi-new-sxml num)
  (let* ((srfi (srfi-by-number num))
         (email-url (srfi-mail-archive-url num))
         (landing-url (srfi-landing-url num))
	 (num (number->string num))
         (title (srfi-title srfi))
	 (abstract (srfi-abstract-html num))
         (authors (srfi-format-authors (srfi-authors srfi))))
    `((p "Scheme Request for Implementation "
	 ,num
	 ","
	 (br)
	 "\""
	 ,title
	 "\","
	 (br)
	 "by "
	 ,authors
	 ","
	 (br)
	 "is now available for discussion.")
      (p "Its draft and an archive of the ongoing discussion are available at "
	 (a (@ (href ,landing-url)) ,landing-url)
	 ".")
      (p "You can join the discussion of the draft by filling out the
subscription form on that page.")
      (p "You can contribute a message to the discussion by sending it to "
	 (a (@ (href ,email-url)) ,email-url)
	 ".")
      (p "Here's the abstract:")
      (blockquote (@raw ,abstract))
      (p "Regards,")
      (p (@ (style "margin-top: 3em;")) "SRFI Editor"))))

(define-command (compose-new num)
  "Put HTML of new-SRFI announcement message for SRFI <num> into clipboard, then
open email client with new message addressed to mailing list for SRFI <num>,
ready for pasting the body."
  (let ((num (parse-srfi-number num)))
    (compose-message num
		     (srfi-new-subject num)
		     (srfi-new-sxml num))))