%% Demo for "Slice3ms" type scanner triggers
% Trigger type is found on the MRI sequence card
% special tab, "Trigger type" setting
%
% NB
% For "Vol3ms" triggers use KbTriggerWait()
% For "Slice3ms" triggers use Use KbWait() / KbPressWait() etc DO NOT use KbTriggerWait()
%     It misses every second trigger !!

%% Scan parameters
nDummies = 5;                                           % number of dummy volumes to wait for
nSlices  = 49;                                          % number of slices per volume
nTriggers= nDummies*nSlices;                            % total number of dummy triggers

%% PsychToolbox basic setup
PsychDefaultSetup(2);                                   % apply common Psychtoolbox parameters

%% Keyboard setup
KbName('UnifyKeyNames');
triggerKeys = KbName('5%');                             % Numeric keypad '5%' key for scanner triggers
RestrictKeysForKbCheck(triggerKeys);                    % restrict the keys for keyboard input to the keys we want

%% Wait for scanner
disp('Waiting for scanner...')
for n = 1:nTriggers                                     % wait for dummy volumes
    t0 = KbPressWait();                                 % wait for a trigger
    if rem(n,nSlices)==0                                % display timestamp & volume number
        disp(['Vol ' num2str(n/nSlices) ' @ time ' num2str(t0)])
    end
end

%% Present stimuli from here...

%% Tidy up & End
RestrictKeysForKbCheck();
