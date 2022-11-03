%% Very basic scanner trigger demo
% Waits for 5 scanner triggers - printing a message to the Matlab command
% window for each trigger

%% Scan parameters
ndummies = 5;                                           % number of dummy volumes to wait for

%% PsychToolbox basic setup
PsychDefaultSetup(2);                                   % apply common Psychtoolbox parameters

%% Keyboard setup
KbName('UnifyKeyNames');
KbQueueRelease                                          % close keyboard queue
triggerKeys = KbName('5');                              % Numeric keypad '5' key for scanner triggers
ListenChar(0);                                          % disable character listening - to allow KbTriggerWait()

%% Wait for scanner
disp('Waiting for scanner...')
for n = 1:ndummies                                      % wait for dummy volumes
    t0 = KbTriggerWait(triggerKeys);                    % wait for a volume
    disp(['Vol ' num2str(n) ' @ time ' num2str(t0)])    % display timestamp & volume number
end                                                     % 

%% Tidy up & End
ListenChar(1)                                           % re-enable keyboard
