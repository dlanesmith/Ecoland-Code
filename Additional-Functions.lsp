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
(setq lin (read-line savef))
(if (= lin nil)
	(progn
		(setq elOn 1)
	)
	(progn
		(setq elOn (atoi lin))
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
(setq norm 1)

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
	(writeToSaveFile nil nil nil (rtos cur_oVal) nil nil nil nil nil nil)
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

(defun PntNLbl(m1 m2 m3 m4 m5 / lp2 xc yc pntm1 pntm2 cnt e mul mg outN outFsaveF lin coordF ch lp em pnt1 pnt2 pnt3 pntb pntf a b dis x y linN ss numStr wrt os num rAng sel)
	(setq lp 1)
	(setq lp2 1)
	(setq em 0)
	(regapp "Name")
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
								(prompt (strcat "\nError: " (vl-catch-all-error-message b) ". First number set to 1."))
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
			(setq outN (rtos m5))
			(setq outF (getvar "dwgname"))
			(write-line outN coordF)
			(write-line outF coordF)
			(write-line "" coordF)
			(if (not bns_tcircle) (load "acettxt.lsp"))
		)
	)
	(while (and (= lp 1) (= lp2 1))
		(if (or (= m1 1) (= m4 1))
			(progn
				(if (> (getvar "osmode") 16383) (setvar "osmode" (- (getvar "osmode") 16384)))
				(setq pnt1 (vl-catch-all-apply 'getpoint (list "\nChoose point: ")))
				(if (vl-catch-all-error-p pnt1)
					(progn
						(if (equal (vl-catch-all-error-message pnt1) "Function cancelled") ()
							(progn
								(prompt (strcat "\nError: " (vl-catch-all-error-message pnt1) "."))
								(setq em 2)
							)
						)
						(setq lp 0)
					)
					(progn
						(if (= m1 1) (progn (command "._point" pnt1) (setq pntName (entlast))) (setq pntName nil))
						(if (= m4 1)
							(progn
								(setq x (rtos (car pnt1) 2 5))
								(setq y (rtos (cadr pnt1) 2 5))
								(setq z (rtos (caddr pnt1) 2 5))
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
				(setq numStr (itoa num))
				;(if (= elOn 1)
				;	(setq fP "C:\\Users\\Ecoland\\Documents\\Point Drawings\\Points\\Deleted Points\\")
				;	(setq fN (getvar "dwgname"))
				;	(setq i 1)
				;	(while (not (= (substr fN i 1) ".")) (setq i (1+ i)))
				;	(setq fN (substr fN 1 (- i 1)))
				;	(setq fP (strcat fP fN "-deleted points.txt"))
				;	(setq delF (open fP "r"))
				;	(setq lin (read-line delF))
				;	(if (not (= lin nil))
				;		(progn
				;			(setq numStr lin)
				;			(setq lst '())
				;			(while (not (= (setq lin (read-line delF)) nil))
				;				(setq lst (append lst (list lin)))
				;			)
				;			(close delF)
				;			(setq delF (open fP "w"))
				;			(while (not (= (car lst) nil))
				;				(write-line (car lst) delF)
				;				(setq lst (cdr lst))
				;			)
				;		)
				;	)
				;)
				(if (= m5 1)
					(progn
						(setq numStr (vl-catch-all-apply 'getstring (list "Input label: ")))
						(if (vl-catch-all-error-p numStr)
							(progn
								(if (equal (vl-catch-all-error-message numStr) "Function cancelled")
									(setq em 1)
									(progn
										(prompt (strcat "\nError: " (vl-catch-all-error-message numStr) "."))
										(setq em 2)
									)
								)
								(setq lp 0)
							)
						)
					)
				)
				(if (= lp 1)
					(progn
						(if (= m4 1) 
							(progn
								(setq wrt (strcat numStr "," x "," y))
								(if (= elOn 1) (setq wrt (strcat wrt "," z)))
							)
						)
						(if (or (= m1 1) (= m4 1))
							(setq pnt2 pnt1)
							(progn
								(setq pnt2 (getCursor))
							)
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
						(print numStr)
						(command "._text" pntf textH textA numStr)
						(setq txtName (entlast))
						(setq ss (ssget "_L"))
						(if (= m3 1)
							(progn
								(bns_tcircle ss "Variable" "Rectangles" nil 0.5)
								(setq boxName (entlast))
								(setq ss (ssadd (entlast) ss))
							) ; progn
						) ; if
						(setq dis (sqrt (* (expt (* textH 0.1) 2) 2)))
						(setq a (* dis (cos (+ rAng (/ PI 4)))))
						(setq b (* dis (sin (+ rAng (/ PI 4)))))
						(setq pntb (list (+ (car pnt2) a) (+ (cadr pnt2) b)))
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
								(prompt (strcat "\nError: " (vl-catch-all-error-message err) "."))
								(setq em 2)
								(setq lp 0)
							)
						)
						(if (and (= os 1) (> (getvar "osmode") 16383)) (setvar "osmode" (- (getvar "osmode") 16384)))
					)
				)
				(if (= lp 1)
					(progn
						(if (not (= pntName nil))
							(progn
								(setq lastent (entget pntName))
								(setq exdata (list (list -3 (list "Name" (cons 1000 numStr)))))
								(setq lastent (append lastent exdata))
								(entmod lastent)
							)
						)
						(if (not (= txtName nil))
							(progn
								(setq lastent (entget txtName))
								(setq exdata (list (list -3 (list "Name" (cons 1000 numStr)))))
								(setq lastent (append lastent exdata))
								(entmod lastent)
							)
						)
						(if (not (= boxName nil))
							(progn
								(setq lastent (entget boxName))
								(setq exdata (list (list -3 (list "Name" (cons 1000 numStr)))))
								(setq lastent (append lastent exdata))
								(entmod lastent)
							)
						)
					)
				)
			) ; progn
		) ; if
		(if (and (= m5 0) (= lp 1))
			(progn
				(setq num (1+ num))
				(setq numStr (rtos num))
				(writeToSaveFile numStr nil nil nil nil nil nil nil nil nil)
			)
		)
		(if (and (= m4 1) (= lp 1)) (write-line wrt coordF))
		(if (= norm 0) (setq lp2 0))
	) ; while
	(if (= norm 1) (HandErr em (= m1 1) (= m2 1) (= m4 1)))
	(close coordF)
	(princ)
)

(defun moveL(sel pntb)
	(command "._move" sel "" pntb pause)
	(princ)
)

(defun HandErr(em m1 m2 m4 / q loop)
	(if (= em 1)
		(if m1
			(if m2 (command "._undo" 3) (command "._undo" 1))
			(if m2 (command "._undo" 2))
		)
	)
	(if m4
		(progn
			(setq loop T)
			(while loop
				(setq q (getYN "Save to File [Y/N]: "))
				(if (= q 1)
					(progn
						(writeToCModes "0" nil nil)
						(startapp "C:\\Users\\Ecoland\\Documents\\Helpful Code\\Coordinate Formatter.exe")
						(prompt "\nCoordinates saved to file.")
						(setq loop nil)
					)
					(progn
						(if (= q 0)
							(setq loop nil)
							(progn
								(prompt "Invalid input!\n")
							)
						)
					)
				)
			)
		)
	)
	(if (= em 2)
		(prompt "\nFunction terminated improperly.")
	)
)

(defun getYN(pr / inS loop)
	(setq loop T)
	(while loop
		(setq inS (getstring pr))
		(if (or (= inS "Y") (= inS "y")) (progn (setq loop nil) 1) 
			(progn
				(if (or (= ins "N") (= ins "n")) (progn (setq loop nil) 0)
					(progn
						(prompt "Invalid input. Try again.\n")
					)
				)
			)
		)
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

(defun c:setNum( / numStr num) ; Sets new starting number for label, and saves it to the save file
	(setq num (getint "\nEnter new starting number: "))
	(setq numStr (rtos num))
	(writeToSaveFile numStr nil nil nil nil nil nil nil nil nil)
	(princ)
) ; defun

(defun c:setText() ; Sets new height and angle of text, and saves it to the save file
	(c:setHeight)
	(c:setAngle)
	(princ)
) ; defun

(defun c:setHeight( / textHStr)
	(setq textH (getdist (getCursor) "\nSelect height of text: "))
	(setq textHStr (rtos textH 2 3))
	(prompt (strcat "\nText height: " textHStr))
	(writeToSaveFile nil textHStr nil nil nil nil nil nil nil nil)
	(princ)
)

(defun getCursor( / a b c tpnt pnt)
	(setq
		c (grread T)
		tpnt (cadr c)
		a (car tpnt)
		b (cadr tpnt)
		pnt (list a b)
	)
)

(defun c:setAngle( / ang textAStr)
	(setq ang (getorient (getCursor) "\nDraw a horizontal line: "))
	(setq textA (* ang (/ 180 PI)))
	(setq textAStr (rtos textA 2 2))
	(prompt (strcat "\nText angle: " textAStr " degrees"))
	(writeToSaveFile nil nil textAStr nil nil nil nil nil nil nil)
	(princ)
)

(defun writeToSaveFile(strt textH textA cur_oVal fPnt fLbl fBox fCoord fCLbl elOn / strtt textHt textAt cur_oValt fPntt fLblt fBoxt fCoordt fCLblt elOnt saveF lin) ; Writes values to the save file
	(setq strtt strt)
	(setq textHt textH)
	(setq textAt textA)
	(setq cur_oValt cur_oVal)
	(setq fPntt fPnt)
	(setq fLblt fLbl)
	(setq fBoxt fBox)
	(setq fCoordt fCoord)
	(setq fCLblt fCLbl)
	(setq elOnt elOn)
	(setq saveF (open "C:\\Users\\Ecoland\\Documents\\Helpful Code\\LSP Files\\SaveFile.txt" "r"))
	(setq lin (read-line saveF)) ; strt
	(if (and (not (= lin "NULL")) (not strt)) (setq strtt lin))
	(setq lin (read-line saveF)) ; textH
	(if (and (not (= lin "NULL")) (not textH)) (setq textHt lin))
	(setq lin (read-line saveF)) ; textA
	(if (and (not (= lin "NULL")) (not textA)) (setq textAt lin))
	(setq lin (read-line saveF)) ; cur_oVal
	(if (and (not (= lin "NULL")) (not cur_oVal)) (setq cur_oValt lin))
	(setq lin (read-line saveF)) ; fPnt
	(if (and (not (= lin "NULL")) (not fPnt)) (setq fPntt lin))
	(setq lin (read-line saveF)) ; fLbl
	(if (and (not (= lin "NULL")) (not fLbl)) (setq fLblt lin))
	(setq lin (read-line saveF)) ; fBox
	(if (and (not (= lin "NULL")) (not fBox)) (setq fBoxt lin))
	(setq lin (read-line saveF)) ; fCoord
	(if (and (not (= lin "NULL")) (not fCoord)) (setq fCoordt lin))
	(setq lin (read-line saveF)) ; fCLbl
	(if (and (not (= lin "NULL")) (not fCLbl)) (setq fCLblt lin))
	(setq lin (read-line saveF)) ; elOn
	(if (and (not (= lin "NULL")) (not elOn)) (setq elOnt lin))
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
	(if (not elOnt) (write-line "NULL" saveF) (write-line elOnt saveF))
	(close saveF)
	(princ)
) ; defun

(defun writeToCModes(ln1 ln2 ln3 / ln1t ln2t ln3t cMode)
	(setq ln1t ln1)
	(setq ln2t ln2)
	(setq ln3t ln3)
	(setq cMode (open "C:\\Users\\Ecoland\\Documents\\Helpful Code\\cModes.txt" "r"))
	(setq lin (read-line cMode)) ; ln1
	(if (and (not(= lin "NULL")) (not ln1)) (setq ln1t lin))
	(setq lin (read-line cMode)) ; ln2
	(if (and (not(= lin "NULL")) (not ln2)) (setq ln2t lin))
	(setq lin (read-line cMode)) ; ln3
	(if (and (not(= lin "NULL")) (not ln3)) (setq ln3t lin))
	(close cMode)
	(vl-file-delete "C:\\Users\\Ecoland\\Documents\\Helpful Code\\cModes.txt")
	(setq cMode (open "C:\\Users\\Ecoland\\Documents\\Helpful Code\\cModes.txt" "w"))
	(if (not ln1t) (write-line "NULL" cMode) (write-line ln1t cMode))
	(if (not ln2t) (write-line "NULL" cMode) (write-line ln2t cMode))
	(if (not ln3t) (write-line "NULL" cMode) (write-line ln3t cMode))
	(close cMode)
	(princ)
)

(defun c:PLSet( / df u ln linArr dcl_id PreNam chk temp preset)
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
				(writeToSaveFile nil nil nil nil (itoa PntOn) (itoa LblOn) (itoa BoxOn) (itoa CoordOn) (itoa CLbl) nil)
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
						(prompt "\nThat preset name is already in use.")
					)
					(close preset)
					(load "C:\\Users\\Ecoland\\Documents\\Helpful Code\\LSP Files\\Preset.lsp")
				)
				(prompt "\nInvalid command name. Spaces are not allowed.")
			)
		)
	)
	(princ)
)

(defun c:AFMenu( / dcl_id flag i)
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
	(prompt "\nList of Presets:\n")
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
		(prompt "\nThere is no preset with that name.")
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
			(prompt "\nPreset deleted.")
		)
	)
	(princ)
)

(defun c:delAPres( / presF)
	(setq presF (open "C:\\Users\\Ecoland\\Documents\\Helpful Code\\LSP Files\\Preset.lsp" "w"))
	(close presF)
	(prompt "\nAll presets deleted.")
	(princ)
)

(defun c:backupPoints()
	(writeToCModes "4" nil nil)
	(startapp "C:\\Users\\Ecoland\\Documents\\Helpful Code\\Coordinate Formatter.exe")
)

(defun c:delPt( / lNam sel q e1 e2 ss xdat1 xdat2)
	(setq lNam (entsel "Select point or label to be deleted: "))
	(setq e1 (entget (car lNam) '("Name")))
	(setq xdat1 (cdr (car (cdr (car (cdr (assoc -3 e1)))))))
	(if (= xdat1 nil) (prompt "\nInvalid selection.")
		(progn
			(setq sel (entnext))
			(setq ss (ssadd (car lNam)))
			(while (not (= sel nil))
				(setq e2 (entget sel '("Name")))
				(setq xdat2 (cdr (car (cdr (car (cdr (assoc -3 e2)))))))
				(if (= xdat1 xdat2)
					(setq ss (ssadd sel ss))
				)
				(setq sel (entnext sel))
			)
			(command "_erase" ss "")
			(prompt "Label and Point deleted.\n")
			(setq q (getYN "Undo that? [Y/N]: "))
			(if (= q 1)
				(command "_undo" 1)
				(progn
					(writeToCModes "5" xdat1 (getvar "dwgname"))
					(startapp "C:\\Users\\Ecoland\\Documents\\Helpful Code\\Coordinate Formatter.exe")
				)
			)
		)
	)
	(princ)
)

(defun c:movPt()
	(setq lNam (entsel "Select point or label to be moved: "))
	(setq e1 (entget (car lNam) '("Name")))
	(setq xdat1 (cdr (car (cdr (car (cdr (assoc -3 e1)))))))
	(if (= xdat1 nil) (prompt "\nInvalid selection.")
		(progn
			(setq sel (entnext))
			(setq ss (ssadd (car lNam)))
			(while (not (= sel nil))
				(setq e2 (entget sel '("Name")))
				(setq xdat2 (cdr (car (cdr (car (cdr (assoc -3 e2)))))))
				(if (= xdat1 xdat2)
					(setq ss (ssadd sel ss))
				)
				(setq sel (entnext sel))
			)
			(command "_erase" ss "")
			(setq norm 0)
			(writeToSaveFile xdat1 nil nil nil nil nil nil nil nil nil)
			(PntNLbl PntOn LblOn BoxOn CoordOn CLbl)
			(setq norm 1)
			(writeToCModes "6" xdat1 (getvar "dwgname"))
			(startapp "C:\\Users\\Ecoland\\Documents\\Helpful Code\\Coordinate Formatter.exe")
		)
	)
	(princ)
)

(defun c:chngHt()
	(setq ss (ssget "_A" '((-4 . "<AND") (0 . "LWPOLYLINE") (8 . "SUBDVN-Design-Construction") (-4 . "AND>"))))
	(setq i 0)
	(print (sslength ss))
	(while (< i (sslength ss))
		(entdel (ssname ss i))
		(setq i (1+ i))
	)
	(setq i 0)
	(setq ss1 (ssget "_A" '((-4 . "<AND") (0 . "TEXT") (8 . "SUBDVN-Design-Construction") (-4 . "AND>"))))
	(while (< i (sslength ss1))
		(if (not bns_tcircle) (load "acettxt.lsp"))
		(setq eList (entget (ssname ss1 i)))
		(setq eList (subst (cons 40 10.0) (assoc 40 eList) eList))
		(entmod eList)
		(bns_tcircle (ssadd (ssname ss1 i)) "Variable" "Rectangles" nil 0.5)
		(print i)
		(setq i (1+ i))
	)
	(princ)
)

(defun c:recordElevation()
	(setq q (getYN "Record elevation? [Y/N]: "))
	(if (= q 1)
		(setq elOn 1)
		(setq elOn 0)
	)
	(writeToSaveFile nil nil nil nil nil nil nil nil nil (itoa elOn))
)

(prompt "\nAdditional functions loaded.")
(princ)