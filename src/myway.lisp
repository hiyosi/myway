(in-package :cl-user)
(defpackage myway
  (:use :cl)
  (:import-from :myway.mapper
                :mapper
                :make-mapper
                :member-route
                :add-route
                :next-route
                :dispatch)
  (:import-from :myway.route
                :route
                :make-route
                :route-handler)
  (:export :make-mapper
           :connect
           :next-route
           :dispatch

           :*env*
           :to-app

           :mapper
           :add-route
           :find-route

           :route
           :make-route
           :route-name
           :route-handler))
(in-package :myway)

(defun connect (mapper url fn &key (method '(:GET)) regexp name)
  (add-route mapper
             (make-route url
                         :method method
                         :regexp regexp
                         :name name
                         :handler fn)))

(defun find-route (mapper url &key (method '(:GET)) regexp name)
  (car
   (member-route mapper
                 (make-route url
                             :method method
                             :regexp regexp
                             :name name))))

(defparameter *env* nil)

(defun to-app (mapper)
  (lambda (env)
    (let ((*env* env))
      (destructuring-bind (&key method path-info &allow-other-keys) env
        (dispatch mapper path-info :method method)))))
