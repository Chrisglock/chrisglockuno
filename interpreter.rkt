#lang plait

;; =============================================================================
;; Interpreter: interpreter.rkt
;; =============================================================================

(require "support.rkt")

(define (eval [str : S-Exp]): Value
  (interp (desugar (parse str))))

;; DO NOT EDIT ABOVE THIS LINE =================================================

(define (desugar [expr : Expr]): Expr
    (type-case Expr expr
    [(e-num expr) (e-num  expr)]
    [(e-str expr) (e-str expr)]
    [(e-bool expr) (e-bool expr)]
    [(e-op op left right)(e-op op (desugar left) (desugar right))];construir las 4 ops posiblemente con un cond en interp
  [(e-if cond consq altern) (e-if (desugar cond) (desugar consq) (desugar altern))]
  [(e-lam param body)(e-lam param (desugar body))]
  [(e-app func arg)(e-app func (desugar arg))]
  [(e-id name)(e-id name)]
  [(sugar-and left right) (e-if (desugar left);(desugar (e-if (sugar-or (e-bool #t) (e-bool #f)) (e-num 1) (e-num 2)))
                                (e-if (desugar right)
                                      (e-bool #t)
                                (e-bool #f))
                          (e-bool #f) )]
  [(sugar-or left right) (e-if (desugar left)
                                  (e-bool #t)
                               (e-if (desugar right)
                                     (e-bool #t)
                                     (e-bool #f) ))]
  [(sugar-let namevar value body) (e-app (e-lam namevar (desugar body)) (desugar value))];(desugar value)
      );(lambda (y) (+ 2 y)) result:(Number -> Number)
  )

;(test (desugar (e-if (sugar-or (e-bool #t) (e-bool #f)) (e-num 1) (e-num 2))) (e-if (e-if (e-bool #t) (e-bool #t) (e-if (e-bool #f) (e-bool #t) (e-bool #f))) (e-num 1) (e-num 2)))

(define (interp [expr : Expr]): Value
  (interp-aux expr mt-env)
  )
(define (interp-aux [expr : Expr][env : Env]): Value
  (type-case Expr expr
    [(e-num expr) (v-num expr)]
    [(e-str expr) (v-str expr)]
    [(e-bool expr) (v-bool expr)]
    [(e-op op left right)(cond
                           [(op-plus? op)(op-plus-aux (interp-aux left env) (interp-aux right env))]
                           [(op-append? op)(op-append-aux (interp-aux left env)(interp-aux right env))]
                           [(op-str-eq? op)(op-str-eq-aux (interp-aux left env)(interp-aux right env))]
                           [(op-num-eq? op)(op-num-eq-aux (interp-aux left env)(interp-aux right env))]
                           )
                         ];construir las 4 ops posiblemente con un cond en interp-aux
  [(e-if cond consq altern) (if (v-bool? (interp-aux cond env))
                                (if (v-bool-value (interp-aux cond env)) (interp-aux consq env) (interp-aux altern env))
(raise-error (err-if-got-non-boolean (interp-aux cond env)))
                              )
                                ]
  [(e-lam param body)(v-fun param body env)];ambos e-lam y e-app necesitan un Env(ambiente)
  [(e-app func arg)(let ([f-value (interp-aux func env)])
                     (interp-aux (v-fun-body f-value)
                             (extend-env (bind (v-fun-param f-value)
                                               (interp-aux arg env)) (v-fun-env f-value))))];((lambda (x y)(+ x y)) 1 2)
  [(e-id name)(lookup name env)]
  [(sugar-and a b)(error 'and-error "desugar error")]
    [(sugar-or a b)(error 'or-error "desugar error")]
    [(sugar-let a b c)(error 'let-error "desugar error")]
    )
  );
;(extend-env(bind 'sus (v-str "texto")) mt-env) prueba de bind
(define (op-plus-aux [l : Value] [r : Value]) : Value
    (cond
        [(and (v-num? l) (v-num? r))
          (v-num (+ (v-num-value l) (v-num-value r)))]
        [else
          (raise-error(err-bad-arg-to-op (op-plus) (cond
                                                   [(not (v-num? l))l]
                                                   [(not (v-num? r))r]
                                                   )))
          ]))

(define (op-append-aux [l : Value] [r : Value]) : Value
    (cond
        [(and (v-str? l) (v-str? r))
          (v-str (string-append (v-str-value l) (v-str-value r)))]
        [else
          (raise-error(err-bad-arg-to-op (op-append) (cond
                                                   [(not (v-str? l))l]
                                                   [(not (v-str? r))r]
                                                   )))
          ]))

(define (op-str-eq-aux [l : Value] [r : Value]) : Value
    (cond
        [(and (v-str? l) (v-str? r))
          (v-bool (eq? (v-str-value l) (v-str-value r)))]
        [else
          (raise-error(err-bad-arg-to-op (op-str-eq) (cond
                                                   [(not (v-str? l))l]
                                                   [(not (v-str? r))r]
                                                   )))
          ]))


(define (op-num-eq-aux [l : Value] [r : Value]) : Value
    (cond
        [(and (v-num? l) (v-num? r))
          (v-bool (eq? (v-num-value l) (v-num-value r)))]
        [else
          (raise-error(err-bad-arg-to-op (op-num-eq) (cond
                                                   [(not (v-num? l))l]
                                                   [(not (v-num? r))r]
                                                   )))
          ]))


(define (lookup [id : Symbol] [env : Env]) : Value
  (cond
    [(empty? env) (raise-error(err-unbound-id id))]
    [else (cond
            [(symbol=? id (bind-name (first env)))
              (bind-val (first env))]
            [else (lookup id (rest env))])]))