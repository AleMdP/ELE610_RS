MODULE main_2
    TASK PERS wobjdata wobjTableR := [FALSE, TRUE, "", [[150,500,8], [1,0,0,0]], [[0,0,0], [1,0,0,0]]];
    TASK PERS wobjdata wobjA4     := [FALSE, TRUE, "", [[150,500,8.1], [1,0,0,0]], [[0,0,0], [1,0,0,0]]];
    PERS tooldata tSimplePen      := [TRUE, [[0,0,110], [1,0,0,0]], [1, [0,0,1], [1,0,0,0], 0, 0, 0]];

    
    CONST robtarget Target_10 := [[0,0,30], [0,0,1,0], [0,0,0,0], [9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget Target_A4_Center := [[148.5,105,0],[0,0,1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR btnres answer;

    VAR btnres btnAnswer;
    VAR num nofSC_val;
    
    

    PROC section24a()
        VAR robtarget Target_20 := [[70,0,0], [0,0,1,0], [0,0,0,0], [9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
        VAR robtarget Target_30 := [[70,50,0], [0,0,1,0], [0,0,0,0], [9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
        VAR robtarget Target_40 := [[0,50,0], [0,0,1,0], [0,0,0,0], [9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
        VAR robtarget Target_50 := [[0,0,0], [0,0,1,0], [0,0,0,0], [9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

        MoveL Offs(Target_50, 0, 0, 10), v200, z1, tSimplePen\WObj:=wobjA4;
        MoveL Target_50, v50, fine, tSimplePen\WObj:=wobjA4;
        MoveL Target_20, v50, z1, tSimplePen\WObj:=wobjA4;
        MoveL Target_30, v50, z1, tSimplePen\WObj:=wobjA4;
        MoveL Target_40, v50, z1, tSimplePen\WObj:=wobjA4;
        MoveL Target_50, v50, fine, tSimplePen\WObj:=wobjA4;
        MoveL Offs(Target_50, 0, 0, 10), v200, z1, tSimplePen\WObj:=wobjA4;
    ENDPROC

    PROC drawRectangle(robtarget pLowerLeft, num length, num height)
        
        MoveL Offs(pLowerLeft, 0, 0, 10), v200, fine, tSimplePen\WObj:=wobjA4;
    
        MoveL pLowerLeft, v50, fine, tSimplePen\WObj:=wobjA4;
    
        MoveL Offs(pLowerLeft, length, 0, 0), v50, z1, tSimplePen\WObj:=wobjA4;
        MoveL Offs(pLowerLeft, length, height, 0), v50, z1, tSimplePen\WObj:=wobjA4;
        MoveL Offs(pLowerLeft, 0, height, 0), v50, z1, tSimplePen\WObj:=wobjA4;
        MoveL pLowerLeft, v50, fine, tSimplePen\WObj:=wobjA4;
    
        MoveL Offs(pLowerLeft, 0, 0, 10), v200, fine, tSimplePen\WObj:=wobjA4;
    ENDPROC
    PROC section24b()
        
        drawRectangle Offs(Target_10, -35, -25, -30), 70, 50;
        drawRectangle Offs(Target_10, -40, -30, -30), 80, 60;
        drawRectangle Offs(Target_10, -45, -35, -30), 90, 70;
    ENDPROC     

    
    PROC drawRotatedRectangle(robtarget pCenter, num length, num height, num angleDeg)
        VAR num cosA;
        VAR num sinA;
        VAR num x1; VAR num y1;
        VAR num x2; VAR num y2;
        VAR num x3; VAR num y3;
        VAR num x4; VAR num y4;
        VAR num a2; VAR num b2;
    
        IF angleDeg = 30 THEN
            cosA := 0.866025;
            sinA := 0.500000;
        ELSE
            cosA := Cos(angleDeg * 3.14159265 / 180.0);
            sinA := Sin(angleDeg * 3.14159265 / 180.0);
        ENDIF
    
        a2 := length / 2;
        b2 := height / 2;
        x1 := (-a2 * cosA) - (-b2 * sinA);
        y1 := (-a2 * sinA) + (-b2 * cosA);
        x2 := (a2 * cosA) - (-b2 * sinA);
        y2 := (a2 * sinA) + (-b2 * cosA);
        x3 := (a2 * cosA) - (b2 * sinA);
        y3 := (a2 * sinA) + (b2 * cosA);
        x4 := (-a2 * cosA) - (b2 * sinA);
        y4 := (-a2 * sinA) + (b2 * cosA);
    
        MoveL Offs(pCenter, x1, y1, -20), v200, fine, tSimplePen\WObj:=wobjA4;
        MoveL Offs(pCenter, x1, y1, -30), v50, fine, tSimplePen\WObj:=wobjA4;
    
        MoveL Offs(pCenter, x2, y2, -30), v50, z1, tSimplePen\WObj:=wobjA4;
        MoveL Offs(pCenter, x3, y3, -30), v50, z1, tSimplePen\WObj:=wobjA4;
        MoveL Offs(pCenter, x4, y4, -30), v50, z1, tSimplePen\WObj:=wobjA4;
        MoveL Offs(pCenter, x1, y1, -30), v50, fine, tSimplePen\WObj:=wobjA4;
    
        MoveL Offs(pCenter, x1, y1, -20), v200, fine, tSimplePen\WObj:=wobjA4;
    ENDPROC
    
    PROC section24c()
        drawRotatedRectangle Target_10, 70, 50, 30;
        drawRotatedRectangle Target_10, 80, 60, 30;
        drawRotatedRectangle Target_10, 90, 70, 30;
    ENDPROC
    
    PROC drawTriangle(robtarget pCenter, num s)
        VAR num h1;
        VAR num h2;
        
        h1 := (Sqrt(3) / 6.0) * s;
        h2 := (Sqrt(3) / 3.0) * s;
        MoveL Offs(pCenter, -s/2, -h1, -20), v200, fine, tSimplePen\WObj:=wobjA4;
        MoveL Offs(pCenter, -s/2, -h1, -30), v50, fine, tSimplePen\WObj:=wobjA4;
        
        MoveL Offs(pCenter, s/2, -h1, -30), v50, z1, tSimplePen\WObj:=wobjA4;
        MoveL Offs(pCenter, 0, h2, -30), v50, z1, tSimplePen\WObj:=wobjA4;
        MoveL Offs(pCenter, -s/2, -h1, -30), v50, fine, tSimplePen\WObj:=wobjA4;
        
        MoveL Offs(pCenter, -s/2, -h1, -20), v200, fine, tSimplePen\WObj:=wobjA4;
    ENDPROC
    
    PROC drawCircle(robtarget pCenter, num r)
        
        MoveL Offs(pCenter, r, 0, -20), v200, fine, tSimplePen\WObj:=wobjA4;
        MoveL Offs(pCenter, r, 0, -30), v50, fine, tSimplePen\WObj:=wobjA4;
        
        MoveC Offs(pCenter, 0, r, -30), Offs(pCenter, -r, 0, -30), v50, z1, tSimplePen\WObj:=wobjA4;
        MoveC Offs(pCenter, 0, -r, -30), Offs(pCenter, r, 0, -30), v50, fine, tSimplePen\WObj:=wobjA4;
        
        MoveL Offs(pCenter, r, 0, -20), v200, fine, tSimplePen\WObj:=wobjA4;
    ENDPROC
    
    PROC section25()
        VAR num s := 25;
        VAR num r;
        r := (s / 3.0) * Sqrt(3);
        drawRectangle Offs(Target_10, -50, -50, -30), 100, 100;
    
        drawTriangle Offs(Target_10, -50, -50, 0), s;
        drawTriangle Offs(Target_10, 50, -50, 0), s;
        drawTriangle Offs(Target_10, 50, 50, 0), s;
        drawTriangle Offs(Target_10, -50, 50, 0), s;
    
        drawCircle Offs(Target_10, -50, -50, 0), r;
        drawCircle Offs(Target_10, 50, -50, 0), r;
        drawCircle Offs(Target_10, 50, 50, 0), r;
        drawCircle Offs(Target_10, -50, 50, 0), r;
    ENDPROC
    

    PROC drawShapes(robtarget pCenter, num nofSC)
        VAR num currentSquareSide;
        VAR num currentRadius;
        VAR num i;
    
        currentSquareSide := 120;
        currentRadius := 60;
    
        FOR i FROM 1 TO nofSC DO
            drawRectangle Offs(pCenter, -currentSquareSide/2.0, -currentSquareSide/2.0, -30), currentSquareSide, currentSquareSide;
    
            drawCircle pCenter, currentRadius;
    
            currentSquareSide := currentRadius * Sqrt(2);
            currentRadius := currentSquareSide / 2.0;
        ENDFOR
    ENDPROC
    
    PROC section26()
        drawShapes Target_10, 3;
    ENDPROC
    
    PROC main()
        MoveL Target_10, v500, z10, tSimplePen\WObj:=wobjA4;
    
        TPReadFK btnAnswer, "Select the section to play:", "2.4a", "2.4b", "2.4c", "2.5", "2.6";
    
        TEST btnAnswer
            CASE 1:
                section24a;
            CASE 2:
                section24b;
            CASE 3:
                section24c;
            CASE 4:
                section25;
            CASE 5:
                TPReadNum nofSC_val, "Introduce the number of figures (nofSC):";
                drawShapes Target_10, nofSC_val;
        ENDTEST
    
        MoveL Target_10, v500, z10, tSimplePen\WObj:=wobjA4;
    ENDPROC

ENDMODULE