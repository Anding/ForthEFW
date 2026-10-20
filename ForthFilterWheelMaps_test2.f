\ Hardware-free metadata lifecycle checks using filter-wheel replies.
NEED simple-tester
NEED ordered-maps

: wheel_position ( -- n ) 2 ;
: filterBand ( n -- caddr u ) drop s" RED" ;
: filterSpec ( n -- caddr u ) drop s" 50mm" ;
: wheel_name ( -- caddr u ) s" ZWO EFW" ;

include "%idir%\ForthFilterWheelMaps.f"
allocate-map constant wheel.test-map

Tstart
T{ 1234 wheel.test-map add-wheelFITS }T 1234 ==
T{ wheel.test-map map-count }T 5 ==
T{ s" FILTER" wheel.test-map map@ s" RED" compare }T 0 ==
T{ s" WHEELPOS" wheel.test-map map@ s" 2" compare }T 0 ==
T{ wheel.test-map reset-map wheel.test-map map-count }T 5 ==
T{ s" FILTER" wheel.test-map map@ }T 0 0 ==
T{ wheel.test-map add-wheelFITS wheel.test-map map-count }T 5 ==
T{ s" WHEEL" wheel.test-map map@ s" ZWO EFW" compare }T 0 ==
T{ wheel.test-map erase-map wheel.test-map map-count }T 0 ==
T{ s" WHEEL" wheel.test-map map@ }T 0 0 ==
T{ wheel.test-map free-map }T ==
Tend
