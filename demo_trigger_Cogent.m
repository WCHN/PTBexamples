%% Demo for "Cogent" type scanner triggers
% Trigger type is found on the MRI sequence card
% special tab, "Trigger type" setting

%% Parameters
port         = 1;                           % scanners are connected to port 1.
baudrate     = 14400;                       % baudrate for PRISMA scanners
slicespervol = 49;                          % get this from your MRI sequence
dummyvolumes = 6;                           % typical value
dummyslices  = slicespervol * dummyvolumes;
slicelist    = dummyslices + [1:90:981];  % e.g. 11 trials, 1 trial per 90 slices
%% Start up
config_serial(port,baudrate)                % configure the serial port
start_serial                                % open the serial port

disp('Waiting for scanner...')
[c,s,t] = waitslice(port,0,'V');            % wait for...
logslice                                    % ...and log sequence version string

%% Trial loop
for trial = 1:length(slicelist)
    % prepare each trial's stimulus here...

    % wait for slice & record (in variables s & t) which slice was found and when
    fprintf('Waiting for trial %d @ volume %d, slice %d\n', trial, floor(slicelist(trial)/slicespervol), slicelist(trial))
    [s(trial), t(trial)] = waitslice(port,slicelist(trial));
    logslice
    % present the stimulus here...

end

%% Stop and clean up
stop_serial                                 % close the serial port
