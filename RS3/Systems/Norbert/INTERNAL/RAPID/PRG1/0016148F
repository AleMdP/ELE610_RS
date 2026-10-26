MODULE E458GripperTest
    TASK PERS wobjdata wobjTableN:=[FALSE,TRUE,"",[[150,-500,8],[0.707106781,0,0,-0.707106781]],[[0,0,0],[1,0,0,0]]];

    CONST speeddata vSlow := v50;
    CONST speeddata vFast := v200;
    CONST num puckHeight := 30;   
    CONST num safeHeight := 240;  
    CONST num nPos := 7;          

    VAR num lastPosNo := 0;
    PERS num nonPos{7} := [5,0,0,0,0,0,0]; 

    VAR robtarget targets{7}:=[
        [[0,-200,0],[0,1,0,0],[-1,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],
        [[200,-200,0],[0,1,0,0],[-1,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],
        [[0,0,0],[0,1,0,0],[-1,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],
        [[200,0,0],[0,1,0,0],[-1,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],
        [[-200,200,0],[0,1,0,0],[-1,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],
        [[0,200,0],[0,1,0,0],[-1,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],
        [[200,200,0],[0,1,0,0],[-1,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]]
    ];

    PROC main()
        VAR btnres btnAnswer;
        VAR num pFrom;
        VAR num pTo;
        VAR num numPucks;

        
        nonPos := [5,0,0,0,0,0,0];
        lastPosNo := 0;

        openGripper;
        MoveL Offs(targets{1}, 0, 0, safeHeight), vFast, z50, tGripper \WObj:=wobjTableN;

        TPErase;
        TPWrite "Ajust all the pucks to position 1.";
        TPWrite "Press START to continue.";
        Stop;


        WHILE TRUE DO
            TPErase;
            TPWrite "Actual state of the pucks:";
            TPWrite "1-7: " + ValToStr(nonPos{1}) + "," + ValToStr(nonPos{2}) + "," + ValToStr(nonPos{3}) + "," + ValToStr(nonPos{4}) + "," + ValToStr(nonPos{5}) + "," + ValToStr(nonPos{6}) + "," + ValToStr(nonPos{7});

            TPReadFK btnAnswer, "Select an action:", "Mv Puck", "Mv Stack", "Flip", "Recollect", "Exit";

            TEST btnAnswer
                CASE 1:
                    TPReadNum pFrom, "ORIGIN position (1-7):";
                    TPReadNum pTo, "DESTINATION position (1-7):";
                    TPReadNum numPucks, "How many pucks do you want to move?:";

                    FOR i FROM 1 TO numPucks DO
                        movePuck pFrom, pTo;
                    ENDFOR

                CASE 2:
                    TPReadNum pFrom, "ORIGIN position (1-7):";
                    TPReadNum pTo, "DESTINATION position (1-7):";
                    moveStack pFrom, pTo;

                CASE 3:
                    TPReadNum pFrom, "Position of the stack to flip (1-7):";
                    flipStack pFrom;

                CASE 4:
                    FOR i FROM 2 TO nPos DO
                        IF nonPos{i} > 0 THEN
                            moveStack i, 1;
                        ENDIF
                    ENDFOR

                CASE 5:
                    TPWrite "Program finished";
                    EXIT;
            ENDTEST
        ENDWHILE
    ENDPROC

    
  
    PROC movePuck(num fromPosNo, num toPosNo)
        VAR robtarget pPick;
        VAR robtarget pPlace;
        VAR robtarget pSafe;

        IF fromPosNo < 1 OR fromPosNo > nPos OR toPosNo < 1 OR toPosNo > nPos THEN
            TPWrite "ERROR: Position out of range (1-7).";
            RETURN;
        ENDIF
        
        IF nonPos{fromPosNo} <= 0 THEN
            TPWrite "ERROR: There are no pucks in the origin position.";
            RETURN;
        ENDIF
        
        IF fromPosNo = toPosNo THEN
            TPWrite "ERROR: Origin and destination must not be the same.";
            RETURN;
        ENDIF

        pPick := targets{fromPosNo};
        pPick.trans.z := pPick.trans.z + ((nonPos{fromPosNo} - 1) * puckHeight);

        pPlace := targets{toPosNo};
        pPlace.trans.z := pPlace.trans.z + (nonPos{toPosNo} * puckHeight);

        IF lastPosNo <> fromPosNo THEN
            pSafe := pPick;
            pSafe.trans.z := safeHeight;
            MoveL pSafe, vFast, z50, tGripper \WObj:=wobjTableN;
        ENDIF

        openGripper;
        MoveL Offs(pPick, 0, 0, 20), vFast, z10, tGripper \WObj:=wobjTableN;
        MoveL pPick, vSlow, fine, tGripper \WObj:=wobjTableN;
        
        closeGripper;

        pSafe := pPick;
        pSafe.trans.z := safeHeight;
        MoveL pSafe, vFast, z50, tGripper \WObj:=wobjTableN;

        pSafe := pPlace;
        pSafe.trans.z := safeHeight;
        MoveL pSafe, vFast, z50, tGripper \WObj:=wobjTableN;

        MoveL Offs(pPlace, 0, 0, 20), vSlow, z10, tGripper \WObj:=wobjTableN;
        MoveL pPlace, vSlow, fine, tGripper \WObj:=wobjTableN;
        
        openGripper;

        nonPos{fromPosNo} := nonPos{fromPosNo} - 1;
        nonPos{toPosNo} := nonPos{toPosNo} + 1;
        lastPosNo := toPosNo;

        MoveL Offs(pPlace, 0, 0, puckHeight * 2), vFast, z10, tGripper \WObj:=wobjTableN;
    ENDPROC

    PROC moveStack(num fromPosNo, num toPosNo)
        VAR num count;
        
        count := nonPos{fromPosNo};
        
        IF count <= 0 THEN
            TPWrite "ERROR: There are no pucks in this position to move.";
            RETURN;
        ENDIF

        FOR i FROM 1 TO count DO
            movePuck fromPosNo, toPosNo;
        ENDFOR
    ENDPROC

    PROC flipStack(num fromPosNo)
        VAR num count;
        VAR num targetPos;
        VAR num placedPositions{7};

        count := nonPos{fromPosNo};

        IF count < 2 THEN
            TPWrite "ERROR: There must be at least 2 pucks to flip the stack.";
            RETURN;
        ENDIF

        IF (7 - 1) < count THEN
            TPWrite "ERROR: Not enough free positions to flip stack.";
            RETURN;
        ENDIF

        targetPos := 1;

        FOR i FROM 1 TO count DO
            WHILE targetPos = fromPosNo OR nonPos{targetPos} > 0 DO
                targetPos := targetPos + 1;
            ENDWHILE

            placedPositions{i} := targetPos;
            movePuck fromPosNo, targetPos;
        ENDFOR

        FOR i FROM 1 TO count DO
            movePuck placedPositions{i}, fromPosNo;
        ENDFOR
    ENDPROC

ENDMODULE