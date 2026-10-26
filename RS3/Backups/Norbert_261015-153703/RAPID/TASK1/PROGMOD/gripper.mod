MODULE gripper
    PERS tooldata tGripper:=[TRUE,[[0,0,114.25],[0,0,0,1]],[1,[-0.095984607,0.082520613,38.69176324],[1,0,0,0],0,0,0]];

    PROC openGripper()
        SetDO AirValve1, 0;
        SetDO AirValve2, 1;
        WaitTime 0.5;
    ENDPROC

    PROC closeGripper()
        SetDO AirValve1, 1;
        SetDO AirValve2, 0;
        WaitTime 0.5;
    ENDPROC
ENDMODULE