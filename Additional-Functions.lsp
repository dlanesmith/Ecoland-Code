; ---Additional Functions---
; Written by David Lane-Smith
; To optimize use of AutoCAD at Ecoland Inc.



; Reads the save file and sets variables to their saved values upon loading program

(setq saveF (open "C:\\Users\\Ecoland\\Documents\\Helpful Code\\LSP Files\\SaveFile.txt" "r"))
(setq lin (read-line savef))
(if (= lin nil) (setq num 1) (setq num (atof lin)))
(setq lin (read-line savef))
(if (= lin nil) (setq textH 1) (setq textH (atof lin)))
(setq lin (read-line savef))
(setq lin (read-line savef))
(if (= lin nil) (setq cur_oVal (getvar "osmode")) (setq cur_oVal (atoi lin)))
(setq lin (read-line savef))
(if (= lin nil) (setq PntOn T) (setq PntOn (atoi lin)))
(setq lin (read-line savef))
(if (= lin nil) (setq LblOn T) (setq LblOn (atoi lin)))
(setq lin (read-line savef))
(if (= lin nil) (setq BoxOn T) (setq BoxOn (atoi lin)))
(setq lin (read-line savef))
(if (= lin nil) (setq CoordOn T) (setq CoordOn (atoi lin)))
(setq lin (read-line savef))
(if (= lin nil) (setq CLbl T) (setq CLbl (atoi lin)))
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
	(PntNLbl PntOn LblOn BoxOn CoordOn CLbl)
	(princ)
)

(defun c:pNt()
	(setq err (vl-catch-all-apply 'PntNLbl (list 1 1 1 1 0)))
	(if (vl-catch-all-error-p err)
		(print (strcat "Error: " (vl-catch-all-error-message err) ". Try again."))
	)
	(princ)
)

(defun c:ptO()
	(PntNLbl 1 0 0 1 0)
	(princ)
)

(defun c:ttO()
	(PntNLbl 0 1 1 1 0)
	(princ)
)

(defun c:getCoord()
	(PntNLbl 0 0 0 1 0)
	(princ)
)

(defun c:dLabel()
	(PntNLbl 0 1 1 0 0)
	(princ)
)

(defun c:pnb()
	(PntNLbl 1 1 0 1 0)
	(princ)
)

; Places point and records coordinate in file, labels the point and repeats with the label increasing by 1
; Different modes affect which capabilites are enabled

(defun PntNLbl(m1 m2 m3 m4 m5 / pnt1 pnt2 pnt3 pntb a b dis x y linN ss numStr wrt os num rAng sel)
	(setq lp 1)
	(setq em 0)
	(setq cMode (open "C:\\Users\\Ecoland\\Documents\\Helpful Code\\cModes.txt" "w"))
	(write-line "0" cMode)
	(close cMode)
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
				(setq pnt1 (vl-catch-all-apply 'getpoint (list "Choose point: ")))
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
						(setq err (vl-catch-all-apply 'moveL (list ss pntb)))
						(print err)
						(if (vl-catch-all-error-p err)
							(progn
								(print "moveErr")
								(if (equal (vl-catch-all-error-message err) "Function cancelled")
									(setq em 1)
									(progn
										(print (strcat "Error: " (vl-catch-all-error-message err) "."))
										(setq em 2)
									)
								)
								(setq lp 0)
							)
						)
						(if (= os 1) (setvar "osmode" (- (getvar "osmode") 16384)))
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
	(print "HandErr")
	(if (and m1 (= em 1))
		(if m2 (command "._undo" 3) (command "._undo" 1))	
	)
	;(if m4
	;	(progn
	;		(startapp "C:\\Users\\Ecoland\\Documents\\Helpful Code\\Coordinate Formatter.exe")
	;		(print "Coordinates saved to file.")
	;	)
	;)
	(if (= em 2)
		(print "Function terminated improperly.")
	)
)

(defun c:test()
	(setq a 0)
	(while (< a 10)
		(setq pnt1 (vl-catch-all-apply 'getpoint (list "Pick point")))
		(if (vl-catch-all-error-p pnt1)
			(progn
				(command "._undo" 1)
				(if (equal (vl-catch-all-error-message pnt1) "Function cancelled")
					(print "esc pressed from 1")
					(print (strcat "not esc: " (vl-catch-all-error-message pnt1)))
				)
				(break)
			)
			(command "._point" pnt1)
		)
		(setq a (1+ a))
	)
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

(defun c:PLSet( / df u ln linArr)
	(setq dcl_id (load_dialog "C:\\Users\\Ecoland\\Documents\\GitHub Files\\Ecoland-Code\\UIBox.dcl"))
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
		"(if (= df T) (writeToFile nil nil nil nil (itoa PntOn) (itoa LblOn) (itoa BoxOn) (itoa CoordOn) (itoa CLbl)))"
		)
	)
	(start_dialog)
	(unload_dialog dcl_id)
	(if (= PreNam "") ()
		(progn
			(setq linArr (list nil))
			(if (findfile "C:\\Users\\Ecoland\\Documents\\Helpful Code\\LSP Files\\Preset.lsp")
				(progn
					(setq preset (open "C:\\Users\\Ecoland\\Documents\\Helpful Code\\LSP Files\\Preset.lsp" "r"))
					(if (= (setq ln (read-line preset)) nil) ()
						(progn
							(setq linArr (list ln))
							(while (not (= (setq ln (read-line preset)) nil))
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
			(write-line (strcat "(defun c:" PreNam "()") preset)
			(write-line (strcat "	(PntNLbl " (itoa PntOn) " " (itoa LblOn) " " (itoa BoxOn) " " (itoa CoordOn) " " (itoa CLbl) ")") preset)
			(write-line "	(princ)" preset)
			(write-line ")\n" preset)
			(close preset)
			(load "C:\\Users\\Ecoland\\Documents\\Helpful Code\\LSP Files\\Preset.lsp")
		)
	)
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

(prompt "\nAdditional functions loaded.")
(princ)