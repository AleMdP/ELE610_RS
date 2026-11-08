MODULE MainModule
    ! made by KS November 2023
    ! (based on how RWS and JAMR adapted template program from ABB spring 2023)
    ! 
    ! main module for simulation using TATEM tool and a test board with pegs attached
    
    ! position of tool point is relative to tool0, translated so the Tool Center Point (TCP) is
    ! between the two fingers at level of the gap for the front LED, it is rotated -60 degrees around x-axis to make z-axis
    ! point 'forward' from the tool, the 180 degrees around the z-axis so y-axis points into the widest finger, 
    ! and x-axis points to the 'right'.
    PERS tooldata TatemTool1:=[TRUE,[[0,-48.3,153.5],[0,0,-0.5,0.866025404]],[0.3,[0,0,1],[1,0,0,0],0,0,0]];
    
    ! the center of the table (not used), relative to robot coordinate system (not world)
    TASK PERS wobjdata wobjTableR:=[FALSE,TRUE,"",[[150,500,8],[1,0,0,0]],[[0,0,0],[1,0,0,0]]];
    
    ! the work object used with test board on table                 x      y      z
    TASK PERS wobjdata wobjTestBoardOnTable := [FALSE,TRUE,"",[[0,544,146],[0.965928085,0.258810616,0,0]],[[0,0,0],[1,0,0,0]]];
    ! the one used with test board on conveyer belt         x      y      z
    TASK PERS wobjdata wobjTestBoardOnBelt  := [FALSE,TRUE,"",[[599.763,-318.75,282.622],[0.265084,0.0713605,-0.252646,-0.927797]],[[0,0,0],[1,0,0,0]]];
    ! the work object to use or used last time
    TASK PERS wobjdata wobjTestBoard :=        [FALSE,TRUE,"",[[0,544,146],[0.965928,0.258811,0,0]],[[0,0,0],[1,0,0,0]]];
    
    ! speeddata that are fixed
    CONST speeddata vVeryFast  := [5000,500,5000,1000];
    CONST speeddata vFast      := [1000,500,5000,1000];
    CONST speeddata vSlow      := [ 200,500,5000,1000];
    CONST speeddata vVerySlow  := [ 100,500,5000,1000];
    
    VAR NUM tA         := 0.1;          ! The time it takes to activate the tool
    VAR NUM tAdelay    := 0.03;         ! The amount of time before entering the point that the DO signal will be turned on (should be less than tA)
    VAR NUM tAdiff     := 0.07;         ! Amount of time the robot will stand still in its position before executing the spotwelding (MUST be tA-tA_Delay)
    VAR NUM tOp        := 0.3;          ! The execution time of the task
    VAR NUM tOpdelay   := 0.18;         ! Extra time to make sure the task is finished before retracting the tool
    VAR NUM tR         := 0.1;          ! The time it takes to retract the tool
    VAR NUM tRdelay    := 0.05;         ! Extra time to make sure that the tool has been retracted before exiting the point
    VAR num tWait      := 0.59;         ! tWait, == (tAdiff + tO + tOpdelay + tR + tRdelay)

    CONST robtarget AboveTestBoard:= [[90,90,100],[0,1,0,0],[1,0,-1,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    ! pegs at the 4 corners of the test board
    CONST robtarget Peg00:=[[0,0,0],[0,1,0,0],[1,0,-1,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget Peg03:=[[0,180,0],[0,1,0,0],[1,0,-1,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget Peg30:=[[180,0,0],[0,1,0,0],[0,-1,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget Peg33:=[[180,180,0],[0,1,0,0],[0,-1,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

    VAR intnum igun_on;   
    VAR triggdata PGunOn;
    CONST jointtarget jCalibPosL:=[[60,30,0,0,-10,90],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST jointtarget jCalibPos0:=[[0,0,0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST jointtarget jCalibPosR:=[[-15,15,0,0,-10,90],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR jointtarget jCalibPos;
    
    VAR bool doSlow := TRUE;
    VAR bool useFlexPendant := TRUE;
    VAR bool useBoardOnTable := TRUE; 

    PROC main()
        IF useBoardOnTable THEN 
            wobjTestBoard := wobjTestBoardOnTable;
            jCalibPos := jCalibPosL;
        ELSE
            wobjTestBoard := wobjTestBoardOnBelt;
            jCalibPos := jCalibPosR;
        ENDIF

        IF useFlexPendant THEN 
            TPErase;
            reg1 := 0;
        ELSE
            reg1 := 2;
        ENDIF

        WHILE reg1 < 5 DO 
            TEST reg1
            CASE 1:
                testPeg00;
            CASE 2:
                test4corners;
            CASE 3:
                test7pegs;
            CASE 4:
                options; 
            DEFAULT:
                WaitTime 0.1;
            ENDTEST

            IF useFlexPendant THEN 
                
                TPReadFK reg1, "Select task", "testPeg00", "test4corners", "test7pegs", "Options", "Quit";
            ELSE
                reg1 := 5;  
            ENDIF
        ENDWHILE

        MoveAbsJ jCalibPos0,v1000,z10,tool0;
    ENDPROC
    
    PROC testPeg00()   
        VAR num pegNo := 0;
        VAR num pegAng := 0;
        VAR bool exitLoop := FALSE;
        VAR string msgPrompt;

        IF useFlexPendant THEN 
            TPWrite "testPeg00() interactive iniciated";
            
            WHILE NOT exitLoop DO
                msgPrompt := "Select Number of peg (1-16) or negative to quit:";
                TPReadNum pegNo, msgPrompt;
                
                IF pegNo < 0 THEN
                    TPWrite "Finishing the test loop...";
                    exitLoop := TRUE;
                ELSE
                    IF pegNo >= 1 AND pegNo <= 16 THEN
                        msgPrompt := "Select angle (-180 to 180, step 45):";
                        TPReadNum pegAng, msgPrompt;
                        
                        testPegNA pegNo, pegAng;
                    ELSE
                        TPWrite "Peg number out of range (1-16).";
                    ENDIF
                ENDIF
            ENDWHILE
        ELSE
            initTatemTool;
            doPeg00 0, 0, 0;
        ENDIF
    ENDPROC
       
    PROC test4corners()  
        VAR num numTime := 0;
        
        IF useFlexPendant THEN 
            TPWrite "test4corners() started";
        ENDIF
        MoveAbsJ jCalibPos,vFast,z10,tool0;     
        ClkReset clock1;  
        ClkStart clock1;
        
        initTatemTool;
        doPeg00 0, 0, 0;
        doPeg00 180, 0, 0;
        doPeg00 180, 180, 0;
        doPeg00 0, 180, 0;
        
        MoveAbsJ jCalibPos,vFast,z10,tool0;     
        numTime := ClkRead(clock1);
        IF useFlexPendant THEN 
            TPWrite "Time used on test4corners() [s] = " \Num:=numTime;
        ENDIF
    ENDPROC
    
    PROC doPeg00(num dx, num dy, num rotz)
        VAR num t1 := 0.025;   
        VAR num t2 := 0.450;   
        VAR num t3 := 0.125;   

        IF doSlow THEN
            MoveL RelTool(Peg00, dx, -dy, -50, \Rz:= -rotz), vFast, z5,   TatemTool1\WObj:=wobjTestBoard;
            MoveL RelTool(Peg00, dx, -dy,   0, \Rz:= -rotz), vSlow, fine, TatemTool1\WObj:=wobjTestBoard;
            WaitTime t1;
            SetDO AirValve, 1;  
            WaitTime t2;
            SetDO AirValve, 0;  
            WaitTime t3;
            MoveL RelTool(Peg00, dx, -dy, -50, \Rz:= -rotz), vSlow, z5,  TatemTool1\WObj:=wobjTestBoard;
        ELSE
            MoveL RelTool(Peg00, dx, -dy, -50, \Rz:= -rotz), vFast,         z10, TatemTool1\WObj:=wobjTestBoard;
            TriggL RelTool(Peg00, dx, -dy,  0, \Rz:= -rotz),  vSlow, PGunOn, fine, TatemTool1\WObj:=wobjTestBoard; 
            WaitTime tWait;   
            MoveL RelTool(Peg00, dx, -dy, -50, \Rz:= -rotz), vFast,         z10, TatemTool1\WObj:=wobjTestBoard;
        ENDIF
    ENDPROC
    
    PROC initTatemTool()   
        IF NOT doSlow THEN
            TriggIO PGunOn, tAdelay\Time \DOp:=AirValve, 1;   
            IDelete igun_on;
            CONNECT igun_on WITH resetSignal;
            ISignalDO AirValve, 1, igun_on;
       ENDIF
    ENDPROC
    
    TRAP resetSignal
        TEST INTNO    
        CASE igun_on:
            ISleep igun_on;
            SetDO \SDelay:=tA+tOp+tOpdelay, AirValve, 0; 
            IWatch igun_on;
        ENDTEST
    ENDTRAP

    
    PROC testPegNA(num no, num ang)
        VAR num dx := 0;
        VAR num dy := 0;
        VAR num row := 0;
        VAR num col := 0;

        IF no < 1 OR no > 16 THEN
            TPWrite "Peg number invalid (1 a 16).";
            RETURN;
        ENDIF

        row := TRUNC((no - 1) / 4);
        col := (no - 1) MOD 4;
        
        dx := row * 60;
        dy := col * 60;

        initTatemTool;
        doPeg00 dx, dy, ang;
        
        TPWrite "Peg " + NumToStr(no, 0) + " to " + NumToStr(ang, 0) + " degrees reached.";

    ERROR
        IF ERRNO = ERR_ROBLIMIT THEN
            TPWrite "¡ALERT! Peg " + NumToStr(no, 0) + " with " + NumToStr(ang, 0) + " degrees is NOT reachable.";
        ENDIF
    ENDPROC

    PROC testAllPegsAndAngles()
        VAR num i;
        VAR num j;
        VAR num currentAng;

        TPWrite "Starting reaching mapping of 16 peg x 9 degrees...";
        
        FOR i FROM 16 TO 16 DO
            FOR j FROM -4 TO 4 DO
                currentAng := j * 45; 
                testPegNA i, currentAng;
            ENDFOR
        ENDFOR
        
        TPWrite "Mapping completed.";
    ENDPROC

    PROC test7pegs()
        VAR num numTime := 0;

        IF useFlexPendant THEN 
            TPWrite "test7pegs() started";
        ENDIF

        MoveAbsJ jCalibPos, vFast, z10, tool0;
        ClkReset clock1;
        ClkStart clock1;

        initTatemTool;

        ! 1. Pivote 1 (arriba-izquierda): X=0, Y=180
        doPeg00 0, 180, 0;

        ! 2. Pivote 2 (abajo-izquierda, Origen): X=0, Y=0
        doPeg00 0, 0, 0;

        ! 3. Pivote 3 (abajo-derecha): X=180, Y=0
        doPeg00 180, 0, 0;

        ! 4. Pivote 4 (arriba, 2da columna): X=60, Y=180
        doPeg00 60, 180, -45;

        ! 5. Pivote 5 (centro-inferior): X=60, Y=60
        doPeg00 60, 60, 45;

        ! 6. Pivote 6 (centro-derecha): X=120, Y=120
        doPeg00 120, 120, 0;

        ! 7. Pivote 7 (derecha): X=180, Y=120
        doPeg00 180, 120, -45;

        MoveAbsJ jCalibPos, vVeryFast, z10, tool0;
        numTime := ClkRead(clock1);

        IF useFlexPendant THEN 
            TPWrite "Total time test7pegs() [s] = " \Num:=numTime;
        ENDIF
    ENDPROC
    
    PROC options()
        VAR num selection := 0;

        IF useFlexPendant THEN
            TPReadFK selection, "Select Work Object:", "Table", "Belt", "Cancel", "unused", "unused";

            IF selection = 1 THEN
                useBoardOnTable := TRUE;
                wobjTestBoard := wobjTestBoardOnTable;
                jCalibPos := jCalibPosL;
                TPWrite "WObj changed to: Table (wobjTestBoardOnTable)";
            ELSEIF selection = 2 THEN
                useBoardOnTable := FALSE;
                wobjTestBoard := wobjTestBoardOnBelt;
                jCalibPos := jCalibPosR;
                TPWrite "WObj changed to: Belt (wobjTestBoardOnBelt)";
            ENDIF

            TPReadFK selection, "Select mode doSlow:", "TRUE (slow)", "FALSE (fast)", "Cancel", "unused", "unused";

            IF selection = 1 THEN
                doSlow := TRUE;
                TPWrite "doSlow configurated on: TRUE";
            ELSEIF selection = 2 THEN
                doSlow := FALSE;
                TPWrite "doSlow configurated on: FALSE";
            ENDIF
        ELSE
            TPWrite "FlexPendant is not habilitated to change options.";
        ENDIF
    ENDPROC
ENDMODULE