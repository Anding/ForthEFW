# ForthEFW

`efw.error.code` and `.timestamp` retain the latest nonzero SDK result until
application acknowledgement; success does not clear them. Timestamps are
ForthBase UTC Unix epoch seconds. `EFW.reopen?` accepts removed (4),
error-state (6) and closed (10), not invalid values, moving, unsupported
operations or invalid length (9). Printers never reconnect.

`configure-wheel` selects `wheel.default.slot` (0) and waits for settling.
Desired defaults are not cached hardware state. Filter names, products and
focus offsets belong to the observing environment; unnamed slots report numbers.
Control of the ZWO electronic filter wheel in Forth

Metadata uses ForthBase's `NEED ordered-maps` string maps.
`ForthFilterWheelMaps_test2.f` checks metadata and map reuse without hardware;
`ForthFilterWheelMaps_test1.f` remains a hardware example.

Ordinary SDK errors report and return normally; `EFW.?abort` retains its name
but does not abort. Failed reads return initialized zero values. A failed
readiness query prevents movement or calibration; attachment and scans stop
at the failed step. The caller can retry on its next iteration.
`ForthFilterWheel_test1.f` checks reporting and skipped moves with SDK mocks and no hardware.
