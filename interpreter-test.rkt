#lang racket

;; =============================================================================
;; Interpreter: interpreter-tests.rkt
;; =============================================================================

(require (only-in "interpreter.rkt" eval)
         "support.rkt"
         "test-support.rkt")

;; DO NOT EDIT ABOVE THIS LINE =================================================

(define/provide-test-suite interpreter-tests ;; DO NOT EDIT THIS LINE ==========
  ; TODO: Add your own tests below!

  ; Here, we provide some examples of how to use the testing forms provided in
  ; "test-support.rkt". You should not use any external testing library other
  ; than those specifically provided; otherwise, we will not be able to grade
  ; your code.
  (test-equal? "Works with Num primitive"
               (eval `2) (v-num 2))
  (test-true "Works with lambda"
             (v-fun? (eval `{lam x 5})))
  (test-pred "Equivalent to the test case above, but with test-pred"
             v-fun? (eval `{lam x 5}))
  (test-raises-interp-error? "Passing Str to + results in err-bad-arg-to-op"
                             (eval `{+ "bad" 1})
                             (err-bad-arg-to-op (op-plus) (v-str "bad")))
;;MY TESTS

  (test-equal? "basic test paret and"
               (eval `{and true true}) (v-bool #t))
  (test-equal? "basic test paret or"
               (eval `{or true false}) (v-bool #t))
  (test-true "basic test paret lamda"
               (v-fun? (eval `{lam x (+ 5 x)})))
  (test-equal? "basic test paret +"
               (eval `{+ 5 8}) (v-num 13))
  (test-equal? "basic test paret ++"
               (eval `{++ "among" " us"}) (v-str "among us"))

  (test-equal? "basic test paret num="
               (eval `{num= 2 2}) (v-bool #t))
  
  (test-equal? "basic test 2 paret num="
               (eval `{num= 7 0}) (v-bool #f))

   (test-equal? "basic test paret str="
               (eval `{num= 2 1}) (v-bool #f))
  
   (test-equal? "basic test 2 paret str="
               (eval `{str= "perro" "perro"}) (v-bool #t))

       (test-true "basic test paret let"
               (v-num?(eval `{let (x 1) (+ x 2)})))
 ;combined test 
       (test-equal? "combination test  paret num= y +"
               (eval `{num= 20 (+ 5 (+ (+ 5 5) 5 ))}) (v-bool #t))
;errores esperados test
    (test-raises-interp-error? "str in + err-bad-arg-to-op"
                             (eval `{+ 2 "bad"})
                             (err-bad-arg-to-op (op-plus) (v-str "bad")))

     (test-raises-interp-error? "num in ++ err-bad-arg-to-op"
                             (eval `{++ 2 "bad"})
                             (err-bad-arg-to-op (op-append) (v-num 2)))
  
      (test-raises-interp-error? "num in str= err-bad-arg-to-op"
                             (eval `{str= 2 2})
                             (err-bad-arg-to-op (op-str-eq) (v-num 2)))
  
      (test-raises-interp-error? "error mal argumento dentro de otra op err-bad-arg-to-op"
                             (eval `{num= "string" (+ 2 3)})
                             (err-bad-arg-to-op (op-num-eq) (v-str "string")))
       (test-raises-interp-error? "cond no es boolean err-if-got-non-boolean"
                             (eval `{if "string" 0 1})
                             (err-if-got-non-boolean (v-str "string")))
  
;faltan test de: operaciones combinadas, errores esperados, casoslimite 
  )
;; DO NOT EDIT BELOW THIS LINE =================================================

(run-tests interpreter-tests)
