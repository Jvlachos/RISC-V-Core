simSetSimulator "-vcssv" -exec "./simv" -args "-l sim.log" -uvmDebug on -simDelim
debImport "-i" "-simflow" "-dbdir" "./simv.daidir"
srcTBInvokeSim
verdiSetActWin -dock widgetDock_<Member>
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
srcHBSelect "core_top.ex_s" -win $_nTrace1
srcSetScope "core_top.ex_s" -delim "." -win $_nTrace1
srcHBSelect "core_top.ex_s" -win $_nTrace1
verdiSetActWin -dock widgetDock_<Inst._Tree>
srcDeselectAll -win $_nTrace1
srcSelect -signal "ex_bus_o" -line 7 -pos 1 -win $_nTrace1
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
wvCreateWindow
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave3
verdiDockWidgetMaximize -dock windowDock_nWave_3
wvSelectSignal -win $_nWave3 {( "G1" 1 )} 
wvExpandBus -win $_nWave3
srcTBRunSim
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
verdiSetActWin -win $_nWave3
wvSelectSignal -win $_nWave3 {( "G1" 4 )} 
wvSelectSignal -win $_nWave3 {( "G1" 3 )} 
wvSelectSignal -win $_nWave3 {( "G1" 4 )} 
wvCut -win $_nWave3
wvSetPosition -win $_nWave3 {("G2" 0)}
wvSetPosition -win $_nWave3 {("G1" 14)}
wvSelectSignal -win $_nWave3 {( "G1" 4 )} 
wvSelectSignal -win $_nWave3 {( "G1" 4 )} 
wvSetCursor -win $_nWave3 146.225690 -snap {("G1" 14)}
wvSetCursor -win $_nWave3 152.773109 -snap {("G1" 14)}
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomIn -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomIn -win $_nWave3
wvZoomIn -win $_nWave3
wvZoomOut -win $_nWave3
wvSelectSignal -win $_nWave3 {( "G1" 5 )} 
wvSelectSignal -win $_nWave3 {( "G1" 5 6 7 8 9 )} 
wvCut -win $_nWave3
wvSetPosition -win $_nWave3 {("G1" 9)}
verdiDockWidgetRestore -dock windowDock_nWave_3
srcDeselectAll -win $_nTrace1
srcSelect -signal "clk" -line 8 -pos 1 -win $_nTrace1
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave3
wvScrollDown -win $_nWave3 1
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
verdiSetActWin -win $_nWave3
wvScrollUp -win $_nWave3 1
srcTBSimReset
wvScrollDown -win $_nWave3 1
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
wvScrollDown -win $_nWave3 0
verdiDockWidgetMaximize -dock windowDock_nWave_3
wvZoomIn -win $_nWave3
wvZoomIn -win $_nWave3
wvZoomIn -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
srcTBRunSim
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
verdiSetActWin -win $_nWave3
wvSetCursor -win $_nWave3 121.127251 -snap {("G1" 9)}
wvSetCursor -win $_nWave3 116.762305 -snap {("G2" 0)}
wvSetCursor -win $_nWave3 117.853541 -snap {("G1" 10)}
wvSetCursor -win $_nWave3 159.866146 -snap {("G1" 10)}
wvSetCursor -win $_nWave3 199.150660 -snap {("G1" 10)}
wvSetCursor -win $_nWave3 238.980792 -snap {("G1" 10)}
wvSetCursor -win $_nWave3 279.902161 -snap {("G1" 10)}
wvSetCursor -win $_nWave3 198.059424 -snap {("G1" 10)}
wvSetCursor -win $_nWave3 240.072029 -snap {("G1" 9)}
wvSetCursor -win $_nWave3 240.072029 -snap {("G1" 9)}
wvSetCursor -win $_nWave3 238.435174 -snap {("G1" 10)}
wvSetCursor -win $_nWave3 199.150660 -snap {("G1" 10)}
wvSetCursor -win $_nWave3 238.980792 -snap {("G1" 10)}
wvSetCursor -win $_nWave3 280.993397 -snap {("G1" 10)}
wvSetCursor -win $_nWave3 319.186675 -snap {("G1" 9)}
wvSetCursor -win $_nWave3 360.653661 -snap {("G1" 10)}
wvSetCursor -win $_nWave3 398.846939 -snap {("G1" 10)}
wvSetCursor -win $_nWave3 439.222689 -snap {("G1" 10)}
