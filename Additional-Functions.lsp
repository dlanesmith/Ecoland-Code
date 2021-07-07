; ---Additional Functions---
; Written by David Lane-Smith
; To optimize use of AutoCAD at Ecoland Inc.



; Reads the save file and sets variables to their saved values upon loading program

(load "C:\\Users\\Ecoland\\Documents\\Helpful Code\\LSP Files\\Preset.lsp")
(setq saveF (open "C:\\Users\\Ecoland\\Documents\\Helpful Code\\LSP Files\\SaveFile.txt" "r"))
(setq lin (read-line savef))
(if (= lin nil) (setq num 1) (setq num (atof lin)))
(setq lin (read-line savef))
(if (= lin nil) (setq textH 1) (setq textH (atof lin)))
(setq lin (read-line savef))
(setq lin (read-line savef))
(if (= lin nil) (setq cur_oVal (getvar "osmode")) (setq cur_oVal (atoi lin)))
(setq lin (read-line savef))
(if (= lin nil)
	(progn
		(setq dPntOn T)
	)
	(progn
		(setq dPntOn (atoi lin))
	)
)
(setq lin (read-line savef))
(if (= lin nil)
	(progn
		(setq dLblOn T)
	)
	(progn
		(setq dLblOn (atoi lin))
	)
)
(setq lin (read-line savef))
(if (= lin nil)
	(progn
		(setq dBoxOn T)
	)
	(progn
		(setq dBoxOn (atoi lin))
	)
)
(setq lin (read-line savef))
(if (= lin nil)
	(progn
		(setq dCoordOn T)
	)
	(progn
		(setq dCoordOn (atoi lin))
	)
)
(setq lin (read-line savef))
(if (= lin nil)
	(progn
		(setq dCLbl T)
	)
	(progn
		(setq dCLbl (atoi lin))
	)
)
(setq
	PntOn dPntOn
	LblOn dLblOn
	BoxOn dBoxOn
	CoordOn dCoordOn
	CLbl dCLbl
)
(close saveF)
(setq textAR (- (* PI 2) (getvar "viewtwist")))
(setq textA (* textAR (/ 180 PI)))

(defun c:cur( / num msg) ; Sets OSNAP mode to the standard as dictated by the save file
	(setvar "osmode" cur_oVal)
	(setq num (itoa cur_oVal))
	(setq msg (strcat "OSMODE set to " num))
	(princ msg)
	(princ)
) ; defun

(defun c:cir() ; Sets OSNAP mode to just node and circle, for selecting circles
	(setq cur_oVal (getvar "osmode"))
	(setvar "osmode" 12)
	(princ "OSMODE set to 12")
	(princ)
) ; defun

(defun c:recur() ; Sets saved OSNAP mode to the current mode
	(setq cur_oVal (getvar "osmode"))
	(writeToFile nil nil nil (rtos cur_oVal) nil nil nil nil nil)
	(princ)
) ; defun

(defun c:defpt()
	(PntNLbl dPntOn dLblOn dBoxOn dCoordOn dCLbl)
	(princ)
)

(defun c:pt()
	(PntNLbl PntOn LblOn BoxOn CoordOn CLbl)
	(princ)
)

; Places point and records coordinate in file, labels the point and repeats with the label increasing by 1
; Different modes affect which capabilites are enabled

(defun PntNLbl(m1 m2 m3 m4 m5 / pnt1 pnt2 pnt3 pntb a b dis x y linN ss numStr wrt os num rAng sel)
	(setq lp 1)
	(setq em 0)
	(setq coordF (open "C:\\Users\\Ecoland\\Documents\\Helpful Code\\LSP Files\\CoordFile.txt" "w"))
	(setq ch (findfile "C:\\Users\\Ecoland\\Documents\\Helpful Code\\LSP Files\\SaveFile.txt"))
	(if (= ch nil)
		(setq num (getint "\nEnter the first number: "))
		(progn
			(setq saveF (open "C:\\Users\\Ecoland\\Documents\\Helpful Code\\LSP Files\\SaveFile.txt" "r"))
			(setq lin (read-line savef))
			(close saveF)
			(if (= lin nil)
				(progn
					(setq num (vl-catch-all-apply 'getint (list "Enter the first number: ")))
					(if (vl-catch-all-error-p num)
						(if (equal (vl-catch-all-error-message b) "Function cancelled")
							(setq lp 0)
							(progn
								(print (strcat "Error: " (vl-catch-all-error-message b) ". First number set to 1."))
								(setq num 1)
							)
						)
					)
				)
				(progn
					(setq linN (atoi lin))
					(setq num linN)
				) ; progn
			) ; if
		) ; progn
	) ; if
	(if (= lp 1)
		(progn
			(setq numStr (rtos num))
			(setq outN (strcat "Starting point: " numStr))
			(setq outF (getvar "dwgname"))
			(write-line outN coordF)
			(write-line outF coordF)
			(write-line "" coordF)
			(if (not bns_tcircle) (load "acettxt.lsp"))
		)
	)
	(while (= lp 1)
		(if (or (= m1 1) (= m4 1))
			(progn
				(if (> (getvar "osmode") 16383) (setvar "osmode" (- (getvar "osmode") 16384)))
				(setq pnt1 (vl-catch-all-apply 'getpoint (list "\nChoose point: ")))
				(if (vl-catch-all-error-p pnt1)
					(progn
						(if (equal (vl-catch-all-error-message pnt1) "Function cancelled") ()
							(progn
								(print (strcat "Error: " (vl-catch-all-error-message pnt1) "."))
								(setq em 2)
							)
						)
						(setq lp 0)
					)
					(progn
						(if (= m1 1) (command "._point" pnt1))
						(if (= m4 1)
							(progn
								(setq x (rtos (car pnt1) 2 5))
								(setq y (rtos (cadr pnt1) 2 5))
								(setq wrt (strcat x "," y))
							) ; progn
						) ; if
					) ; progn
				) ; if
			) ; progn
		) ; if
		(if (and (= m2 1) (= lp 1))
			(progn
				(if (< (getvar "osmode") 16384) 
					(progn
						(setq os 1)
						(setvar "osmode" (+ (getvar "osmode") 16384))
					)
					(setq os 0)
				)
				(if (= m5 1)
					(progn
						(setq num (vl-catch-all-apply 'getstring (list "Input label: ")))
						(if (vl-catch-all-error-p num)
							(progn
								(if (equal (vl-catch-all-error-message num) "Function cancelled")
									(setq em 1)
									(progn
										(print (strcat "Error: " (vl-catch-all-error-message num) "."))
										(setq em 2)
									)
								)
								(setq lp 0)
							)
						)
					)
				)
				(if (= lp 1)
					(if (or (= m1 1) (= m4 1))
						(setq pnt2 pnt1)
						(progn
							(setq pnt2 (getCursor))
							;(setq pnt2 (vl-catch-all-apply 'getpoint (list "Choose approximate label position: ")))
							;(if (vl-catch-all-error-p pnt2)
							;	(progn
							;		(if (equal (vl-catch-all-error-message pnt2) "Function cancelled")
							;			(setq em 1)
							;			(progn
							;				(print (strcat "Error: " (vl-catch-all-error-message pnt2) "."))
							;				(setq em 2)
							;			)
							;		)
							;		(setq lp 0)
							;	)
							;)
						)
					)
				)
				(if (= lp 1)
					(progn
						(setq dis (sqrt (* (expt (* textH 0.6) 2) 2)))
						(setq rAng (* textA (/ PI 180)))
						(setq a (* dis (cos (+ rAng (/ PI 4)))))
						(setq b (* dis (sin (+ rAng (/ PI 4)))))
						(setq pntf (list (+ (car pnt2) a) (+ (cadr pnt2) b)))
						(command "._text" pntf textH textA num)
						(setq ss (ssget "_L"))
						(if (= m3 1)
							(progn
								(bns_tcircle ss "Variable" "Rectangles" nil 0.5)
								(setq ss (ssadd (entlast) ss))
							) ; progn
						) ; if
						(setq dis (sqrt (* (expt (* textH 0.1) 2) 2)))
						(setq a (* dis (cos (+ rAng (/ PI 4)))))
						(setq b (* dis (sin (+ rAng (/ PI 4)))))
						(setq pntb (list (+ (car pnt2) a) (+ (cadr pnt2) b)))
						(if (= m5 1)
							(setq mul (strlen num))
							(progn
								(setq mg 1.0)
								(setq mul 0)
								(while (>= (/ num mg) 1) ; determines the number of digits of the label so that the four points contain the entire number
									(setq mul (1+ mul))
									(setq mg (* mg 10.0))
								)
							)
						)
						(repeat (setq cnt (sslength ss))
							(setq e (ssname ss (setq cnt (1- cnt))))
							(if (= (cdr (assoc 0 (entget e))) "TEXT")
								(progn
									(setq xc (cadr (assoc 10 (entget e))))
									(setq yc (caddr (assoc 10 (entget e))))
									(setq pntm1 (list xc yc))
								)
							)
						)
						(setq err (vl-catch-all-apply 'moveL (list ss pntb)))
						(repeat (setq cnt (sslength ss))
							(setq e (ssname ss (setq cnt (1- cnt))))
							(if (= (cdr (assoc 0 (entget e))) "TEXT")
								(progn
									(setq xc (cadr (assoc 10 (entget e))))
									(setq yc (caddr (assoc 10 (entget e))))
									(setq pntm2 (list xc yc))
								)
							)
						)
						(if (equal pntm1 pntm2)
							(progn
								(setq em 1)
								(setq lp 0)
							)
						)
						(if (vl-catch-all-error-p err)
							(progn
								(print (strcat "Error: " (vl-catch-all-error-message err) "."))
								(setq em 2)
								(setq lp 0)
							)
						)
						(if (and (= os 1) (> (getvar "osmode") 16383)) (setvar "osmode" (- (getvar "osmode") 16384)))
					)
				)
			) ; progn
		) ; if
		(if (and (= m5 0) (= lp 1))
			(progn
				(setq num (1+ num))
				(setq numStr (rtos num))
				(writeToFile numStr nil nil nil nil nil nil nil nil)
			)
		)
		(if (and (= m4 1) (= lp 1)) (write-line wrt coordF))
	) ; while
	(HandErr em (= m1 1) (= m2 1) (= m4 1))
	(close coordF)
	(princ)
)

(defun moveL(sel pntb)
	(command "._move" sel "" pntb pause)
	(princ)
)

(defun HandErr(em m1 m2 m4)
	(if (and m1 (= em 1))
		(if m2 (command "._undo" 3) (command "._undo" 1))	
	)
	(if m4
		(progn
			(setq loop T)
			(while loop
				(setq q (getstring "Save to File [Y/N]: "))
				(if (or (= q "Y") (= q "y"))
					(progn
						(setq cMode (open "C:\\Users\\Ecoland\\Documents\\Helpful Code\\cModes.txt" "w"))
						(write-line "0" cMode)
						(close cMode)
						(startapp "C:\\Users\\Ecoland\\Documents\\Helpful Code\\Coordinate Formatter.exe")
						(print "Coordinates saved to file.")
						(setq loop nil)
					)
					(progn
						(if (or (= q "N") (= q "n"))
							(setq loop nil)
							(progn
								(print "Invalid input!")
							)
						)
					)
				)
			)
		)
	)
	(if (= em 2)
		(print "Function terminated improperly.")
	)
)

(defun c:test()
	(c:setnum)
	(princ)
)

(defun test2(a)
	(setq b (vl-catch-all-apply 'getpoint (list "Input num: ")))
	(if (vl-catch-all-error-p b)
		(progn
			(if (equal (vl-catch-all-error-message b) "Function cancelled")
				(print "esc pressed in 2")
				(print (strcat "not esc2: " (vl-catch-all-error-message b)))
			)
			(setq b 2)
		)
	)
	(/ a b)
)

(defun addpnts(size angle pnt2 mul / x y x1 y1 h th pnt3 pnt4 pnt5 box a b c d rAng ss dis) ; Useless now I think, keep just in case
	(setq y (* 2.2 size)) ; The following code uses trigonometry to determine the locations of the points for any coordinate plane oreintation
	(setq x (* (+ mul 1.1) size))
	(setq rAng (* angle (/ PI 180))) 
	(setq h (sqrt (+ (expt x 2) (expt y 2))))
	(setq th (atan (/ y x)))
	(setq th (+ rAng th))
	(setq dis (sqrt (* (expt (* size 0.6) 2) 2)))
	(setq x1 (* dis (cos (+ rAng (/ PI 4)))))
	(setq y1 (* dis (sin (+ rAng (/ PI 4)))))
	(setq a (- (car pnt2) x1))
	(setq b (- (cadr pnt2) y1))
	(setq pnt2 (list a b))
	(setq x1 (* h (cos th)))
	(setq y1 (* h (sin th)))
	(setq pnt3 (list (+ a x1) (+ b y1)))
	(setq x1 (* x (cos rAng)))
	(setq y1 (* x (sin rAng)))
	(setq pnt4 (list (+ a x1) (+ b y1)))
	(setq x1 (* y (cos (+ (/ PI 2) rAng))))
	(setq y1 (* y (sin (+ (/ PI 2) rAng))))
	(setq pnt5 (list (+ a x1) (+ b y1)))
	;(command "._point" pnt2) ; For debugging
	;(command "._point" pnt3)
	;(command "._point" pnt4)
	;(command "._point" pnt5)
	(setq box (list pnt2 pnt5 pnt3 pnt4))
	(setq curLay (getvar "clayer"))
	(setq ss (ssget "WP" box (list '(-4 . "<AND") '(-4 . "<OR") '(0 . "TEXT") '(0 . "LWPOLYLINE") '(-4 . "OR>") (cons 8 curLay) '(-4 . "AND>"))))
) ; defun

(defun c:setNum( / numStr num) ; Sets new starting number for label, and saves it to the save file
	(setq num (getint "\nEnter new starting number: "))
	(setq numStr (rtos num))
	(writeToFile numStr nil nil nil nil nil nil nil nil)
	(princ)
) ; defun

(defun c:setText( / textHStr textAStr pnt1 pnt2 ang) ; Sets new height and angle of text, and saves it to the save file
	(c:setHeight)
	(c:setAngle)
	(princ)
) ; defun

(defun c:setHeight( / textHStr)
	(setq textH (getdist (getCursor) "\nSelect height of text: "))
	(setq textHStr (rtos textH 2 3))
	(print (strcat "Text height: " textHStr))
	(writeToFile nil textHStr nil nil nil nil nil nil nil)
	(princ)
)

(defun getCursor( / a b c tpnt)
	(setq
		c (grread T)
		tpnt (cadr c)
		a (car tpnt)
		b (cadr tpnt)
		pnt1 (list a b)
	)
)

(defun c:setAngle( / ang textAStr)
	(setq ang (getorient (getCursor) "\nDraw a horizontal line: "))
	(setq textA (* ang (/ 180 PI)))
	(setq textAStr (rtos textA 2 2))
	(print (strcat "Text angle: " textAStr " degrees"))
	(writeToFile nil nil textAStr nil nil nil nil nil nil)
	(princ)
)

(defun writeToFile(strt textH textA cur_oVal fPnt fLbl fBox fCoord fCLbl / strtt textHt textAt cur_oValt fPntt fLblt fBoxt fCoordt fCLblt) ; Writes values to the save file
	(setq strtt strt)
	(setq textHt textH)
	(setq textAt textA)
	(setq cur_oValt cur_oVal)
	(setq fPntt fPnt)
	(setq fLblt fLbl)
	(setq fBoxt fBox)
	(setq fCoordt fCoord)
	(setq fCLblt fCLbl)
	(setq saveF (open "C:\\Users\\Ecoland\\Documents\\Helpful Code\\LSP Files\\SaveFile.txt" "r"))
	(setq lin (read-line savef)) ; strt
	(if (and (not(= lin "NULL")) (not strt)) (setq strtt lin))
	(setq lin (read-line savef)) ; textH
	(if (and (not(= lin "NULL")) (not textH)) (setq textHt lin))
	(setq lin (read-line savef)) ; textA
	(if (and (not(= lin "NULL")) (not textA)) (setq textAt lin))
	(setq lin (read-line savef)) ; cur_oVal
	(if (and (not(= lin "NULL")) (not cur_oVal)) (setq cur_oValt lin))
	(setq lin (read-line savef)) ; fPnt
	(if (and (not(= lin "NULL")) (not fPnt)) (setq fPntt lin))
	(setq lin (read-line savef)) ; fLbl
	(if (and (not(= lin "NULL")) (not fLbl)) (setq fLblt lin))
	(setq lin (read-line savef)) ; fBox
	(if (and (not(= lin "NULL")) (not fBox)) (setq fBoxt lin))
	(setq lin (read-line savef)) ; fCoord
	(if (and (not(= lin "NULL")) (not fCoord)) (setq fCoordt lin))
	(setq lin (read-line savef)) ; fCLbl
	(if (and (not(= lin "NULL")) (not fCLbl)) (setq fCLblt lin))
	(close saveF)
	(vl-file-delete "C:\\Users\\Ecoland\\Documents\\Helpful Code\\LSP Files\\SaveFile.txt")
	(setq saveF (open "C:\\Users\\Ecoland\\Documents\\Helpful Code\\LSP Files\\SaveFile.txt" "w"))
	(if (not strtt) (write-line "NULL" saveF) (write-line strtt saveF))
	(if (not textHt) (write-line "NULL" saveF) (write-line textHt saveF))
	(if (not textAt) (write-line "NULL" saveF) (write-line textAt saveF))
	(if (not cur_oValt) (write-line "NULL" saveF) (write-line cur_oValt saveF))
	(if (not fPntt) (write-line "NULL" saveF) (write-line fPntt saveF))
	(if (not fLblt) (write-line "NULL" saveF) (write-line fLblt saveF))
	(if (not fBoxt) (write-line "NULL" saveF) (write-line fBoxt saveF))
	(if (not fCoordt) (write-line "NULL" saveF) (write-line fCoordt saveF))
	(if (not fCLblt) (write-line "NULL" saveF) (write-line fCLblt saveF))
	(close saveF)
	(princ)
) ; defun

(defun c:PLSet( / df u ln linArr dcl_id PreNam chk)
	(setq dcl_id (load_dialog "C:\\Users\\Ecoland\\Documents\\GitHub Files\\Ecoland-Code\\Additional-Functions Dialog.dcl"))
	(new_dialog "PLSet" dcl_id)
	(setq
		PntOn 0
		LblOn 0
		BoxOn 0
		CoordOn 0
		CLbl 0
		df nil
		u nil
		PreNam ""
	)
	(action_tile "f1" "(setq PntOn 1)")
	(action_tile "f2" "(setq LblOn 1)")
	(action_tile "f3" "(setq BoxOn 1)")
	(action_tile "f4" "(setq CoordOn 1)")
	(action_tile "d1" "(setq df T)")
	(action_tile "d2" "(setq df nil)")
	(action_tile "o1" "(setq CLbl 1)")
	(action_tile "cancel" "(done_dialog) (setq u nil)")
	(action_tile "accept"
		(strcat
		"(setq PreNam (get_tile \"e1\")) "
		"(setq u T) "
		"(done_dialog) "
		"(if (= df T)
			(progn	
				(writeToFile nil nil nil nil (itoa PntOn) (itoa LblOn) (itoa BoxOn) (itoa CoordOn) (itoa CLbl))
				(setq dPntOn PntOn)
				(setq dLblOn LblOn)
				(setq dBoxOn BoxOn)
				(setq dCoordOn CoordOn)
				(setq dCLbl CLbl)
			)
		)"
		)
	)
	(start_dialog)
	(unload_dialog dcl_id)
	(if (= PreNam "") ()
		(progn
			(setq temp PreNam)
			(setq chk 0)
			(while (not (= temp ""))
				(if (= (substr temp 1 1) " ") (setq chk 1))
				(setq temp (substr temp 2 (- (strlen temp) 1)))
			)
			(if (= chk 0)
				(progn
					(setq linArr (list nil))
					(setq chk 0)
					(if (findfile "C:\\Users\\Ecoland\\Documents\\Helpful Code\\LSP Files\\Preset.lsp")
						(progn
							(setq preset (open "C:\\Users\\Ecoland\\Documents\\Helpful Code\\LSP Files\\Preset.lsp" "r"))
							(setq ln nil)
							(if (= (setq ln (read-line preset)) nil) ()
								(progn
									(setq linArr (list ln))
									(while (not (= (setq ln (read-line preset)) nil))
										(if (= (strcase (substr ln 10 (- (strlen ln) 11)) T) (strcase PreNam T)) (setq chk 1))
										(setq linArr (append linArr (list ln)))
									)
								)
							)
							(close preset)
							(setq linArr (append linArr (list nil)))
						)
					)
					(setq preset (open "C:\\Users\\Ecoland\\Documents\\Helpful Code\\LSP Files\\Preset.lsp" "w"))
					(while (not (= (car linArr) nil))
						(write-line (car linArr) preset)
						(setq linArr (cdr linArr))
					)
					(if (= chk 0)
						(progn
							(write-line (strcat "(defun c:" PreNam "()") preset)
							(write-line (strcat "	(PntNLbl " (itoa PntOn) " " (itoa LblOn) " " (itoa BoxOn) " " (itoa CoordOn) " " (itoa CLbl) ")") preset)
							(write-line "	(princ)" preset)
							(write-line ")\n" preset)
						)
						(prompt "That preset name is already in use.")
					)
					(close preset)
					(load "C:\\Users\\Ecoland\\Documents\\Helpful Code\\LSP Files\\Preset.lsp")
				)
				(prompt "Invalid command name. Spaces are not allowed.")
			)
		)
	)
	(princ)
)

(defun c:AFMenu( / dcl_id)
	(setq flag 4)
	(setq dcl_id (load_dialog "C:\\Users\\Ecoland\\Documents\\GitHub Files\\Ecoland-Code\\Additional-Functions Dialog.dcl"))
	(new_dialog "AFMenu" dcl_id)
	(setq i 0)
	(while (and (> flag 2) (< i 5))
		(action_tile "cancel" "(done_dialog 0)")
		(action_tile "accept" "(done_dialog 1)")
		(action_tile "point" "(done_dialog 4)")
		(setq flag (start_dialog))
		(if (= flag 4)
			(print "hello")
		)
		(setq i (1+ i))
	)
	(unload_dialog dcl_id)
	(princ)
)

(defun c:reload()
	(load "C:\\Users\\Ecoland\\Documents\\GitHub Files\\Ecoland-Code\\Additional-Functions.lsp")
	(princ)
)

(defun c:deleteF()
	(findfile "C:\\Users\\Ecoland\\Documents\\Helpful Code\\LSP Files\\Preset.lsp")
	(vl-file-delete "C:\\Users\\Ecoland\\Documents\\Helpful Code\\LSP Files\\Preset.lsp")
	(princ)
)

(defun callPt()
	(c:pt)
)

(defun c:listPres( / presF ln)
	(setq presF (open "C:\\Users\\Ecoland\\Documents\\Helpful Code\\LSP Files\\Preset.lsp" "r"))
	(prompt "List of Presets:\n")
	(while (not (= (setq ln (read-line presF)) nil))
		(prompt (strcat "--" (substr ln 10 (- (strlen ln) 11)) "--\n"))
		(setq ln (read-line presF))
		(prompt (strcat "   -Point: " (if (= (substr ln 11 1) "1") "On" "Off") "\n"))
		(prompt (strcat "   -Label: " (if (= (substr ln 13 1) "1") "On" "Off") "\n"))
		(prompt (strcat "   -Label Border: " (if (= (substr ln 15 1) "1") "On" "Off") "\n"))
		(prompt (strcat "   -Record Coordinate: " (if (= (substr ln 17 1) "1") "On" "Off") "\n"))
		(prompt (strcat "   -Custom Label: " (if (= (substr ln 19 1) "1") "On" "Off") "\n"))
		(setq ln (read-line presF))
		(setq ln (read-line presF))
		(setq ln (read-line presF))
	)
	(close presF)
	(princ)
)

(defun c:delPres( / presF chk presNam ln linArr)
	(setq presNam (getstring "Input preset name to be deleted: "))
	(setq presF (open "C:\\Users\\Ecoland\\Documents\\Helpful Code\\LSP Files\\Preset.lsp" "r"))
	(setq chk 0)
	(while (not (= (setq ln (read-line presF)) nil))
		(if (= (strcase (substr ln 10 (- (strlen ln) 11)) T) (strcase presNam T))
			(setq chk 1)
		)
	)
	(close presF)
	(if (= chk 0)
		(prompt "There is no preset with that name.")
		(progn
			(setq presF (open "C:\\Users\\Ecoland\\Documents\\Helpful Code\\LSP Files\\Preset.lsp" "r"))
			(setq ln (read-line presF))
			(setq linArr (list ln))
			(while (not (= (setq ln (read-line presF)) nil))
				(setq linArr (append linArr (list ln)))
			)
			(close presF)
			(setq presF (open "C:\\Users\\Ecoland\\Documents\\Helpful Code\\LSP Files\\Preset.lsp" "w"))
			(while (not (= (car linArr) nil))
				(if (= (strcase (substr (car linArr) 10 (- (strlen (car linArr)) 11)) T) (strcase presNam T))
					(progn
						(setq linArr (cddddr linArr))
						(setq linArr (cdr linArr))
					)
					(progn
						(write-line (car linArr) presF)
						(setq linArr (cdr linArr))
						(write-line (car linArr) presF)
						(setq linArr (cdr linArr))
						(write-line (car linArr) presF)
						(setq linArr (cdr linArr))
						(write-line (car linArr) presF)
						(setq linArr (cdr linArr))
						(write-line (car linArr) presF)
						(setq linArr (cdr linArr))
					)
				)
				
			)
			(close presF)
			(prompt "Preset deleted.")
		)
	)
	(princ)
)

(defun c:delAPres()
	(setq presF (open "C:\\Users\\Ecoland\\Documents\\Helpful Code\\LSP Files\\Preset.lsp" "w"))
	(close presF)
	(prompt "All presets deleted.")
	(princ)
)

(defun c:backupPoints()
	(setq cMode (open "C:\\Users\\Ecoland\\Documents\\Helpful Code\\cModes.txt" "w"))
	(write-line "4" cMode)
	(close cMode)
	(startapp "C:\\Users\\Ecoland\\Documents\\Helpful Code\\Coordinate Formatter.exe")
)

(prompt "\nAdditional functions loaded.")
(princ)