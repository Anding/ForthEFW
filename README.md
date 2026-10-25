# ForthEFW
Control of the ZWO electronic filter wheel in Forth

Metadata uses ForthBase's `NEED ordered-maps` string maps.
`ForthFilterWheelMaps_test2.f` checks metadata and map reuse without hardware;
`ForthFilterWheelMaps_test1.f` remains a hardware example.

Ordinary SDK errors report and return normally; `EFW.?abort` retains its name
but does not abort. Failed reads return initialized zero values. A failed
readiness query prevents movement or calibration; attachment and scans stop
at the failed step. The caller can retry on its next iteration.
`ForthFilterWheel_test1.f` checks reporting and skipped moves with SDK mocks and no hardware.
