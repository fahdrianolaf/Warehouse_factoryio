PROGRAM main
  VAR
    Init_Req : BOOL;
    Init_Cmd : BOOL;
    Boot_Done : BOOL;
    Fault_Latch : BOOL;
    System_Run : BOOL;
    Idle_Enter : BOOL;
    S0_Idle : BOOL;
    S1_Load_ForkOut : BOOL;
    S2_Load_LiftUp : BOOL;
    S3_Load_ForkIn : BOOL;
    S4_Move_To_Cell : BOOL;
    S5_Cell_ForkOut : BOOL;
    S6_Cell_LiftDown : BOOL;
    S7_Cell_ForkIn : BOOL;
    S8_Get_ForkOut : BOOL;
    S9_Get_LiftUp : BOOL;
    S10_Get_ForkIn : BOOL;
    S11_Move_To_Unload : BOOL;
    S12_Unload_ForkOut : BOOL;
    S13_Unload_LiftDown : BOOL;
    S14_Unload_ForkIn : BOOL;
    CellOut_Req : BOOL;
    Ext_Load : BOOL;
    Ext_Cell : BOOL;
    Ext_Unload : BOOL;
    Lift_Req : BOOL;
    Unload_Run : BOOL;
    T_LiftA : TON;
    T_LiftB : TON;
    T_LiftC : TON;
    T_LiftD : TON;
    T_Move1 : TON;
    T_Move2 : TON;
  END_VAR
  VAR
    At_Entry AT %IX0.0 : BOOL;
    At_Load AT %IX0.1 : BOOL;
    At_Left AT %IX0.2 : BOOL;
    At_Middle AT %IX0.3 : BOOL;
    At_Right AT %IX0.4 : BOOL;
    At_Unload AT %IX0.5 : BOOL;
    At_Exit AT %IX0.6 : BOOL;
    Moving_X AT %IX0.7 : BOOL;
    Moving_Z AT %IX1.0 : BOOL;
    Start_Button AT %IX1.1 : BOOL;
    Reset_Button AT %IX1.2 : BOOL;
    Stop_Button AT %IX1.3 : BOOL;
    Emergency_Stop AT %IX1.4 : BOOL;
    Auto_Mode AT %IX1.5 : BOOL;
    FIO_Running AT %IX1.6 : BOOL;
    Entry_Conveyor AT %QX0.0 : BOOL;
    Load_Conveyor AT %QX0.1 : BOOL;
    Forks_Left AT %QX0.2 : BOOL;
    Forks_Right AT %QX0.3 : BOOL;
    Lift AT %QX0.4 : BOOL;
    Unload_Conveyor AT %QX0.5 : BOOL;
    Exit_Conveyor AT %QX0.6 : BOOL;
    Start_Light AT %QX0.7 : BOOL;
    Reset_Light AT %QX1.0 : BOOL;
    Stop_Light AT %QX1.1 : BOOL;
    Target_Position AT %QW0 : INT;
  END_VAR
  VAR
    _TMP_MUX5108200_ENO : BOOL;
    _TMP_MUX5108200_OUT : INT;
    _TMP_MUX4370714_ENO : BOOL;
    _TMP_MUX4370714_OUT : INT;
    _TMP_MUX2077616_ENO : BOOL;
    _TMP_MUX2077616_OUT : INT;
    _TMP_MUX2337323_ENO : BOOL;
    _TMP_MUX2337323_OUT : INT;
  END_VAR

  Init_Req := NOT(FIO_Running) OR Reset_Button;
  Init_Cmd := Init_Req OR NOT(Boot_Done);
  Fault_Latch := NOT(Emergency_Stop) OR NOT(Reset_Button) AND Fault_Latch;
  System_Run := FIO_Running AND NOT(Fault_Latch) AND Auto_Mode AND Stop_Button AND (Start_Button OR System_Run);
  Idle_Enter := Init_Cmd OR System_Run AND At_Middle AND S14_Unload_ForkIn;
  S14_Unload_ForkIn := NOT(Idle_Enter) AND (S14_Unload_ForkIn OR System_Run AND NOT(Moving_Z) AND T_LiftD.Q AND S13_Unload_LiftDown);
  S13_Unload_LiftDown := NOT(Init_Cmd) AND NOT(S14_Unload_ForkIn) AND (S13_Unload_LiftDown OR System_Run AND At_Right AND S12_Unload_ForkOut);
  S12_Unload_ForkOut := NOT(Init_Cmd) AND NOT(S13_Unload_LiftDown) AND (S12_Unload_ForkOut OR System_Run AND NOT(At_Unload) AND T_Move2.Q AND S11_Move_To_Unload);
  S11_Move_To_Unload := NOT(Init_Cmd) AND NOT(S12_Unload_ForkOut) AND (S11_Move_To_Unload OR System_Run AND At_Middle AND S10_Get_ForkIn);
  S10_Get_ForkIn := NOT(Init_Cmd) AND NOT(S11_Move_To_Unload) AND (S10_Get_ForkIn OR System_Run AND NOT(Moving_Z) AND T_LiftC.Q AND S9_Get_LiftUp);
  S9_Get_LiftUp := NOT(Init_Cmd) AND NOT(S10_Get_ForkIn) AND (S9_Get_LiftUp OR System_Run AND At_Left AND S8_Get_ForkOut);
  S8_Get_ForkOut := NOT(Init_Cmd) AND NOT(S9_Get_LiftUp) AND (S8_Get_ForkOut OR System_Run AND At_Middle AND S7_Cell_ForkIn);
  S7_Cell_ForkIn := NOT(Init_Cmd) AND NOT(S8_Get_ForkOut) AND (S7_Cell_ForkIn OR System_Run AND NOT(Moving_Z) AND T_LiftB.Q AND S6_Cell_LiftDown);
  S6_Cell_LiftDown := NOT(Init_Cmd) AND NOT(S7_Cell_ForkIn) AND (S6_Cell_LiftDown OR System_Run AND At_Left AND S5_Cell_ForkOut);
  S5_Cell_ForkOut := NOT(Init_Cmd) AND NOT(S6_Cell_LiftDown) AND (S5_Cell_ForkOut OR System_Run AND T_Move1.Q AND S4_Move_To_Cell);
  S4_Move_To_Cell := NOT(Init_Cmd) AND NOT(S5_Cell_ForkOut) AND (S4_Move_To_Cell OR System_Run AND At_Middle AND S3_Load_ForkIn);
  S3_Load_ForkIn := NOT(Init_Cmd) AND NOT(S4_Move_To_Cell) AND (S3_Load_ForkIn OR System_Run AND NOT(Moving_Z) AND T_LiftA.Q AND S2_Load_LiftUp);
  S2_Load_LiftUp := NOT(Init_Cmd) AND NOT(S3_Load_ForkIn) AND (S2_Load_LiftUp OR System_Run AND At_Left AND S1_Load_ForkOut);
  S1_Load_ForkOut := NOT(Init_Cmd) AND NOT(S2_Load_LiftUp) AND (S1_Load_ForkOut OR System_Run AND NOT(Moving_Z) AND NOT(Moving_X) AND At_Middle AND At_Load AND S0_Idle);
  S0_Idle := NOT(S1_Load_ForkOut) AND (Idle_Enter OR S0_Idle);
  T_LiftA(IN := S2_Load_LiftUp, PT := T#1500ms);
  T_LiftB(IN := S6_Cell_LiftDown, PT := T#1500ms);
  T_LiftC(IN := S9_Get_LiftUp, PT := T#1500ms);
  T_LiftD(IN := S13_Unload_LiftDown, PT := T#1500ms);
  T_Move1(IN := NOT(Moving_Z) AND NOT(Moving_X) AND S4_Move_To_Cell, PT := T#2s);
  T_Move2(IN := NOT(Moving_Z) AND NOT(Moving_X) AND S11_Move_To_Unload, PT := T#2s);
  CellOut_Req := S5_Cell_ForkOut OR S8_Get_ForkOut;
  Ext_Load := NOT(Init_Cmd) AND NOT(S3_Load_ForkIn) AND (Ext_Load OR S1_Load_ForkOut);
  Ext_Cell := NOT(Init_Cmd) AND NOT(S10_Get_ForkIn) AND NOT(S7_Cell_ForkIn) AND (CellOut_Req OR Ext_Cell);
  Ext_Unload := NOT(Init_Cmd) AND NOT(S14_Unload_ForkIn) AND (Ext_Unload OR S12_Unload_ForkOut);
  Forks_Left := Ext_Cell OR Ext_Load;
  Forks_Right := Ext_Unload;
  Lift_Req := S2_Load_LiftUp OR S9_Get_LiftUp;
  Lift := NOT(Init_Cmd) AND NOT(S13_Unload_LiftDown) AND NOT(S6_Cell_LiftDown) AND (Lift OR Lift_Req);
  _TMP_MUX5108200_OUT := MUX(EN := S0_Idle, K := 0, IN0 := 55, IN1 := 0, ENO => _TMP_MUX5108200_ENO);
  IF _TMP_MUX5108200_ENO THEN
      Target_Position := _TMP_MUX5108200_OUT;
  END_IF;
  _TMP_MUX4370714_OUT := MUX(EN := S4_Move_To_Cell, K := 0, IN0 := 1, IN1 := 0, ENO => _TMP_MUX4370714_ENO);
  IF _TMP_MUX4370714_ENO THEN
      Target_Position := _TMP_MUX4370714_OUT;
  END_IF;
  _TMP_MUX2077616_OUT := MUX(EN := S11_Move_To_Unload, K := 0, IN0 := 55, IN1 := 0, ENO => _TMP_MUX2077616_ENO);
  IF _TMP_MUX2077616_ENO THEN
      Target_Position := _TMP_MUX2077616_OUT;
  END_IF;
  _TMP_MUX2337323_OUT := MUX(EN := Fault_Latch, K := 0, IN0 := 0, IN1 := 0, ENO => _TMP_MUX2337323_ENO);
  IF _TMP_MUX2337323_ENO THEN
      Target_Position := _TMP_MUX2337323_OUT;
  END_IF;
  Entry_Conveyor := NOT(At_Load) AND System_Run;
  Load_Conveyor := NOT(At_Load) AND System_Run;
  Unload_Run := NOT(Init_Cmd) AND NOT(At_Exit) AND (At_Unload OR Unload_Run);
  Unload_Conveyor := System_Run AND Unload_Run;
  Exit_Conveyor := System_Run;
  Start_Light := System_Run;
  Stop_Light := NOT(System_Run);
  Reset_Light := Fault_Latch;
  Boot_Done := FIO_Running OR NOT(FIO_Running);
END_PROGRAM


CONFIGURATION Config0

  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 1);
    PROGRAM instance0 WITH task0 : main;
  END_RESOURCE
END_CONFIGURATION
