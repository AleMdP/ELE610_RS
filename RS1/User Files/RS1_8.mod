MODULE Module1
    PERS tooldata UISpenholder:=[TRUE,[[0,0,110],[1,0,0,0]],[1,[0,0,1],[1,0,0,0],0,0,0]];
    TASK PERS wobjdata wobjTable:=[FALSE,TRUE,"",[[325,200,309],[0.707106781,0,0,-0.707106781]],[[0,0,0],[1,0,0,0]]];
    CONST robtarget Target_10:=[[0,300,0],[0,-0.707106781,0.707106781,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget Target_20:=[[400,300,0],[0,-0.707106781,0.707106781,0],[-1,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget Target_30:=[[400,0,0],[0,-0.707106781,0.707106781,0],[-1,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget Target_40:=[[0,0,0],[0,-0.707106781,0.707106781,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget Target_50:=[[100,25,15],[0,-0.707106781,0.707106781,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget Target_60:=[[100,275,15],[0,-0.707106781,0.707106781,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget Target_70:=[[300,275,15],[0,-0.707106781,0.707106781,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget Target_80:=[[300,25,15],[0,-0.707106781,0.707106781,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    !***********************************************************
    !
    ! M?dulo:  Module1
    !
    ! Descripción:
    !   <Introduzca la descripción aquí>
    !
    ! Autor: calza
    !
    ! Versión: 1.0
    !
    !***********************************************************
    
    
    !***********************************************************
    !
    ! Procedimiento Main
    !
    !   Este es el punto de entrada de su programa
    !
    !***********************************************************
    PROC main()
        !Add your code here
        Path_10;
        Path_20;
    ENDPROC
    PROC Path_10()
        MoveL Target_10,v1000,z5,UISpenholder\WObj:=wobjTable;
        MoveL Target_20,v1000,z5,UISpenholder\WObj:=wobjTable;
        MoveL Target_30,v1000,z5,UISpenholder\WObj:=wobjTable;
        MoveL Target_40,v1000,z5,UISpenholder\WObj:=wobjTable;
        MoveL Target_10,v1000,z5,UISpenholder\WObj:=wobjTable;
    ENDPROC
    PROC Path_20()
        MoveL Target_50,v1000,z5,UISpenholder\WObj:=wobjTable;
        MoveL Target_60,v1000,z5,UISpenholder\WObj:=wobjTable;
        MoveL Target_70,v1000,z5,UISpenholder\WObj:=wobjTable;
        MoveL Target_80,v1000,z5,UISpenholder\WObj:=wobjTable;
        MoveL Target_50,v1000,z5,UISpenholder\WObj:=wobjTable;
    ENDPROC
ENDMODULE