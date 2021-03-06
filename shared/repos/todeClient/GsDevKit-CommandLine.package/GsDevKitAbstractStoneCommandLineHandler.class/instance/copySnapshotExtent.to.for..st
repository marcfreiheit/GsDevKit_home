actions
copySnapshotExtent: snapshotExtentFile to: stoneDirectory for: aGsVersionString
	"use copydbf, so that any corruption in the extent file can be found at the outset"

	| extentFile argsArray cmdPath |
	Transcript
		cr;
		tab;
		show: 'Copying extent file: ' , snapshotExtentFile pathString printString.
	extentFile := stoneDirectory / 'extents' / 'extent0.dbf'.
	cmdPath := (aGsVersionString beginsWith: '2.4')
		ifTrue: [ 
			"cannot use copydbf to copy extent from product tree, so unconditionally use `cp`"
			'/bin/cp' ]
		ifFalse: [ (self gemstoneBin / 'copydbf') pathString ].
	argsArray := {(snapshotExtentFile pathString).
	(extentFile pathString)}.
	Transcript
		cr;
		show: (self runShellCommand: cmdPath args: argsArray);
		cr.
	OSProcess command: 'chmod +w ' , extentFile pathString